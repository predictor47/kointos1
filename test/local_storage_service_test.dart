import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kointos/core/services/local_storage_service.dart';

void main() {
  group('LocalStorageService Tests', () {
    late LocalStorageService storageService;

    setUp(() async {
      // Mock SharedPreferences for testing
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      storageService = LocalStorageService(prefs: prefs);
    });

    test('should save and retrieve string data', () async {
      const key = 'test_key';
      const value = 'test_value';

      await storageService.set(key, value);
      final retrieved = await storageService.get(key);

      expect(retrieved, equals(value));
    });

    test('should return null for non-existent key', () async {
      const key = 'non_existent_key';
      final retrieved = await storageService.get(key);

      expect(retrieved, isNull);
    });

    test('should remove data successfully', () async {
      const key = 'test_key';
      const value = 'test_value';

      await storageService.set(key, value);
      await storageService.remove(key);
      final retrieved = await storageService.get(key);

      expect(retrieved, isNull);
    });

    test('should clear all data', () async {
      await storageService.set('key1', 'value1');
      await storageService.set('key2', 'value2');

      await storageService.clear();

      final retrieved1 = await storageService.get('key1');
      final retrieved2 = await storageService.get('key2');

      expect(retrieved1, isNull);
      expect(retrieved2, isNull);
    });

    test('should handle expiry correctly', () async {
      const key = 'expiry_test';
      const value = 'expiry_value';
      const shortExpiry = Duration(milliseconds: 100);

      await storageService.set(key, value, expiry: shortExpiry);

      // Should be available immediately
      final immediate = await storageService.get(key);
      expect(immediate, equals(value));
      expect(await storageService.hasExpired(key), false);

      // Wait for expiry
      await Future.delayed(const Duration(milliseconds: 150));

      // Value should still exist but be expired
      final stillExists = await storageService.get(key);
      expect(stillExists, equals(value)); // Value still exists
      expect(await storageService.hasExpired(key), true); // But is expired

      // Clean up expired data
      await storageService.clearExpired();
      final afterCleanup = await storageService.get(key);
      expect(afterCleanup, isNull);
    });
  });
}
