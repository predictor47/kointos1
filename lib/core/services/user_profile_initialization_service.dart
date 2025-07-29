import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:kointos/core/services/api_service.dart';
import 'package:kointos/core/services/auth_service.dart';
import 'package:kointos/core/services/logger_service.dart';
import 'package:kointos/core/services/service_locator.dart';

class UserProfileInitializationService {
  final ApiService _apiService = getService<ApiService>();
  final AuthService _authService = getService<AuthService>();

  /// Initialize user profile after successful authentication
  /// This method should be called after sign up confirmation or sign in
  Future<Map<String, dynamic>?> ensureUserProfile() async {
    try {
      LoggerService.info('Starting user profile initialization...');

      // Get current user info
      final userId = await _authService.getCurrentUserId();
      if (userId == null) {
        LoggerService.error('No authenticated user found');
        return null;
      }

      LoggerService.info('Current user ID: $userId');

      // Try to get existing profile first
      final existingProfile = await _apiService.getUserProfile(userId);
      if (existingProfile != null) {
        LoggerService.info(
            'User profile already exists, returning existing profile');
        return existingProfile;
      }

      LoggerService.info('No existing profile found, creating new profile...');

      // Get user attributes from Cognito
      final user = await Amplify.Auth.getCurrentUser();
      final attributes = await Amplify.Auth.fetchUserAttributes();

      String? email;
      String? preferredUsername;

      for (final attribute in attributes) {
        if (attribute.userAttributeKey == CognitoUserAttributeKey.email) {
          email = attribute.value;
        } else if (attribute.userAttributeKey ==
            CognitoUserAttributeKey.preferredUsername) {
          preferredUsername = attribute.value;
        }
      }

      // Use email as fallback for username if no preferred username
      final username = preferredUsername ??
          email?.split('@').first ??
          'user_${userId.substring(0, 8)}';
      final displayName = username;

      if (email == null) {
        LoggerService.error('No email found for user');
        throw Exception('User email not found');
      }

      LoggerService.info(
          'Creating profile with email: $email, username: $username');

      // Create new user profile
      final newProfile = await _apiService.createUserProfile(
        userId: userId,
        email: email,
        username: username,
        displayName: displayName,
        bio: 'Welcome to Kointos! 🚀',
      );

      if (newProfile != null) {
        LoggerService.info('User profile created successfully');
        return newProfile;
      } else {
        LoggerService.error('Failed to create user profile');
        throw Exception('Failed to create user profile');
      }
    } catch (e) {
      LoggerService.error('Failed to initialize user profile: $e');
      rethrow;
    }
  }

  /// Create profile during sign up process
  Future<Map<String, dynamic>?> createProfileForNewUser({
    required String email,
    String? displayName,
  }) async {
    try {
      LoggerService.info('Creating profile for new user: $email');

      // Wait a moment for Cognito to be fully ready
      await Future.delayed(const Duration(seconds: 1));

      // Get current user info after confirmation
      final userId = await _authService.getCurrentUserId();
      if (userId == null) {
        LoggerService.error('No authenticated user found after sign up');
        return null;
      }

      final username = displayName ?? email.split('@').first;

      return await _apiService.createUserProfile(
        userId: userId,
        email: email,
        username: username,
        displayName: displayName ?? username,
        bio: 'New Kointos member! 🎉',
      );
    } catch (e) {
      LoggerService.error('Failed to create profile for new user: $e');
      rethrow;
    }
  }

  /// Update user profile activity
  Future<void> updateUserActivity() async {
    try {
      final userId = await _authService.getCurrentUserId();
      if (userId == null) return;

      final now = DateTime.now().toIso8601String();

      // This could be expanded to update activity tracking
      // For now, we'll just ensure the profile exists
      await ensureUserProfile();
    } catch (e) {
      LoggerService.error('Failed to update user activity: $e');
    }
  }

  /// Get or create user profile - main method to use throughout the app
  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    try {
      return await ensureUserProfile();
    } catch (e) {
      LoggerService.error('Failed to get current user profile: $e');
      return null;
    }
  }
}
