import '../models/post_target.dart';
import '../models/social_post.dart';

abstract class SocialMediaService {
  /// Service name for identification
  String get serviceName;

  /// Check if user is authenticated
  Future<bool> isAuthenticated();

  /// Authenticate user with OAuth
  Future<bool> authenticate();

  /// Sign out user
  Future<void> signOut();

  /// Get available post targets (wall, stories, pages)
  Future<List<PostTarget>> getPostTargets();

  /// Post content to specified target
  Future<bool> postContent(SocialPost post, PostTarget target);

  /// Check if user has permission to post to specific target
  Future<bool> hasPostPermission(PostTarget target);

  /// Request additional permissions if needed
  Future<bool> requestPermissions(List<String> permissions);

  /// Get user information
  Future<Map<String, dynamic>?> getUserInfo();
}

class SocialMediaException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const SocialMediaException(this.message, {this.code, this.details});

  @override
  String toString() {
    return 'SocialMediaException: $message${code != null ? ' (Code: $code)' : ''}';
  }
}