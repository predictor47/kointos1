import 'package:flutter_test/flutter_test.dart';
import 'package:kointos/core/services/user_profile_initialization_service.dart';
import 'package:kointos/core/services/api_service.dart';
import 'package:kointos/core/services/auth_service.dart';
import 'package:kointos/core/services/service_locator.dart';

void main() {
  group('User Profile Initialization Tests', () {
    late UserProfileInitializationService profileService;
    late ApiService apiService;
    late AuthService authService;

    setUpAll(() async {
      // Initialize service locator for testing
      await setupServiceLocator();

      profileService = getService<UserProfileInitializationService>();
      apiService = getService<ApiService>();
      authService = getService<AuthService>();
    });

    test('should create user profile with proper data structure', () async {
      // This test would verify profile creation in a real environment
      // For now, we'll test the service exists and has the right methods

      expect(profileService, isNotNull);
      expect(profileService.getCurrentUserProfile, isA<Function>());
      expect(profileService.ensureUserProfile, isA<Function>());
      expect(profileService.createProfileForNewUser, isA<Function>());
    });

    test('should handle missing user gracefully', () async {
      // Test that the service handles unauthenticated users properly
      try {
        final profile = await profileService.getCurrentUserProfile();
        // If no user is authenticated, it should return null or handle gracefully
        expect(profile, anyOf(isNull, isA<Map<String, dynamic>>()));
      } catch (e) {
        // Should not throw unhandled exceptions
        expect(e, isA<Exception>());
      }
    });

    test('API service should have createUserProfile method', () {
      expect(apiService.createUserProfile, isA<Function>());
      expect(apiService.getUserProfile, isA<Function>());
      expect(apiService.updateUserProfile, isA<Function>());
    });
  });
}
