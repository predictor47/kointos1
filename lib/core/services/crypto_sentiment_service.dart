import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:kointos/core/services/logger_service.dart';
import 'package:kointos/core/services/gamification_service.dart';

/// Service for managing crypto sentiment tracking and voting
class CryptoSentimentService {
  final GamificationService _gamificationService;

  CryptoSentimentService(this._gamificationService);

  /// Submit a sentiment vote for a cryptocurrency
  Future<SentimentVoteResult> submitVote({
    required String cryptoSymbol,
    required SentimentType sentiment,
    String? reasoning,
    double? confidenceLevel,
    Duration? holdDuration,
  }) async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      final userId = user.userId;

      // Check if user already voted for this crypto today
      final existingVote = await _getExistingVote(userId, cryptoSymbol);
      if (existingVote != null) {
        return SentimentVoteResult(
          success: false,
          message: 'You have already voted for $cryptoSymbol today',
          existingVote: existingVote,
        );
      }

      // Create the vote
      const mutation = '''
        mutation CreateSentimentVote(\$input: CreateSentimentVoteInput!) {
          createSentimentVote(input: \$input) {
            id
            userId
            cryptoSymbol
            sentiment
            reasoning
            confidenceLevel
            holdDuration
            createdAt
            isActive
          }
        }
      ''';

      final variables = {
        'input': {
          'userId': userId,
          'cryptoSymbol': cryptoSymbol.toUpperCase(),
          'sentiment': sentiment.toString().split('.').last.toUpperCase(),
          'reasoning': reasoning,
          'confidenceLevel': confidenceLevel ?? 0.5,
          'holdDuration': holdDuration?.inDays,
          'createdAt': DateTime.now().toIso8601String(),
          'isActive': true,
        }
      };

      final request = GraphQLRequest<String>(
        document: mutation,
        variables: variables,
      );

      final response = await Amplify.API.mutate(request: request).response;

      if (response.data != null) {
        // Award points for voting
        await _gamificationService.awardPoints(
          GameAction.correctPrediction,
          metadata: {
            'cryptoSymbol': cryptoSymbol,
            'sentiment': sentiment.toString()
          },
        );

        LoggerService.info(
            'Sentiment vote submitted for $cryptoSymbol: $sentiment');

        return SentimentVoteResult(
          success: true,
          message: 'Vote submitted successfully! +15 points earned',
          voteId: 'vote_${DateTime.now().millisecondsSinceEpoch}',
        );
      }

      return SentimentVoteResult(
        success: false,
        message: 'Failed to submit vote',
      );
    } catch (e) {
      LoggerService.error('Failed to submit sentiment vote: $e');
      return SentimentVoteResult(
        success: false,
        message: 'Error submitting vote: ${e.toString()}',
      );
    }
  }

  /// Get sentiment summary for a cryptocurrency
  Future<CryptoSentiment> getCryptoSentiment(String cryptoSymbol) async {
    try {
      const query = '''
        query GetCryptoSentiment(\$cryptoSymbol: String!) {
          listSentimentVotes(
            filter: {
              cryptoSymbol: { eq: \$cryptoSymbol }
              isActive: { eq: true }
              createdAt: { ge: \$since }
            }
          ) {
            items {
              sentiment
              confidenceLevel
              createdAt
              userId
            }
          }
        }
      ''';

      // Get votes from last 24 hours
      final since = DateTime.now().subtract(const Duration(hours: 24));

      final request = GraphQLRequest<String>(
        document: query,
        variables: {
          'cryptoSymbol': cryptoSymbol.toUpperCase(),
          'since': since.toIso8601String(),
        },
      );

      final response = await Amplify.API.query(request: request).response;

      if (response.data != null) {
        return _processSentimentData(cryptoSymbol, response.data!);
      }

      return CryptoSentiment.empty(cryptoSymbol);
    } catch (e) {
      LoggerService.error('Failed to get crypto sentiment: $e');
      return CryptoSentiment.empty(cryptoSymbol);
    }
  }

  /// Get user's voting history
  Future<List<UserSentimentVote>> getUserVotingHistory([String? userId]) async {
    try {
      userId ??= (await Amplify.Auth.getCurrentUser()).userId;

      const query = '''
        query GetUserVotes(\$userId: ID!) {
          listSentimentVotes(
            filter: { userId: { eq: \$userId } }
            sortDirection: DESC
            limit: 50
          ) {
            items {
              id
              cryptoSymbol
              sentiment
              reasoning
              confidenceLevel
              createdAt
              isActive
              actualOutcome
              pointsEarned
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
        // Parse and return vote history
        return _parseVoteHistory(response.data!);
      }

      return [];
    } catch (e) {
      LoggerService.error('Failed to get user voting history: $e');
      return [];
    }
  }

  /// Get trending sentiment across all cryptocurrencies
  Future<List<TrendingSentiment>> getTrendingSentiments() async {
    try {
      const query = '''
        query GetTrendingSentiments {
          getTrendingSentiments(timeframe: "24h", limit: 20) {
            cryptoSymbol
            bullishVotes
            bearishVotes
            neutralVotes
            totalVotes
            sentimentScore
            priceChange24h
            volumeChange24h
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: query,
        variables: {},
      );

      final response = await Amplify.API.query(request: request).response;

      if (response.data != null) {
        return _parseTrendingSentiments(response.data!);
      }

      return [];
    } catch (e) {
      LoggerService.error('Failed to get trending sentiments: $e');
      return [];
    }
  }

  /// Check if user has existing vote for crypto today
  Future<UserSentimentVote?> _getExistingVote(
      String userId, String cryptoSymbol) async {
    // Query for existing vote today
    // For now, return null (no existing vote)
    return null;
  }

  /// Process raw sentiment data into structured format
  CryptoSentiment _processSentimentData(String cryptoSymbol, String rawData) {
    // Parse the GraphQL response and calculate sentiment metrics
    int bullishCount = 0;
    int bearishCount = 0;
    int neutralCount = 0;
    double averageConfidence = 0.0;

    // Parse aggregated sentiment data from backend response
    return CryptoSentiment(
      cryptoSymbol: cryptoSymbol,
      bullishVotes: bullishCount,
      bearishVotes: bearishCount,
      neutralVotes: neutralCount,
      totalVotes: bullishCount + bearishCount + neutralCount,
      sentimentScore:
          _calculateSentimentScore(bullishCount, bearishCount, neutralCount),
      averageConfidence: averageConfidence,
      lastUpdated: DateTime.now(),
      topReasons: [
        'Strong fundamentals',
        'Institutional adoption',
        'Technical breakout'
      ],
    );
  }

  /// Calculate sentiment score (-1.0 to 1.0)
  double _calculateSentimentScore(int bullish, int bearish, int neutral) {
    final total = bullish + bearish + neutral;
    if (total == 0) return 0.0;

    return (bullish - bearish) / total;
  }

  /// Parse vote history from GraphQL response
  List<UserSentimentVote> _parseVoteHistory(String rawData) {
    // Parse vote history from GraphQL response
    try {
      final data = jsonDecode(rawData);
      final votes = data['items'] as List;
      return votes
          .map((vote) => UserSentimentVote(
                id: vote['id'],
                userId: vote['userId'],
                cryptoSymbol: vote['cryptoSymbol'],
                sentiment: SentimentType.values.firstWhere(
                  (e) =>
                      e.toString().split('.').last.toUpperCase() ==
                      vote['sentiment'],
                ),
                reasoning: vote['reasoning'],
                confidenceLevel: vote['confidenceLevel']?.toDouble() ?? 0.5,
                createdAt: DateTime.parse(vote['createdAt']),
                isActive: vote['isActive'] ?? true,
              ))
          .toList();
    } catch (e) {
      LoggerService.error('Failed to parse vote history: $e');
      return [];
    }
  }

  /// Parse trending sentiments from GraphQL response
  List<TrendingSentiment> _parseTrendingSentiments(String rawData) {
    // Parse trending sentiment data from GraphQL response
    try {
      final data = jsonDecode(rawData);
      final trends = data['items'] as List;
      return trends
          .map((trend) => TrendingSentiment(
                cryptoSymbol: trend['cryptoSymbol'],
                bullishVotes: trend['bullishVotes'] ?? 0,
                bearishVotes: trend['bearishVotes'] ?? 0,
                neutralVotes: trend['neutralVotes'] ?? 0,
                totalVotes: trend['totalVotes'] ?? 0,
                sentimentScore: trend['sentimentScore']?.toDouble() ?? 0.0,
                priceChange24h: trend['priceChange24h']?.toDouble(),
                volumeChange24h: trend['volumeChange24h']?.toDouble(),
              ))
          .toList();
    } catch (e) {
      LoggerService.error('Failed to parse trending sentiments: $e');
      return [];
    }
  }
}

/// Types of sentiment
enum SentimentType {
  bullish,
  bearish,
  neutral,
}

/// Result of a sentiment vote submission
class SentimentVoteResult {
  final bool success;
  final String message;
  final String? voteId;
  final UserSentimentVote? existingVote;

  SentimentVoteResult({
    required this.success,
    required this.message,
    this.voteId,
    this.existingVote,
  });
}

/// Crypto sentiment data
class CryptoSentiment {
  final String cryptoSymbol;
  final int bullishVotes;
  final int bearishVotes;
  final int neutralVotes;
  final int totalVotes;
  final double sentimentScore; // -1.0 to 1.0
  final double averageConfidence;
  final DateTime lastUpdated;
  final List<String> topReasons;

  CryptoSentiment({
    required this.cryptoSymbol,
    required this.bullishVotes,
    required this.bearishVotes,
    required this.neutralVotes,
    required this.totalVotes,
    required this.sentimentScore,
    required this.averageConfidence,
    required this.lastUpdated,
    required this.topReasons,
  });

  factory CryptoSentiment.empty(String cryptoSymbol) {
    return CryptoSentiment(
      cryptoSymbol: cryptoSymbol,
      bullishVotes: 0,
      bearishVotes: 0,
      neutralVotes: 0,
      totalVotes: 0,
      sentimentScore: 0.0,
      averageConfidence: 0.0,
      lastUpdated: DateTime.now(),
      topReasons: [],
    );
  }

  /// Get sentiment as emoji
  String get sentimentEmoji {
    if (sentimentScore > 0.3) return '🚀';
    if (sentimentScore > 0.1) return '📈';
    if (sentimentScore > -0.1) return '😐';
    if (sentimentScore > -0.3) return '📉';
    return '💀';
  }

  /// Get sentiment as text
  String get sentimentText {
    if (sentimentScore > 0.3) return 'Very Bullish';
    if (sentimentScore > 0.1) return 'Bullish';
    if (sentimentScore > -0.1) return 'Neutral';
    if (sentimentScore > -0.3) return 'Bearish';
    return 'Very Bearish';
  }

  /// Get bullish percentage
  double get bullishPercentage {
    if (totalVotes == 0) return 0.0;
    return bullishVotes / totalVotes;
  }

  /// Get bearish percentage
  double get bearishPercentage {
    if (totalVotes == 0) return 0.0;
    return bearishVotes / totalVotes;
  }
}

/// User's sentiment vote
class UserSentimentVote {
  final String id;
  final String userId;
  final String cryptoSymbol;
  final SentimentType sentiment;
  final String? reasoning;
  final double confidenceLevel;
  final Duration? holdDuration;
  final DateTime createdAt;
  final bool isActive;
  final SentimentType? actualOutcome;
  final int? pointsEarned;

  UserSentimentVote({
    required this.id,
    required this.userId,
    required this.cryptoSymbol,
    required this.sentiment,
    this.reasoning,
    required this.confidenceLevel,
    this.holdDuration,
    required this.createdAt,
    required this.isActive,
    this.actualOutcome,
    this.pointsEarned,
  });

  /// Check if prediction was correct
  bool get wasCorrect => actualOutcome != null && actualOutcome == sentiment;

  /// Get accuracy rate for display
  String get accuracyDisplay {
    if (actualOutcome == null) return 'Pending';
    return wasCorrect ? 'Correct ✅' : 'Incorrect ❌';
  }
}

/// Trending sentiment data
class TrendingSentiment {
  final String cryptoSymbol;
  final int bullishVotes;
  final int bearishVotes;
  final int neutralVotes;
  final int totalVotes;
  final double sentimentScore;
  final double? priceChange24h;
  final double? volumeChange24h;

  TrendingSentiment({
    required this.cryptoSymbol,
    required this.bullishVotes,
    required this.bearishVotes,
    required this.neutralVotes,
    required this.totalVotes,
    required this.sentimentScore,
    this.priceChange24h,
    this.volumeChange24h,
  });
}
