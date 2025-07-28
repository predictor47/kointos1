import 'dart:async';
import 'dart:convert';
import 'package:kointos/core/services/logger_service.dart';
import 'package:kointos/core/services/settings_service.dart';
import 'package:kointos/core/services/service_locator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

/// Service for managing push notifications using AWS SNS
/// This is a simplified implementation that can be extended with Firebase or other services
class PushNotificationService {
  final SettingsService _settingsService;

  StreamController<Map<String, dynamic>>? _notificationController;
  Stream<Map<String, dynamic>>? _notificationStream;

  String? _deviceToken;
  bool _initialized = false;

  // In-memory notification queue for demo purposes
  final List<Map<String, dynamic>> _notificationQueue = [];

  PushNotificationService({SettingsService? settingsService})
      : _settingsService = settingsService ?? getService<SettingsService>();

  /// Initialize push notification service
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Check if notifications are enabled in settings
      final notificationsEnabled =
          await _settingsService.isNotificationsEnabled();
      if (!notificationsEnabled) {
        LoggerService.info('Push notifications disabled in settings');
        return;
      }

      // Initialize notification stream
      _notificationController =
          StreamController<Map<String, dynamic>>.broadcast();
      _notificationStream = _notificationController!.stream;

      // In a real app, you would:
      // 1. Request notification permissions
      // 2. Get device token from platform (iOS/Android)
      // 3. Register device with AWS SNS
      // 4. Subscribe to topics

      // For demo, generate a mock device token
      _deviceToken = 'demo_token_${DateTime.now().millisecondsSinceEpoch}';

      // Save token to backend
      await _saveTokenToBackend(_deviceToken!);

      _initialized = true;
      LoggerService.info('Push notification service initialized (demo mode)');

      // Start checking for notifications periodically
      _startNotificationPolling();
    } catch (e) {
      LoggerService.error('Failed to initialize push notifications: $e');
    }
  }

  /// Start polling for notifications (demo implementation)
  void _startNotificationPolling() {
    Timer.periodic(const Duration(seconds: 30), (timer) async {
      if (!_initialized) {
        timer.cancel();
        return;
      }

      // Check for new notifications from backend
      await _checkForNotifications();
    });
  }

  /// Check for new notifications
  Future<void> _checkForNotifications() async {
    try {
      // In a real app, this would query the backend for new notifications
      // For demo, we'll simulate notifications based on user activity

      final user = await Amplify.Auth.getCurrentUser();

      // Query for notifications
      const query = '''
        query GetUserNotifications(\$userId: ID!, \$lastCheck: AWSDateTime) {
          listNotifications(
            filter: {
              userId: { eq: \$userId }
              createdAt: { gt: \$lastCheck }
            }
          ) {
            items {
              id
              type
              title
              body
              data
              createdAt
            }
          }
        }
      ''';

      final lastCheck = DateTime.now().subtract(const Duration(minutes: 1));

      final request = GraphQLRequest<String>(
        document: query,
        variables: {
          'userId': user.userId,
          'lastCheck': lastCheck.toIso8601String(),
        },
      );

      final response = await Amplify.API.query(request: request).response;

      if (response.data != null) {
        final data = jsonDecode(response.data!);
        final notifications = data['listNotifications']['items'] as List;

        for (final notification in notifications) {
          _handleIncomingNotification(notification);
        }
      }
    } catch (e) {
      LoggerService.error('Error checking for notifications: $e');
    }
  }

  /// Handle incoming notification
  void _handleIncomingNotification(Map<String, dynamic> notification) {
    LoggerService.info('Received notification: ${notification['id']}');

    // Add to queue
    _notificationQueue.add(notification);

    // Emit to stream
    _notificationController?.add({
      'type': 'new',
      'notification': notification,
    });

    // Show local notification (would use flutter_local_notifications in real app)
    _showLocalNotification(notification);
  }

  /// Show local notification (simplified for demo)
  void _showLocalNotification(Map<String, dynamic> notification) {
    LoggerService.info('Showing notification: ${notification['title']}');

    // In a real app, this would use flutter_local_notifications
    // to show a system notification
  }

  /// Handle navigation based on notification data
  void _handleNotificationNavigation(Map<String, dynamic> data) {
    final type = data['type'] as String?;

    switch (type) {
      case 'price_alert':
        // Navigate to market screen
        LoggerService.info('Navigate to market for price alert');
        break;
      case 'social':
        // Navigate to social feed
        LoggerService.info('Navigate to social feed');
        break;
      case 'achievement':
        // Navigate to profile/achievements
        LoggerService.info('Navigate to achievements');
        break;
      case 'article':
        // Navigate to specific article
        final articleId = data['articleId'] as String?;
        if (articleId != null) {
          LoggerService.info('Navigate to article: $articleId');
        }
        break;
      default:
        LoggerService.info('Unknown notification type: $type');
    }
  }

  /// Save device token to backend
  Future<void> _saveTokenToBackend(String token) async {
    try {
      final user = await Amplify.Auth.getCurrentUser();

      const mutation = '''
        mutation UpdateUserProfile(\$input: UpdateUserProfileInput!) {
          updateUserProfile(input: \$input) {
            userId
            deviceToken
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: mutation,
        variables: {
          'input': {
            'userId': user.userId,
            'deviceToken': token,
          }
        },
      );

      await Amplify.API.mutate(request: request).response;
      LoggerService.info('Device token saved to backend');
    } catch (e) {
      LoggerService.error('Failed to save device token: $e');
    }
  }

  /// Send local notification (for demo purposes)
  Future<void> sendLocalNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    final notification = {
      'id': 'local_${DateTime.now().millisecondsSinceEpoch}',
      'type': data?['type'] ?? 'local',
      'title': title,
      'body': body,
      'data': data ?? {},
      'createdAt': DateTime.now().toIso8601String(),
    };

    _handleIncomingNotification(notification);
  }

  /// Schedule a notification (for demo purposes)
  Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledDate,
    Map<String, dynamic>? data,
  }) async {
    // In a real app, this would schedule a notification
    // For demo, we'll just log it
    LoggerService.info('Scheduled notification for $scheduledDate: $title');

    // Simulate scheduling by adding to queue with delay
    Future.delayed(scheduledDate.difference(DateTime.now()), () {
      if (_initialized) {
        sendLocalNotification(
          title: title,
          body: body,
          data: data,
        );
      }
    });
  }

  /// Get notification history
  List<Map<String, dynamic>> getNotificationHistory() {
    return List.from(_notificationQueue.reversed);
  }

  /// Clear notification history
  void clearNotificationHistory() {
    _notificationQueue.clear();
  }

  /// Mark notification as read
  void markAsRead(String notificationId) {
    final index =
        _notificationQueue.indexWhere((n) => n['id'] == notificationId);
    if (index != -1) {
      _notificationQueue[index]['isRead'] = true;
    }
  }

  /// Get unread count
  int getUnreadCount() {
    return _notificationQueue.where((n) => n['isRead'] != true).length;
  }

  /// Get notification stream
  Stream<Map<String, dynamic>>? get notificationStream => _notificationStream;

  /// Get device token
  String? get deviceToken => _deviceToken;

  /// Check if service is initialized
  bool get isInitialized => _initialized;

  /// Dispose service
  void dispose() {
    _notificationController?.close();
  }

  /// Simulate notifications for demo
  Future<void> simulateDemoNotifications() async {
    if (!_initialized) return;

    // Simulate achievement notification
    await sendLocalNotification(
      title: '🏆 Achievement Unlocked!',
      body: 'You\'ve earned the "Active Trader" badge!',
      data: {'type': 'achievement', 'badgeId': 'active_trader'},
    );

    // Simulate social notification
    await Future.delayed(const Duration(seconds: 2));
    await sendLocalNotification(
      title: '👥 New Follower',
      body: 'CryptoExpert started following you',
      data: {'type': 'social', 'userId': 'user123'},
    );

    // Simulate price alert
    await Future.delayed(const Duration(seconds: 2));
    await sendLocalNotification(
      title: '📈 Price Alert',
      body: 'Bitcoin has reached \$50,000!',
      data: {'type': 'price_alert', 'crypto': 'BTC', 'price': 50000},
    );

    // Simulate article notification
    await Future.delayed(const Duration(seconds: 2));
    await sendLocalNotification(
      title: '📰 New Article',
      body: 'Check out "Understanding DeFi Protocols"',
      data: {'type': 'article', 'articleId': 'article123'},
    );
  }
}
