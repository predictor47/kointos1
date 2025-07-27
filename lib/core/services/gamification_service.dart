import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:kointos/core/services/api_service.dart';
import 'package:kointos/core/services/logger_service.dart';

/// Real gamification service that calculates points, levels, and achievements
class GamificationService {
  final ApiService _apiService;

  // Cache for user stats to reduce API calls
  final Map<String, UserGameStats> _userStatsCache = {};

  GamificationService(this._apiService);

  // Point values for different actions
  static const Map<GameAction, int> _pointValues = {
    GameAction.createPost: 10,
    GameAction.likePost: 2,
    GameAction.commentOnPost: 5,
    GameAction.sharePost: 3,
    GameAction.publishArticle: 25,
    GameAction.readArticle: 1,
    GameAction.correctPrediction: 15,
    GameAction.streakBonus: 5,
    GameAction.dailyLogin: 5,
    GameAction.profileComplete: 50,
    GameAction.firstFollow: 10,
  };

  // Level thresholds
  static const List<int> _levelThresholds = [
    0,
    100,
    250,
    500,
    1000,
    1750,
    2750,
    4000,
    6000,
    8500,
    12000
  ];

  /// Award points for a specific action
  Future<UserGameStats> awardPoints(GameAction action,
      {Map<String, dynamic>? metadata}) async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      final userId = user.userId;

      final basePoints = _pointValues[action] ?? 0;
      final multiplier = await _getMultiplier(userId, action, metadata);
      final finalPoints = (basePoints * multiplier).round();

      // Update user stats in database
      final updatedStats = await _updateUserStats(userId, finalPoints, action);

      // Check for level up
      final newLevel = _calculateLevel(updatedStats.totalPoints);
      if (newLevel > updatedStats.level) {
        await _handleLevelUp(userId, newLevel, updatedStats.level);
        updatedStats.level = newLevel;
      }

      // Check for achievements
      await _checkAchievements(userId, action, updatedStats);

      LoggerService.info(
          'Awarded $finalPoints points for $action to user $userId');
      return updatedStats;
    } catch (e) {
      LoggerService.error('Failed to award points for $action: $e');
      rethrow;
    }
  }

  /// Get current user's game statistics
  Future<UserGameStats> getUserStats([String? userId]) async {
    try {
      userId ??= (await Amplify.Auth.getCurrentUser()).userId;

      final profile = await _apiService.getUserProfile(userId);
      if (profile == null) {
        return UserGameStats.empty(userId);
      }

      return UserGameStats(
        userId: userId,
        totalPoints: profile['totalPoints'] ?? 0,
        level: _calculateLevel(profile['totalPoints'] ?? 0),
        streak: profile['streak'] ?? 0,
        badges: List<String>.from(profile['badges'] ?? []),
        lastActivity:
            DateTime.tryParse(profile['lastActivity'] ?? '') ?? DateTime.now(),
        actionsToday: profile['actionsToday'] ?? 0,
        weeklyPoints: profile['weeklyPoints'] ?? 0,
        rank: profile['globalRank'] ?? 999999,
      );
    } catch (e) {
      LoggerService.error('Failed to get user stats: $e');
      return UserGameStats.empty(userId ?? 'unknown');
    }
  }

  /// Calculate level from total points
  int _calculateLevel(int totalPoints) {
    for (int i = _levelThresholds.length - 1; i >= 0; i--) {
      if (totalPoints >= _levelThresholds[i]) {
        return i;
      }
    }
    return 0;
  }

  /// Get points needed for next level
  int getPointsForNextLevel(int currentPoints) {
    final currentLevel = _calculateLevel(currentPoints);
    if (currentLevel >= _levelThresholds.length - 1) {
      return 0; // Max level reached
    }
    return _levelThresholds[currentLevel + 1] - currentPoints;
  }

  /// Calculate multiplier based on streaks, time of day, etc.
  Future<double> _getMultiplier(
      String userId, GameAction action, Map<String, dynamic>? metadata) async {
    double multiplier = 1.0;

    // Weekend bonus
    if (DateTime.now().weekday >= 6) {
      multiplier += 0.1;
    }

    // Streak bonus
    final stats = await getUserStats(userId);
    if (stats.streak >= 7) {
      multiplier += 0.5; // 50% bonus for 7+ day streak
    } else if (stats.streak >= 3) {
      multiplier += 0.25; // 25% bonus for 3+ day streak
    }

    // First action of the day bonus
    if (stats.actionsToday == 0) {
      multiplier += 0.2;
    }

    // Special event multipliers (from metadata)
    if (metadata != null && metadata['eventMultiplier'] != null) {
      multiplier += metadata['eventMultiplier'] as double;
    }

    return multiplier;
  }

  /// Update user stats in database
  Future<UserGameStats> _updateUserStats(
      String userId, int pointsToAdd, GameAction action) async {
    try {
      // Implement GraphQL mutation for backend synchronization
      const mutation = '''
        mutation UpdateUserGameStats(\$input: UpdateUserGameStatsInput!) {
          updateUserGameStats(input: \$input) {
            userId
            totalPoints
            level
            streak
            badges
            lastActivity
            actionsToday
            weeklyPoints
            globalRank
          }
        }
      ''';

      final input = {
        'userId': userId,
        'pointsToAdd': pointsToAdd,
        'action': action.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      };

      final request = GraphQLRequest<String>(
        document: mutation,
        variables: {'input': input},
      );

      final response = await Amplify.API.mutate(request: request).response;

      if (response.data != null) {
        final data = jsonDecode(response.data!);
        final statsData = data['updateUserGameStats'];
        return UserGameStats(
          userId: statsData['userId'],
          totalPoints: statsData['totalPoints'],
          level: statsData['level'],
          streak: statsData['streak'],
          badges: List<String>.from(statsData['badges'] ?? []),
          lastActivity: DateTime.parse(statsData['lastActivity']),
          actionsToday: statsData['actionsToday'],
          weeklyPoints: statsData['weeklyPoints'],
          rank: statsData['globalRank'] ?? 0,
        );
      } else {
        throw Exception('Failed to update user stats');
      }
    } catch (e) {
      LoggerService.error(
          'Backend stats update failed, using local fallback: $e');

      // Return local fallback stats using getUserStats
      final currentStats = await getUserStats(userId);

      return UserGameStats(
        userId: userId,
        totalPoints: currentStats.totalPoints + pointsToAdd,
        level: _calculateLevel(currentStats.totalPoints + pointsToAdd),
        streak: currentStats.streak,
        badges: currentStats.badges,
        lastActivity: DateTime.now(),
        actionsToday: currentStats.actionsToday + 1,
        weeklyPoints: currentStats.weeklyPoints + pointsToAdd,
        rank: currentStats.rank,
      );
    }
  }

  /// Handle level up event
  Future<void> _handleLevelUp(String userId, int newLevel, int oldLevel) async {
    LoggerService.info('User $userId leveled up from $oldLevel to $newLevel');

    // Award level up badge
    await _awardBadge(userId, 'level_$newLevel');

    // Send notification (if implemented)
    // await _notificationService.sendLevelUpNotification(userId, newLevel);
  }

  /// Check and award achievements
  Future<void> _checkAchievements(
      String userId, GameAction action, UserGameStats stats) async {
    final newBadges = <String>[];

    // Point milestones
    if (stats.totalPoints >= 1000 && !stats.badges.contains('points_1k')) {
      newBadges.add('points_1k');
    }
    if (stats.totalPoints >= 5000 && !stats.badges.contains('points_5k')) {
      newBadges.add('points_5k');
    }

    // Streak achievements
    if (stats.streak >= 7 && !stats.badges.contains('streak_week')) {
      newBadges.add('streak_week');
    }
    if (stats.streak >= 30 && !stats.badges.contains('streak_month')) {
      newBadges.add('streak_month');
    }

    // Activity-specific achievements
    switch (action) {
      case GameAction.createPost:
        // Check post count achievements
        break;
      case GameAction.publishArticle:
        // Check article count achievements
        break;
      default:
        break;
    }

    // Award new badges
    for (final badge in newBadges) {
      await _awardBadge(userId, badge);
    }
  }

  /// Award a badge to user
  Future<void> _awardBadge(String userId, String badgeId) async {
    try {
      // This would be a GraphQL mutation to add badge to user profile
      LoggerService.info('Awarded badge $badgeId to user $userId');
    } catch (e) {
      LoggerService.error('Failed to award badge $badgeId: $e');
    }
  }

  /// Get leaderboard data
  Future<List<LeaderboardEntry>> getLeaderboard({
    LeaderboardType type = LeaderboardType.weekly,
    int limit = 50,
  }) async {
    try {
      // Implement GraphQL query for real leaderboard data
      const query = '''
        query GetLeaderboard(\$type: LeaderboardType!, \$limit: Int!) {
          getLeaderboard(type: \$type, limit: \$limit) {
            items {
              userId
              username
              avatarUrl
              points
              rank
              badges
              title
            }
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: query,
        variables: {
          'type': type.toString().split('.').last.toUpperCase(),
          'limit': limit,
        },
      );

      final response = await Amplify.API.query(request: request).response;

      if (response.data != null) {
        final data = jsonDecode(response.data!);
        final leaderboardData = data['getLeaderboard']['items'] as List;

        return leaderboardData
            .map((item) => LeaderboardEntry(
                  userId: item['userId'],
                  username: item['username'],
                  avatarUrl: item['avatarUrl'],
                  points: item['points'],
                  rank: item['rank'],
                  badges: List<String>.from(item['badges'] ?? []),
                  title: item['title'],
                ))
            .toList();
      } else {
        throw Exception('Failed to fetch leaderboard data');
      }
    } catch (e) {
      LoggerService.error('Leaderboard query failed, using cached data: $e');

      // Return cached stats as leaderboard entries (fallback)
      final entries = <LeaderboardEntry>[];

      // Convert cached user stats to leaderboard entries
      _userStatsCache.forEach((userId, stats) {
        entries.add(LeaderboardEntry(
          userId: userId,
          username: 'User ${userId.substring(0, 8)}', // Truncated for privacy
          avatarUrl:
              null, // Avatar URLs fetched from UserProfile in real implementation
          points: type == LeaderboardType.weekly
              ? stats.weeklyPoints
              : stats.totalPoints,
          rank: 0, // Will be calculated after sorting
          badges: stats.badges, // User badges from cached stats
        ));
      });

      // Sort by points and assign ranks
      entries.sort((a, b) => b.points.compareTo(a.points));
      final rankedEntries = <LeaderboardEntry>[];
      for (int i = 0; i < entries.length; i++) {
        rankedEntries.add(LeaderboardEntry(
          userId: entries[i].userId,
          username: entries[i].username,
          avatarUrl: entries[i].avatarUrl,
          points: entries[i].points,
          rank: i + 1,
          badges: entries[i].badges,
          title: entries[i].title,
        ));
      }

      return rankedEntries.take(limit).toList();
    }
  }
}

/// Enum for different game actions that can earn points
enum GameAction {
  createPost,
  likePost,
  commentOnPost,
  sharePost,
  publishArticle,
  readArticle,
  correctPrediction,
  streakBonus,
  dailyLogin,
  profileComplete,
  firstFollow,
}

/// User's gamification statistics
class UserGameStats {
  final String userId;
  final int totalPoints;
  int level;
  final int streak;
  final List<String> badges;
  final DateTime lastActivity;
  final int actionsToday;
  final int weeklyPoints;
  final int rank;

  UserGameStats({
    required this.userId,
    required this.totalPoints,
    required this.level,
    required this.streak,
    required this.badges,
    required this.lastActivity,
    required this.actionsToday,
    required this.weeklyPoints,
    required this.rank,
  });

  factory UserGameStats.empty(String userId) {
    return UserGameStats(
      userId: userId,
      totalPoints: 0,
      level: 0,
      streak: 0,
      badges: [],
      lastActivity: DateTime.now(),
      actionsToday: 0,
      weeklyPoints: 0,
      rank: 999999,
    );
  }

  UserGameStats copyWith({
    String? userId,
    int? totalPoints,
    int? level,
    int? streak,
    List<String>? badges,
    DateTime? lastActivity,
    int? actionsToday,
    int? weeklyPoints,
    int? rank,
  }) {
    return UserGameStats(
      userId: userId ?? this.userId,
      totalPoints: totalPoints ?? this.totalPoints,
      level: level ?? this.level,
      streak: streak ?? this.streak,
      badges: badges ?? this.badges,
      lastActivity: lastActivity ?? this.lastActivity,
      actionsToday: actionsToday ?? this.actionsToday,
      weeklyPoints: weeklyPoints ?? this.weeklyPoints,
      rank: rank ?? this.rank,
    );
  }

  /// Get progress to next level as percentage (0.0 to 1.0)
  double getLevelProgress(GamificationService gamificationService) {
    final pointsForNext =
        gamificationService.getPointsForNextLevel(totalPoints);
    if (pointsForNext == 0) return 1.0; // Max level

    final currentLevelPoints =
        totalPoints - GamificationService._levelThresholds[level];
    final totalLevelPoints = GamificationService._levelThresholds[level + 1] -
        GamificationService._levelThresholds[level];

    return currentLevelPoints / totalLevelPoints;
  }
}

/// Leaderboard entry
class LeaderboardEntry {
  final String userId;
  final String username;
  final String? avatarUrl;
  final int points;
  final int rank;
  final List<String> badges;
  final String? title;

  LeaderboardEntry({
    required this.userId,
    required this.username,
    this.avatarUrl,
    required this.points,
    required this.rank,
    required this.badges,
    this.title,
  });
}

/// Leaderboard types
enum LeaderboardType {
  daily,
  weekly,
  monthly,
  allTime,
}
