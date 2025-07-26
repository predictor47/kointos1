import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:kointos/core/services/performance_optimization_service.dart';

class EnhancedAnalyticsService {
  static final EnhancedAnalyticsService _instance =
      EnhancedAnalyticsService._internal();
  
  factory EnhancedAnalyticsService() => _instance;
  
  EnhancedAnalyticsService._internal();

  final PerformanceOptimizationService _performanceService = 
      PerformanceOptimizationService();
  
  // User Analytics
  final Map<String, dynamic> _userBehavior = {};
  final Map<String, int> _screenViews = {};
  final Map<String, int> _featureUsage = {};
  final Map<String, List<DateTime>> _sessionData = {};
  
  // Portfolio Analytics
  final Map<String, dynamic> _portfolioMetrics = {};
  final Map<String, List<Map<String, dynamic>>> _transactionHistory = {};
  final Map<String, double> _performanceHistory = {};
  
  // Market Analytics
  final Map<String, dynamic> _marketTrends = {};
  final Map<String, List<double>> _priceCorrelations = {};
  final Map<String, dynamic> _volumeAnalysis = {};
  
  // Social Analytics
  final Map<String, int> _postEngagement = {};
  final Map<String, dynamic> _communityMetrics = {};
  final Map<String, int> _chatbotInteractions = {};
  
  // Real-time data
  Timer? _analyticsTimer;
  final List<String> _realtimeEvents = [];
  
  void initialize() {
    _startRealtimeAnalytics();
    _loadStoredAnalytics();
    if (kDebugMode) {
      print('EnhancedAnalyticsService initialized');
    }
  }
  
  void dispose() {
    _analyticsTimer?.cancel();
    _saveAnalyticsData();
  }

  // User Behavior Analytics
  void trackScreenView(String screenName, {Map<String, dynamic>? parameters}) {
    _screenViews[screenName] = (_screenViews[screenName] ?? 0) + 1;
    
    final event = {
      'type': 'screen_view',
      'screen': screenName,
      'timestamp': DateTime.now().toIso8601String(),
      'parameters': parameters ?? {},
    };
    
    _addRealtimeEvent(event);
    _performanceService.recordOperationStart('screen_load_$screenName');
    
    if (kDebugMode) {
      print('Screen view tracked: $screenName');
    }
  }
  
  void trackFeatureUsage(String featureName, {Map<String, dynamic>? context}) {
    _featureUsage[featureName] = (_featureUsage[featureName] ?? 0) + 1;
    
    final event = {
      'type': 'feature_usage',
      'feature': featureName,
      'timestamp': DateTime.now().toIso8601String(),
      'context': context ?? {},
    };
    
    _addRealtimeEvent(event);
    
    if (kDebugMode) {
      print('Feature usage tracked: $featureName');
    }
  }
  
  void trackUserAction(String action, Map<String, dynamic> data) {
    final key = 'action_$action';
    _userBehavior[key] = _userBehavior[key] ?? <Map<String, dynamic>>[];
    
    final actionData = {
      'timestamp': DateTime.now().toIso8601String(),
      'data': data,
    };
    
    (_userBehavior[key] as List).add(actionData);
    
    // Keep only last 1000 actions per type
    if ((_userBehavior[key] as List).length > 1000) {
      (_userBehavior[key] as List).removeAt(0);
    }
    
    _addRealtimeEvent({
      'type': 'user_action',
      'action': action,
      'timestamp': DateTime.now().toIso8601String(),
      'data': data,
    });
  }
  
  void startSession(String userId) {
    _sessionData[userId] = _sessionData[userId] ?? <DateTime>[];
    _sessionData[userId]!.add(DateTime.now());
    
    _addRealtimeEvent({
      'type': 'session_start',
      'userId': userId,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  void endSession(String userId) {
    if (_sessionData[userId]?.isNotEmpty == true) {
      final sessionStart = _sessionData[userId]!.last;
      final sessionDuration = DateTime.now().difference(sessionStart);
      
      _addRealtimeEvent({
        'type': 'session_end',
        'userId': userId,
        'duration': sessionDuration.inSeconds,
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  // Portfolio Analytics
  void trackPortfolioPerformance(String userId, Map<String, dynamic> portfolioData) {
    final key = 'portfolio_$userId';
    _portfolioMetrics[key] = portfolioData;
    
    // Calculate performance metrics
    final totalValue = portfolioData['totalValue'] as double? ?? 0.0;
    final previousValue = _performanceHistory['${key}_previous'] ?? totalValue;
    final performance = totalValue > 0 ? ((totalValue - previousValue) / previousValue) * 100 : 0.0;
    
    _performanceHistory[key] = performance;
    _performanceHistory['${key}_previous'] = totalValue;
    
    _addRealtimeEvent({
      'type': 'portfolio_update',
      'userId': userId,
      'performance': performance,
      'totalValue': totalValue,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  void trackTransaction(String userId, Map<String, dynamic> transaction) {
    final key = 'transactions_$userId';
    _transactionHistory[key] = _transactionHistory[key] ?? <Map<String, dynamic>>[];
    
    final transactionData = {
      ...transaction,
      'timestamp': DateTime.now().toIso8601String(),
      'id': _generateTransactionId(),
    };
    
    _transactionHistory[key]!.add(transactionData);
    
    // Keep only last 10000 transactions per user
    if (_transactionHistory[key]!.length > 10000) {
      _transactionHistory[key]!.removeAt(0);
    }
    
    _addRealtimeEvent({
      'type': 'transaction',
      'userId': userId,
      'transaction': transactionData,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  Map<String, dynamic> getPortfolioAnalytics(String userId) {
    final key = 'portfolio_$userId';
    final transactions = _transactionHistory['transactions_$userId'] ?? [];
    final performance = _performanceHistory[key] ?? 0.0;
    
    return {
      'currentMetrics': _portfolioMetrics[key] ?? {},
      'performance': performance,
      'transactionCount': transactions.length,
      'recentTransactions': transactions.take(10).toList(),
      'analytics': _calculatePortfolioAnalytics(transactions),
    };
  }

  // Market Analytics
  void trackMarketData(String symbol, Map<String, dynamic> marketData) {
    _marketTrends[symbol] = marketData;
    
    // Update price correlations
    _updatePriceCorrelations(symbol, marketData['price'] as double? ?? 0.0);
    
    // Update volume analysis
    _updateVolumeAnalysis(symbol, marketData['volume'] as double? ?? 0.0);
    
    _addRealtimeEvent({
      'type': 'market_update',
      'symbol': symbol,
      'price': marketData['price'],
      'change': marketData['priceChange24h'],
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  void _updatePriceCorrelations(String symbol, double price) {
    _priceCorrelations[symbol] = _priceCorrelations[symbol] ?? <double>[];
    _priceCorrelations[symbol]!.add(price);
    
    // Keep only last 100 prices for correlation analysis
    if (_priceCorrelations[symbol]!.length > 100) {
      _priceCorrelations[symbol]!.removeAt(0);
    }
  }
  
  void _updateVolumeAnalysis(String symbol, double volume) {
    final key = '${symbol}_volume';
    _volumeAnalysis[key] = _volumeAnalysis[key] ?? <double>[];
    (_volumeAnalysis[key] as List<double>).add(volume);
    
    // Keep only last 100 volume data points
    if ((_volumeAnalysis[key] as List<double>).length > 100) {
      (_volumeAnalysis[key] as List<double>).removeAt(0);
    }
  }
  
  Map<String, dynamic> getMarketAnalytics() {
    return {
      'trends': _marketTrends,
      'correlations': _calculatePriceCorrelations(),
      'volumeAnalysis': _calculateVolumeAnalytics(),
      'topMovers': _getTopMovers(),
    };
  }

  // Social Analytics
  void trackPostEngagement(String postId, String engagementType) {
    final key = '${postId}_$engagementType';
    _postEngagement[key] = (_postEngagement[key] ?? 0) + 1;
    
    _addRealtimeEvent({
      'type': 'post_engagement',
      'postId': postId,
      'engagementType': engagementType,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  void trackCommunityActivity(String communityId, String activityType, Map<String, dynamic> data) {
    final key = '${communityId}_$activityType';
    _communityMetrics[key] = _communityMetrics[key] ?? <Map<String, dynamic>>[];
    
    final activityData = {
      'timestamp': DateTime.now().toIso8601String(),
      'data': data,
    };
    
    (_communityMetrics[key] as List).add(activityData);
    
    _addRealtimeEvent({
      'type': 'community_activity',
      'communityId': communityId,
      'activityType': activityType,
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  void trackChatbotInteraction(String interactionType, Map<String, dynamic> context) {
    _chatbotInteractions[interactionType] = (_chatbotInteractions[interactionType] ?? 0) + 1;
    
    _addRealtimeEvent({
      'type': 'chatbot_interaction',
      'interactionType': interactionType,
      'context': context,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  Map<String, dynamic> getSocialAnalytics() {
    return {
      'postEngagement': _postEngagement,
      'communityMetrics': _communityMetrics,
      'chatbotInteractions': _chatbotInteractions,
      'engagementTrends': _calculateEngagementTrends(),
    };
  }

  // Advanced Analytics
  Map<String, dynamic> getUserInsights(String userId) {
    final sessions = _sessionData[userId] ?? [];
    final portfolio = getPortfolioAnalytics(userId);
    
    return {
      'sessionCount': sessions.length,
      'averageSessionDuration': _calculateAverageSessionDuration(userId),
      'lastActive': sessions.isNotEmpty ? sessions.last.toIso8601String() : null,
      'portfolioPerformance': portfolio,
      'featureUsage': _getUserFeatureUsage(userId),
      'recommendations': _generateUserRecommendations(userId),
    };
  }
  
  Map<String, dynamic> getComprehensiveAnalytics() {
    return {
      'userAnalytics': {
        'totalScreenViews': _screenViews.values.fold(0, (a, b) => a + b),
        'totalFeatureUsage': _featureUsage.values.fold(0, (a, b) => a + b),
        'activeUsers': _sessionData.length,
        'topScreens': _getTopScreens(),
        'topFeatures': _getTopFeatures(),
      },
      'marketAnalytics': getMarketAnalytics(),
      'socialAnalytics': getSocialAnalytics(),
      'performanceMetrics': _performanceService.getAllAveragePerformances(),
      'realtimeEvents': _realtimeEvents.take(100).toList(),
    };
  }
  
  List<Map<String, dynamic>> getRealtimeEvents({int limit = 50}) {
    return _realtimeEvents
        .take(limit)
        .map((event) => jsonDecode(event) as Map<String, dynamic>)
        .toList();
  }
  
  // Helper Methods
  void _addRealtimeEvent(Map<String, dynamic> event) {
    _realtimeEvents.insert(0, jsonEncode(event));
    
    // Keep only last 1000 events
    if (_realtimeEvents.length > 1000) {
      _realtimeEvents.removeLast();
    }
  }
  
  void _startRealtimeAnalytics() {
    _analyticsTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      _processAnalytics();
      _cleanupOldData();
    });
  }
  
  void _processAnalytics() {
    // Process and aggregate analytics data
    _generateInsights();
    _updateTrends();
    _calculateMetrics();
  }
  
  void _generateInsights() {
    // Generate user behavior insights
    // Generate market insights
    // Generate performance insights
  }
  
  void _updateTrends() {
    // Update trending data
    // Calculate moving averages
    // Identify patterns
  }
  
  void _calculateMetrics() {
    // Calculate KPIs
    // Update performance metrics
    // Generate reports
  }
  
  void _cleanupOldData() {
    final cutoffDate = DateTime.now().subtract(const Duration(days: 30));
    
    // Cleanup old session data
    _sessionData.removeWhere((key, sessions) {
      sessions.removeWhere((session) => session.isBefore(cutoffDate));
      return sessions.isEmpty;
    });
    
    // Cleanup old realtime events
    if (_realtimeEvents.length > 500) {
      _realtimeEvents.removeRange(500, _realtimeEvents.length);
    }
  }
  
  void _loadStoredAnalytics() {
    // Load analytics data from storage
    // This would typically load from a local database or SharedPreferences
  }
  
  void _saveAnalyticsData() {
    // Save analytics data to storage
    // This would typically save to a local database or SharedPreferences
  }
  
  String _generateTransactionId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}';
  }
  
  Map<String, dynamic> _calculatePortfolioAnalytics(List<Map<String, dynamic>> transactions) {
    if (transactions.isEmpty) return {};
    
    final buyTransactions = transactions.where((t) => t['type'] == 'buy').length;
    final sellTransactions = transactions.where((t) => t['type'] == 'sell').length;
    final totalVolume = transactions.fold<double>(
      0.0,
      (sum, t) => sum + (t['amount'] as double? ?? 0.0),
    );
    
    return {
      'totalTransactions': transactions.length,
      'buyTransactions': buyTransactions,
      'sellTransactions': sellTransactions,
      'totalVolume': totalVolume,
      'averageTransactionSize': totalVolume / transactions.length,
    };
  }
  
  Map<String, double> _calculatePriceCorrelations() {
    final correlations = <String, double>{};
    final symbols = _priceCorrelations.keys.toList();
    
    for (int i = 0; i < symbols.length; i++) {
      for (int j = i + 1; j < symbols.length; j++) {
        final symbol1 = symbols[i];
        final symbol2 = symbols[j];
        final correlation = _calculateCorrelation(
          _priceCorrelations[symbol1]!,
          _priceCorrelations[symbol2]!,
        );
        correlations['${symbol1}_$symbol2'] = correlation;
      }
    }
    
    return correlations;
  }
  
  double _calculateCorrelation(List<double> x, List<double> y) {
    if (x.length != y.length || x.isEmpty) return 0.0;
    
    final n = x.length;
    final meanX = x.reduce((a, b) => a + b) / n;
    final meanY = y.reduce((a, b) => a + b) / n;
    
    double numerator = 0.0;
    double sumXSquared = 0.0;
    double sumYSquared = 0.0;
    
    for (int i = 0; i < n; i++) {
      final dx = x[i] - meanX;
      final dy = y[i] - meanY;
      numerator += dx * dy;
      sumXSquared += dx * dx;
      sumYSquared += dy * dy;
    }
    
    final denominator = sqrt(sumXSquared * sumYSquared);
    return denominator != 0 ? numerator / denominator : 0.0;
  }
  
  Map<String, dynamic> _calculateVolumeAnalytics() {
    final analytics = <String, dynamic>{};
    
    for (final entry in _volumeAnalysis.entries) {
      final volumes = entry.value as List<double>;
      if (volumes.isNotEmpty) {
        final avgVolume = volumes.reduce((a, b) => a + b) / volumes.length;
        final maxVolume = volumes.reduce(max);
        final minVolume = volumes.reduce(min);
        
        analytics[entry.key] = {
          'average': avgVolume,
          'maximum': maxVolume,
          'minimum': minVolume,
          'current': volumes.last,
          'trend': volumes.length > 1 ? (volumes.last - volumes[volumes.length - 2]) : 0.0,
        };
      }
    }
    
    return analytics;
  }
  
  List<Map<String, dynamic>> _getTopMovers() {
    final movers = <Map<String, dynamic>>[];
    
    for (final entry in _marketTrends.entries) {
      final data = entry.value as Map<String, dynamic>;
      final change = data['priceChange24h'] as double? ?? 0.0;
      
      movers.add({
        'symbol': entry.key,
        'change': change,
        'price': data['price'],
      });
    }
    
    movers.sort((a, b) => (b['change'] as double).compareTo(a['change'] as double));
    return movers.take(10).toList();
  }
  
  Map<String, dynamic> _calculateEngagementTrends() {
    // Calculate engagement trends over time
    return {
      'totalEngagements': _postEngagement.values.fold(0, (a, b) => a + b),
      'averageEngagementPerPost': _postEngagement.isNotEmpty
          ? _postEngagement.values.fold(0, (a, b) => a + b) / _postEngagement.length
          : 0.0,
      'topEngagementTypes': _getTopEngagementTypes(),
    };
  }
  
  Duration _calculateAverageSessionDuration(String userId) {
    final sessions = _sessionData[userId] ?? [];
    if (sessions.length < 2) return Duration.zero;
    
    int totalDuration = 0;
    for (int i = 1; i < sessions.length; i++) {
      totalDuration += sessions[i].difference(sessions[i - 1]).inSeconds;
    }
    
    return Duration(seconds: totalDuration ~/ (sessions.length - 1));
  }
  
  Map<String, int> _getUserFeatureUsage(String userId) {
    // This would typically filter feature usage by user ID
    // For now, return general feature usage
    return Map.from(_featureUsage);
  }
  
  List<String> _generateUserRecommendations(String userId) {
    // Generate personalized recommendations based on user behavior
    final recommendations = <String>[];
    
    final portfolio = _portfolioMetrics['portfolio_$userId'];
    if (portfolio != null) {
      recommendations.add('Consider diversifying your portfolio');
      recommendations.add('Set up price alerts for your holdings');
    }
    
    recommendations.add('Join crypto communities to stay updated');
    recommendations.add('Use the AI chatbot for market insights');
    
    return recommendations;
  }
  
  List<Map<String, dynamic>> _getTopScreens() {
    final screens = _screenViews.entries.map((e) => {
      'screen': e.key,
      'views': e.value,
    }).toList();
    
    screens.sort((a, b) => (b['views'] as int).compareTo(a['views'] as int));
    return screens.take(10).toList();
  }
  
  List<Map<String, dynamic>> _getTopFeatures() {
    final features = _featureUsage.entries.map((e) => {
      'feature': e.key,
      'usage': e.value,
    }).toList();
    
    features.sort((a, b) => (b['usage'] as int).compareTo(a['usage'] as int));
    return features.take(10).toList();
  }
  
  List<Map<String, dynamic>> _getTopEngagementTypes() {
    final engagements = <String, int>{};
    
    for (final entry in _postEngagement.entries) {
      final type = entry.key.split('_').last;
      engagements[type] = (engagements[type] ?? 0) + entry.value;
    }
    
    final sorted = engagements.entries.map((e) => {
      'type': e.key,
      'count': e.value,
    }).toList();
    
    sorted.sort((a, b) => (b['count'] as int).compareTo(a['count'] as int));
    return sorted.take(5).toList();
  }
}
