import 'package:flutter_test/flutter_test.dart';
import 'package:kointos/presentation/screens/profile_screen.dart';

void main() {
  group('UserProfile Factory Tests', () {
    test('UserProfile.fromApi should create instance with API data', () {
      // Arrange
      final apiData = {
        'username': 'testuser',
        'bio': 'Test bio',
        'totalPoints': 1500,
        'followersCount': 10,
        'followingCount': 5,
        'createdAt': '2024-01-01T10:00:00Z',
      };

      final currentUser = {
        'userId': 'user123',
        'username': 'testuser',
        'email': 'test@example.com',
        'displayName': 'Test User',
      };

      // Act
      final profile = UserProfile.fromApi(apiData, currentUser);

      // Assert
      expect(profile.id, equals('user123'));
      expect(profile.username, equals('testuser'));
      expect(profile.email, equals('test@example.com'));
      expect(profile.fullName, equals('Test User'));
      expect(profile.bio, equals('Test bio'));
      expect(profile.totalPoints, equals(1500));
      expect(profile.followers, equals(10));
      expect(profile.following, equals(5));
    });

    test('UserProfile.fromApi should handle null API data gracefully', () {
      // Arrange
      final currentUser = {
        'userId': 'user123',
        'username': 'testuser',
        'email': 'test@example.com',
        'displayName': 'Test User',
      };

      // Act
      final profile = UserProfile.fromApi(null, currentUser);

      // Assert
      expect(profile.id, equals('user123'));
      expect(profile.username, equals('testuser'));
      expect(profile.email, equals('test@example.com'));
      expect(profile.fullName, equals('Test User'));
      expect(profile.bio,
          equals('Welcome to Kointos! Exploring the world of cryptocurrency.'));
      expect(profile.totalPoints, equals(500)); // default value
      expect(profile.followers, equals(0)); // default value
      expect(profile.following, equals(0)); // default value
    });

    test('UserProfile.guest should create guest profile', () {
      // Act
      final profile = UserProfile.guest();

      // Assert
      expect(profile.id, equals('guest'));
      expect(profile.username, equals('Guest'));
      expect(profile.email, equals('guest@kointos.com'));
      expect(profile.fullName, equals('Guest User'));
      expect(profile.totalPoints, equals(0));
      expect(profile.followers, equals(0));
      expect(profile.following, equals(0));
    });
  });
}
