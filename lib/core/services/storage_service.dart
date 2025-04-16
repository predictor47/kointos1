import 'dart:convert';
import 'package:kointos/core/services/logger_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  late SharedPreferences _prefs;
  bool _isInitialized = false;

  Future<void> init() async {
    if (!_isInitialized) {
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
    }
  }

  Future<void> saveData(String key, dynamic data) async {
    try {
      if (!_isInitialized) await init();

      final jsonString = json.encode(data);
      await _prefs.setString(key, jsonString);
      LoggerService.info('Data saved successfully: $key');
    } catch (e, stackTrace) {
      LoggerService.error('Failed to save data', e, stackTrace);
      rethrow;
    }
  }

  Future<dynamic> getData(String key) async {
    try {
      if (!_isInitialized) await init();

      final jsonString = _prefs.getString(key);
      if (jsonString == null) return null;
      return json.decode(jsonString);
    } catch (e, stackTrace) {
      LoggerService.error('Failed to get data', e, stackTrace);
      return null;
    }
  }

  Future<void> removeData(String key) async {
    try {
      if (!_isInitialized) await init();

      await _prefs.remove(key);
      LoggerService.info('Data removed successfully: $key');
    } catch (e, stackTrace) {
      LoggerService.error('Failed to remove data', e, stackTrace);
      rethrow;
    }
  }

  Future<void> clearAll() async {
    try {
      if (!_isInitialized) await init();

      await _prefs.clear();
      LoggerService.info('All data cleared successfully');
    } catch (e, stackTrace) {
      LoggerService.error('Failed to clear all data', e, stackTrace);
      rethrow;
    }
  }

  bool hasKey(String key) {
    if (!_isInitialized) {
      LoggerService.warning('Storage service not initialized');
      return false;
    }
    return _prefs.containsKey(key);
  }
}
