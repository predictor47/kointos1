import 'dart:async';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:kointos/core/services/logger_service.dart';
import 'package:kointos/core/services/service_locator.dart';
import 'package:kointos/core/services/settings_service.dart';

/// Service for tracking analytics using Amazon Pinpoint
class PinpointAnalyticsService {
  final SettingsService _settingsService;
  bool _initialized = false;
  String? _userId;

  PinpointAnalyticsService({SettingsService? settingsService})
      : _settingsService = settingsService ?? getService<SettingsService>();

  /// Initialize Pinpoint analytics
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Check if analytics are enabled in settings
      final analyticsEnabled = await _settingsService.isAnalyticsEnabled();
      if (!analyticsEnabled) {
        LoggerService.info('Analytics disabled in settings');
        return;
      }

      // Get current user
      final user = await Amplify.Auth.getCurrentUser();
      _userId = user.userId;

      // Register user with Pinpoint
      await _registerUser();

      _initialized = true;
      LoggerService.info('Pinpoint analytics initialized');

      // Track app open event
      await trackEvent('app_opened');
    } catch (e) {
      LoggerService.error('Failed to initialize Pinpoint analytics: $e');
    }
  }

  /// Register user with Pinpoint
  Future<void> _registerUser() async {
    try {
      if (_userId == null) return;

      // Register user with Analytics
      const userProfile = UserProfile();
      userProfile.customProperties
        ?..addStringProperty('userId', _userId!)
        ..addStringProperty('registeredAt', DateTime.now().toIso8601String());

      await Amplify.Analytics.identifyUser(
        userId: _userId!,
        userProfile: userProfile,
      );

      LoggerService.info('User registered with Pinpoint: $_userId');
    } catch (e) {
      LoggerService.error('Failed to register user with Pinpoint: $e');
    }
  }

  /// Track a custom event
  Future<void> trackEvent(
    String eventName, {
    Map<String, dynamic>? properties,
    Map<String, double>? metrics,
  }) async {
    if (!_initialized) return;

    try {
      final event = AnalyticsEvent(eventName);

      // Add properties
      properties?.forEach((key, value) {
        if (value is String) {
          event.customProperties.addStringProperty(key, value);
        } else if (value is int) {
          event.customProperties.addIntProperty(key, value);
        } else if (value is double) {
          event.customProperties.addDoubleProperty(key, value);
        } else if (value is bool) {
          event.customProperties.addBoolProperty(key, value);
        }
      });

      // Add metrics
      metrics?.forEach((key, value) {
        event.customProperties.addDoubleProperty(key, value);
      });

      await Amplify.Analytics.recordEvent(event: event);
      LoggerService.debug('Tracked event: $eventName');
    } catch (e) {
      LoggerService.error('Failed to track event $eventName: $e');
    }
  }

  /// Track screen view
  Future<void> trackScreenView(
    String screenName, {
    Map<String, dynamic>? properties,
  }) async {
    await trackEvent(
      'screen_view',
      properties: {
        'screen_name': screenName,
        ...?properties,
      },
    );
  }

  /// Track user action
  Future<void> trackUserAction(
    String action, {
    String? category,
    String? label,
    int? value,
    Map<String, dynamic>? properties,
  }) async {
    await trackEvent(
      'user_action',
      properties: {
        'action': action,
        if (category != null) 'category': category,
        if (label != null) 'label': label,
        if (value != null) 'value': value,
        ...?properties,
      },
    );
  }

  /// Track gamification events
  Future<void> trackGamificationEvent(
    String eventType, {
    int? xpEarned,
    int? newLevel,
    String? badgeId,
    String? achievement,
    Map<String, dynamic>? properties,
  }) async {
    await trackEvent(
      'gamification_$eventType',
      properties: {
        if (xpEarned != null) 'xp_earned': xpEarned,
        if (newLevel != null) 'new_level': newLevel,
        if (badgeId != null) 'badge_id': badgeId,
        if (achievement != null) 'achievement': achievement,
        ...?properties,
      },
      metrics: {
        if (xpEarned != null) 'xp_earned': xpEarned.toDouble(),
        if (newLevel != null) 'level': newLevel.toDouble(),
      },
    );
  }

  /// Track crypto-related events
  Future<void> trackCryptoEvent(
    String eventType, {
    String? cryptoId,
    String? cryptoSymbol,
    double? price,
    double? changePercent,
    Map<String, dynamic>? properties,
  }) async {
    await trackEvent(
      'crypto_$eventType',
      properties: {
        if (cryptoId != null) 'crypto_id': cryptoId,
        if (cryptoSymbol != null) 'crypto_symbol': cryptoSymbol,
        if (price != null) 'price': price,
        if (changePercent != null) 'change_percent': changePercent,
        ...?properties,
      },
      metrics: {
        if (price != null) 'price': price,
        if (changePercent != null) 'change_percent': changePercent,
      },
    );
  }

  /// Track social events
  Future<void> trackSocialEvent(
    String eventType, {
    String? postId,
    String? userId,
    String? contentType,
    Map<String, dynamic>? properties,
  }) async {
    await trackEvent(
      'social_$eventType',
      properties: {
        if (postId != null) 'post_id': postId,
        if (userId != null) 'user_id': userId,
        if (contentType != null) 'content_type': contentType,
        ...?properties,
      },
    );
  }

  /// Track article events
  Future<void> trackArticleEvent(
    String eventType, {
    String? articleId,
    String? articleTitle,
    String? category,
    int? readTime,
    Map<String, dynamic>? properties,
  }) async {
    await trackEvent(
      'article_$eventType',
      properties: {
        if (articleId != null) 'article_id': articleId,
        if (articleTitle != null) 'article_title': articleTitle,
        if (category != null) 'category': category,
        if (readTime != null) 'read_time': readTime,
        ...?properties,
      },
      metrics: {
        if (readTime != null) 'read_time': readTime.toDouble(),
      },
    );
  }

  /// Track user engagement
  Future<void> trackEngagement({
    required String engagementType,
    int? duration,
    Map<String, dynamic>? properties,
  }) async {
    await trackEvent(
      'user_engagement',
      properties: {
        'engagement_type': engagementType,
        if (duration != null) 'duration': duration,
        ...?properties,
      },
      metrics: {
        if (duration != null) 'duration': duration.toDouble(),
      },
    );
  }

  /// Track error events
  Future<void> trackError({
    required String errorType,
    required String errorMessage,
    String? stackTrace,
    Map<String, dynamic>? properties,
  }) async {
    await trackEvent(
      'error_occurred',
      properties: {
        'error_type': errorType,
        'error_message': errorMessage,
        if (stackTrace != null) 'stack_trace': stackTrace,
        ...?properties,
      },
    );
  }

  /// Update user attributes
  Future<void> updateUserAttributes(Map<String, dynamic> attributes) async {
    if (!_initialized || _userId == null) return;

    try {
      const userProfile = UserProfile();

      // Add custom properties based on attribute types
      attributes.forEach((key, value) {
        if (value is String) {
          userProfile.customProperties?.addStringProperty(key, value);
        } else if (value is int) {
          userProfile.customProperties?.addIntProperty(key, value);
        } else if (value is double) {
          userProfile.customProperties?.addDoubleProperty(key, value);
        } else if (value is bool) {
          userProfile.customProperties?.addBoolProperty(key, value);
        } else {
          userProfile.customProperties
              ?.addStringProperty(key, value.toString());
        }
      });

      await Amplify.Analytics.identifyUser(
        userId: _userId!,
        userProfile: userProfile,
      );

      LoggerService.info('Updated user attributes');
    } catch (e) {
      LoggerService.error('Failed to update user attributes: $e');
    }
  }

  /// Track session start
  Future<void> startSession() async {
    if (!_initialized) return;

    try {
      // Amplify Analytics automatically manages sessions
      await trackEvent('session_start', properties: {
        'timestamp': DateTime.now().toIso8601String(),
      });
      LoggerService.info('Analytics session started');
    } catch (e) {
      LoggerService.error('Failed to start session: $e');
    }
  }

  /// Track session end
  Future<void> endSession() async {
    if (!_initialized) return;

    try {
      await trackEvent('session_end', properties: {
        'timestamp': DateTime.now().toIso8601String(),
      });
      // Flush events before ending session
      await flushEvents();
      LoggerService.info('Analytics session ended');
    } catch (e) {
      LoggerService.error('Failed to end session: $e');
    }
  }

  /// Flush pending events
  Future<void> flushEvents() async {
    if (!_initialized) return;

    try {
      await Amplify.Analytics.flushEvents();
      LoggerService.info('Analytics events flushed');
    } catch (e) {
      LoggerService.error('Failed to flush events: $e');
    }
  }

  /// Check if analytics is initialized
  bool get isInitialized => _initialized;

  /// Disable analytics (for user opt-out)
  Future<void> disable() async {
    try {
      await Amplify.Analytics.disable();
      _initialized = false;
      LoggerService.info('Analytics disabled');
    } catch (e) {
      LoggerService.error('Failed to disable analytics: $e');
    }
  }

  /// Enable analytics (after user opt-in)
  Future<void> enable() async {
    try {
      await Amplify.Analytics.enable();
      await initialize();
      LoggerService.info('Analytics enabled');
    } catch (e) {
      LoggerService.error('Failed to enable analytics: $e');
    }
  }
}
