import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:kointos/core/services/user_profile_initialization_service.dart';
import 'package:kointos/core/services/service_locator.dart';

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
        await profileService.createProfileForNewUser(email: email);
      } catch (e) {
        // Log the error but don't fail the auth process
        print('Warning: Failed to create user profile: $e');
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
        await profileService.ensureUserProfile();
      } catch (e) {
        // Log the error but don't fail the auth process
        print('Warning: Failed to initialize user profile: $e');
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
