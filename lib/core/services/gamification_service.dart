import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:kointos/core/services/api_service.dart';
import 'package:kointos/core/services/logger_service.dart';

/// Real gamification service that calculates points, levels, and achievements
class GamificationService {
  final ApiService _apiService;

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
      // Get current user profile to update
      final currentProfile = await _apiService.getUserProfile(userId);
      if (currentProfile == null) {
        throw Exception('User profile not found');
      }

      final currentPoints = currentProfile['totalPoints'] ?? 0;
      final newTotalPoints = currentPoints + pointsToAdd;
      final newLevel = _calculateLevel(newTotalPoints);

      // Reset daily/weekly counters if needed
      final now = DateTime.now();
      final lastActivity =
          DateTime.tryParse(currentProfile['lastActivity'] ?? '') ?? now;
      final isNewDay = !_isSameDay(lastActivity, now);
      final isNewWeek = !_isSameWeek(lastActivity, now);

      final newActionsToday =
          isNewDay ? 1 : (currentProfile['actionsToday'] ?? 0) + 1;
      final newWeeklyPoints = isNewWeek
          ? pointsToAdd
          : (currentProfile['weeklyPoints'] ?? 0) + pointsToAdd;

      // Update user profile with gamification data
      const mutation = '''
        mutation UpdateUserProfile(\$input: UpdateUserProfileInput!) {
          updateUserProfile(input: \$input) {
            userId
            totalPoints
            level
            streak
            badges
            lastActivity
            actionsToday
            weeklyPoints
            monthlyPoints
            globalRank
          }
        }
      ''';

      final input = {
        'userId': userId,
        'totalPoints': newTotalPoints,
        'level': newLevel,
        'lastActivity': now.toIso8601String(),
        'actionsToday': newActionsToday,
        'weeklyPoints': newWeeklyPoints,
        // Keep existing values for other fields
        'streak': currentProfile['streak'] ?? 0,
        'badges': currentProfile['badges'] ?? [],
        'monthlyPoints': currentProfile['monthlyPoints'] ?? 0,
        'globalRank': currentProfile['globalRank'] ?? 999999,
      };

      final request = GraphQLRequest<String>(
        document: mutation,
        variables: {'input': input},
      );

      final response = await Amplify.API.mutate(request: request).response;

      if (response.data != null) {
        final data = jsonDecode(response.data!);
        final profileData = data['updateUserProfile'];

        LoggerService.info(
            'Updated user stats: +$pointsToAdd points for $action');

        return UserGameStats(
          userId: profileData['userId'],
          totalPoints: profileData['totalPoints'],
          level: profileData['level'],
          streak: profileData['streak'],
          badges: List<String>.from(profileData['badges'] ?? []),
          lastActivity: DateTime.parse(profileData['lastActivity']),
          actionsToday: profileData['actionsToday'],
          weeklyPoints: profileData['weeklyPoints'],
          rank: profileData['globalRank'] ?? 0,
        );
      } else {
        throw Exception('Failed to update user profile');
      }
    } catch (e) {
      LoggerService.error('Backend stats update failed: $e');
      rethrow;
    }
  }

  /// Check if two dates are on the same day
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Check if two dates are in the same week
  bool _isSameWeek(DateTime date1, DateTime date2) {
    final startOfWeek1 = date1.subtract(Duration(days: date1.weekday - 1));
    final startOfWeek2 = date2.subtract(Duration(days: date2.weekday - 1));
    return _isSameDay(startOfWeek1, startOfWeek2);
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
      // Get current user profile
      final currentProfile = await _apiService.getUserProfile(userId);
      if (currentProfile == null) {
        throw Exception('User profile not found');
      }

      // Check if user already has this badge
      final currentBadges = List<String>.from(currentProfile['badges'] ?? []);
      if (currentBadges.contains(badgeId)) {
        LoggerService.info('User $userId already has badge $badgeId');
        return;
      }

      // Add new badge
      currentBadges.add(badgeId);

      // Update user profile with new badge
      const mutation = '''
        mutation UpdateUserProfile(\$input: UpdateUserProfileInput!) {
          updateUserProfile(input: \$input) {
            userId
            badges
          }
        }
      ''';

      final input = {
        'userId': userId,
        'badges': currentBadges,
      };

      final request = GraphQLRequest<String>(
        document: mutation,
        variables: {'input': input},
      );

      final response = await Amplify.API.mutate(request: request).response;

      if (response.data != null) {
        LoggerService.info('Awarded badge $badgeId to user $userId');
      } else {
        throw Exception('Failed to update user badges');
      }
    } catch (e) {
      LoggerService.error('Failed to award badge $badgeId: $e');
    }
  }

  /// Get leaderboard data
  Future<List<LeaderboardEntry>> getLeaderboard({
    LeaderboardType type = LeaderboardType.weekly,
    int limit = 50,
  }) async {
    LoggerService.info('Fetching leaderboard for type: $type, limit: $limit');

    // Primary method: Try LeaderboardEntry table first
    try {
      final entries = await _fetchFromLeaderboardTable(type, limit);
      if (entries.isNotEmpty) {
        LoggerService.info(
            'Retrieved ${entries.length} entries from LeaderboardEntry table');
        return entries;
      }
      LoggerService.info(
          'LeaderboardEntry table is empty, falling back to UserProfile data');
    } catch (e) {
      LoggerService.error(
          'LeaderboardEntry query failed, falling back to UserProfile: $e');
    }

    // Fallback method: Generate from UserProfile data
    try {
      final entries = await _generateLeaderboardFromProfiles(type, limit);
      LoggerService.info(
          'Generated ${entries.length} entries from UserProfile data');
      return entries;
    } catch (e) {
      LoggerService.error('UserProfile fallback also failed: $e');
    }

    // Ultimate fallback: Return sample data for testing
    LoggerService.info('All leaderboard methods failed, returning sample data');
    return _generateSampleLeaderboard(type, limit);
  }

  /// Try to fetch from LeaderboardEntry table
  Future<List<LeaderboardEntry>> _fetchFromLeaderboardTable(
      LeaderboardType type, int limit) async {
    const query = '''
      query ListLeaderboardEntries(
        \$filter: ModelLeaderboardEntryFilterInput
        \$limit: Int
      ) {
        listLeaderboardEntries(
          filter: \$filter
          limit: \$limit
        ) {
          items {
            userId
            username
            avatarUrl
            points
            rank
            badges
            title
            leaderboardType
          }
        }
      }
    ''';

    final filter = {
      'leaderboardType': {'eq': type.toString().split('.').last.toUpperCase()}
    };

    final request = GraphQLRequest<String>(
      document: query,
      variables: {
        'filter': filter,
        'limit': limit,
      },
    );

    final response = await Amplify.API.query(request: request).response;

    if (response.data != null) {
      final data = jsonDecode(response.data!);
      final leaderboardData = data['listLeaderboardEntries']['items'] as List;

      if (leaderboardData.isEmpty) {
        return []; // Empty but successful response
      }

      final entries = leaderboardData
          .map((item) => LeaderboardEntry(
                userId: item['userId'] ?? 'unknown',
                username: item['username'] ?? 'Unknown User',
                avatarUrl: item['avatarUrl'],
                points: item['points'] ?? 0,
                rank: item['rank'] ?? 0,
                badges: List<String>.from(item['badges'] ?? []),
                title: item['title'],
              ))
          .toList();

      // Sort by rank to ensure proper ordering
      entries.sort((a, b) => a.rank.compareTo(b.rank));
      return entries;
    } else {
      throw Exception('GraphQL response was null');
    }
  }

  /// Generate leaderboard from UserProfile data (fallback)
  Future<List<LeaderboardEntry>> _generateLeaderboardFromProfiles(
      LeaderboardType type, int limit) async {
    try {
      LoggerService.info(
          'Attempting to generate leaderboard from UserProfile data');

      // Query all user profiles and sort by points
      const query = '''
        query ListUserProfiles(\$limit: Int) {
          listUserProfiles(limit: \$limit) {
            items {
              userId
              username
              displayName
              profilePicture
              totalPoints
              weeklyPoints
              monthlyPoints
              badges
              level
            }
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: query,
        variables: {'limit': limit * 2}, // Get more to sort and filter
      );

      final response = await Amplify.API.query(request: request).response;

      if (response.data != null) {
        final data = jsonDecode(response.data!);
        final profiles = data['listUserProfiles']['items'] as List;

        LoggerService.info('Found ${profiles.length} user profiles');

        if (profiles.isEmpty) {
          LoggerService.info('No user profiles found');
          return [];
        }

        // Convert to leaderboard entries
        final entries = profiles.map((profile) {
          int points;
          switch (type) {
            case LeaderboardType.weekly:
              points = profile['weeklyPoints'] ?? 0;
              break;
            case LeaderboardType.monthly:
              points = profile['monthlyPoints'] ?? 0;
              break;
            case LeaderboardType.daily:
              points =
                  profile['weeklyPoints'] ?? 0; // Use weekly for daily fallback
              break;
            case LeaderboardType.allTime:
              points = profile['totalPoints'] ?? 0;
              break;
          }

          final username = profile['username'] ??
              profile['displayName'] ??
              'User ${(profile['userId'] ?? '???').substring(0, 8)}';

          return LeaderboardEntry(
            userId: profile['userId'] ?? 'unknown',
            username: username,
            avatarUrl: profile['profilePicture'],
            points: points,
            rank: 0, // Will be assigned after sorting
            badges: List<String>.from(profile['badges'] ?? []),
            title: _getLevelTitle(profile['level'] ?? 0),
          );
        }).toList();

        // Include all users, even those with 0 points for now
        LoggerService.info(
            'Converted ${entries.length} profiles to leaderboard entries');

        // Sort by points and assign ranks
        entries.sort((a, b) => b.points.compareTo(a.points));

        final rankedEntries = <LeaderboardEntry>[];
        for (int i = 0; i < entries.length && i < limit; i++) {
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

        LoggerService.info(
            'Generated ${rankedEntries.length} ranked leaderboard entries from profiles');
        return rankedEntries;
      } else {
        LoggerService.error('UserProfile query returned null response');
        throw Exception('UserProfile query returned null response');
      }
    } catch (e) {
      LoggerService.error('Failed to generate leaderboard from profiles: $e');
      rethrow;
    }
  }

  /// Get title based on level
  String? _getLevelTitle(int level) {
    if (level >= 10) return 'Legend';
    if (level >= 8) return 'Expert';
    if (level >= 6) return 'Pro';
    if (level >= 4) return 'Advanced';
    if (level >= 2) return 'Intermediate';
    if (level >= 1) return 'Beginner';
    return null;
  }

  /// Generate sample leaderboard for testing (ultimate fallback)
  List<LeaderboardEntry> _generateSampleLeaderboard(
      LeaderboardType type, int limit) {
    final sampleEntries = <LeaderboardEntry>[];

    // Create some sample entries to show the leaderboard structure
    final sampleUsers = [
      {'name': 'CryptoTrader', 'points': 2500},
      {'name': 'BitcoinBull', 'points': 2100},
      {'name': 'EthereumEagle', 'points': 1800},
      {'name': 'DeFiDiver', 'points': 1500},
      {'name': 'AltcoinAnalyst', 'points': 1200},
    ];

    for (int i = 0; i < sampleUsers.length && i < limit; i++) {
      final user = sampleUsers[i];
      sampleEntries.add(LeaderboardEntry(
        userId: 'sample_user_$i',
        username: user['name'] as String,
        avatarUrl: null,
        points: user['points'] as int,
        rank: i + 1,
        badges: i == 0 ? ['top_trader', 'streak_week'] : [],
        title: _getLevelTitle((user['points'] as int) ~/ 250),
      ));
    }

    LoggerService.info(
        'Generated ${sampleEntries.length} sample leaderboard entries');
    return sampleEntries;
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
