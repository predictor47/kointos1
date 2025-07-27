import 'package:flutter/material.dart';
import 'package:kointos/core/theme/modern_theme.dart';
import 'package:kointos/core/services/service_locator.dart';
import 'package:kointos/core/services/gamification_service.dart';
import 'package:kointos/presentation/widgets/platform_widgets.dart';

class RealLeaderboardScreen extends StatefulWidget {
  const RealLeaderboardScreen({super.key});

  @override
  State<RealLeaderboardScreen> createState() => _RealLeaderboardScreenState();
}

class _RealLeaderboardScreenState extends State<RealLeaderboardScreen>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final _gamificationService = getService<GamificationService>();

  bool _isLoading = true;
  List<LeaderboardEntry> _leaderboard = [];
  UserGameStats? _currentUserStats;
  LeaderboardType _selectedType = LeaderboardType.allTime;
  late TabController _tabController;

  final List<String> _periods = [
    'All Time',
    'This Week',
    'This Month',
    'Today'
  ];
  final List<String> _categories = ['Points', 'Level', 'Streak'];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _loadLeaderboardData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadLeaderboardData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load current user stats
      final userStats = await _gamificationService.getUserStats();

      // Load leaderboard data
      final leaderboard = await _gamificationService.getLeaderboard(
        type: _selectedType,
        limit: 50,
      );

      setState(() {
        _currentUserStats = userStats;
        _leaderboard = leaderboard;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading leaderboard: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: PlatformAppBar(
        title: 'Leaderboard',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadLeaderboardData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildLeaderboardContent(),
    );
  }

  Widget _buildLeaderboardContent() {
    return RefreshIndicator(
      onRefresh: _loadLeaderboardData,
      child: Column(
        children: [
          // Current User Stats Card
          if (_currentUserStats != null) _buildUserStatsCard(),

          // Period Filter
          _buildPeriodFilter(),

          // Category Tabs
          _buildCategoryTabs(),

          // Leaderboard List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLeaderboardList('points'),
                _buildLeaderboardList('level'),
                _buildLeaderboardList('streak'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserStatsCard() {
    final stats = _currentUserStats!;

    return PlatformCard(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: AppTheme.cryptoGradient,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    '${stats.level}',
                    style: const TextStyle(
                      color: AppTheme.primaryBlack,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Ranking',
                      style: TextStyle(
                        color: AppTheme.greyText,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '#${stats.rank} Global',
                      style: const TextStyle(
                        color: AppTheme.pureWhite,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${stats.totalPoints} XP',
                    style: const TextStyle(
                      color: AppTheme.cryptoGold,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Level ${stats.level}',
                    style: const TextStyle(
                      color: AppTheme.greyText,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Stats Row
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Streak',
                  '${stats.streak} days',
                  Icons.local_fire_department,
                  Colors.orange,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Badges',
                  '${stats.badges.length}',
                  Icons.stars,
                  AppTheme.cryptoGold,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Weekly',
                  '${stats.weeklyPoints} XP',
                  Icons.trending_up,
                  Colors.green,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Today',
                  '${stats.actionsToday}',
                  Icons.today,
                  Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.greyText,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodFilter() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _periods.length,
        itemBuilder: (context, index) {
          final period = _periods[index];
          LeaderboardType type;
          switch (period) {
            case 'Today':
              type = LeaderboardType.daily;
              break;
            case 'This Week':
              type = LeaderboardType.weekly;
              break;
            case 'This Month':
              type = LeaderboardType.monthly;
              break;
            default:
              type = LeaderboardType.allTime;
          }

          final isSelected = _selectedType == type;

          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: PlatformButton(
              isPrimary: isSelected,
              onPressed: () {
                setState(() {
                  _selectedType = type;
                });
                _loadLeaderboardData();
              },
              child: Text(period),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.cardBlack,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppTheme.cryptoGold,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: AppTheme.primaryBlack,
        unselectedLabelColor: AppTheme.greyText,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        tabs: _categories.map((category) => Tab(text: category)).toList(),
      ),
    );
  }

  Widget _buildLeaderboardList(String sortBy) {
    // For LeaderboardEntry, we'll show them in order since they come pre-sorted
    final sortedLeaderboard = List<LeaderboardEntry>.from(_leaderboard);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedLeaderboard.length,
      itemBuilder: (context, index) {
        final entry = sortedLeaderboard[index];
        final isCurrentUser = _currentUserStats?.userId == entry.userId;

        return _buildLeaderboardItem(entry, isCurrentUser);
      },
    );
  }

  Widget _buildLeaderboardItem(LeaderboardEntry entry, bool isCurrentUser) {
    final position = entry.rank;

    Color rankColor;
    IconData? rankIcon;

    // Special styling for top 3
    switch (position) {
      case 1:
        rankColor = const Color(0xFFFFD700); // Gold
        rankIcon = Icons.emoji_events;
        break;
      case 2:
        rankColor = const Color(0xFFC0C0C0); // Silver
        rankIcon = Icons.emoji_events;
        break;
      case 3:
        rankColor = const Color(0xFFCD7F32); // Bronze
        rankIcon = Icons.emoji_events;
        break;
      default:
        rankColor = AppTheme.greyText;
        break;
    }

    final displayValue = '${entry.points} XP';

    return PlatformCard(
      margin: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          border: isCurrentUser
              ? Border.all(color: AppTheme.cryptoGold, width: 2)
              : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Rank
              SizedBox(
                width: 40,
                child: Column(
                  children: [
                    if (rankIcon != null)
                      Icon(rankIcon, color: rankColor, size: 24)
                    else
                      Text(
                        '#$position',
                        style: TextStyle(
                          color: rankColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // User Avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: isCurrentUser
                      ? AppTheme.cryptoGradient
                      : LinearGradient(
                          colors: [
                            Colors.blue.shade400,
                            Colors.purple.shade400,
                          ],
                        ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: entry.avatarUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.network(
                          entry.avatarUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Text(
                              entry.username.substring(0, 1).toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          entry.username.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
              ),

              const SizedBox(width: 16),

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          isCurrentUser ? 'You' : entry.username,
                          style: TextStyle(
                            color: isCurrentUser
                                ? AppTheme.cryptoGold
                                : AppTheme.pureWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (isCurrentUser) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.cryptoGold.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'YOU',
                              style: TextStyle(
                                color: AppTheme.cryptoGold,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (entry.title != null) ...[
                          Text(
                            entry.title!,
                            style: const TextStyle(
                              color: AppTheme.greyText,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                        if (entry.badges.isNotEmpty) ...[
                          const Icon(Icons.stars,
                              color: AppTheme.cryptoGold, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${entry.badges.length} badges',
                            style: const TextStyle(
                              color: AppTheme.greyText,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Display Value
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    displayValue,
                    style: TextStyle(
                      color: isCurrentUser
                          ? AppTheme.cryptoGold
                          : AppTheme.pureWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (entry.badges.isNotEmpty)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.stars,
                          color: AppTheme.cryptoGold,
                          size: 14,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${entry.badges.length}',
                          style: const TextStyle(
                            color: AppTheme.cryptoGold,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
