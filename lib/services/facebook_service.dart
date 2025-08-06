import 'dart:convert';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart' as http;
import '../models/post_target.dart';
import '../models/social_post.dart';
import 'social_media_service.dart';

class FacebookService implements SocialMediaService {
  static const String _baseUrl = 'https://graph.facebook.com/v18.0';
  
  AccessToken? _accessToken;
  Map<String, dynamic>? _userInfo;

  @override
  String get serviceName => 'Facebook';

  @override
  Future<bool> isAuthenticated() async {
    try {
      _accessToken = await FacebookAuth.instance.accessToken;
      return _accessToken != null && !_isTokenExpired(_accessToken!);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> authenticate() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: [
          'email',
          'public_profile',
          'pages_show_list',
          'pages_read_engagement',
          'pages_manage_posts',
          'publish_to_groups',
        ],
      );

      if (result.status == LoginStatus.success) {
        _accessToken = result.accessToken;
        _userInfo = await _fetchUserInfo();
        return true;
      } else {
        throw SocialMediaException(
          'Facebook authentication failed: ${result.message}',
          code: result.status.toString(),
        );
      }
    } catch (e) {
      throw SocialMediaException(
        'Facebook authentication error: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await FacebookAuth.instance.logOut();
      _accessToken = null;
      _userInfo = null;
    } catch (e) {
      throw SocialMediaException('Failed to sign out: ${e.toString()}');
    }
  }

  @override
  Future<List<PostTarget>> getPostTargets() async {
    if (!await isAuthenticated()) {
      throw SocialMediaException('User not authenticated');
    }

    final List<PostTarget> targets = [];

    try {
      // Add user's wall as default target
      if (_userInfo != null) {
        targets.add(PostTarget(
          id: _userInfo!['id'],
          name: 'My Wall',
          type: PostTargetType.wall,
          description: 'Post to your personal timeline',
          hasPermission: true,
        ));

        // Add story option
        targets.add(PostTarget(
          id: '${_userInfo!['id']}_story',
          name: 'My Story',
          type: PostTargetType.story,
          description: 'Share to your story',
          hasPermission: true,
        ));
      }

      // Fetch managed pages
      final pages = await _fetchManagedPages();
      targets.addAll(pages);

      return targets;
    } catch (e) {
      throw SocialMediaException('Failed to fetch post targets: ${e.toString()}');
    }
  }

  @override
  Future<bool> postContent(SocialPost post, PostTarget target) async {
    if (!await isAuthenticated()) {
      throw SocialMediaException('User not authenticated');
    }

    try {
      switch (target.type) {
        case PostTargetType.wall:
          return await _postToWall(post, target.id);
        case PostTargetType.story:
          return await _postToStory(post);
        case PostTargetType.page:
          return await _postToPage(post, target.id);
      }
    } catch (e) {
      throw SocialMediaException('Failed to post content: ${e.toString()}');
    }
  }

  @override
  Future<bool> hasPostPermission(PostTarget target) async {
    if (!await isAuthenticated()) return false;

    try {
      switch (target.type) {
        case PostTargetType.wall:
        case PostTargetType.story:
          return true; // User always has permission to post to their own wall/story
        case PostTargetType.page:
          return await _checkPagePermission(target.id);
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> requestPermissions(List<String> permissions) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: permissions,
      );
      return result.status == LoginStatus.success;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>?> getUserInfo() async {
    if (_userInfo != null) return _userInfo;
    
    if (await isAuthenticated()) {
      _userInfo = await _fetchUserInfo();
    }
    return _userInfo;
  }

  // Private helper methods

  bool _isTokenExpired(AccessToken token) {
    if (token.expires == null) return false;
    return DateTime.now().isAfter(token.expires!);
  }

  Future<Map<String, dynamic>?> _fetchUserInfo() async {
    if (_accessToken == null) return null;

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/me?fields=id,name,email&access_token=${_accessToken!.token}'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<PostTarget>> _fetchManagedPages() async {
    if (_accessToken == null) return [];

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/me/accounts?access_token=${_accessToken!.token}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final pages = data['data'] as List<dynamic>? ?? [];
        
        return pages.map((page) => PostTarget(
          id: page['id'],
          name: page['name'],
          type: PostTargetType.page,
          description: 'Post to ${page['name']} page',
          hasPermission: page['perms']?.contains('CREATE_CONTENT') ?? false,
        )).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> _postToWall(SocialPost post, String userId) async {
    if (_accessToken == null) return false;

    try {
      final Map<String, String> data = {
        'message': post.content,
        'access_token': _accessToken!.token,
      };

      if (post.imageUrl != null) {
        data['link'] = post.imageUrl!;
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/$userId/feed'),
        body: data,
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _postToStory(SocialPost post) async {
    // Note: Stories require different API endpoints and media handling
    // This is a simplified implementation
    throw SocialMediaException('Story posting not yet implemented');
  }

  Future<bool> _postToPage(SocialPost post, String pageId) async {
    if (_accessToken == null) return false;

    try {
      // First, get page access token
      final pageToken = await _getPageAccessToken(pageId);
      if (pageToken == null) return false;

      final Map<String, String> data = {
        'message': post.content,
        'access_token': pageToken,
      };

      if (post.imageUrl != null) {
        data['link'] = post.imageUrl!;
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/$pageId/feed'),
        body: data,
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<String?> _getPageAccessToken(String pageId) async {
    if (_accessToken == null) return null;

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/me/accounts?access_token=${_accessToken!.token}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final pages = data['data'] as List<dynamic>? ?? [];
        
        for (final page in pages) {
          if (page['id'] == pageId) {
            return page['access_token'];
          }
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> _checkPagePermission(String pageId) async {
    if (_accessToken == null) return false;

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/me/accounts?access_token=${_accessToken!.token}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final pages = data['data'] as List<dynamic>? ?? [];
        
        for (final page in pages) {
          if (page['id'] == pageId) {
            final perms = page['perms'] as List<dynamic>? ?? [];
            return perms.contains('CREATE_CONTENT');
          }
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}