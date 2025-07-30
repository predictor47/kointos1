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

      // Wait for Cognito to be fully ready and try multiple times
      Map<String, dynamic>? profile;
      String? userId;

      for (int attempt = 1; attempt <= 5; attempt++) {
        LoggerService.info('Profile creation attempt $attempt/5');

        // Wait longer between attempts
        await Future.delayed(Duration(seconds: attempt));

        // Get current user info after confirmation
        userId = await _authService.getCurrentUserId();
        if (userId == null) {
          LoggerService.warning(
              'No authenticated user found on attempt $attempt');
          if (attempt == 5) {
            throw Exception('No authenticated user found after 5 attempts');
          }
          continue;
        }

        LoggerService.info('Found user ID: $userId');
        break;
      }

      if (userId == null) {
        throw Exception('Could not get user ID after confirmation');
      }

      final username = displayName ?? email.split('@').first;

      // Try to create the profile with retry logic
      for (int attempt = 1; attempt <= 3; attempt++) {
        try {
          LoggerService.info('Attempting profile creation: attempt $attempt/3');

          profile = await _apiService.createUserProfile(
            userId: userId,
            email: email,
            username: username,
            displayName: displayName ?? username,
            bio: 'New Kointos member! 🎉',
          );

          if (profile != null) {
            LoggerService.info(
                'Profile created successfully on attempt $attempt');
            return profile;
          } else {
            LoggerService.warning(
                'Profile creation returned null on attempt $attempt');
            if (attempt < 3) {
              await Future.delayed(Duration(seconds: 2 * attempt));
            }
          }
        } catch (e) {
          LoggerService.error('Profile creation attempt $attempt failed: $e');
          if (attempt == 3) {
            rethrow;
          }
          await Future.delayed(Duration(seconds: 2 * attempt));
        }
      }

      throw Exception('Profile creation failed after 3 attempts');
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
      LoggerService.info('Getting current user profile...');

      // First check if user is authenticated
      final userId = await _authService.getCurrentUserId();
      if (userId == null) {
        LoggerService.error('No authenticated user found');
        return null;
      }

      // Try to get existing profile
      try {
        final existingProfile = await _apiService.getUserProfile(userId);
        if (existingProfile != null) {
          LoggerService.info('Found existing user profile');
          return existingProfile;
        }
      } catch (e) {
        LoggerService.warning(
            'Error fetching existing profile, will create new: $e');
      }

      // Profile doesn't exist, try to create it
      LoggerService.info('No profile found, creating new profile...');
      return await ensureUserProfile();
    } catch (e) {
      LoggerService.error('Failed to get current user profile: $e');

      // If all else fails, return a minimal profile from auth data
      try {
        final userId = await _authService.getCurrentUserId();
        if (userId != null) {
          final user = await Amplify.Auth.getCurrentUser();
          final attributes = await Amplify.Auth.fetchUserAttributes();

          String email = 'user@example.com';
          for (final attr in attributes) {
            if (attr.userAttributeKey == CognitoUserAttributeKey.email) {
              email = attr.value;
              break;
            }
          }

          return {
            'id': userId,
            'userId': userId,
            'username': user.username,
            'displayName': user.username,
            'email': email,
            'bio': 'Kointos User',
            'totalPoints': 0,
            'level': 1,
            'globalRank': 999999,
            'followersCount': 0,
            'followingCount': 0,
            'totalPortfolioValue': 0.0,
          };
        }
      } catch (fallbackError) {
        LoggerService.error('Fallback profile creation failed: $fallbackError');
      }

      return null;
    }
  }
}
