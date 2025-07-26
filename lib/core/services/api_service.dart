import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:kointos/core/services/auth_service.dart';
import 'package:kointos/core/services/logger_service.dart';

class ApiService {
  final String baseUrl;
  final AuthService authService;

  ApiService({
    required this.baseUrl,
    required this.authService,
  });

  // Article operations using Amplify GraphQL
  Future<Map<String, dynamic>?> getArticle(String articleId) async {
    try {
      const query = '''
        query GetArticle(\$id: ID!) {
          getArticle(id: \$id) {
            id
            authorId
            authorName
            title
            content
            summary
            coverImageUrl
            contentKey
            tags
            images
            status
            likesCount
            commentsCount
            viewsCount
            isPublic
            publishedAt
            createdAt
            updatedAt
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: query,
        variables: {'id': articleId},
      );

      final response = await Amplify.API.query(request: request).response;

      if (response.data != null) {
        LoggerService.info('Article retrieved successfully');
        final data = jsonDecode(response.data!);
        return data['getArticle'];
      }
      return null;
    } catch (e) {
      LoggerService.error('Failed to get article: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getArticles({
    String? authorId,
    String? status,
    int limit = 10,
    String? nextToken,
  }) async {
    try {
      const query = '''
        query ListArticles(\$authorId: ID, \$status: String, \$limit: Int, \$nextToken: String) {
          listArticles(
            filter: {
              authorId: { eq: \$authorId }
              status: { eq: \$status }
            }
            limit: \$limit
            nextToken: \$nextToken
          ) {
            items {
              id
              authorId
              authorName
              title
              summary
              coverImageUrl
              contentKey
              tags
              status
              likesCount
              commentsCount
              viewsCount
              isPublic
              publishedAt
              createdAt
              updatedAt
            }
            nextToken
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: query,
        variables: {
          if (authorId != null) 'authorId': authorId,
          if (status != null) 'status': status,
          'limit': limit,
          if (nextToken != null) 'nextToken': nextToken,
        },
      );

      final response = await Amplify.API.query(request: request).response;

      if (response.data != null) {
        LoggerService.info('Articles retrieved successfully');
        final data = jsonDecode(response.data!);
        return List<Map<String, dynamic>>.from(data['listArticles']['items']);
      }
      return [];
    } catch (e) {
      LoggerService.error('Failed to get articles: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> createArticle({
    required String authorId,
    required String authorName,
    required String title,
    String? content,
    String? summary,
    String? coverImageUrl,
    required String contentKey,
    List<String>? tags,
    List<String>? images,
    String status = 'DRAFT',
    bool isPublic = true,
  }) async {
    try {
      const mutation = '''
        mutation CreateArticle(\$input: CreateArticleInput!) {
          createArticle(input: \$input) {
            id
            authorId
            authorName
            title
            content
            summary
            coverImageUrl
            contentKey
            tags
            images
            status
            likesCount
            commentsCount
            viewsCount
            isPublic
            publishedAt
            createdAt
            updatedAt
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: mutation,
        variables: {
          'input': {
            'authorId': authorId,
            'authorName': authorName,
            'title': title,
            if (content != null) 'content': content,
            if (summary != null) 'summary': summary,
            if (coverImageUrl != null) 'coverImageUrl': coverImageUrl,
            'contentKey': contentKey,
            if (tags != null) 'tags': tags,
            if (images != null) 'images': images,
            'status': status,
            'isPublic': isPublic,
            'likesCount': 0,
            'commentsCount': 0,
            'viewsCount': 0,
            'createdAt': DateTime.now().toIso8601String(),
            'updatedAt': DateTime.now().toIso8601String(),
          }
        },
      );

      final response = await Amplify.API.mutate(request: request).response;

      if (response.data != null) {
        LoggerService.info('Article created successfully');
        final data = jsonDecode(response.data!);
        return data['createArticle'];
      }
      return null;
    } catch (e) {
      LoggerService.error('Failed to create article: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> updateArticle({
    required String id,
    String? title,
    String? content,
    String? summary,
    String? coverImageUrl,
    List<String>? tags,
    List<String>? images,
    String? status,
    bool? isPublic,
  }) async {
    try {
      const mutation = '''
        mutation UpdateArticle(\$input: UpdateArticleInput!) {
          updateArticle(input: \$input) {
            id
            authorId
            authorName
            title
            content
            summary
            coverImageUrl
            contentKey
            tags
            images
            status
            likesCount
            commentsCount
            viewsCount
            isPublic
            publishedAt
            createdAt
            updatedAt
          }
        }
      ''';

      final Map<String, dynamic> input = {'id': id};
      if (title != null) input['title'] = title;
      if (content != null) input['content'] = content;
      if (summary != null) input['summary'] = summary;
      if (coverImageUrl != null) input['coverImageUrl'] = coverImageUrl;
      if (tags != null) input['tags'] = tags;
      if (images != null) input['images'] = images;
      if (status != null) input['status'] = status;
      if (isPublic != null) input['isPublic'] = isPublic;
      input['updatedAt'] = DateTime.now().toIso8601String();

      final request = GraphQLRequest<String>(
        document: mutation,
        variables: {'input': input},
      );

      final response = await Amplify.API.mutate(request: request).response;

      if (response.data != null) {
        LoggerService.info('Article updated successfully');
        final data = jsonDecode(response.data!);
        return data['updateArticle'];
      }
      return null;
    } catch (e) {
      LoggerService.error('Failed to update article: $e');
      rethrow;
    }
  }

  Future<bool> deleteArticle(String articleId) async {
    try {
      const mutation = '''
        mutation DeleteArticle(\$input: DeleteArticleInput!) {
          deleteArticle(input: \$input) {
            id
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: mutation,
        variables: {
          'input': {'id': articleId}
        },
      );

      final response = await Amplify.API.mutate(request: request).response;

      if (response.data != null) {
        LoggerService.info('Article deleted successfully');
        return true;
      }
      return false;
    } catch (e) {
      LoggerService.error('Failed to delete article: $e');
      rethrow;
    }
  }

  // User Profile operations
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      const query = '''
        query GetUserProfile(\$userId: ID!) {
          getUserProfile(userId: \$userId) {
            userId
            email
            username
            displayName
            bio
            profilePicture
            totalPortfolioValue
            followersCount
            followingCount
            isPublic
            createdAt
            updatedAt
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: query,
        variables: {'userId': userId},
      );

      final response = await Amplify.API.query(request: request).response;

      if (response.data != null) {
        LoggerService.info('User profile retrieved successfully');
        final data = jsonDecode(response.data!);
        return data['getUserProfile'];
      }
      return null;
    } catch (e) {
      LoggerService.error('Failed to get user profile: $e');
      rethrow;
    }
  }

  // Payment Methods operations
  Future<List<Map<String, dynamic>>> getPaymentMethods(String userId) async {
    try {
      const query = '''
        query ListPaymentMethods(\$userId: ID!) {
          listPaymentMethods(filter: { userId: { eq: \$userId } }) {
            items {
              id
              userId
              type
              name
              last4
              expiryMonth
              expiryYear
              bankName
              accountType
              walletAddress
              isDefault
              isActive
              createdAt
              updatedAt
            }
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: query,
        variables: {'userId': userId},
      );

      final response = await Amplify.API.query(request: request).response;

      if (response.data != null) {
        LoggerService.info('Payment methods retrieved successfully');
        final data = jsonDecode(response.data!);
        return List<Map<String, dynamic>>.from(
            data['listPaymentMethods']['items']);
      }
      return [];
    } catch (e) {
      LoggerService.error('Failed to get payment methods: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> createPaymentMethod({
    required String userId,
    required String type,
    required String name,
    String? last4,
    int? expiryMonth,
    int? expiryYear,
    String? bankName,
    String? accountType,
    String? walletAddress,
    bool isDefault = false,
  }) async {
    try {
      const mutation = '''
        mutation CreatePaymentMethod(\$input: CreatePaymentMethodInput!) {
          createPaymentMethod(input: \$input) {
            id
            userId
            type
            name
            last4
            expiryMonth
            expiryYear
            bankName
            accountType
            walletAddress
            isDefault
            isActive
            createdAt
            updatedAt
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: mutation,
        variables: {
          'input': {
            'userId': userId,
            'type': type,
            'name': name,
            if (last4 != null) 'last4': last4,
            if (expiryMonth != null) 'expiryMonth': expiryMonth,
            if (expiryYear != null) 'expiryYear': expiryYear,
            if (bankName != null) 'bankName': bankName,
            if (accountType != null) 'accountType': accountType,
            if (walletAddress != null) 'walletAddress': walletAddress,
            'isDefault': isDefault,
            'isActive': true,
            'createdAt': DateTime.now().toIso8601String(),
            'updatedAt': DateTime.now().toIso8601String(),
          }
        },
      );

      final response = await Amplify.API.mutate(request: request).response;

      if (response.data != null) {
        LoggerService.info('Payment method created successfully');
        final data = jsonDecode(response.data!);
        return data['createPaymentMethod'];
      }
      return null;
    } catch (e) {
      LoggerService.error('Failed to create payment method: $e');
      rethrow;
    }
  }

  // Support Ticket operations
  Future<Map<String, dynamic>?> createSupportTicket({
    required String userId,
    required String subject,
    required String description,
    required String category,
    String priority = 'MEDIUM',
    List<String>? attachments,
  }) async {
    try {
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
            adminNotes
            resolvedAt
            createdAt
            updatedAt
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: mutation,
        variables: {
          'input': {
            'userId': userId,
            'subject': subject,
            'description': description,
            'category': category,
            'priority': priority,
            'status': 'OPEN',
            if (attachments != null) 'attachments': attachments,
            'createdAt': DateTime.now().toIso8601String(),
            'updatedAt': DateTime.now().toIso8601String(),
          }
        },
      );

      final response = await Amplify.API.mutate(request: request).response;

      if (response.data != null) {
        LoggerService.info('Support ticket created successfully');
        final data = jsonDecode(response.data!);
        return data['createSupportTicket'];
      }
      return null;
    } catch (e) {
      LoggerService.error('Failed to create support ticket: $e');
      rethrow;
    }
  }

  // FAQ operations
  Future<List<Map<String, dynamic>>> getFAQs({String? category}) async {
    try {
      const query = '''
        query ListFAQs(\$category: String) {
          listFAQs(
            filter: {
              isPublished: { eq: true }
              category: { eq: \$category }
            }
          ) {
            items {
              id
              question
              answer
              category
              tags
              isPublished
              order
              createdAt
              updatedAt
            }
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: query,
        variables: {
          if (category != null) 'category': category,
        },
      );

      final response = await Amplify.API.query(request: request).response;

      if (response.data != null) {
        LoggerService.info('FAQs retrieved successfully');
        final data = jsonDecode(response.data!);
        return List<Map<String, dynamic>>.from(data['listFAQs']['items']);
      }
      return [];
    } catch (e) {
      LoggerService.error('Failed to get FAQs: $e');
      return [];
    }
  }

  // User Settings operations
  Future<Map<String, dynamic>?> getUserSettings(String userId) async {
    try {
      const query = '''
        query GetUserSettings(\$userId: ID!) {
          getUserSettings(userId: \$userId) {
            userId
            theme
            language
            currency
            notificationsEnabled
            emailNotifications
            pushNotifications
            marketAlerts
            portfolioPrivacy
            twoFactorEnabled
            biometricEnabled
            dataRetention
            createdAt
            updatedAt
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: query,
        variables: {'userId': userId},
      );

      final response = await Amplify.API.query(request: request).response;

      if (response.data != null) {
        LoggerService.info('User settings retrieved successfully');
        final data = jsonDecode(response.data!);
        return data['getUserSettings'];
      }
      return null;
    } catch (e) {
      LoggerService.error('Failed to get user settings: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> updateUserSettings({
    required String userId,
    String? theme,
    String? language,
    String? currency,
    bool? notificationsEnabled,
    bool? emailNotifications,
    bool? pushNotifications,
    bool? marketAlerts,
    bool? portfolioPrivacy,
    bool? twoFactorEnabled,
    bool? biometricEnabled,
    int? dataRetention,
  }) async {
    try {
      const mutation = '''
        mutation UpdateUserSettings(\$input: UpdateUserSettingsInput!) {
          updateUserSettings(input: \$input) {
            userId
            theme
            language
            currency
            notificationsEnabled
            emailNotifications
            pushNotifications
            marketAlerts
            portfolioPrivacy
            twoFactorEnabled
            biometricEnabled
            dataRetention
            createdAt
            updatedAt
          }
        }
      ''';

      final Map<String, dynamic> input = {'userId': userId};
      if (theme != null) input['theme'] = theme;
      if (language != null) input['language'] = language;
      if (currency != null) input['currency'] = currency;
      if (notificationsEnabled != null) {
        input['notificationsEnabled'] = notificationsEnabled;
      }
      if (emailNotifications != null) {
        input['emailNotifications'] = emailNotifications;
      }
      if (pushNotifications != null) {
        input['pushNotifications'] = pushNotifications;
      }
      if (marketAlerts != null) input['marketAlerts'] = marketAlerts;
      if (portfolioPrivacy != null) {
        input['portfolioPrivacy'] = portfolioPrivacy;
      }
      if (twoFactorEnabled != null) {
        input['twoFactorEnabled'] = twoFactorEnabled;
      }
      if (biometricEnabled != null) {
        input['biometricEnabled'] = biometricEnabled;
      }
      if (dataRetention != null) input['dataRetention'] = dataRetention;
      input['updatedAt'] = DateTime.now().toIso8601String();

      final request = GraphQLRequest<String>(
        document: mutation,
        variables: {'input': input},
      );

      final response = await Amplify.API.mutate(request: request).response;

      if (response.data != null) {
        LoggerService.info('User settings updated successfully');
        final data = jsonDecode(response.data!);
        return data['updateUserSettings'];
      }
      return null;
    } catch (e) {
      LoggerService.error('Failed to update user settings: $e');
      rethrow;
    }
  }

  // Account deletion
  Future<bool> deleteUserAccount(String userId) async {
    try {
      const mutation = '''
        mutation DeleteUserAccount(\$userId: ID!) {
          deleteUserProfile(input: { userId: \$userId }) {
            userId
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: mutation,
        variables: {'userId': userId},
      );

      final response = await Amplify.API.mutate(request: request).response;

      if (response.data != null) {
        LoggerService.info('User account deleted successfully');
        return true;
      }
      return false;
    } catch (e) {
      LoggerService.error('Failed to delete user account: $e');
      rethrow;
    }
  }

  // Transaction History
  Future<List<Map<String, dynamic>>> getTransactionHistory({
    required String userId,
    int limit = 20,
    String? nextToken,
  }) async {
    try {
      const query = '''
        query ListTransactions(\$userId: ID!, \$limit: Int, \$nextToken: String) {
          listTransactions(
            filter: { portfolioId: { beginsWith: \$userId } }
            limit: \$limit
            nextToken: \$nextToken
          ) {
            items {
              id
              portfolioId
              cryptoSymbol
              type
              amount
              price
              totalValue
              fees
              notes
              transactionDate
              createdAt
            }
            nextToken
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: query,
        variables: {
          'userId': userId,
          'limit': limit,
          if (nextToken != null) 'nextToken': nextToken,
        },
      );

      final response = await Amplify.API.query(request: request).response;

      if (response.data != null) {
        LoggerService.info('Transaction history retrieved successfully');
        final data = jsonDecode(response.data!);
        return List<Map<String, dynamic>>.from(
            data['listTransactions']['items']);
      }
      return [];
    } catch (e) {
      LoggerService.error('Failed to get transaction history: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/$endpoint').replace(
        queryParameters: queryParameters?.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );

      final response = await http.get(
        uri,
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: await _getHeaders(),
        body: json.encode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$endpoint'),
        headers: await _getHeaders(),
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to update data: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$endpoint'),
        headers: await _getHeaders(),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete data: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, String>> _getHeaders() async {
    final headers = {
      'Content-Type': 'application/json',
    };

    try {
      final token = await authService.getUserToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      // Handle auth error or continue without token
    }

    return headers;
  }
}
