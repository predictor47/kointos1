import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:kointos/core/services/user_profile_initialization_service.dart';
import 'package:kointos/core/services/service_locator.dart';
import 'package:kointos/core/services/logger_service.dart';

class AuthService {
  Future<bool> isAuthenticated() async {
    try {
      final session = await getCurrentSession();
      return session?.isSignedIn ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<AuthSession?> getCurrentSession() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      return session;
    } on AuthException {
      return null;
    }
  }

  Future<String?> getCurrentUserId() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      return user.userId;
    } on AuthException {
      return null;
    }
  }

  Future<String?> getUserToken() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      if (session is CognitoAuthSession) {
        // Extract the access token from Cognito session
        final accessToken = session.userPoolTokensResult.value.accessToken;
        return accessToken.raw;
      }
      // Return null if not signed in or no valid token available
      return null;
    } on AuthException {
      return null;
    }
  }

  Future<void> signUp(
    String email,
    String password,
  ) async {
    try {
      await Amplify.Auth.signUp(
        username: email,
        password: password,
        options: SignUpOptions(
          userAttributes: {
            CognitoUserAttributeKey.email: email,
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> confirmSignUp(
    String email,
    String confirmationCode,
  ) async {
    try {
      await Amplify.Auth.confirmSignUp(
        username: email,
        confirmationCode: confirmationCode,
      );

      // Initialize user profile after successful confirmation
      try {
        final profileService = getService<UserProfileInitializationService>();
        final profile =
            await profileService.createProfileForNewUser(email: email);
        if (profile == null) {
          LoggerService.error(
              'Profile creation returned null for user: $email');
          throw Exception('Profile creation failed - returned null');
        }
        LoggerService.info('User profile created successfully for: $email');
      } catch (e) {
        LoggerService.error('CRITICAL: Failed to create user profile: $e');
        // Still throw the error so we know profile creation failed
        throw Exception('Profile creation failed: $e');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resendConfirmationCode(String email) async {
    try {
      await Amplify.Auth.resendSignUpCode(
        username: email,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signIn(
    String email,
    String password,
  ) async {
    try {
      await Amplify.Auth.signIn(
        username: email,
        password: password,
      );

      // Ensure user profile exists after successful sign in
      try {
        final profileService = getService<UserProfileInitializationService>();
        final profile = await profileService.ensureUserProfile();
        if (profile == null) {
          LoggerService.error('Profile ensure returned null after sign in');
          throw Exception('Profile initialization failed after sign in');
        }
        LoggerService.info('User profile ensured successfully after sign in');
      } catch (e) {
        LoggerService.error(
            'CRITICAL: Failed to initialize user profile on sign in: $e');
        // Still throw the error so we know profile creation failed
        throw Exception('Profile initialization failed on sign in: $e');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await Amplify.Auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await Amplify.Auth.resetPassword(
        username: email,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> confirmResetPassword(
    String email,
    String newPassword,
    String confirmationCode,
  ) async {
    try {
      await Amplify.Auth.confirmResetPassword(
        username: email,
        newPassword: newPassword,
        confirmationCode: confirmationCode,
      );
    } catch (e) {
      rethrow;
    }
  }
}
