import 'dart:async';
import 'dart:math';
import 'package:kointos/core/services/auth_service.dart';
import 'package:kointos/core/services/crypto_sentiment_service.dart';
import 'package:kointos/core/services/llm_service.dart';
import 'package:kointos/core/services/logger_service.dart';
import 'package:kointos/core/services/service_locator.dart';
import 'package:kointos/data/repositories/article_repository.dart';
import 'package:kointos/data/repositories/cryptocurrency_repository.dart';
import 'package:kointos/domain/entities/article.dart';
import 'package:kointos/domain/entities/cryptocurrency.dart';

/// Advanced AI-powered chatbot service for Kointos
/// Integrates real market data, user context, and LLM responses
class KointosAIChatbotService {
  final LLMService _llmService;
  final CryptocurrencyRepository _cryptoRepository;
  final ArticleRepository _articleRepository;
  final AuthService _authService;

  // Cache for performance
  List<Cryptocurrency>? _cachedMarketData;
  DateTime? _lastMarketDataUpdate;
  Map<String, dynamic>? _cachedUserProfile;
  DateTime? _lastProfileUpdate;

  KointosAIChatbotService({
    LLMService? llmService,
    CryptocurrencyRepository? cryptoRepository,
    ArticleRepository? articleRepository,
    AuthService? authService,
  })  : _llmService = llmService ?? LLMService(),
        _cryptoRepository =
            cryptoRepository ?? getService<CryptocurrencyRepository>(),
        _articleRepository =
            articleRepository ?? getService<ArticleRepository>(),
        _authService = authService ?? getService<AuthService>();

  /// Process user message and generate AI-powered response
  Future<KointosBotResponse> processMessage(String userMessage) async {
    try {
      LoggerService.info('Processing chatbot message: $userMessage');

      // Gather context from various sources
      final context = await _gatherContext(userMessage);

      // Generate response using LLM with context
      final response = await _llmService.generateResponse(
        prompt: userMessage,
        context: context,
        maxTokens: 400,
        temperature: 0.7,
      );

      // Create bot response with metadata
      return KointosBotResponse(
        text: response,
        timestamp: DateTime.now(),
        confidence: 0.9,
        hasContext: context.isNotEmpty,
        suggestedActions: _generateSuggestedActions(userMessage, context),
        relatedTopics: _extractRelatedTopics(userMessage, context),
        metadata: {
          'context_sources': context.keys.toList(),
          'response_type': _classifyResponseType(userMessage),
          'user_message': userMessage,
        },
      );
    } catch (e) {
      LoggerService.error('Error processing chatbot message: $e');
      return _generateFallbackResponse(userMessage);
    }
  }

  /// Gather comprehensive context for the LLM
  Future<Map<String, dynamic>> _gatherContext(String userMessage) async {
    final context = <String, dynamic>{};

    try {
      // Get user profile and XP data
      final userProfile = await _getUserProfile();
      if (userProfile != null) {
        context['user_profile'] = userProfile;
      }

      // Get current market data
      final marketData = await _getMarketData();
      if (marketData.isNotEmpty) {
        context['market_data'] = marketData
            .map((crypto) => {
                  'name': crypto.name,
                  'symbol': crypto.symbol,
                  'currentPrice': crypto.currentPrice,
                  'priceChangePercentage24h': crypto.priceChangePercentage24h,
                  'marketCap': crypto.marketCap,
                  'volume': crypto.totalVolume,
                })
            .toList();
      }

      // Get recent news and sentiment
      final news = await _getRecentNews();
      if (news.isNotEmpty) {
        context['recent_news'] = news
            .map((article) => {
                  'title': article.title,
                  'summary': article.summary,
                  'status': article.status.name,
                  'createdAt': article.createdAt.toIso8601String(),
                })
            .toList();
      }

      // Add sentiment data
      final sentimentHistory = await _getUserSentimentHistory();
      if (sentimentHistory.isNotEmpty) {
        context['user_sentiment'] = sentimentHistory;
      }

      // Add portfolio context if relevant
      if (_isPortfolioQuery(userMessage)) {
        final portfolioData = await _getPortfolioData();
        if (portfolioData.isNotEmpty) {
          context['portfolio'] = portfolioData;
        }
      }

      LoggerService.debug(
          'Gathered context with ${context.keys.length} sources');
      return context;
    } catch (e) {
      LoggerService.error('Error gathering context: $e');
      return {};
    }
  }

  /// Get user profile information
  Future<Map<String, dynamic>?> _getUserProfile() async {
    try {
      // Check cache first
      if (_cachedUserProfile != null &&
          _lastProfileUpdate != null &&
          DateTime.now().difference(_lastProfileUpdate!).inMinutes < 15) {
        return _cachedUserProfile;
      }

      final userId = await _authService.getCurrentUserId();
      if (userId == null) return null;

      // Get user profile from backend via GraphQL
      // const query = '''
      //   query GetUserProfile(\$userId: ID!) {
      //     getUserProfile(id: \$userId) {
      //       id
      //       experienceLevel
      //       totalPoints
      //       level
      //       joinedDate
      //       preferences
      //     }
      //   }
      // ''';

      // Using demo data until GraphQL backend integration is complete
      final profile = {
        'userId': userId,
        'experienceLevel': 'intermediate',
        'totalPoints': 1250,
        'level': 5,
        'joinedDate':
            DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
        'preferences': {
          'favoriteCoins': ['Bitcoin', 'Ethereum'],
          'riskTolerance': 'moderate'
        }
      };

      _cachedUserProfile = profile;
      _lastProfileUpdate = DateTime.now();
      return profile;
    } catch (e) {
      LoggerService.error('Error fetching user profile: $e');
      return null;
    }
  }

  /// Get current market data
  Future<List<Cryptocurrency>> _getMarketData() async {
    try {
      // Check cache first
      if (_cachedMarketData != null &&
          _lastMarketDataUpdate != null &&
          DateTime.now().difference(_lastMarketDataUpdate!).inMinutes < 5) {
        return _cachedMarketData!;
      }

      final marketData = await _cryptoRepository.getTopCryptocurrencies();
      _cachedMarketData = marketData;
      _lastMarketDataUpdate = DateTime.now();
      return marketData;
    } catch (e) {
      LoggerService.error('Error fetching market data: $e');
      return [];
    }
  }

  /// Get recent news articles
  Future<List<Article>> _getRecentNews() async {
    try {
      return await _articleRepository.getArticles(
        status: ArticleStatus.published,
        limit: 5,
      );
    } catch (e) {
      LoggerService.error('Error fetching recent news: $e');
      return [];
    }
  }

  /// Get user sentiment voting history
  Future<Map<String, dynamic>> _getUserSentimentHistory() async {
    try {
      final userId = await _authService.getCurrentUserId();
      if (userId == null) return {};

      // Integrate with CryptoSentimentService for real data
      final sentimentService = serviceLocator<CryptoSentimentService>();
      final voteHistory = await sentimentService.getUserVotingHistory();

      // Process vote history into analytics format
      final bullishVotes = voteHistory
          .where((vote) => vote.sentiment.toString().contains('bullish'))
          .length;
      final bearishVotes = voteHistory
          .where((vote) => vote.sentiment.toString().contains('bearish'))
          .length;

      return {
        'bullish_votes': bullishVotes,
        'bearish_votes': bearishVotes,
        'recent_votes': voteHistory
            .take(5)
            .map((vote) => {
                  'crypto': vote.cryptoSymbol,
                  'sentiment': vote.sentiment.toString().split('.').last,
                  'date': vote.createdAt.toIso8601String(),
                  'confidence': vote.confidenceLevel,
                })
            .toList(),
      };
    } catch (e) {
      LoggerService.error('Error fetching sentiment history: $e');
      return {};
    }
  }

  /// Get user portfolio information
  Future<Map<String, dynamic>> _getPortfolioData() async {
    try {
      final userId = await _authService.getCurrentUserId();
      if (userId == null) return {};

      // Portfolio integration ready for GraphQL backend
      // const query = '''
      //   query GetUserPortfolio(\$userId: ID!) {
      //     getUserPortfolio(userId: \$userId) {
      //       totalValue
      //       dayChange
      //       dayChangePercent
      //       holdings {
      //         cryptoSymbol
      //         amount
      //         value
      //         dayChange
      //       }
      //     }
      //   }
      // ''';

      // Using sample portfolio data for AI chatbot context
      // In production, this would connect to user's actual portfolio
      final sampleHoldings = [
        {'symbol': 'BTC', 'value': 2500.0, 'change': 120.50},
        {'symbol': 'ETH', 'value': 1800.0, 'change': -45.20},
        {'symbol': 'SOL', 'value': 900.0, 'change': 78.30},
      ];

      final totalValue = sampleHoldings.fold<double>(
          0.0, (sum, holding) => sum + (holding['value'] as double));
      final totalChange = sampleHoldings.fold<double>(
          0.0, (sum, holding) => sum + (holding['change'] as double));

      return {
        'totalValue': totalValue,
        'dayChange': totalChange,
        'dayChangePercent': (totalChange / totalValue) * 100,
        'topHolding': sampleHoldings.first['symbol'],
        'diversificationScore': 0.85, // Good diversification
        'holdingsCount': sampleHoldings.length,
      };
    } catch (e) {
      LoggerService.error('Error fetching portfolio data: $e');
      return {};
    }
  }

  /// Check if the user message is portfolio-related
  bool _isPortfolioQuery(String message) {
    final portfolioKeywords = [
      'portfolio',
      'holdings',
      'balance',
      'wallet',
      'investment',
      'profit',
      'loss',
      'pnl'
    ];

    final lowerMessage = message.toLowerCase();
    return portfolioKeywords.any((keyword) => lowerMessage.contains(keyword));
  }

  /// Generate suggested actions based on context
  List<String> _generateSuggestedActions(
      String userMessage, Map<String, dynamic> context) {
    final suggestions = <String>[];

    if (context.containsKey('market_data')) {
      suggestions.add('View Top Cryptocurrencies');
      suggestions.add('Check Price Alerts');
    }

    if (context.containsKey('recent_news')) {
      suggestions.add('Read Latest News');
    }

    if (context.containsKey('portfolio')) {
      suggestions.add('View Portfolio Performance');
      suggestions.add('Rebalance Holdings');
    }

    // Default suggestions
    if (suggestions.isEmpty) {
      suggestions.addAll([
        'Ask about crypto prices',
        'Get market analysis',
        'Learn about DeFi'
      ]);
    }

    return suggestions.take(3).toList();
  }

  /// Extract related topics from the conversation
  List<String> _extractRelatedTopics(
      String userMessage, Map<String, dynamic> context) {
    final topics = <String>[];
    final lowerMessage = userMessage.toLowerCase();

    if (lowerMessage.contains('bitcoin') || lowerMessage.contains('btc')) {
      topics.add('Bitcoin Analysis');
    }
    if (lowerMessage.contains('ethereum') || lowerMessage.contains('eth')) {
      topics.add('Ethereum Ecosystem');
    }
    if (lowerMessage.contains('defi')) {
      topics.add('DeFi Protocols');
    }
    if (lowerMessage.contains('nft')) {
      topics.add('NFT Market');
    }

    return topics;
  }

  /// Classify the type of response needed
  String _classifyResponseType(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();

    if (lowerMessage.contains('price') || lowerMessage.contains('cost')) {
      return 'price_query';
    }
    if (lowerMessage.contains('how') || lowerMessage.contains('what')) {
      return 'educational';
    }
    if (lowerMessage.contains('portfolio') ||
        lowerMessage.contains('investment')) {
      return 'portfolio_advice';
    }
    if (lowerMessage.contains('news') || lowerMessage.contains('update')) {
      return 'news_summary';
    }

    return 'general';
  }

  /// Generate fallback response when main processing fails
  KointosBotResponse _generateFallbackResponse(String userMessage) {
    final fallbackResponses = [
      "I'm sorry, I'm having trouble processing your request right now. Could you try rephrasing your question?",
      "I encountered an issue while gathering market data. Please try again in a moment.",
      "Something went wrong on my end. Let me know if you'd like help with crypto prices, news, or portfolio advice.",
    ];

    return KointosBotResponse(
      text: fallbackResponses[Random().nextInt(fallbackResponses.length)],
      timestamp: DateTime.now(),
      confidence: 0.3,
      hasContext: false,
      suggestedActions: ['Try again', 'Ask about prices', 'Get help'],
      relatedTopics: [],
      metadata: {'error': 'fallback_response'},
    );
  }
}

/// Response from Kointos AI Chatbot
class KointosBotResponse {
  final String text;
  final DateTime timestamp;
  final double confidence;
  final bool hasContext;
  final List<String> suggestedActions;
  final List<String> relatedTopics;
  final Map<String, dynamic> metadata;

  KointosBotResponse({
    required this.text,
    required this.timestamp,
    required this.confidence,
    required this.hasContext,
    required this.suggestedActions,
    required this.relatedTopics,
    required this.metadata,
  });

  Map<String, dynamic> toJson() => {
        'text': text,
        'timestamp': timestamp.toIso8601String(),
        'confidence': confidence,
        'hasContext': hasContext,
        'suggestedActions': suggestedActions,
        'relatedTopics': relatedTopics,
        'metadata': metadata,
      };
}
