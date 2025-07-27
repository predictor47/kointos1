import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kointos/core/services/logger_service.dart';

/// LLM Service for connecting to free AI APIs
/// Supports OpenRouter (LLaMA3/Mistral) and Google Gemini API
class LLMService {
  static const String _openRouterBaseUrl = 'https://openrouter.ai/api/v1';
  static const String _geminiBaseUrl =
      'https://generativelanguage.googleapis.com/v1beta';

  // API Keys - In production, these should be in environment variables
  static const String? _openRouterApiKey = null; // Add your OpenRouter API key
  static const String? _geminiApiKey = null; // Add your Gemini API key

  // Model configurations
  static const String _mistralModel =
      'mistralai/mistral-7b-instruct'; // Primary model (fast and efficient)
  static const String _geminiModel = 'gemini-pro';

  final http.Client _httpClient;

  LLMService({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  /// Generate response using the best available LLM
  Future<String> generateResponse({
    required String prompt,
    required Map<String, dynamic> context,
    int maxTokens = 500,
    double temperature = 0.7,
  }) async {
    try {
      // Try Gemini first (free tier available)
      if (_geminiApiKey != null) {
        final geminiResponse = await _callGeminiAPI(
          prompt: prompt,
          context: context,
          maxTokens: maxTokens,
          temperature: temperature,
        );
        if (geminiResponse != null) {
          return geminiResponse;
        }
      }

      // Fallback to OpenRouter
      if (_openRouterApiKey != null) {
        final openRouterResponse = await _callOpenRouterAPI(
          prompt: prompt,
          context: context,
          maxTokens: maxTokens,
          temperature: temperature,
        );
        if (openRouterResponse != null) {
          return openRouterResponse;
        }
      }

      // If no APIs are configured, return intelligent fallback
      return _generateIntelligentFallback(prompt, context);
    } catch (e) {
      LoggerService.error('LLM Service error: $e');
      return _generateIntelligentFallback(prompt, context);
    }
  }

  /// Call Google Gemini API
  Future<String?> _callGeminiAPI({
    required String prompt,
    required Map<String, dynamic> context,
    int maxTokens = 500,
    double temperature = 0.7,
  }) async {
    try {
      final contextualPrompt = _buildContextualPrompt(prompt, context);

      final response = await _httpClient.post(
        Uri.parse(
            '$_geminiBaseUrl/models/$_geminiModel:generateContent?key=$_geminiApiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': contextualPrompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': temperature,
            'maxOutputTokens': maxTokens,
            'topP': 0.8,
            'topK': 10
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final candidates = data['candidates'] as List?;
        if (candidates != null && candidates.isNotEmpty) {
          final content = candidates[0]['content'];
          final parts = content['parts'] as List;
          if (parts.isNotEmpty) {
            return parts[0]['text'] as String;
          }
        }
      } else {
        LoggerService.error(
            'Gemini API error: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      LoggerService.error('Gemini API call failed: $e');
    }
    return null;
  }

  /// Call OpenRouter API (supports LLaMA3, Mistral, etc.)
  Future<String?> _callOpenRouterAPI({
    required String prompt,
    required Map<String, dynamic> context,
    int maxTokens = 500,
    double temperature = 0.7,
  }) async {
    try {
      final contextualPrompt = _buildContextualPrompt(prompt, context);

      final response = await _httpClient.post(
        Uri.parse('$_openRouterBaseUrl/chat/completions'),
        headers: {
          'Authorization': 'Bearer $_openRouterApiKey',
          'Content-Type': 'application/json',
          'HTTP-Referer': 'https://kointos.app',
          'X-Title': 'Kointos Crypto Assistant',
        },
        body: jsonEncode({
          'model': _mistralModel, // Using Mistral model (faster and cheaper)
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are KryptoBot, an intelligent cryptocurrency assistant for the Kointos platform. Provide helpful, accurate, and engaging responses about crypto markets, analysis, and user questions. Keep responses concise but informative.'
            },
            {'role': 'user', 'content': contextualPrompt}
          ],
          'max_tokens': maxTokens,
          'temperature': temperature,
          'top_p': 0.9,
          'frequency_penalty': 0.1,
          'presence_penalty': 0.1,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final choices = data['choices'] as List?;
        if (choices != null && choices.isNotEmpty) {
          return choices[0]['message']['content'] as String;
        }
      } else {
        LoggerService.error(
            'OpenRouter API error: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      LoggerService.error('OpenRouter API call failed: $e');
    }
    return null;
  }

  /// Build contextual prompt with user data and market information
  String _buildContextualPrompt(
      String userQuery, Map<String, dynamic> context) {
    final buffer = StringBuffer();

    buffer.writeln('USER QUERY: $userQuery');
    buffer.writeln('');

    // Add user profile context
    if (context.containsKey('user_profile')) {
      final profile = context['user_profile'] as Map<String, dynamic>;
      buffer.writeln('USER PROFILE:');
      buffer.writeln('- Level: ${profile['level'] ?? 'Beginner'}');
      buffer.writeln('- XP: ${profile['xp'] ?? 0}');
      buffer.writeln('- Rank: ${profile['rank'] ?? 'Bronze'}');
      buffer.writeln('');
    }

    // Add market data context
    if (context.containsKey('market_data')) {
      final marketData = context['market_data'] as List<dynamic>;
      buffer.writeln('CURRENT MARKET DATA:');
      for (final crypto in marketData.take(5)) {
        final price = crypto['currentPrice'] ?? 0.0;
        final change = crypto['priceChangePercentage24h'] ?? 0.0;
        final name = crypto['name'] ?? 'Unknown';
        buffer.writeln(
            '- $name: \$${price.toStringAsFixed(2)} (${change > 0 ? '+' : ''}${change.toStringAsFixed(2)}%)');
      }
      buffer.writeln('');
    }

    // Add sentiment context
    if (context.containsKey('sentiment_history')) {
      final sentiment = context['sentiment_history'] as Map<String, dynamic>;
      buffer.writeln('USER SENTIMENT HISTORY:');
      buffer.writeln('- Bullish votes: ${sentiment['bullish_votes'] ?? 0}');
      buffer.writeln('- Bearish votes: ${sentiment['bearish_votes'] ?? 0}');
      buffer.writeln('');
    }

    // Add related articles
    if (context.containsKey('related_articles')) {
      final articles = context['related_articles'] as List<dynamic>;
      if (articles.isNotEmpty) {
        buffer.writeln('RELATED KOINTOS ARTICLES:');
        for (final article in articles.take(3)) {
          buffer.writeln('- "${article['title'] ?? 'Untitled'}"');
        }
        buffer.writeln('');
      }
    }

    // Add portfolio context
    if (context.containsKey('portfolio_data')) {
      final portfolio = context['portfolio_data'] as Map<String, dynamic>;
      buffer.writeln('USER PORTFOLIO:');
      buffer.writeln(
          '- Total Value: \$${portfolio['totalValue']?.toStringAsFixed(2) ?? '0.00'}');
      buffer.writeln(
          '- 24h Change: ${portfolio['dayChangePercent']?.toStringAsFixed(2) ?? '0.00'}%');
      buffer.writeln('');
    }

    buffer.writeln(
        'Please provide a helpful, engaging response as KryptoBot. Use emojis where appropriate and reference the provided context. Keep the response under 300 words.');

    return buffer.toString();
  }

  /// Generate intelligent fallback response when APIs are unavailable
  String _generateIntelligentFallback(
      String prompt, Map<String, dynamic> context) {
    final lowerPrompt = prompt.toLowerCase();

    // Price-related queries
    if (lowerPrompt.contains('price') || lowerPrompt.contains('cost')) {
      if (context.containsKey('market_data')) {
        final marketData = context['market_data'] as List<dynamic>;
        if (marketData.isNotEmpty) {
          final crypto = marketData.first;
          final name = crypto['name'] ?? 'Bitcoin';
          final price = crypto['currentPrice'] ?? 0.0;
          final change = crypto['priceChangePercentage24h'] ?? 0.0;

          return '📊 $name is currently trading at \$${price.toStringAsFixed(2)} with a 24h change of ${change > 0 ? '+' : ''}${change.toStringAsFixed(2)}%.\n\n'
              '${change > 0 ? '📈 Looking bullish!' : change < -5 ? '📉 Significant dip - could be an opportunity.' : '😐 Relatively stable movement.'}\n\n'
              'What aspects of the market would you like to explore further?';
        }
      }
      return '📊 I can help you analyze current crypto prices and market trends! Check the Market tab for real-time data, and feel free to ask about specific cryptocurrencies.';
    }

    // Portfolio queries
    if (lowerPrompt.contains('portfolio') || lowerPrompt.contains('holding')) {
      if (context.containsKey('portfolio_data')) {
        final portfolio = context['portfolio_data'] as Map<String, dynamic>;
        final totalValue = portfolio['totalValue'] ?? 0.0;
        final dayChange = portfolio['dayChangePercent'] ?? 0.0;

        return '💼 Your portfolio is valued at \$${totalValue.toStringAsFixed(2)} with a 24h change of ${dayChange > 0 ? '+' : ''}${dayChange.toStringAsFixed(2)}%.\n\n'
            '${dayChange > 0 ? '🎉 Nice gains!' : dayChange < -5 ? '💪 Stay strong! Volatility is normal in crypto.' : '📊 Steady performance.'}\n\n'
            'Would you like me to analyze any specific holdings or suggest optimization strategies?';
      }
      return '💼 I can help analyze your crypto portfolio! Visit the Portfolio tab to track your holdings, and I\'ll provide personalized insights based on your investments.';
    }

    // Sentiment queries
    if (lowerPrompt.contains('sentiment') || lowerPrompt.contains('feel')) {
      if (context.containsKey('sentiment_history')) {
        final sentiment = context['sentiment_history'] as Map<String, dynamic>;
        final bullish = sentiment['bullish_votes'] ?? 0;
        final bearish = sentiment['bearish_votes'] ?? 0;
        final total = bullish + bearish;

        if (total > 0) {
          final bullishPercent = (bullish / total * 100).toStringAsFixed(1);
          return '🎯 Based on your voting history, you\'ve been ${bullish > bearish ? 'predominantly bullish' : 'predominantly bearish'} with $bullishPercent% bullish sentiment.\n\n'
              'Community sentiment can be a great indicator alongside technical analysis. What\'s driving your current market outlook?';
        }
      }
      return '🎯 Market sentiment is crucial in crypto! I can analyze community sentiment based on article content and user votes. What specific crypto or market trend are you curious about?';
    }

    // Educational queries
    if (lowerPrompt.contains('what is') ||
        lowerPrompt.contains('explain') ||
        lowerPrompt.contains('how')) {
      return '📚 I\'d love to help you learn about crypto! I can explain concepts like:\n\n'
          '• Blockchain fundamentals\n'
          '• Trading strategies\n'
          '• DeFi protocols\n'
          '• Technical analysis\n'
          '• Risk management\n\n'
          'What specific topic interests you most?';
    }

    // General fallback
    return '🤖 I\'m here to help with all your crypto questions! I can assist with:\n\n'
        '📊 Market analysis and price insights\n'
        '💼 Portfolio optimization\n'
        '📚 Crypto education\n'
        '🎯 Sentiment analysis\n'
        '📝 Community articles\n\n'
        'What would you like to explore today?';
  }

  void dispose() {
    _httpClient.close();
  }
}
