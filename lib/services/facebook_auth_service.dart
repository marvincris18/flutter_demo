import 'dart:convert';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class FacebookAuthService {
  static const String _userKey = 'user_data';
  static const String _tokenKey = 'access_token';

  // Sign in with Facebook
  Future<UserModel?> signInWithFacebook() async {
    try {
      // Request login with read permissions
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        // Get user data
        final userData = await FacebookAuth.instance.getUserData();
        final user = UserModel.fromMap(userData);
        
        // Store user data and token locally
        await _storeUserData(user);
        await _storeAccessToken(result.accessToken!.tokenString);
        
        return user;
      } else {
        print('Facebook login failed: ${result.status}');
        return null;
      }
    } catch (e) {
      print('Error during Facebook login: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await FacebookAuth.instance.logOut();
      await _clearStoredData();
    } catch (e) {
      print('Error during sign out: $e');
    }
  }

  // Check if user is already logged in
  Future<UserModel?> getCurrentUser() async {
    try {
      final accessToken = await FacebookAuth.instance.accessToken;
      if (accessToken != null) {
        // Verify token is still valid
        final userData = await FacebookAuth.instance.getUserData();
        return UserModel.fromMap(userData);
      }
      
      // Try to get stored user data
      return await _getStoredUserData();
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  // Store user data locally
  Future<void> _storeUserData(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toMap()));
  }

  // Store access token locally
  Future<void> _storeAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Get stored user data
  Future<UserModel?> _getStoredUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      if (userJson != null) {
        final userMap = jsonDecode(userJson);
        return UserModel.fromMap(userMap);
      }
      return null;
    } catch (e) {
      print('Error getting stored user data: $e');
      return null;
    }
  }

  // Clear stored data
  Future<void> _clearStoredData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
  }
}