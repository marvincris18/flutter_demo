import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_state.dart';
import '../models/user_model.dart';

// Demo page to show the UI without needing actual Facebook credentials
class DemoAuthPage extends StatelessWidget {
  const DemoAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Facebook Auth Demo'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Facebook Authentication Demo',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 20),
            
            // Demo login state
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Login State Demo',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 12),
                    Consumer<AuthState>(
                      builder: (context, authState, child) {
                        return Column(
                          children: [
                            Text('Authenticated: ${authState.isAuthenticated}'),
                            Text('Loading: ${authState.isLoading}'),
                            if (authState.user != null)
                              Text('User: ${authState.user!.name}'),
                            SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () {
                                // Simulate login for demo
                                _simulateLogin(authState);
                              },
                              child: Text('Simulate Facebook Login'),
                            ),
                            if (authState.isAuthenticated) ...[
                              SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {
                                  authState.signOut();
                                },
                                child: Text('Sign Out'),
                              ),
                            ],
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
            Text(
              'Implementation Features:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8),
            _buildFeatureList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureList() {
    final features = [
      '✅ Facebook OAuth integration with flutter_facebook_auth',
      '✅ Modular authentication service architecture',
      '✅ User profile model with data persistence',
      '✅ Beautiful login UI with error handling',
      '✅ Secure token storage with SharedPreferences',
      '✅ Navigation flow for authenticated/unauthenticated states',
      '✅ Android platform configuration for Facebook SDK',
      '✅ User profile display with logout functionality',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: features.map((feature) => Padding(
        padding: EdgeInsets.symmetric(vertical: 2),
        child: Text(feature),
      )).toList(),
    );
  }

  void _simulateLogin(AuthState authState) {
    // This is just for demo purposes to show the UI
    // In real implementation, this would call authState.signInWithFacebook()
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Demo Mode'),
        content: Text('This is a demo. In the real app, this would trigger Facebook authentication.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}