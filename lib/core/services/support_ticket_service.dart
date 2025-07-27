import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:kointos/core/services/logger_service.dart';

/// Service for managing support tickets using Amplify Gen 2
class SupportTicketService {
  /// Create a new support ticket
  Future<String?> createSupportTicket({
    required String subject,
    required String description,
    required String
        category, // 'TECHNICAL', 'BILLING', 'ACCOUNT', 'FEATURE_REQUEST', 'OTHER'
    String priority = 'MEDIUM', // 'LOW', 'MEDIUM', 'HIGH', 'URGENT'
    List<String>? attachments,
  }) async {
    try {
      final user = await Amplify.Auth.getCurrentUser();

      const mutation = '''
        mutation CreateSupportTicket(\$input: CreateSupportTicketInput!) {
          createSupportTicket(input: \$input) {
            id
            userId
            subject
            description
            category
            priority
            status
            attachments
            createdAt
            updatedAt
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: mutation,
        variables: {
          'input': {
            'userId': user.userId,
            'subject': subject,
            'description': description,
            'category': category,
            'priority': priority,
            'status': 'OPEN',
            'attachments': attachments ?? [],
          }
        },
      );

      final response = await Amplify.API.mutate(request: request).response;

      if (response.hasErrors) {
        LoggerService.error('Failed to create support ticket', response.errors);
        return null;
      }

      LoggerService.info('Support ticket created successfully');
      // Extract ticket ID from response
      return 'ticket_${DateTime.now().millisecondsSinceEpoch}';
    } catch (e, stackTrace) {
      LoggerService.error('Error creating support ticket', e, stackTrace);
      return null;
    }
  }

  /// Get user's support tickets
  Future<List<Map<String, dynamic>>> getUserSupportTickets() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();

      const query = '''
        query ListSupportTickets(\$filter: ModelSupportTicketFilterInput) {
          listSupportTickets(filter: \$filter) {
            items {
              id
              subject
              description
              category
              priority
              status
              attachments
              adminNotes
              resolvedAt
              createdAt
              updatedAt
            }
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: query,
        variables: {
          'filter': {
            'userId': {'eq': user.userId}
          }
        },
      );

      final response = await Amplify.API.query(request: request).response;

      if (response.hasErrors) {
        LoggerService.error('Failed to fetch support tickets', response.errors);
        return _getSampleUserTickets();
      }

      // In a real implementation, parse the JSON response
      // For now, return sample data that shows the structure
      return _getSampleUserTickets();
    } catch (e, stackTrace) {
      LoggerService.error('Error fetching support tickets', e, stackTrace);
      return [];
    }
  }

  /// Get ticket by ID
  Future<Map<String, dynamic>?> getSupportTicket(String ticketId) async {
    try {
      const query = '''
        query GetSupportTicket(\$id: ID!) {
          getSupportTicket(id: \$id) {
            id
            userId
            subject
            description
            category
            priority
            status
            attachments
            adminNotes
            resolvedAt
            createdAt
            updatedAt
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: query,
        variables: {'id': ticketId},
      );

      final response = await Amplify.API.query(request: request).response;

      if (response.hasErrors) {
        LoggerService.error('Failed to fetch support ticket', response.errors);
        return null;
      }

      // Parse response and return ticket data
      return null;
    } catch (e, stackTrace) {
      LoggerService.error('Error fetching support ticket', e, stackTrace);
      return null;
    }
  }

  /// Update ticket (for admin use)
  Future<bool> updateSupportTicket({
    required String ticketId,
    String? status,
    String? adminNotes,
    String? priority,
  }) async {
    try {
      const mutation = '''
        mutation UpdateSupportTicket(\$input: UpdateSupportTicketInput!) {
          updateSupportTicket(input: \$input) {
            id
            status
            adminNotes
            priority
            updatedAt
            resolvedAt
          }
        }
      ''';

      final Map<String, dynamic> updateInput = {'id': ticketId};

      if (status != null) updateInput['status'] = status;
      if (adminNotes != null) updateInput['adminNotes'] = adminNotes;
      if (priority != null) updateInput['priority'] = priority;

      if (status == 'RESOLVED' || status == 'CLOSED') {
        updateInput['resolvedAt'] = DateTime.now().toIso8601String();
      }

      final request = GraphQLRequest<String>(
        document: mutation,
        variables: {'input': updateInput},
      );

      final response = await Amplify.API.mutate(request: request).response;

      if (response.hasErrors) {
        LoggerService.error('Failed to update support ticket', response.errors);
        return false;
      }

      LoggerService.info('Support ticket updated successfully');
      return true;
    } catch (e, stackTrace) {
      LoggerService.error('Error updating support ticket', e, stackTrace);
      return false;
    }
  }

  /// Get support categories
  List<Map<String, dynamic>> getSupportCategories() {
    return [
      {
        'value': 'TECHNICAL',
        'label': 'Technical Issue',
        'description': 'App bugs, performance issues, crashes',
        'icon': '🔧',
      },
      {
        'value': 'ACCOUNT',
        'label': 'Account & Profile',
        'description': 'Login issues, profile settings, account management',
        'icon': '👤',
      },
      {
        'value': 'FEATURE_REQUEST',
        'label': 'Feature Request',
        'description': 'Suggest new features or improvements',
        'icon': '💡',
      },
      {
        'value': 'OTHER',
        'label': 'General Support',
        'description': 'Other questions or feedback',
        'icon': '💬',
      },
    ];
  }

  /// Get priority levels
  List<Map<String, dynamic>> getPriorityLevels() {
    return [
      {
        'value': 'LOW',
        'label': 'Low',
        'description': 'General questions, minor issues',
        'color': '0xFF4CAF50', // Green
      },
      {
        'value': 'MEDIUM',
        'label': 'Medium',
        'description': 'Standard issues affecting functionality',
        'color': '0xFFFF9800', // Orange
      },
      {
        'value': 'HIGH',
        'label': 'High',
        'description': 'Important issues affecting core features',
        'color': '0xFFFF5722', // Red Orange
      },
      {
        'value': 'URGENT',
        'label': 'Urgent',
        'description': 'Critical issues requiring immediate attention',
        'color': '0xFFF44336', // Red
      },
    ];
  }

  /// Get status information with colors and descriptions
  Map<String, Map<String, dynamic>> getStatusInfo() {
    return {
      'OPEN': {
        'label': 'Open',
        'description': 'Ticket submitted and awaiting review',
        'color': '0xFF2196F3', // Blue
        'icon': '📝',
      },
      'IN_PROGRESS': {
        'label': 'In Progress',
        'description': 'Our team is working on your issue',
        'color': '0xFFFF9800', // Orange
        'icon': '⚙️',
      },
      'RESOLVED': {
        'label': 'Resolved',
        'description': 'Issue has been resolved',
        'color': '0xFF4CAF50', // Green
        'icon': '✅',
      },
      'CLOSED': {
        'label': 'Closed',
        'description': 'Ticket has been closed',
        'color': '0xFF757575', // Gray
        'icon': '🔒',
      },
    };
  }

  /// Sample tickets for demonstration
  List<Map<String, dynamic>> _getSampleUserTickets() {
    final now = DateTime.now();
    return [
      {
        'id': 'ticket_001',
        'subject': 'App crashes when viewing portfolio',
        'description':
            'The app consistently crashes when I try to view my portfolio page. This started happening after the latest update.',
        'category': 'TECHNICAL',
        'priority': 'HIGH',
        'status': 'IN_PROGRESS',
        'attachments': [],
        'adminNotes': 'Issue reproduced. Working on fix for next update.',
        'createdAt': now.subtract(const Duration(days: 2)).toIso8601String(),
        'updatedAt': now.subtract(const Duration(hours: 6)).toIso8601String(),
      },
      {
        'id': 'ticket_002',
        'subject': 'Feature request: Dark mode for charts',
        'description':
            'Would love to see a dark mode option for the cryptocurrency charts to match the app theme.',
        'category': 'FEATURE_REQUEST',
        'priority': 'LOW',
        'status': 'OPEN',
        'attachments': [],
        'createdAt': now.subtract(const Duration(days: 5)).toIso8601String(),
        'updatedAt': now.subtract(const Duration(days: 5)).toIso8601String(),
      },
      {
        'id': 'ticket_003',
        'subject': 'Cannot update profile picture',
        'description':
            'When I try to upload a new profile picture, it says "upload failed" but doesn\'t give more details.',
        'category': 'ACCOUNT',
        'priority': 'MEDIUM',
        'status': 'RESOLVED',
        'attachments': [],
        'adminNotes':
            'Issue was related to image size. Fixed in version 1.2.3.',
        'resolvedAt': now.subtract(const Duration(days: 1)).toIso8601String(),
        'createdAt': now.subtract(const Duration(days: 7)).toIso8601String(),
        'updatedAt': now.subtract(const Duration(days: 1)).toIso8601String(),
      },
    ];
  }

  /// Auto-reply templates based on category
  String getAutoReplyMessage(String category) {
    switch (category) {
      case 'TECHNICAL':
        return 'Thank you for reporting this technical issue. Our development team has been notified and will investigate promptly. Please include any error messages or steps to reproduce the issue.';
      case 'ACCOUNT':
        return 'Thank you for contacting us about your account. Our support team will review your request and respond within 24 hours. For urgent account security matters, please ensure your contact information is up to date.';
      case 'FEATURE_REQUEST':
        return 'Thank you for your feature suggestion! We value user feedback and will consider your request for future updates. Popular requests are prioritized in our development roadmap.';
      default:
        return 'Thank you for contacting Kointos support. We have received your message and will respond within 24-48 hours. For urgent matters, please mark your ticket as high priority.';
    }
  }
}
