import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:kointos/core/services/logger_service.dart';
import 'package:kointos/core/services/auth_service.dart';
import 'package:kointos/core/services/service_locator.dart';
import 'package:kointos/core/services/bedrock_client.dart';
import 'package:kointos/core/services/user_profile_initialization_service.dart';
import 'package:kointos/data/repositories/article_repository.dart';

/// LLM Service using Amazon Bedrock Claude 3 Haiku
/// Integrates with real user data, market data, and Amplify DataStore
class LLMService {
  // Amazon Bedrock configuration
  static const String _bedrockRegion = 'us-east-1';
  static const String _claudeModel = 'anthropic.claude-3-haiku-20240307-v1:0';
  static const String _coinGeckoBaseUrl = 'https://api.coingecko.com/api/v3';

  final http.Client _httpClient;
  final AuthService _authService;
  final ArticleRepository _articleRepository;
  final BedrockClient _bedrockClient;
  final UserProfileInitializationService _profileService;

  LLMService({
    http.Client? httpClient,
    AuthService? authService,
    ArticleRepository? articleRepository,
    BedrockClient? bedrockClient,
    UserProfileInitializationService? profileService,
  })  : _httpClient = httpClient ?? http.Client(),
        _authService = authService ?? getService<AuthService>(),
        _articleRepository =
            articleRepository ?? getService<ArticleRepository>(),
        _bedrockClient = bedrockClient ?? BedrockClient(),
        _profileService =
            profileService ?? getService<UserProfileInitializationService>();

  /// Generate response using Amazon Bedrock Claude 3 Haiku with real user context
  Future<String> generateResponse({
    required String prompt,
    required Map<String, dynamic> context,
    int maxTokens = 500,
    double temperature = 0.7,
  }) async {
    try {
      LoggerService.info('Processing Claude request for user message: $prompt');

      // Test Bedrock connectivity first
      final hasCredentials = await _bedrockClient.testCredentials();
      if (!hasCredentials) {
        LoggerService.error('Failed to obtain AWS credentials for Bedrock');
        return '🔴 Bot offline: Authentication issue. Please ensure you are logged in and try again.';
      }

      // 1. Fetch real user data from Amplify DataStore
      final userData = await _fetchUserData();

      // 2. Fetch user's recent article interactions
      final recentArticles = await _fetchUserArticleHistory();

      // 3. Extract coins mentioned in prompt and fetch real market data
      final marketData = await _fetchRelevantMarketData(prompt);

      // 4. Build contextual prompt for Claude
      final claudePrompt = _buildClaudePrompt(
        userMessage: prompt,
        userData: userData,
        articles: recentArticles,
        marketData: marketData,
      );

      // 5. Call Amazon Bedrock Claude 3 Haiku
      LoggerService.info('Attempting to call Bedrock API...');
      final claudeResponse = await _callClaudeBedrock(
        prompt: claudePrompt,
        maxTokens: maxTokens,
        temperature: temperature,
      );

      if (claudeResponse != null && claudeResponse.isNotEmpty) {
        // 6. Optional: Save interaction to user history
        await _saveInteractionHistory(
            prompt, claudeResponse, userData['userId']);

        LoggerService.info('Claude response generated successfully');
        return claudeResponse;
      }

      LoggerService.warning(
          'Bedrock returned null/empty response, using fallback');
      // Fallback if Claude fails
      return _generateEnhancedFallback(prompt, userData, marketData);
    } catch (e, stackTrace) {
      LoggerService.error('LLM Service error: $e\nStackTrace: $stackTrace');

      // Provide more specific error messages
      if (e.toString().contains('ENOTFOUND') ||
          e.toString().contains('getaddrinfo')) {
        return '🔴 Bot offline: Network connectivity issue. Please check your internet connection and try again.';
      } else if (e.toString().contains('AccessDenied')) {
        return '🔴 Bot offline: Permission denied. Please contact support - Bedrock access may not be properly configured.';
      } else if (e.toString().contains('timeout')) {
        return '🔴 Bot offline: Request timed out. The AI service is taking too long to respond. Please try again.';
      }

      return '🔴 Bot temporarily offline. Error: ${e.toString().split('\n').first}. Please try again later.';
    }
  }

  /// Fetch real user data from Amplify DataStore
  Future<Map<String, dynamic>> _fetchUserData() async {
    try {
      // Use the profile initialization service to get user profile
      final profileData = await _profileService.getCurrentUserProfile();

      if (profileData != null) {
        LoggerService.info(
            'User data fetched successfully from profile service');

        return {
          'userId': profileData['userId'],
          'displayName':
              profileData['displayName'] ?? profileData['username'] ?? 'User',
          'username': profileData['username'] ?? 'User',
          'email': profileData['email'],
          'totalPoints': profileData['totalPoints'] ?? 0,
          'level': profileData['level'] ?? 1,
          'streak': profileData['streak'] ?? 0,
          'portfolioValue': profileData['totalPortfolioValue'] ?? 0.0,
          'followersCount': profileData['followersCount'] ?? 0,
          'followingCount': profileData['followingCount'] ?? 0,
          'weeklyPoints': profileData['weeklyPoints'] ?? 0,
          'monthlyPoints': profileData['monthlyPoints'] ?? 0,
        };
      }

      // Fallback for users without profiles
      final userId = await _authService.getCurrentUserId();
      if (userId != null) {
        LoggerService.info('Using fallback user data for: $userId');
        return {
          'userId': userId,
          'displayName': 'User',
          'username': 'User',
          'email': '',
          'totalPoints': 0,
          'level': 1,
          'streak': 0,
          'portfolioValue': 0.0,
          'followersCount': 0,
          'followingCount': 0,
          'weeklyPoints': 0,
          'monthlyPoints': 0,
        };
      }

      throw Exception('No authenticated user found');
    } catch (e) {
      LoggerService.error('Failed to fetch user data: $e');

      // Return minimal user data as fallback
      final userId = await _authService.getCurrentUserId();
      return {
        'userId': userId ?? 'anonymous',
        'displayName': 'User',
        'username': 'User',
        'email': '',
        'totalPoints': 0,
        'level': 1,
        'streak': 0,
        'portfolioValue': 0.0,
        'followersCount': 0,
        'followingCount': 0,
        'weeklyPoints': 0,
        'monthlyPoints': 0,
      };
    }
  }

  /// Calculate user level based on XP
  String _calculateLevel(int xp) {
    if (xp >= 10000) return 'Diamond';
    if (xp >= 5000) return 'Gold';
    if (xp >= 2000) return 'Silver';
    return 'Bronze';
  }

  /// Fetch user's recent article interactions
  Future<List<Map<String, dynamic>>> _fetchUserArticleHistory() async {
    try {
      final articles = await _articleRepository.getArticles(limit: 3);
      return articles
          .map((article) => {
                'id': article.id,
                'title': article.title,
                'tags': article.tags,
              })
          .toList();
    } catch (e) {
      LoggerService.error('Error fetching user articles: $e');
      return [];
    }
  }

  /// Extract mentioned coins and fetch real market data from CoinGecko
  Future<List<Map<String, dynamic>>> _fetchRelevantMarketData(
      String prompt) async {
    try {
      // Extract coin symbols from user message
      final coins = _extractCoinSymbols(prompt);

      // If no coins mentioned, get trending coins
      if (coins.isEmpty) {
        coins.addAll(['bitcoin', 'ethereum']);
      }

      final marketData = <Map<String, dynamic>>[];

      for (final coinId in coins.take(3)) {
        try {
          final uri = Uri.parse('$_coinGeckoBaseUrl/simple/price').replace(
            queryParameters: {
              'ids': coinId,
              'vs_currencies': 'usd',
              'include_24hr_change': 'true',
              'include_market_cap': 'true',
            },
          );

          final response = await _httpClient.get(uri).timeout(
                const Duration(seconds: 5),
              );

          if (response.statusCode == 200) {
            final data = jsonDecode(response.body) as Map<String, dynamic>;

            if (data.containsKey(coinId)) {
              final coinData = data[coinId] as Map<String, dynamic>;
              marketData.add({
                'id': coinId,
                'name': _getCoinName(coinId),
                'symbol': _getCoinSymbol(coinId),
                'price': coinData['usd'] ?? 0.0,
                'change24h': coinData['usd_24h_change'] ?? 0.0,
                'marketCap': coinData['usd_market_cap'] ?? 0.0,
              });
            }
          }
        } catch (e) {
          LoggerService.warning('Failed to fetch data for $coinId: $e');
        }
      }

      LoggerService.info('Fetched market data for ${marketData.length} coins');
      return marketData;
    } catch (e) {
      LoggerService.error('Error fetching market data: $e');
      return [];
    }
  }

  /// Extract cryptocurrency symbols from user message
  List<String> _extractCoinSymbols(String message) {
    final symbols = <String>[];
    final lowerMessage = message.toLowerCase();

    // Common cryptocurrency mappings
    final coinMap = {
      'btc': 'bitcoin',
      'bitcoin': 'bitcoin',
      'eth': 'ethereum',
      'ethereum': 'ethereum',
      'sol': 'solana',
      'solana': 'solana',
      'ada': 'cardano',
      'cardano': 'cardano',
      'dot': 'polkadot',
      'polkadot': 'polkadot',
      'link': 'chainlink',
      'chainlink': 'chainlink',
      'avax': 'avalanche-2',
      'avalanche': 'avalanche-2',
    };

    for (final entry in coinMap.entries) {
      if (lowerMessage.contains(entry.key)) {
        symbols.add(entry.value);
      }
    }

    return symbols.toSet().toList(); // Remove duplicates
  }

  /// Get readable coin name
  String _getCoinName(String coinId) {
    final nameMap = {
      'bitcoin': 'Bitcoin',
      'ethereum': 'Ethereum',
      'solana': 'Solana',
      'cardano': 'Cardano',
      'polkadot': 'Polkadot',
      'chainlink': 'Chainlink',
      'avalanche-2': 'Avalanche',
    };
    return nameMap[coinId] ?? coinId.toUpperCase();
  }

  /// Get coin symbol
  String _getCoinSymbol(String coinId) {
    final symbolMap = {
      'bitcoin': 'BTC',
      'ethereum': 'ETH',
      'solana': 'SOL',
      'cardano': 'ADA',
      'polkadot': 'DOT',
      'chainlink': 'LINK',
      'avalanche-2': 'AVAX',
    };
    return symbolMap[coinId] ?? coinId.toUpperCase();
  }

  /// Build contextual prompt for Claude 3 Haiku
  String _buildClaudePrompt({
    required String userMessage,
    required Map<String, dynamic> userData,
    required List<Map<String, dynamic>> articles,
    required List<Map<String, dynamic>> marketData,
  }) {
    final buffer = StringBuffer();

    // User context
    buffer.writeln('User: "$userMessage"');
    buffer.writeln('');

    // User profile data
    buffer.writeln('User Profile:');
    buffer.writeln('- XP: ${userData['xp']} (${userData['level']})');
    buffer.writeln(
        '- Sentiment: Bullish: ${userData['bullishVotes']}, Bearish: ${userData['bearishVotes']}');
    buffer.writeln(
        '- Portfolio Value: \$${(userData['portfolioValue'] as double).toStringAsFixed(2)}');
    buffer.writeln('');

    // Market data
    if (marketData.isNotEmpty) {
      buffer.writeln('Market Data:');
      for (final coin in marketData) {
        final price = (coin['price'] as double).toStringAsFixed(2);
        final change = (coin['change24h'] as double).toStringAsFixed(2);
        final changeSymbol = coin['change24h'] >= 0 ? '↑' : '↓';
        final marketCap = _formatMarketCap(coin['marketCap'] as double);

        buffer.writeln(
            '- ${coin['name']} (${coin['symbol']}): \$$price ($changeSymbol$change%), Market Cap: $marketCap');
      }
      buffer.writeln('');
    }

    // Recent articles
    if (articles.isNotEmpty) {
      buffer.writeln('Recent Articles:');
      for (final article in articles) {
        buffer.writeln('- "${article['title']}"');
      }
      buffer.writeln('');
    }

    // Instructions for Claude
    buffer.writeln('Instructions:');
    buffer.writeln(
        'You are KryptoBot, an intelligent cryptocurrency assistant for the Kointos platform.');
    buffer.writeln(
        'Provide a helpful 2-3 paragraph analysis based on the user\'s experience level, sentiment history, and current market data.');
    buffer.writeln(
        'Use the user\'s portfolio context and recent article engagement to personalize your response.');
    buffer.writeln(
        'Include relevant emojis and keep the tone engaging but professional.');
    buffer.writeln(
        'If giving advice, consider the user\'s experience level (XP/Level).');
    buffer.writeln('Maximum 300 words.');

    return buffer.toString();
  }

  /// Format market cap for display
  String _formatMarketCap(double marketCap) {
    if (marketCap >= 1e12) {
      return '\$${(marketCap / 1e12).toStringAsFixed(1)}T';
    } else if (marketCap >= 1e9) {
      return '\$${(marketCap / 1e9).toStringAsFixed(1)}B';
    } else if (marketCap >= 1e6) {
      return '\$${(marketCap / 1e6).toStringAsFixed(1)}M';
    } else {
      return '\$${marketCap.toStringAsFixed(0)}';
    }
  }

  /// Call Amazon Bedrock Claude 3 Haiku
  Future<String?> _callClaudeBedrock({
    required String prompt,
    int maxTokens = 500,
    double temperature = 0.7,
  }) async {
    try {
      LoggerService.info(
          'Calling Amazon Bedrock Claude 3 Haiku (Model: $_claudeModel, Region: $_bedrockRegion)');

      // Call Bedrock using the proper client
      final response = await _bedrockClient.invokeClaudeModel(
        prompt: prompt,
        maxTokens: maxTokens,
        temperature: temperature,
        stopSequences: ['Human:', 'Assistant:', '\n\nHuman:', '\n\nAssistant:'],
      );

      if (response != null) {
        LoggerService.info('Bedrock Claude response received successfully');
        return response;
      } else {
        LoggerService.warning('Bedrock Claude returned null response');
        return null;
      }
    } catch (e) {
      LoggerService.error('Bedrock Claude call failed: $e');
      return null;
    }
  }

  /// Save interaction to user history
  Future<void> _saveInteractionHistory(
      String userMessage, String botResponse, String userId) async {
    try {
      // In a real implementation, save to DynamoDB via Amplify
      const mutation = '''
        mutation CreateBotInteraction(\$input: CreateBotInteractionInput!) {
          createBotInteraction(input: \$input) {
            id
            userId
            userMessage
            botResponse
            createdAt
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: mutation,
        variables: {
          'input': {
            'userId': userId,
            'userMessage': userMessage,
            'botResponse': botResponse,
            'createdAt': DateTime.now().toIso8601String(),
          }
        },
      );

      await Amplify.API.mutate(request: request).response;
      LoggerService.info('Bot interaction saved for user: $userId');
    } catch (e) {
      LoggerService.warning('Failed to save interaction history: $e');
      // Non-critical error, don't throw
    }
  }

  /// Generate enhanced fallback response with real user data
  String _generateEnhancedFallback(String prompt, Map<String, dynamic> userData,
      List<Map<String, dynamic>> marketData) {
    final userName = userData['displayName'] as String? ?? 'User';
    final level = userData['level'] as int? ?? 1;
    final levelName = _calculateLevel(userData['totalPoints'] as int? ?? 0);

    // Check if this is a specific type of query
    final lowerPrompt = prompt.toLowerCase();

    if (lowerPrompt.contains('price') && marketData.isNotEmpty) {
      final coin = marketData.first;
      final price = (coin['price'] as double).toStringAsFixed(2);
      final change = (coin['change24h'] as double).toStringAsFixed(2);
      final changeSymbol = coin['change24h'] >= 0 ? '📈' : '📉';

      return 'Hi $userName! While I\'m having trouble connecting to my AI service, I can still provide current data:\n\n'
          '${coin['name']} (${coin['symbol']}): \$$price $changeSymbol $change%\n'
          'Market Cap: ${_formatMarketCap(coin['marketCap'] as double)}\n\n'
          '⚠️ Note: AI-powered analysis is temporarily unavailable. Basic market data is still accessible.';
    }

    if (lowerPrompt.contains('portfolio') || lowerPrompt.contains('balance')) {
      return 'Hi $userName! 📊 Your portfolio features are accessible, but AI-powered insights are temporarily offline.\n\n'
          'Your Level: $levelName (Level $level)\n'
          'Total Points: ${userData['totalPoints'] ?? 0} XP\n\n'
          '⚠️ For detailed portfolio analysis, please try again when the AI service is restored.';
    }

    // Generic fallback with helpful information
    return 'Hi $userName! 🤖 I\'m experiencing connectivity issues with the AI service.\n\n'
        'What\'s working:\n'
        '✅ Market data and prices\n'
        '✅ Your profile (Level $level - $levelName)\n'
        '✅ Basic app features\n\n'
        'What\'s offline:\n'
        '❌ AI-powered analysis\n'
        '❌ Intelligent responses\n\n'
        'Please try again in a few moments, or check the Dev Tools for diagnostics.';
  }

  void dispose() {
    _httpClient.close();
  }
}
