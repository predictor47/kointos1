import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:kointos/core/theme/modern_theme.dart';
import 'package:kointos/core/services/service_locator.dart';
import 'package:kointos/core/services/auth_service.dart';
import 'package:kointos/core/services/api_service.dart';
import 'package:kointos/core/services/gamification_service.dart';
import 'package:kointos/core/services/user_profile_initialization_service.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _authService = getService<AuthService>();
  final _apiService = getService<ApiService>();
  final _gamificationService = getService<GamificationService>();
  final _profileInitService = getService<UserProfileInitializationService>();

  UserProfile? _userProfile;
  UserGameStats? _gameStats;
  List<Map<String, dynamic>> _userArticles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load user profile using the initialization service
      final currentUser = await _authService.getCurrentUserId();
      if (currentUser != null) {
        try {
          // Use the profile initialization service to get or create profile
          final userProfileData =
              await _profileInitService.getCurrentUserProfile();

          if (userProfileData != null) {
            // Load gamification stats
            final gameStats = await _gamificationService.getUserStats();

            // Load user articles
            final articles = await _apiService.getUserArticles(currentUser);

            setState(() {
              _userProfile = UserProfile.fromApi(userProfileData, {
                'userId': currentUser,
                'username': userProfileData['username'] ?? 'User',
                'email': userProfileData['email'] ?? '',
                'displayName': userProfileData['displayName'] ??
                    userProfileData['username'] ??
                    'User',
              });
              _gameStats = gameStats;
              _userArticles = articles;
              _isLoading = false;
            });
          } else {
            // Fallback to auth data if profile creation failed
            final amplifyUser = await Amplify.Auth.getCurrentUser();
            final userAttributes = await Amplify.Auth.fetchUserAttributes();

            String email = '';
            String displayName = '';
            for (final attr in userAttributes) {
              if (attr.userAttributeKey == AuthUserAttributeKey.email) {
                email = attr.value;
              } else if (attr.userAttributeKey == AuthUserAttributeKey.name) {
                displayName = attr.value;
              }
            }

            setState(() {
              _userProfile = UserProfile.fromApi(null, {
                'userId': currentUser,
                'username': amplifyUser.username,
                'email': email,
                'displayName':
                    displayName.isNotEmpty ? displayName : amplifyUser.username,
              });
              _gameStats = null;
              _userArticles = [];
              _isLoading = false;
            });
          }
        } catch (e) {
          print('Error loading user profile: $e');
          // Fallback to auth data
          final amplifyUser = await Amplify.Auth.getCurrentUser();
          final userAttributes = await Amplify.Auth.fetchUserAttributes();

          String email = '';
          String displayName = '';
          for (final attr in userAttributes) {
            if (attr.userAttributeKey == AuthUserAttributeKey.email) {
              email = attr.value;
            } else if (attr.userAttributeKey == AuthUserAttributeKey.name) {
              displayName = attr.value;
            }
          }

          setState(() {
            _userProfile = UserProfile.fromApi(null, {
              'userId': currentUser,
              'username': amplifyUser.username,
              'email': email,
              'displayName':
                  displayName.isNotEmpty ? displayName : amplifyUser.username,
            });
            _gameStats = null;
            _userArticles = [];
            _isLoading = false;
          });
        }
      } else {
        // User not authenticated, show guest state
        setState(() {
          _userProfile = UserProfile.guest();
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Critical error loading user data: $e');
      // Critical error - show error state
      setState(() {
        _userProfile = null;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.primaryBlack,
        body: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.cryptoGold),
          ),
        ),
      );
    }

    if (_userProfile == null) {
      return Scaffold(
        backgroundColor: AppTheme.primaryBlack,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: AppTheme.greyText,
              ),
              const SizedBox(height: 16),
              const Text(
                'Failed to load profile',
                style: TextStyle(
                  color: AppTheme.greyText,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadUserData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 300,
              floating: false,
              pinned: true,
              backgroundColor: AppTheme.primaryBlack,
              elevation: 0,
              title: Text(
                'Profile',
                style: AppTheme.h2.copyWith(color: AppTheme.pureWhite),
              ),
              actions: [
                IconButton(
                  onPressed: _loadUserData,
                  icon: const Icon(
                    Icons.refresh,
                    color: AppTheme.cryptoGold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.settings_rounded,
                    color: AppTheme.pureWhite,
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: _buildProfileHeader(),
              ),
            ),
          ];
        },
        body: Column(
          children: [
            _buildStatsRow(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildActivityTab(),
                  _buildArticlesTab(),
                  _buildAchievementsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppTheme.cryptoGradient,
              border: Border.all(
                color: AppTheme.pureWhite,
                width: 3,
              ),
            ),
            child: Center(
              child: Text(
                _userProfile!.avatar,
                style: AppTheme.h1.copyWith(
                  color: AppTheme.pureWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ).animate().scale(delay: 200.ms),

          const SizedBox(height: 16),

          // Name and Username
          Text(
            _userProfile!.fullName,
            style: AppTheme.h2.copyWith(
              color: AppTheme.pureWhite,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn(delay: 300.ms),

          Text(
            '@${_userProfile!.username}',
            style: AppTheme.body1.copyWith(
              color: AppTheme.greyText,
            ),
          ).animate().fadeIn(delay: 400.ms),

          const SizedBox(height: 12),

          // Bio
          Text(
            _userProfile!.bio,
            textAlign: TextAlign.center,
            style: AppTheme.body2.copyWith(
              color: AppTheme.accentWhite,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ).animate().fadeIn(delay: 500.ms),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBlack,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.pureWhite.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
              'Points',
              (_gameStats?.totalPoints ?? _userProfile!.totalPoints).toString(),
              Icons.star_rounded),
          _buildStatItem(
              'Level',
              _gameStats?.level.toString() ?? '#${_userProfile!.rank}',
              Icons.leaderboard_rounded),
          _buildStatItem('Articles', _userProfile!.articlesPublished.toString(),
              Icons.article_rounded),
          _buildStatItem('Followers', _userProfile!.followers.toString(),
              Icons.group_rounded),
        ],
      ),
    ).animate().slideY(begin: 0.3, delay: 600.ms);
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppTheme.cryptoGold,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTheme.h3.copyWith(
            color: AppTheme.pureWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTheme.caption.copyWith(
            color: AppTheme.greyText,
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.secondaryBlack,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: AppTheme.pureWhite,
        unselectedLabelColor: AppTheme.greyText,
        indicator: BoxDecoration(
          color: AppTheme.pureWhite.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        tabs: const [
          Tab(text: 'Activity'),
          Tab(text: 'Articles'),
          Tab(text: 'Achievements'),
        ],
      ),
    ).animate().slideY(begin: 0.3, delay: 700.ms);
  }

  Widget _buildActivityTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildActivityItem(
          'Published new article',
          'Bitcoin Market Analysis for Q2 2025',
          '2 hours ago',
          Icons.article_rounded,
          AppTheme.successGreen,
        ),
        _buildActivityItem(
          'Earned achievement',
          'Content Creator Badge',
          '1 day ago',
          Icons.star_rounded,
          AppTheme.cryptoGold,
        ),
        _buildActivityItem(
          'Shared post',
          'DeFi trends and predictions',
          '2 days ago',
          Icons.share_rounded,
          AppTheme.pureWhite,
        ),
        _buildActivityItem(
          'Gained followers',
          '5 new followers',
          '3 days ago',
          Icons.group_add_rounded,
          AppTheme.successGreen,
        ),
      ],
    );
  }

  Widget _buildActivityItem(
      String action, String detail, String time, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBlack,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.pureWhite.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action,
                  style: AppTheme.body1.copyWith(
                    color: AppTheme.pureWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  detail,
                  style: AppTheme.body2.copyWith(
                    color: AppTheme.greyText,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: AppTheme.caption.copyWith(
              color: AppTheme.greyText,
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideX(begin: 0.3);
  }

  Widget _buildArticlesTab() {
    if (_userArticles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.article_outlined,
              size: 64,
              color: AppTheme.greyText,
            ),
            const SizedBox(height: 16),
            const Text(
              'No Articles Yet',
              style: TextStyle(
                color: AppTheme.greyText,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Start writing to share your insights\nwith the community!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.greyText,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: _userArticles.map((article) {
        return _buildArticleItem(
          article['title'] ?? 'Untitled',
          article['summary'] ?? 'No summary available',
          _formatTimeAgo(article['createdAt']),
          article['likesCount'] ?? 0,
          article['commentsCount'] ?? 0,
        );
      }).toList(),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${(difference.inDays / 7).floor()} weeks ago';
    }
  }

  Widget _buildArticleItem(
      String title, String excerpt, String time, int likes, int comments) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBlack,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.pureWhite.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.body1.copyWith(
              color: AppTheme.pureWhite,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            excerpt,
            style: AppTheme.body2.copyWith(
              color: AppTheme.greyText,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.favorite_rounded,
                    color: AppTheme.errorRed,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    likes.toString(),
                    style: AppTheme.caption.copyWith(
                      color: AppTheme.greyText,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.comment_rounded,
                    color: AppTheme.greyText,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    comments.toString(),
                    style: AppTheme.caption.copyWith(
                      color: AppTheme.greyText,
                    ),
                  ),
                ],
              ),
              Text(
                time,
                style: AppTheme.caption.copyWith(
                  color: AppTheme.greyText,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.3);
  }

  Widget _buildAchievementsTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _userProfile!.badges.length + 3, // Add some locked badges
      itemBuilder: (context, index) {
        if (index < _userProfile!.badges.length) {
          final badge = _userProfile!.badges[index];
          return _buildBadgeItem(badge.name, badge.icon, true, index);
        } else {
          // Locked badges
          final lockedBadges = [
            ('Influencer', Icons.trending_up_rounded),
            ('Expert Writer', Icons.edit_note_rounded),
            ('Top Contributor', Icons.workspace_premium_rounded),
          ];
          final lockedBadge = lockedBadges[index - _userProfile!.badges.length];
          return _buildBadgeItem(lockedBadge.$1, lockedBadge.$2, false, index);
        }
      },
    );
  }

  Widget _buildBadgeItem(
      String name, IconData icon, bool isUnlocked, int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnlocked ? AppTheme.cardBlack : AppTheme.secondaryBlack,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnlocked
              ? AppTheme.cryptoGold.withValues(alpha: 0.3)
              : AppTheme.pureWhite.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isUnlocked ? AppTheme.cryptoGold : AppTheme.greyText,
            size: 40,
          ),
          const SizedBox(height: 12),
          Text(
            name,
            textAlign: TextAlign.center,
            style: AppTheme.body2.copyWith(
              color: isUnlocked ? AppTheme.pureWhite : AppTheme.greyText,
              fontWeight: isUnlocked ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    ).animate().scale(delay: Duration(milliseconds: index * 100));
  }
}

class UserProfile {
  final String id;
  final String username;
  final String email;
  final String fullName;
  final String bio;
  final String avatar;
  final DateTime joinedDate;
  final int totalPoints;
  final int rank;
  final int articlesPublished;
  final int postsShared;
  final int followers;
  final int following;
  final List<Badge> badges;

  UserProfile({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    required this.bio,
    required this.avatar,
    required this.joinedDate,
    required this.totalPoints,
    required this.rank,
    required this.articlesPublished,
    required this.postsShared,
    required this.followers,
    required this.following,
    required this.badges,
  });

  factory UserProfile.fromApi(
      Map<String, dynamic>? apiData, Map<String, dynamic> currentUser) {
    // Always use real user data instead of demo data
    return UserProfile(
      id: currentUser['userId'] ?? 'unknown',
      username: apiData?['username'] ?? currentUser['username'] ?? 'User',
      email: currentUser['email'] ?? 'user@example.com',
      fullName: apiData?['fullName'] ??
          currentUser['displayName'] ??
          currentUser['username'] ??
          'Kointos User',
      bio: apiData?['bio'] ??
          'Welcome to Kointos! Exploring the world of cryptocurrency.',
      avatar: (apiData?['fullName']?[0] ??
              currentUser['displayName']?[0] ??
              currentUser['username']?[0] ??
              'K')
          .toUpperCase(),
      joinedDate: apiData?['createdAt'] != null
          ? DateTime.parse(apiData!['createdAt'])
          : DateTime.now().subtract(const Duration(days: 30)),
      totalPoints: apiData?['totalPoints'] ?? 500,
      rank: apiData?['rank'] ?? 100,
      articlesPublished: apiData?['articlesCount'] ?? 0,
      postsShared: apiData?['postsCount'] ?? 0,
      followers: apiData?['followersCount'] ?? 0,
      following: apiData?['followingCount'] ?? 0,
      badges: _getBadgesFromApi(apiData?['badges']),
    );
  }

  factory UserProfile.demo() {
    return UserProfile(
      id: 'demo_user',
      username: 'CryptoEnthusiast',
      email: 'demo@kointos.com',
      fullName: 'Demo User',
      bio:
          'Passionate about cryptocurrency and blockchain technology. Always learning and sharing insights with the community.',
      avatar: 'DU',
      joinedDate: DateTime.now().subtract(const Duration(days: 120)),
      totalPoints: 1850,
      rank: 15,
      articlesPublished: 8,
      postsShared: 24,
      followers: 156,
      following: 89,
      badges: [
        Badge(name: 'Early Adopter', icon: Icons.star),
        Badge(name: 'Content Creator', icon: Icons.edit),
        Badge(name: 'Community Builder', icon: Icons.group),
      ],
    );
  }

  factory UserProfile.guest() {
    return UserProfile(
      id: 'guest',
      username: 'Guest',
      email: 'guest@kointos.com',
      fullName: 'Guest User',
      bio: 'Welcome to Kointos! Sign up to start tracking your crypto journey.',
      avatar: 'G',
      joinedDate: DateTime.now(),
      totalPoints: 0,
      rank: 0,
      articlesPublished: 0,
      postsShared: 0,
      followers: 0,
      following: 0,
      badges: [],
    );
  }

  static List<Badge> _getBadgesFromApi(List<dynamic>? badgesData) {
    if (badgesData == null) return [];

    return badgesData.map((badge) {
      return Badge(
        name: badge['name'] ?? 'Badge',
        icon: _getIconFromString(badge['iconName']),
      );
    }).toList();
  }

  static IconData _getIconFromString(String? iconName) {
    switch (iconName) {
      case 'star':
        return Icons.star;
      case 'edit':
        return Icons.edit;
      case 'group':
        return Icons.group;
      case 'trending_up':
        return Icons.trending_up;
      case 'school':
        return Icons.school;
      default:
        return Icons.star;
    }
  }
}

class Badge {
  final String name;
  final IconData icon;

  Badge({
    required this.name,
    required this.icon,
  });
}
