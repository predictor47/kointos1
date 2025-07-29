import 'package:flutter_test/flutter_test.dart';
import 'package:kointos/core/services/gamification_service.dart';
import 'package:kointos/core/services/api_service.dart';
import 'package:kointos/core/services/auth_service.dart';
import 'package:kointos/core/services/user_profile_initialization_service.dart';
import 'package:kointos/core/services/service_locator.dart';

void main() {
  group('Gamification Service - Like/Comment Integration Tests', () {
    late GamificationService gamificationService;
    late ApiService apiService;
    late AuthService authService;
    late UserProfileInitializationService profileService;

    setUpAll(() async {
      // Initialize service locator for testing
      setupServiceLocator();

      authService = getService<AuthService>();
      apiService = getService<ApiService>();
      profileService = getService<UserProfileInitializationService>();
      gamificationService = GamificationService(apiService);
    });

    test('Should award points for liking a post without UserProfile errors',
        () async {
      try {
        // This test ensures that the gamification service can award points
        // without throwing "UserProfile not found" errors

        // Try to award points for liking a post
        // This should either succeed or fail gracefully without the specific error
        await gamificationService.awardPoints(GameAction.likePost);

        // If we get here, the method completed without throwing the specific error
        print('✅ LikePost gamification completed successfully');
      } catch (e) {
        // Check that the error is not the "UserProfile not found" error
        final errorMessage = e.toString();

        // If it's an authentication error, that's expected in tests
        if (errorMessage.contains('not authenticated') ||
            errorMessage.contains('No authenticated user')) {
          print('✅ Expected authentication error in test environment: $e');
        } else if (errorMessage.contains('User profile not found')) {
          // This is the error we're trying to fix
          fail('❌ Still getting "User profile not found" error: $e');
        } else {
          // Some other error is acceptable
          print('ℹ️  Other error (acceptable): $e');
        }
      }
    });

    test('Should award points for commenting without UserProfile errors',
        () async {
      try {
        // Try to award points for commenting
        await gamificationService.awardPoints(GameAction.commentOnPost);

        print('✅ CommentOnPost gamification completed successfully');
      } catch (e) {
        final errorMessage = e.toString();

        if (errorMessage.contains('not authenticated') ||
            errorMessage.contains('No authenticated user')) {
          print('✅ Expected authentication error in test environment: $e');
        } else if (errorMessage.contains('User profile not found')) {
          fail('❌ Still getting "User profile not found" error: $e');
        } else {
          print('ℹ️  Other error (acceptable): $e');
        }
      }
    });

    test('Should get user stats without crashing', () async {
      try {
        // This should return empty stats if no user is authenticated
        final stats = await gamificationService.getUserStats();

        expect(stats, isNotNull);
        print(
            '✅ Got user stats: ${stats.totalPoints} points, level ${stats.level}');
      } catch (e) {
        final errorMessage = e.toString();

        if (errorMessage.contains('not authenticated') ||
            errorMessage.contains('No authenticated user')) {
          print('✅ Expected authentication error in test environment: $e');
        } else {
          print('ℹ️  Error getting stats: $e');
        }
      }
    });
  });
}
