import 'package:shared_preferences/shared_preferences.dart';
import 'package:kointos/core/services/logger_service.dart';

/// Service for managing user settings and preferences
class SettingsService {
  static const String _keyNotifications = 'notifications_enabled';
  static const String _keyDarkMode = 'dark_mode_enabled';
  static const String _keyBiometrics = 'biometrics_enabled';
  static const String _keyLanguage = 'selected_language';
  static const String _keyFirstLaunch = 'first_launch';
  static const String _keyOnboardingComplete = 'onboarding_complete';
  static const String _keySoundEffects = 'sound_effects_enabled';
  static const String _keyHapticFeedback = 'haptic_feedback_enabled';
  static const String _keyAutoRefresh = 'auto_refresh_enabled';
  static const String _keyRefreshInterval = 'refresh_interval_minutes';
  static const String _keyDefaultTab = 'default_tab_index';
  static const String _keyCompactView = 'compact_view_enabled';
  static const String _keyShowPortfolioValue = 'show_portfolio_value';
  static const String _keyCurrency = 'preferred_currency';
  static const String _keyPriceAlerts = 'price_alerts_enabled';
  static const String _keyMarketDataProvider = 'market_data_provider';
  static const String _keyAnalytics = 'analytics_enabled';

  late SharedPreferences _prefs;
  bool _initialized = false;

  /// Initialize the settings service
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;

      // Set default values for first launch
      if (await isFirstLaunch()) {
        await _setDefaults();
      }

      LoggerService.info('Settings service initialized');
    } catch (e) {
      LoggerService.error('Failed to initialize settings service: $e');
      rethrow;
    }
  }

  /// Set default values for first launch
  Future<void> _setDefaults() async {
    await setNotificationsEnabled(true);
    await setDarkModeEnabled(true);
    await setBiometricsEnabled(false);
    await setLanguage('English');
    await setSoundEffectsEnabled(true);
    await setHapticFeedbackEnabled(true);
    await setAutoRefreshEnabled(true);
    await setRefreshInterval(5);
    await setDefaultTabIndex(0);
    await setCompactViewEnabled(false);
    await setShowPortfolioValue(true);
    await setPreferredCurrency('USD');
    await setPriceAlertsEnabled(true);
    await setMarketDataProvider('coingecko');
    await setFirstLaunch(false);
  }

  /// Check if initialized
  void _checkInitialized() {
    if (!_initialized) {
      throw Exception(
          'SettingsService not initialized. Call initialize() first.');
    }
  }

  // Notification Settings
  Future<bool> isNotificationsEnabled() async {
    _checkInitialized();
    return _prefs.getBool(_keyNotifications) ?? true;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    _checkInitialized();
    await _prefs.setBool(_keyNotifications, enabled);
    LoggerService.info('Notifications enabled: $enabled');
  }

  // Analytics Settings
  Future<bool> isAnalyticsEnabled() async {
    _checkInitialized();
    return _prefs.getBool(_keyAnalytics) ?? true;
  }

  Future<void> setAnalyticsEnabled(bool enabled) async {
    _checkInitialized();
    await _prefs.setBool(_keyAnalytics, enabled);
    LoggerService.info('Analytics enabled: $enabled');
  }

  // Theme Settings
  Future<bool> isDarkModeEnabled() async {
    _checkInitialized();
    return _prefs.getBool(_keyDarkMode) ?? true;
  }

  Future<void> setDarkModeEnabled(bool enabled) async {
    _checkInitialized();
    await _prefs.setBool(_keyDarkMode, enabled);
    LoggerService.info('Dark mode enabled: $enabled');
  }

  // Security Settings
  Future<bool> isBiometricsEnabled() async {
    _checkInitialized();
    return _prefs.getBool(_keyBiometrics) ?? false;
  }

  Future<void> setBiometricsEnabled(bool enabled) async {
    _checkInitialized();
    await _prefs.setBool(_keyBiometrics, enabled);
    LoggerService.info('Biometrics enabled: $enabled');
  }

  // Language Settings
  Future<String> getLanguage() async {
    _checkInitialized();
    return _prefs.getString(_keyLanguage) ?? 'English';
  }

  Future<void> setLanguage(String language) async {
    _checkInitialized();
    await _prefs.setString(_keyLanguage, language);
    LoggerService.info('Language set to: $language');
  }

  // App State Settings
  Future<bool> isFirstLaunch() async {
    _checkInitialized();
    return _prefs.getBool(_keyFirstLaunch) ?? true;
  }

  Future<void> setFirstLaunch(bool isFirst) async {
    _checkInitialized();
    await _prefs.setBool(_keyFirstLaunch, isFirst);
  }

  Future<bool> isOnboardingComplete() async {
    _checkInitialized();
    return _prefs.getBool(_keyOnboardingComplete) ?? false;
  }

  Future<void> setOnboardingComplete(bool complete) async {
    _checkInitialized();
    await _prefs.setBool(_keyOnboardingComplete, complete);
    LoggerService.info('Onboarding complete: $complete');
  }

  // Sound & Haptics
  Future<bool> isSoundEffectsEnabled() async {
    _checkInitialized();
    return _prefs.getBool(_keySoundEffects) ?? true;
  }

  Future<void> setSoundEffectsEnabled(bool enabled) async {
    _checkInitialized();
    await _prefs.setBool(_keySoundEffects, enabled);
  }

  Future<bool> isHapticFeedbackEnabled() async {
    _checkInitialized();
    return _prefs.getBool(_keyHapticFeedback) ?? true;
  }

  Future<void> setHapticFeedbackEnabled(bool enabled) async {
    _checkInitialized();
    await _prefs.setBool(_keyHapticFeedback, enabled);
  }

  // Data & Refresh Settings
  Future<bool> isAutoRefreshEnabled() async {
    _checkInitialized();
    return _prefs.getBool(_keyAutoRefresh) ?? true;
  }

  Future<void> setAutoRefreshEnabled(bool enabled) async {
    _checkInitialized();
    await _prefs.setBool(_keyAutoRefresh, enabled);
  }

  Future<int> getRefreshInterval() async {
    _checkInitialized();
    return _prefs.getInt(_keyRefreshInterval) ?? 5;
  }

  Future<void> setRefreshInterval(int minutes) async {
    _checkInitialized();
    await _prefs.setInt(_keyRefreshInterval, minutes);
  }

  // UI Preferences
  Future<int> getDefaultTabIndex() async {
    _checkInitialized();
    return _prefs.getInt(_keyDefaultTab) ?? 0;
  }

  Future<void> setDefaultTabIndex(int index) async {
    _checkInitialized();
    await _prefs.setInt(_keyDefaultTab, index);
  }

  Future<bool> isCompactViewEnabled() async {
    _checkInitialized();
    return _prefs.getBool(_keyCompactView) ?? false;
  }

  Future<void> setCompactViewEnabled(bool enabled) async {
    _checkInitialized();
    await _prefs.setBool(_keyCompactView, enabled);
  }

  // Portfolio Settings
  Future<bool> isShowPortfolioValue() async {
    _checkInitialized();
    return _prefs.getBool(_keyShowPortfolioValue) ?? true;
  }

  Future<void> setShowPortfolioValue(bool show) async {
    _checkInitialized();
    await _prefs.setBool(_keyShowPortfolioValue, show);
  }

  Future<String> getPreferredCurrency() async {
    _checkInitialized();
    return _prefs.getString(_keyCurrency) ?? 'USD';
  }

  Future<void> setPreferredCurrency(String currency) async {
    _checkInitialized();
    await _prefs.setString(_keyCurrency, currency);
  }

  // Alert Settings
  Future<bool> isPriceAlertsEnabled() async {
    _checkInitialized();
    return _prefs.getBool(_keyPriceAlerts) ?? true;
  }

  Future<void> setPriceAlertsEnabled(bool enabled) async {
    _checkInitialized();
    await _prefs.setBool(_keyPriceAlerts, enabled);
  }

  // Data Provider Settings
  Future<String> getMarketDataProvider() async {
    _checkInitialized();
    return _prefs.getString(_keyMarketDataProvider) ?? 'coingecko';
  }

  Future<void> setMarketDataProvider(String provider) async {
    _checkInitialized();
    await _prefs.setString(_keyMarketDataProvider, provider);
  }

  // Clear all settings
  Future<void> clearAllSettings() async {
    _checkInitialized();
    await _prefs.clear();
    LoggerService.info('All settings cleared');
  }

  // Export settings as JSON
  Map<String, dynamic> exportSettings() {
    _checkInitialized();

    final settings = <String, dynamic>{};
    for (final key in _prefs.getKeys()) {
      settings[key] = _prefs.get(key);
    }

    return settings;
  }

  // Import settings from JSON
  Future<void> importSettings(Map<String, dynamic> settings) async {
    _checkInitialized();

    for (final entry in settings.entries) {
      final value = entry.value;
      if (value is bool) {
        await _prefs.setBool(entry.key, value);
      } else if (value is int) {
        await _prefs.setInt(entry.key, value);
      } else if (value is double) {
        await _prefs.setDouble(entry.key, value);
      } else if (value is String) {
        await _prefs.setString(entry.key, value);
      } else if (value is List<String>) {
        await _prefs.setStringList(entry.key, value);
      }
    }

    LoggerService.info('Settings imported successfully');
  }
}
