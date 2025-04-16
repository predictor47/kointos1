import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  final SharedPreferences _prefs;

  LocalStorageService({
    required SharedPreferences prefs,
  }) : _prefs = prefs;

  static Future<LocalStorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorageService(prefs: prefs);
  }

  Future<String?> get(String key) async {
    return _prefs.getString(key);
  }

  Future<bool> set(
    String key,
    String value, {
    Duration? expiry,
  }) async {
    if (expiry != null) {
      final expiryTime = DateTime.now().add(expiry).millisecondsSinceEpoch;
      await _prefs.setInt('${key}_expiry', expiryTime);
    }
    return _prefs.setString(key, value);
  }

  Future<bool> remove(String key) async {
    await _prefs.remove('${key}_expiry');
    return _prefs.remove(key);
  }

  Future<bool> hasExpired(String key) async {
    final expiryTime = _prefs.getInt('${key}_expiry');
    if (expiryTime == null) return false;
    return DateTime.now().millisecondsSinceEpoch > expiryTime;
  }

  Future<void> clear() async {
    await _prefs.clear();
  }

  Future<bool> containsKey(String key) async {
    return _prefs.containsKey(key);
  }

  Future<Set<String>> getAllKeys() async {
    return _prefs.getKeys();
  }

  Future<Map<String, dynamic>> getMultiple(List<String> keys) async {
    final result = <String, dynamic>{};
    for (final key in keys) {
      if (_prefs.containsKey(key)) {
        result[key] = _prefs.getString(key);
      }
    }
    return result;
  }

  Future<bool> setMultiple(Map<String, String> items) async {
    var success = true;
    for (final entry in items.entries) {
      final result = await set(entry.key, entry.value);
      success = success && result;
    }
    return success;
  }

  Future<bool> removeMultiple(List<String> keys) async {
    var success = true;
    for (final key in keys) {
      final result = await remove(key);
      success = success && result;
    }
    return success;
  }

  Future<bool> clearExpired() async {
    final keys = _prefs.getKeys().where((key) => key.endsWith('_expiry'));
    var success = true;

    for (final expiryKey in keys) {
      final key = expiryKey.replaceAll('_expiry', '');
      if (await hasExpired(key)) {
        final result = await remove(key);
        success = success && result;
      }
    }

    return success;
  }
}
