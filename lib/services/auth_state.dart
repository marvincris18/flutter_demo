import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/facebook_auth_service.dart';

class AuthState extends ChangeNotifier {
  final FacebookAuthService _authService = FacebookAuthService();
  
  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String? get errorMessage => _errorMessage;

  AuthState() {
    _checkCurrentUser();
  }

  // Check if user is already logged in
  Future<void> _checkCurrentUser() async {
    _setLoading(true);
    try {
      _user = await _authService.getCurrentUser();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to check authentication status';
      print('Error checking current user: $e');
    }
    _setLoading(false);
  }

  // Sign in with Facebook
  Future<bool> signInWithFacebook() async {
    _setLoading(true);
    _errorMessage = null;
    
    try {
      final user = await _authService.signInWithFacebook();
      if (user != null) {
        _user = user;
        _setLoading(false);
        return true;
      } else {
        _errorMessage = 'Failed to sign in with Facebook';
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _errorMessage = 'An error occurred during sign in';
      _setLoading(false);
      print('Error during Facebook sign in: $e');
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _authService.signOut();
      _user = null;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to sign out';
      print('Error during sign out: $e');
    }
    _setLoading(false);
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}