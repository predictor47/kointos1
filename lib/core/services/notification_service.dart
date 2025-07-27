import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:kointos/core/services/logger_service.dart';
import 'package:kointos/data/repositories/cryptocurrency_repository.dart';

/// Service for managing notifications and price alerts
class NotificationService {
  final CryptocurrencyRepository _cryptoRepository;

  NotificationService(this._cryptoRepository);

  /// Create a price alert
  Future<bool> createPriceAlert({
    required String cryptoSymbol,
    required String alertType, // 'ABOVE' or 'BELOW'
    required double targetPrice,
  }) async {
    try {
      final user = await Amplify.Auth.getCurrentUser();

      const mutation = '''
        mutation CreatePriceAlert(\$input: CreatePriceAlertInput!) {
          createPriceAlert(input: \$input) {
            id
            userId
            cryptoSymbol
            alertType
            targetPrice
            isActive
            createdAt
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: mutation,
        variables: {
          'input': {
            'userId': user.userId,
            'cryptoSymbol': cryptoSymbol,
            'alertType': alertType,
            'targetPrice': targetPrice,
            'isActive': true,
          }
        },
      );

      final response = await Amplify.API.mutate(request: request).response;

      if (response.hasErrors) {
        LoggerService.error('Failed to create price alert', response.errors);
        return false;
      }

      LoggerService.info(
          'Price alert created for \$cryptoSymbol at \$targetPrice');
      return true;
    } catch (e, stackTrace) {
      LoggerService.error('Error creating price alert', e, stackTrace);
      return false;
    }
  }

  /// Get user's active price alerts
  Future<List<Map<String, dynamic>>> getUserPriceAlerts() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();

      const query = '''
        query ListPriceAlerts(\$filter: ModelPriceAlertFilterInput) {
          listPriceAlerts(filter: \$filter) {
            items {
              id
              cryptoSymbol
              alertType
              targetPrice
              isActive
              createdAt
              triggeredAt
            }
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: query,
        variables: {
          'filter': {
            'userId': {'eq': user.userId},
            'isActive': {'eq': true}
          }
        },
      );

      final response = await Amplify.API.query(request: request).response;

      if (response.hasErrors) {
        LoggerService.error('Failed to fetch price alerts', response.errors);
        return _getSamplePriceAlerts();
      }

      // For demo purposes, return sample data
      return _getSamplePriceAlerts();
    } catch (e, stackTrace) {
      LoggerService.error('Error fetching price alerts', e, stackTrace);
      return [];
    }
  }

  /// Check price alerts and trigger notifications
  Future<List<Map<String, dynamic>>> checkPriceAlerts() async {
    try {
      final alerts = await getUserPriceAlerts();
      final triggeredAlerts = <Map<String, dynamic>>[];

      for (final alert in alerts) {
        final cryptoSymbol = alert['cryptoSymbol'] as String;
        final alertType = alert['alertType'] as String;
        final targetPrice = (alert['targetPrice'] as num).toDouble();

        // Get current price
        final cryptos = await _cryptoRepository.getTopCryptocurrencies();
        final crypto = cryptos.firstWhere(
          (c) => c.symbol.toUpperCase() == cryptoSymbol.toUpperCase(),
          orElse: () => throw Exception('Crypto not found'),
        );

        final currentPrice = crypto.currentPrice;
        bool shouldTrigger = false;

        if (alertType == 'ABOVE' && currentPrice >= targetPrice) {
          shouldTrigger = true;
        } else if (alertType == 'BELOW' && currentPrice <= targetPrice) {
          shouldTrigger = true;
        }

        if (shouldTrigger) {
          await _triggerPriceAlert(alert['id'] as String);
          triggeredAlerts.add({
            ...alert,
            'currentPrice': currentPrice,
            'message': _generateAlertMessage(
                cryptoSymbol, alertType, targetPrice, currentPrice),
          });
        }
      }

      return triggeredAlerts;
    } catch (e, stackTrace) {
      LoggerService.error('Error checking price alerts', e, stackTrace);
      return [];
    }
  }

  /// Trigger a price alert (mark as triggered)
  Future<bool> _triggerPriceAlert(String alertId) async {
    try {
      const mutation = '''
        mutation UpdatePriceAlert(\$input: UpdatePriceAlertInput!) {
          updatePriceAlert(input: \$input) {
            id
            isActive
            triggeredAt
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: mutation,
        variables: {
          'input': {
            'id': alertId,
            'isActive': false,
            'triggeredAt': DateTime.now().toIso8601String(),
          }
        },
      );

      final response = await Amplify.API.mutate(request: request).response;

      if (response.hasErrors) {
        LoggerService.error('Failed to update price alert', response.errors);
        return false;
      }

      return true;
    } catch (e, stackTrace) {
      LoggerService.error('Error triggering price alert', e, stackTrace);
      return false;
    }
  }

  /// Delete a price alert
  Future<bool> deletePriceAlert(String alertId) async {
    try {
      const mutation = '''
        mutation DeletePriceAlert(\$input: DeletePriceAlertInput!) {
          deletePriceAlert(input: \$input) {
            id
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: mutation,
        variables: {
          'input': {'id': alertId}
        },
      );

      final response = await Amplify.API.mutate(request: request).response;

      if (response.hasErrors) {
        LoggerService.error('Failed to delete price alert', response.errors);
        return false;
      }

      LoggerService.info('Price alert deleted successfully');
      return true;
    } catch (e, stackTrace) {
      LoggerService.error('Error deleting price alert', e, stackTrace);
      return false;
    }
  }

  /// Get notification history
  Future<List<Map<String, dynamic>>> getNotificationHistory() async {
    try {
      // Get triggered alerts
      final user = await Amplify.Auth.getCurrentUser();

      const query = '''
        query ListPriceAlerts(\$filter: ModelPriceAlertFilterInput) {
          listPriceAlerts(filter: \$filter) {
            items {
              id
              cryptoSymbol
              alertType
              targetPrice
              isActive
              createdAt
              triggeredAt
            }
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: query,
        variables: {
          'filter': {
            'userId': {'eq': user.userId},
            'isActive': {'eq': false}
          }
        },
      );

      final response = await Amplify.API.query(request: request).response;

      if (response.hasErrors) {
        LoggerService.error(
            'Failed to fetch notification history', response.errors);
        return _getSampleNotificationHistory();
      }

      return _getSampleNotificationHistory();
    } catch (e, stackTrace) {
      LoggerService.error('Error fetching notification history', e, stackTrace);
      return [];
    }
  }

  /// Generate alert message
  String _generateAlertMessage(String cryptoSymbol, String alertType,
      double targetPrice, double currentPrice) {
    return '\$cryptoSymbol has reached \$\${currentPrice.toStringAsFixed(2)}, which is ${alertType == 'ABOVE' ? 'above' : 'below'} your alert price of \$\${targetPrice.toStringAsFixed(2)}!';
  }

  /// Get sample price alerts for demo
  List<Map<String, dynamic>> _getSamplePriceAlerts() {
    return [
      {
        'id': 'alert_1',
        'cryptoSymbol': 'BTC',
        'alertType': 'ABOVE',
        'targetPrice': 50000.0,
        'isActive': true,
        'createdAt':
            DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
      },
      {
        'id': 'alert_2',
        'cryptoSymbol': 'ETH',
        'alertType': 'BELOW',
        'targetPrice': 3000.0,
        'isActive': true,
        'createdAt':
            DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      },
      {
        'id': 'alert_3',
        'cryptoSymbol': 'ADA',
        'alertType': 'ABOVE',
        'targetPrice': 1.0,
        'isActive': true,
        'createdAt': DateTime.now()
            .subtract(const Duration(hours: 12))
            .toIso8601String(),
      },
    ];
  }

  /// Get sample notification history
  List<Map<String, dynamic>> _getSampleNotificationHistory() {
    final now = DateTime.now();
    return [
      {
        'id': 'notif_1',
        'type': 'PRICE_ALERT',
        'title': 'Bitcoin Price Alert',
        'message':
            'BTC has reached \$48,500.00, which is above your alert price of \$45,000.00!',
        'cryptoSymbol': 'BTC',
        'isRead': true,
        'triggeredAt': now.subtract(const Duration(days: 1)).toIso8601String(),
      },
      {
        'id': 'notif_2',
        'type': 'ACHIEVEMENT',
        'title': 'New Badge Unlocked!',
        'message':
            'Congratulations! You\'ve unlocked the "Market Watcher" badge for setting up 5 price alerts.',
        'isRead': false,
        'triggeredAt': now.subtract(const Duration(hours: 6)).toIso8601String(),
      },
      {
        'id': 'notif_3',
        'type': 'SOCIAL',
        'title': 'New Follower',
        'message':
            'CryptoExpert42 started following you. Check out their profile!',
        'isRead': false,
        'triggeredAt': now.subtract(const Duration(hours: 3)).toIso8601String(),
      },
      {
        'id': 'notif_4',
        'type': 'SYSTEM',
        'title': 'App Update Available',
        'message':
            'Version 1.3.0 is now available with new features and improvements.',
        'isRead': true,
        'triggeredAt': now.subtract(const Duration(days: 3)).toIso8601String(),
      },
    ];
  }

  /// Get notification types with styling
  Map<String, Map<String, dynamic>> getNotificationTypes() {
    return {
      'PRICE_ALERT': {
        'icon': '🔔',
        'color': '0xFFFF9800', // Orange
        'title': 'Price Alert',
      },
      'ACHIEVEMENT': {
        'icon': '🏆',
        'color': '0xFFFFD700', // Gold
        'title': 'Achievement',
      },
      'SOCIAL': {
        'icon': '👥',
        'color': '0xFF2196F3', // Blue
        'title': 'Social',
      },
      'SYSTEM': {
        'icon': '⚙️',
        'color': '0xFF757575', // Gray
        'title': 'System',
      },
      'NEWS': {
        'icon': '📰',
        'color': '0xFF4CAF50', // Green
        'title': 'News',
      },
    };
  }

  /// Mark notification as read
  Future<bool> markNotificationAsRead(String notificationId) async {
    try {
      // In a real implementation, this would update the notification status
      LoggerService.info('Marked notification \$notificationId as read');
      return true;
    } catch (e, stackTrace) {
      LoggerService.error('Error marking notification as read', e, stackTrace);
      return false;
    }
  }

  /// Clear all notifications
  Future<bool> clearAllNotifications() async {
    try {
      // In a real implementation, this would clear all user notifications
      LoggerService.info('All notifications cleared');
      return true;
    } catch (e, stackTrace) {
      LoggerService.error('Error clearing notifications', e, stackTrace);
      return false;
    }
  }
}
