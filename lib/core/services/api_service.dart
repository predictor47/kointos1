import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:kointos/core/services/auth_service.dart';
import 'package:kointos/core/services/logger_service.dart';

class ApiService {
  final String baseUrl;
  final AuthService authService;

  ApiService({required this.baseUrl, required this.authService});

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
            owner
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
      } else if (response.errors.isNotEmpty) {
        LoggerService.error('GraphQL errors: ${response.errors}');
        throw Exception(
          'Failed to get article: ${response.errors.first.message}',
        );
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
        query ListArticles(\$filter: ModelArticleFilterInput, \$limit: Int, \$nextToken: String) {
          listArticles(
            filter: \$filter
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
              owner
            }
            nextToken
          }
        }
      ''';

      // Build filter object properly
      Map<String, dynamic>? filter;
      if (authorId != null || status != null) {
        filter = {};
        if (authorId != null) {
          filter['authorId'] = {'eq': authorId};
        }
        if (status != null) {
          filter['status'] = {'eq': status};
        }
      }

      final request = GraphQLRequest<String>(
        document: query,
        variables: {
          if (filter != null) 'filter': filter,
          'limit': limit,
          if (nextToken != null) 'nextToken': nextToken,
        },
      );

      final response = await Amplify.API.query(request: request).response;

      if (response.data != null) {
        LoggerService.info('Articles retrieved successfully');
        final data = jsonDecode(response.data!);
        final items = data['listArticles']['items'] as List?;
        return items?.cast<Map<String, dynamic>>() ?? [];
      } else if (response.errors.isNotEmpty) {
        LoggerService.error('GraphQL errors: ${response.errors}');
        return [];
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
          },
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
          'input': {'id': articleId},
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
        query GetUserProfile(\$id: ID!) {
          getUserProfile(id: \$id) {
            id
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
            totalPoints
            level
            streak
            badges
            lastActivity
            actionsToday
            weeklyPoints
            monthlyPoints
            globalRank
            createdAt
            updatedAt
            owner
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: query,
        variables: {'id': userId},
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

  Future<Map<String, dynamic>?> createUserProfile({
    required String userId,
    required String email,
    required String username,
    String? displayName,
    String? bio,
  }) async {
    try {
      const mutation = '''
        mutation CreateUserProfile(\$input: CreateUserProfileInput!) {
          createUserProfile(input: \$input) {
            id
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
            totalPoints
            level
            streak
            badges
            lastActivity
            actionsToday
            weeklyPoints
            monthlyPoints
            globalRank
            createdAt
            updatedAt
            owner
          }
        }
      ''';

      final now = DateTime.now().toIso8601String();

      final request = GraphQLRequest<String>(
        document: mutation,
        variables: {
          'input': {
            'userId': userId,
            'email': email,
            'username': username,
            'displayName': displayName ?? username,
            'bio': bio ?? 'Welcome to Kointos!',
            'lastActivity': now,
          },
        },
      );

      final response = await Amplify.API.mutate(request: request).response;

      LoggerService.info(
          'Create user profile response - Data: ${response.data}, Errors: ${response.errors}');

      if (response.data != null) {
        LoggerService.info('User profile created successfully');
        final data = jsonDecode(response.data!);
        final profile = data['createUserProfile'];
        if (profile != null) {
          LoggerService.info('Profile data received: ${profile.toString()}');
          return profile;
        } else {
          LoggerService.error('Profile data is null in response');
          throw Exception('Profile creation returned null data');
        }
      } else if (response.errors.isNotEmpty) {
        LoggerService.error('GraphQL errors: ${response.errors}');
        throw Exception(
          'Failed to create user profile: ${response.errors.first.message}',
        );
      } else {
        LoggerService.error('No data and no errors in response');
        throw Exception('Profile creation failed - empty response');
      }
    } catch (e) {
      LoggerService.error('Failed to create user profile: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> updateUserProfile({
    required String userId,
    String? displayName,
    String? bio,
    String? profilePicture,
  }) async {
    try {
      const mutation = '''
        mutation UpdateUserProfile(\$input: UpdateUserProfileInput!) {
          updateUserProfile(input: \$input) {
            id
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
            totalPoints
            level
            streak
            badges
            lastActivity
            actionsToday
            weeklyPoints
            monthlyPoints
            globalRank
            createdAt
            updatedAt
            owner
          }
        }
      ''';

      final input = <String, dynamic>{'id': userId};

      if (displayName != null) input['displayName'] = displayName;
      if (bio != null) input['bio'] = bio;
      if (profilePicture != null) input['profilePicture'] = profilePicture;

      final request = GraphQLRequest<String>(
        document: mutation,
        variables: {'input': input},
      );

      final response = await Amplify.API.mutate(request: request).response;

      if (response.data != null) {
        LoggerService.info('User profile updated successfully');
        final data = jsonDecode(response.data!);
        return data['updateUserProfile'];
      } else if (response.errors.isNotEmpty) {
        LoggerService.error('GraphQL errors: ${response.errors}');
        throw Exception(
          'Failed to update user profile: ${response.errors.first.message}',
        );
      }
      return null;
    } catch (e) {
      LoggerService.error('Failed to update user profile: $e');
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
          data['listPaymentMethods']['items'],
        );
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
          },
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
          },
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
        variables: {if (category != null) 'category': category},
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
          data['listTransactions']['items'],
        );
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

      final response = await http.get(uri, headers: await _getHeaders());

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

  // Social Post Operations
  Future<Map<String, dynamic>?> createPost({
    required String content,
    String? imageUrl,
    List<String>? tags,
    List<String>? mentionedCryptos,
    bool isPublic = true,
  }) async {
    try {
      // Get current user ID from auth service
      final userToken = await authService.getUserToken();
      if (userToken == null) {
        throw Exception('User not authenticated');
      }

      // Extract user ID from token or get it from Amplify Auth
      final user = await Amplify.Auth.getCurrentUser();
      final userId = user.userId;

      const mutation = '''
        mutation CreatePost(\$input: CreatePostInput!) {
          createPost(input: \$input) {
            id
            userId
            content
            imageUrl
            likesCount
            commentsCount
            sharesCount
            tags
            mentionedCryptos
            isPublic
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
            'content': content,
            if (imageUrl != null) 'imageUrl': imageUrl,
            if (tags != null) 'tags': tags,
            if (mentionedCryptos != null) 'mentionedCryptos': mentionedCryptos,
            'isPublic': isPublic,
          },
        },
      );

      final response = await Amplify.API.mutate(request: request).response;

      if (response.data != null) {
        final jsonData = json.decode(response.data!);
        return jsonData['createPost'];
      }
      return null;
    } catch (e) {
      LoggerService.error('Failed to create post: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getSocialPosts({
    int limit = 20,
    String? nextToken,
  }) async {
    try {
      const query = '''
        query ListPosts(\$limit: Int, \$nextToken: String) {
          listPosts(limit: \$limit, nextToken: \$nextToken) {
            items {
              id
              userId
              content
              imageUrl
              likesCount
              commentsCount
              sharesCount
              tags
              mentionedCryptos
              isPublic
              createdAt
              updatedAt
            }
            nextToken
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: query,
        variables: {'limit': limit, 'nextToken': nextToken},
      );

      final response = await Amplify.API.query(request: request).response;

      if (response.data != null) {
        final jsonData = json.decode(response.data!);
        return List<Map<String, dynamic>>.from(jsonData['listPosts']['items']);
      }
      return [];
    } catch (e) {
      LoggerService.error('Failed to get social posts: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> likePost(String postId) async {
    try {
      // Get current user ID
      final userId = await authService.getCurrentUserId();
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      const mutation = '''
        mutation CreateLike(\$input: CreateLikeInput!) {
          createLike(input: \$input) {
            id
            userId
            postId
            createdAt
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: mutation,
        variables: {
          'input': {'postId': postId, 'userId': userId},
        },
      );

      final response = await Amplify.API.mutate(request: request).response;

      if (response.data != null) {
        final jsonData = json.decode(response.data!);
        return jsonData['createLike'];
      }
      return null;
    } catch (e) {
      LoggerService.error('Failed to like post: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> createComment({
    required String postId,
    required String content,
  }) async {
    try {
      // Get current user ID
      final userId = await authService.getCurrentUserId();
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      const mutation = '''
        mutation CreateComment(\$input: CreateCommentInput!) {
          createComment(input: \$input) {
            id
            postId
            userId
            content
            likesCount
            createdAt
            updatedAt
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: mutation,
        variables: {
          'input': {'postId': postId, 'content': content, 'userId': userId},
        },
      );

      final response = await Amplify.API.mutate(request: request).response;

      if (response.data != null) {
        final jsonData = json.decode(response.data!);
        return jsonData['createComment'];
      }
      return null;
    } catch (e) {
      LoggerService.error('Failed to create comment: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> followUser(String followingId) async {
    try {
      const mutation = '''
        mutation CreateFollow(\$input: CreateFollowInput!) {
          createFollow(input: \$input) {
            id
            followerId
            followingId
            createdAt
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: mutation,
        variables: {
          'input': {'followingId': followingId},
        },
      );

      final response = await Amplify.API.mutate(request: request).response;

      if (response.data != null) {
        final jsonData = json.decode(response.data!);
        return jsonData['createFollow'];
      }
      return null;
    } catch (e) {
      LoggerService.error('Failed to follow user: $e');
      rethrow;
    }
  }

  Future<Map<String, String>> _getHeaders() async {
    final headers = {'Content-Type': 'application/json'};

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

  // Search for users by username or display name
  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    try {
      const searchQuery = '''
        query SearchUsers(\$query: String!) {
          searchUsers(query: \$query) {
            items {
              id
              username
              displayName
              profileImageUrl
              bio
              followersCount
              followingCount
            }
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: searchQuery,
        variables: {'query': query},
      );

      final response = await Amplify.API.query(request: request).response;

      if (response.data != null) {
        final data = json.decode(response.data!);
        final searchResults = data['searchUsers']?['items'] as List?;

        if (searchResults != null) {
          return searchResults.cast<Map<String, dynamic>>();
        }
      }

      return [];
    } catch (e) {
      LoggerService.error('Error searching users: $e');
      return [];
    }
  }

  // Check if current user is following another user
  Future<bool> isFollowing(String userId) async {
    try {
      const query = '''
        query IsFollowing(\$followingId: ID!) {
          isFollowing(followingId: \$followingId)
        }
      ''';

      final request = GraphQLRequest<String>(
        document: query,
        variables: {'followingId': userId},
      );

      final response = await Amplify.API.query(request: request).response;

      if (response.data != null) {
        final data = json.decode(response.data!);
        return data['isFollowing'] as bool? ?? false;
      }

      return false;
    } catch (e) {
      LoggerService.error('Error checking follow status: $e');
      return false;
    }
  }

  // Unfollow a user
  Future<bool> unfollowUser(String followingId) async {
    try {
      const mutation = '''
        mutation UnfollowUser(\$followingId: ID!) {
          unfollowUser(followingId: \$followingId) {
            id
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: mutation,
        variables: {'followingId': followingId},
      );

      final response = await Amplify.API.mutate(request: request).response;
      return response.data != null;
    } catch (e) {
      LoggerService.error('Error unfollowing user: $e');
      return false;
    }
  }

  // Get user's articles
  Future<List<Map<String, dynamic>>> getUserArticles(String userId) async {
    try {
      const query = '''
        query GetUserArticles(\$userId: ID!) {
          getUserArticles(userId: \$userId) {
            items {
              id
              title
              summary
              coverImageUrl
              likesCount
              commentsCount
              viewsCount
              createdAt
              updatedAt
              status
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
        final data = json.decode(response.data!);
        final articles = data['getUserArticles']?['items'] as List?;

        if (articles != null) {
          return articles.cast<Map<String, dynamic>>();
        }
      }

      return [];
    } catch (e) {
      LoggerService.error('Error getting user articles: $e');
      return [];
    }
  }
}
