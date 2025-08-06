import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/post_target.dart';
import '../models/social_post.dart';
import '../services/facebook_service.dart';
import '../services/social_media_service.dart';

class FacebookPostScreen extends StatefulWidget {
  const FacebookPostScreen({super.key});

  @override
  State<FacebookPostScreen> createState() => _FacebookPostScreenState();
}

class _FacebookPostScreenState extends State<FacebookPostScreen> {
  final FacebookService _facebookService = FacebookService();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  
  List<PostTarget> _postTargets = [];
  PostTarget? _selectedTarget;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    _checkAuthenticationStatus();
  }

  @override
  void dispose() {
    _contentController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _checkAuthenticationStatus() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final isAuth = await _facebookService.isAuthenticated();
      setState(() {
        _isAuthenticated = isAuth;
      });

      if (isAuth) {
        await _loadPostTargets();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to check authentication: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _authenticate() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final success = await _facebookService.authenticate();
      if (success) {
        setState(() {
          _isAuthenticated = true;
        });
        await _loadPostTargets();
      } else {
        setState(() {
          _errorMessage = 'Authentication failed. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Authentication error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signOut() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _facebookService.signOut();
      setState(() {
        _isAuthenticated = false;
        _postTargets = [];
        _selectedTarget = null;
        _errorMessage = null;
        _successMessage = null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Sign out failed: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadPostTargets() async {
    try {
      final targets = await _facebookService.getPostTargets();
      setState(() {
        _postTargets = targets;
        _selectedTarget = targets.isNotEmpty ? targets.first : null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load post targets: ${e.toString()}';
      });
    }
  }

  Future<void> _postContent() async {
    if (_selectedTarget == null || _contentController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Please select a target and enter content';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final post = SocialPost(
        content: _contentController.text.trim(),
        imageUrl: _imageUrlController.text.trim().isNotEmpty 
            ? _imageUrlController.text.trim() 
            : null,
      );

      final success = await _facebookService.postContent(post, _selectedTarget!);
      
      if (success) {
        setState(() {
          _successMessage = 'Successfully posted to ${_selectedTarget!.name}!';
        });
        _contentController.clear();
        _imageUrlController.clear();
      } else {
        setState(() {
          _errorMessage = 'Failed to post content. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Post failed: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Facebook Integration'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (_isAuthenticated)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _isLoading ? null : _signOut,
              tooltip: 'Sign Out',
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _isAuthenticated
                ? _buildPostingInterface()
                : _buildAuthenticationInterface(),
      ),
    );
  }

  Widget _buildAuthenticationInterface() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.facebook,
            size: 64,
            color: Colors.blue,
          ),
          const SizedBox(height: 24),
          const Text(
            'Connect to Facebook',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'Sign in to Facebook to share your content with friends and followers.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _authenticate,
            icon: const Icon(Icons.login),
            label: const Text('Sign in with Facebook'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                border: Border.all(color: Colors.red.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red.shade700),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPostingInterface() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Target selection
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Post to:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<PostTarget>(
                    value: _selectedTarget,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: _postTargets.map((target) {
                      return DropdownMenuItem(
                        value: target,
                        child: Row(
                          children: [
                            Icon(_getTargetIcon(target.type)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(target.name),
                                  if (target.description != null)
                                    Text(
                                      target.description!,
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                ],
                              ),
                            ),
                            if (!target.hasPermission)
                              Icon(
                                Icons.warning,
                                color: Colors.orange,
                                size: 16,
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (target) {
                      setState(() {
                        _selectedTarget = target;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Content input
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Content:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _contentController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'What\'s on your mind?',
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Image URL (optional):',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _imageUrlController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'https://example.com/image.jpg',
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Post button
          ElevatedButton.icon(
            onPressed: _contentController.text.trim().isNotEmpty ? _postContent : null,
            icon: const Icon(Icons.send),
            label: const Text('Post to Facebook'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
          
          // Messages
          if (_errorMessage != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                border: Border.all(color: Colors.red.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red.shade700),
              ),
            ),
          ],
          if (_successMessage != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                border: Border.all(color: Colors.green.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _successMessage!,
                style: TextStyle(color: Colors.green.shade700),
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getTargetIcon(PostTargetType type) {
    switch (type) {
      case PostTargetType.wall:
        return Icons.person;
      case PostTargetType.story:
        return Icons.camera_alt;
      case PostTargetType.page:
        return Icons.business;
    }
  }
}