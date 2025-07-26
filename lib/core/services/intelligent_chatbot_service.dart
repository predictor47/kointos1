import 'dart:math';
import 'package:kointos/core/services/logger_service.dart';
import 'package:kointos/domain/entities/cryptocurrency.dart';
import 'package:kointos/domain/entities/article.dart';

/// Intelligent Chatbot Service with built-in AI capabilities
/// Provides crypto insights, analysis, and conversational responses
class IntelligentChatbotService {
  static const String _botName = "KryptoBot";
  
  // Knowledge base for crypto-related questions
  final Map<String, List<String>> _cryptoKnowledge = {
    'bitcoin': [
      'Bitcoin is the first and largest cryptocurrency by market cap.',
      'It uses a proof-of-work consensus mechanism.',
      'Bitcoin has a maximum supply of 21 million coins.',
      'It was created by the pseudonymous Satoshi Nakamoto in 2009.',
    ],
    'ethereum': [
      'Ethereum is a decentralized platform for smart contracts.',
      'It uses proof-of-stake consensus after the Merge.',
      'ETH is the native cryptocurrency of Ethereum.',
      'It enables decentralized applications (dApps) and DeFi.',
    ],
    'defi': [
      'DeFi stands for Decentralized Finance.',
      'It recreates traditional financial systems using blockchain.',
      'Popular DeFi protocols include Uniswap, Aave, and Compound.',
      'DeFi eliminates intermediaries in financial transactions.',
    ],
    'nft': [
      'NFTs are Non-Fungible Tokens representing unique digital assets.',
      'They prove ownership and authenticity of digital items.',
      'Popular NFT marketplaces include OpenSea and Rarible.',
      'NFTs can represent art, collectibles, gaming items, and more.',
    ],
  };

  // Sentiment analysis keywords
  final Map<String, double> _sentimentKeywords = {
    'bullish': 0.8, 'bearish': -0.8, 'moon': 0.9, 'crash': -0.9,
    'pump': 0.7, 'dump': -0.7, 'hodl': 0.6, 'fud': -0.6,
    'buy': 0.5, 'sell': -0.5, 'long': 0.4, 'short': -0.4,
    'green': 0.3, 'red': -0.3, 'up': 0.3, 'down': -0.3,
    'profit': 0.5, 'loss': -0.5, 'gain': 0.4, 'drop': -0.4,
  };

  IntelligentChatbotService();

  /// Process user message and generate intelligent response
  Future<ChatbotResponse> processMessage(String message, {
    List<Cryptocurrency>? currentPrices,
    List<Article>? userArticles,
    Map<String, dynamic>? portfolioData,
  }) async {
    try {
      final lowerMessage = message.toLowerCase();
      
      // Determine the type of query
      if (_isGreeting(lowerMessage)) {
        return _generateGreeting();
      } else if (_isPriceQuery(lowerMessage)) {
        return await _handlePriceQuery(lowerMessage, currentPrices);
      } else if (_isSentimentQuery(lowerMessage)) {
        return await _handleSentimentQuery(lowerMessage, userArticles);
      } else if (_isTechnicalAnalysisQuery(lowerMessage)) {
        return await _handleTechnicalAnalysis(lowerMessage, currentPrices);
      } else if (_isPortfolioQuery(lowerMessage)) {
        return _handlePortfolioQuery(lowerMessage, portfolioData);
      } else if (_isCryptoEducation(lowerMessage)) {
        return _handleCryptoEducation(lowerMessage);
      } else if (_isArticleQuery(lowerMessage)) {
        return _handleArticleQuery(lowerMessage, userArticles);
      } else {
        return _generateGeneralResponse(lowerMessage);
      }
    } catch (e) {
      LoggerService.error('Error in chatbot processing: $e');
      return ChatbotResponse(
        text: "I'm experiencing some technical difficulties. Please try again in a moment.",
        type: ChatbotResponseType.error,
        confidence: 0.0,
      );
    }
  }

  bool _isGreeting(String message) {
    final greetings = ['hello', 'hi', 'hey', 'good morning', 'good afternoon', 'good evening'];
    return greetings.any((greeting) => message.contains(greeting));
  }

  bool _isPriceQuery(String message) {
    return message.contains('price') || message.contains('cost') || 
           message.contains('worth') || message.contains('value');
  }

  bool _isSentimentQuery(String message) {
    return message.contains('sentiment') || message.contains('feeling') || 
           message.contains('mood') || message.contains('opinion');
  }

  bool _isTechnicalAnalysisQuery(String message) {
    return message.contains('analysis') || message.contains('trend') || 
           message.contains('support') || message.contains('resistance') ||
           message.contains('rsi') || message.contains('macd');
  }

  bool _isPortfolioQuery(String message) {
    return message.contains('portfolio') || message.contains('holding') || 
           message.contains('investment') || message.contains('balance');
  }

  bool _isCryptoEducation(String message) {
    return message.contains('what is') || message.contains('explain') || 
           message.contains('how does') || message.contains('tell me about');
  }

  bool _isArticleQuery(String message) {
    return message.contains('article') || message.contains('post') || 
           message.contains('content') || message.contains('wrote');
  }

  ChatbotResponse _generateGreeting() {
    final greetings = [
      "Hello! I'm $_botName, your crypto companion. How can I help you today?",
      "Hi there! Ready to explore the crypto world together?",
      "Hey! I'm here to help with crypto insights, analysis, and questions.",
      "Greetings! What would you like to know about cryptocurrencies today?",
    ];
    
    return ChatbotResponse(
      text: greetings[Random().nextInt(greetings.length)],
      type: ChatbotResponseType.greeting,
      confidence: 1.0,
      suggestions: [
        "Show me Bitcoin price",
        "Analyze my portfolio",
        "What's the market sentiment?",
        "Explain DeFi to me",
      ],
    );
  }

  Future<ChatbotResponse> _handlePriceQuery(String message, List<Cryptocurrency>? prices) async {
    if (prices == null || prices.isEmpty) {
      return ChatbotResponse(
        text: "I don't have current price data available. Please check the market tab for live prices.",
        type: ChatbotResponseType.info,
        confidence: 0.7,
      );
    }

    // Extract crypto symbol from message
    String? symbol = _extractCryptoSymbol(message);
    
    if (symbol != null) {
      final crypto = prices.firstWhere(
        (c) => c.symbol.toLowerCase() == symbol.toLowerCase() || 
               c.name.toLowerCase().contains(symbol.toLowerCase()),
        orElse: () => prices.first,
      );
      
      final priceChangeText = crypto.priceChangePercentage24h != null 
        ? '${crypto.priceChangePercentage24h! > 0 ? '+' : ''}${crypto.priceChangePercentage24h!.toStringAsFixed(2)}%'
        : 'N/A';
      
      final sentiment = crypto.priceChangePercentage24h != null
        ? (crypto.priceChangePercentage24h! > 0 ? '📈 Bullish' : '📉 Bearish')
        : '😐 Neutral';
      
      return ChatbotResponse(
        text: "${crypto.name} (${crypto.symbol.toUpperCase()}) is currently trading at \$${crypto.currentPrice.toStringAsFixed(2)}.\n\n"
              "24h Change: $priceChangeText\n"
              "Market Sentiment: $sentiment\n\n"
              "💡 ${_generatePriceInsight(crypto)}",
        type: ChatbotResponseType.analysis,
        confidence: 0.9,
        data: {'crypto': crypto},
      );
    }
    
    return ChatbotResponse(
      text: "Here are the top cryptocurrencies by market cap:\n\n${prices.take(5).map((c) => 
              "${c.name}: \$${c.currentPrice.toStringAsFixed(2)} "
              "(${c.priceChangePercentage24h?.toStringAsFixed(2) ?? '0.00'}%)"
            ).join('\n')}",
      type: ChatbotResponseType.info,
      confidence: 0.8,
    );
  }

  Future<ChatbotResponse> _handleSentimentQuery(String message, List<Article>? articles) async {
    if (articles == null || articles.isEmpty) {
      return ChatbotResponse(
        text: "I don't have enough article data to analyze sentiment. Try publishing some articles first!",
        type: ChatbotResponseType.info,
        confidence: 0.7,
      );
    }

    // Analyze sentiment from article titles and content
    double overallSentiment = 0.0;
    int analyzedArticles = 0;
    
    for (final article in articles.take(10)) {
      double articleSentiment = _analyzeSentiment('${article.title} ${article.summary}');
      overallSentiment += articleSentiment;
      analyzedArticles++;
    }
    
    if (analyzedArticles > 0) {
      overallSentiment /= analyzedArticles;
    }
    
    String sentimentText;
    String emoji;
    
    if (overallSentiment > 0.3) {
      sentimentText = "Very Bullish";
      emoji = "🚀";
    } else if (overallSentiment > 0.1) {
      sentimentText = "Bullish";
      emoji = "📈";
    } else if (overallSentiment > -0.1) {
      sentimentText = "Neutral";
      emoji = "😐";
    } else if (overallSentiment > -0.3) {
      sentimentText = "Bearish";
      emoji = "📉";
    } else {
      sentimentText = "Very Bearish";
      emoji = "💀";
    }
    
    return ChatbotResponse(
      text: "$emoji Market Sentiment Analysis\n\n"
            "Based on recent articles: $sentimentText\n"
            "Sentiment Score: ${(overallSentiment * 100).toStringAsFixed(1)}\n\n"
            "💡 This analysis is based on $analyzedArticles recent articles. "
            "Remember, sentiment can change quickly in crypto markets!",
      type: ChatbotResponseType.analysis,
      confidence: 0.8,
      data: {'sentiment': overallSentiment, 'articles_analyzed': analyzedArticles},
    );
  }

  Future<ChatbotResponse> _handleTechnicalAnalysis(String message, List<Cryptocurrency>? prices) async {
    if (prices == null || prices.isEmpty) {
      return ChatbotResponse(
        text: "I need current price data for technical analysis. Please refresh the market data.",
        type: ChatbotResponseType.info,
        confidence: 0.7,
      );
    }

    String? symbol = _extractCryptoSymbol(message);
    final crypto = symbol != null 
      ? prices.firstWhere(
          (c) => c.symbol.toLowerCase() == symbol.toLowerCase() || 
                 c.name.toLowerCase().contains(symbol.toLowerCase()),
          orElse: () => prices.first,
        )
      : prices.first;

    // Basic technical analysis
    final analysis = _performBasicTechnicalAnalysis(crypto);
    
    return ChatbotResponse(
      text: "📊 Technical Analysis for ${crypto.name}\n\n"
            "Current Price: \$${crypto.currentPrice.toStringAsFixed(2)}\n"
            "24h High: \$${crypto.high24h?.toStringAsFixed(2) ?? 'N/A'}\n"
            "24h Low: \$${crypto.low24h?.toStringAsFixed(2) ?? 'N/A'}\n\n"
            "📈 Analysis:\n$analysis\n\n"
            "⚠️ This is basic analysis. Always do your own research!",
      type: ChatbotResponseType.analysis,
      confidence: 0.7,
      data: {'crypto': crypto},
    );
  }

  ChatbotResponse _handlePortfolioQuery(String message, Map<String, dynamic>? portfolioData) {
    if (portfolioData == null) {
      return ChatbotResponse(
        text: "I don't have access to your portfolio data. Please check your portfolio tab for detailed information.",
        type: ChatbotResponseType.info,
        confidence: 0.7,
      );
    }

    // Generate portfolio insights
    final totalValue = portfolioData['totalValue'] ?? 0.0;
    final dayChange = portfolioData['dayChange'] ?? 0.0;
    final dayChangePercent = portfolioData['dayChangePercent'] ?? 0.0;
    
    String performanceEmoji = dayChange >= 0 ? "📈" : "📉";
    String advice = _generatePortfolioAdvice(dayChangePercent);
    
    return ChatbotResponse(
      text: "$performanceEmoji Portfolio Summary\n\n"
            "Total Value: \$${totalValue.toStringAsFixed(2)}\n"
            "24h Change: ${dayChange >= 0 ? '+' : ''}\$${dayChange.toStringAsFixed(2)} "
            "(${dayChangePercent >= 0 ? '+' : ''}${dayChangePercent.toStringAsFixed(2)}%)\n\n"
            "💡 Advice: $advice",
      type: ChatbotResponseType.analysis,
      confidence: 0.8,
      data: portfolioData,
    );
  }

  ChatbotResponse _handleCryptoEducation(String message) {
    // Extract the topic from the message
    String topic = '';
    for (String key in _cryptoKnowledge.keys) {
      if (message.contains(key)) {
        topic = key;
        break;
      }
    }
    
    if (topic.isNotEmpty && _cryptoKnowledge.containsKey(topic)) {
      final info = _cryptoKnowledge[topic]!;
      return ChatbotResponse(
        text: "📚 About ${topic.toUpperCase()}\n\n${info.join('\n\n')}\n\n"
              "Would you like to know more about any specific aspect?",
        type: ChatbotResponseType.education,
        confidence: 0.9,
        suggestions: [
          "Tell me more about blockchain",
          "How to get started with crypto?",
          "What are smart contracts?",
        ],
      );
    }
    
    return ChatbotResponse(
      text: "I'd be happy to explain crypto concepts! I can help with topics like:\n\n"
            "• Bitcoin and Ethereum\n"
            "• DeFi (Decentralized Finance)\n"
            "• NFTs (Non-Fungible Tokens)\n"
            "• Blockchain technology\n"
            "• Trading strategies\n\n"
            "What would you like to learn about?",
      type: ChatbotResponseType.education,
      confidence: 0.8,
    );
  }

  ChatbotResponse _handleArticleQuery(String message, List<Article>? articles) {
    if (articles == null || articles.isEmpty) {
      return ChatbotResponse(
        text: "You haven't published any articles yet. Start sharing your crypto insights with the community!",
        type: ChatbotResponseType.info,
        confidence: 0.8,
        suggestions: ["Write my first article", "Browse community articles"],
      );
    }

    final recentArticle = articles.first;
    return ChatbotResponse(
      text: "📝 Your Recent Articles\n\n"
            "Latest: \"${recentArticle.title}\"\n"
            "Published: ${_formatDate(recentArticle.createdAt)}\n"
            "Engagement: ${recentArticle.likesCount} likes, ${recentArticle.commentsCount} comments\n\n"
            "💡 Keep sharing your insights! Consistent publishing helps build your reputation in the community.",
      type: ChatbotResponseType.info,
      confidence: 0.8,
      data: {'article': recentArticle},
    );
  }

  ChatbotResponse _generateGeneralResponse(String message) {
    final responses = [
      "That's an interesting question! Can you be more specific about what you'd like to know?",
      "I'm here to help with crypto-related questions, price analysis, and portfolio insights. How can I assist you?",
      "I didn't quite understand that. Try asking about prices, market sentiment, or crypto education topics.",
      "Let me help you with that! I specialize in cryptocurrency insights and analysis. What would you like to explore?",
    ];
    
    return ChatbotResponse(
      text: responses[Random().nextInt(responses.length)],
      type: ChatbotResponseType.general,
      confidence: 0.5,
      suggestions: [
        "Show Bitcoin price",
        "Analyze market sentiment",
        "Explain blockchain",
        "Check my portfolio",
      ],
    );
  }

  String? _extractCryptoSymbol(String message) {
    final commonCryptos = ['bitcoin', 'btc', 'ethereum', 'eth', 'cardano', 'ada', 
                          'solana', 'sol', 'dogecoin', 'doge', 'matic', 'polygon'];
    
    for (String crypto in commonCryptos) {
      if (message.contains(crypto)) {
        return crypto;
      }
    }
    return null;
  }

  double _analyzeSentiment(String text) {
    double sentiment = 0.0;
    int keywordCount = 0;
    
    final words = text.toLowerCase().split(' ');
    for (String word in words) {
      if (_sentimentKeywords.containsKey(word)) {
        sentiment += _sentimentKeywords[word]!;
        keywordCount++;
      }
    }
    
    return keywordCount > 0 ? sentiment / keywordCount : 0.0;
  }

  String _generatePriceInsight(Cryptocurrency crypto) {
    final change = crypto.priceChangePercentage24h ?? 0.0;
    
    if (change > 10) {
      return "Strong bullish momentum! Consider taking some profits if you're holding.";
    } else if (change > 5) {
      return "Good upward movement. Watch for potential resistance levels.";
    } else if (change > 0) {
      return "Modest gains today. The trend looks stable.";
    } else if (change > -5) {
      return "Minor dip. Could be a good accumulation opportunity.";
    } else if (change > -10) {
      return "Significant decline. Monitor support levels closely.";
    } else {
      return "Major correction in progress. Exercise caution and manage risk.";
    }
  }

  String _performBasicTechnicalAnalysis(Cryptocurrency crypto) {
    final current = crypto.currentPrice;
    final high24h = crypto.high24h ?? current;
    final low24h = crypto.low24h ?? current;
    final change = crypto.priceChangePercentage24h ?? 0.0;
    
    List<String> analysis = [];
    
    // Price position analysis
    final range = high24h - low24h;
    final position = (current - low24h) / range;
    
    if (position > 0.8) {
      analysis.add("• Price is near 24h high - potential resistance");
    } else if (position < 0.2) {
      analysis.add("• Price is near 24h low - potential support");
    } else {
      analysis.add("• Price is in the middle range - neutral zone");
    }
    
    // Momentum analysis
    if (change.abs() > 5) {
      analysis.add("• Strong momentum (${change > 0 ? 'bullish' : 'bearish'})");
    } else if (change.abs() > 2) {
      analysis.add("• Moderate momentum");
    } else {
      analysis.add("• Low volatility - consolidation phase");
    }
    
    // Volume-based insight (mock)
    analysis.add("• Volume: ${crypto.totalVolume > 1000000000 ? 'High' : 'Normal'} trading activity");
    
    return analysis.join('\n');
  }

  String _generatePortfolioAdvice(double changePercent) {
    if (changePercent > 10) {
      return "Excellent performance! Consider rebalancing to lock in profits.";
    } else if (changePercent > 5) {
      return "Strong gains today. Stay disciplined with your strategy.";
    } else if (changePercent > 0) {
      return "Positive movement. Keep monitoring your positions.";
    } else if (changePercent > -5) {
      return "Minor dip. Good time to review your risk management.";
    } else if (changePercent > -10) {
      return "Significant decline. Consider dollar-cost averaging if you believe in your holdings.";
    } else {
      return "Major correction. Review your positions and consider risk management strategies.";
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return "${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago";
    } else if (difference.inHours > 0) {
      return "${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago";
    } else {
      return "${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago";
    }
  }
}

/// Chatbot response model
class ChatbotResponse {
  final String text;
  final ChatbotResponseType type;
  final double confidence;
  final List<String>? suggestions;
  final Map<String, dynamic>? data;
  final DateTime timestamp;

  ChatbotResponse({
    required this.text,
    required this.type,
    required this.confidence,
    this.suggestions,
    this.data,
  }) : timestamp = DateTime.now();
}

enum ChatbotResponseType {
  greeting,
  analysis,
  education,
  info,
  error,
  general,
}
