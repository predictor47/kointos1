import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kointos/core/theme/modern_theme.dart';
import 'package:kointos/core/services/service_locator.dart';
import 'package:kointos/core/services/api_service.dart';
import 'package:kointos/presentation/screens/chat_screen.dart';

class UserProfileViewScreen extends StatefulWidget {
  final String userId;
  final String? username;

  const UserProfileViewScreen({
    super.key,
    required this.userId,
    this.username,
  });

  @override
  State<UserProfileViewScreen> createState() => _UserProfileViewScreenState();
}

class _UserProfileViewScreenState extends State<UserProfileViewScreen> {
  final _apiService = getService<ApiService>();
  Map<String, dynamic>? _userProfile;
  List<Map<String, dynamic>> _userArticles = [];
  bool _isLoading = true;
  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load user profile and follow status in parallel
      final futures = await Future.wait([
        _apiService.getUserProfile(widget.userId),
        _apiService.isFollowing(widget.userId),
        _apiService.getUserArticles(widget.userId),
      ]);

      if (mounted) {
        setState(() {
          _userProfile = futures[0] as Map<String, dynamic>?;
          _isFollowing = futures[1] as bool;
          _userArticles = futures[2] as List<Map<String, dynamic>>;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _userProfile = {
            'id': widget.userId,
            'username': widget.username ?? 'User',
            'displayName': widget.username ?? 'Kointos User',
            'bio': 'Kointos community member',
            'followersCount': 0,
            'followingCount': 0,
            'articlesCount': 0,
            'totalPoints': 0,
          };
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _toggleFollow() async {
    try {
      bool success;
      if (_isFollowing) {
        success = await _apiService.unfollowUser(widget.userId);
      } else {
        final result = await _apiService.followUser(widget.userId);
        success = result != null;
      }

      if (success && mounted) {
        setState(() {
          _isFollowing = !_isFollowing;
          if (_userProfile != null) {
            final currentFollowers =
                _userProfile!['followersCount'] as int? ?? 0;
            _userProfile!['followersCount'] =
                _isFollowing ? currentFollowers + 1 : currentFollowers - 1;
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isFollowing
                  ? 'Now following ${_userProfile?['displayName'] ?? widget.username}'
                  : 'Unfollowed ${_userProfile?['displayName'] ?? widget.username}',
            ),
            backgroundColor: _isFollowing ? Colors.green : Colors.orange,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlack,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.pureWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _userProfile?['displayName'] ?? widget.username ?? 'Profile',
          style: const TextStyle(color: AppTheme.pureWhite),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.cryptoGold),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildProfileHeader(),
                  _buildStatsSection(),
                  _buildFollowButton(),
                  _buildArticlesSection(),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppTheme.cryptoGradient,
              border: Border.all(color: AppTheme.pureWhite, width: 3),
            ),
            child: Center(
              child: Text(
                (_userProfile?['displayName']?[0] ?? widget.username?[0] ?? 'U')
                    .toUpperCase(),
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
            _userProfile?['displayName'] ?? widget.username ?? 'Kointos User',
            style: AppTheme.h2.copyWith(
              color: AppTheme.pureWhite,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn(delay: 300.ms),

          if (widget.username != null)
            Text(
              '@${widget.username}',
              style: AppTheme.body1.copyWith(color: AppTheme.greyText),
            ).animate().fadeIn(delay: 400.ms),

          const SizedBox(height: 12),

          // Bio
          Text(
            _userProfile?['bio'] ?? 'Kointos community member',
            textAlign: TextAlign.center,
            style: AppTheme.body2.copyWith(color: AppTheme.accentWhite),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ).animate().fadeIn(delay: 500.ms),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBlack,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.pureWhite.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            'Points',
            (_userProfile?['totalPoints'] ?? 0).toString(),
            Icons.star_rounded,
          ),
          _buildStatItem(
            'Articles',
            (_userProfile?['articlesCount'] ?? 0).toString(),
            Icons.article_rounded,
          ),
          _buildStatItem(
            'Followers',
            (_userProfile?['followersCount'] ?? 0).toString(),
            Icons.group_rounded,
          ),
          _buildStatItem(
            'Following',
            (_userProfile?['followingCount'] ?? 0).toString(),
            Icons.person_add_rounded,
          ),
        ],
      ),
    ).animate().slideY(begin: 0.3, delay: 600.ms);
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.cryptoGold, size: 24),
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
          style: AppTheme.caption.copyWith(color: AppTheme.greyText),
        ),
      ],
    );
  }

  Widget _buildFollowButton() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _toggleFollow,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _isFollowing ? AppTheme.greyText : AppTheme.cryptoGold,
                foregroundColor: AppTheme.primaryBlack,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _isFollowing ? 'Unfollow' : 'Follow',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    userId: widget.userId,
                    username: widget.username ??
                        _userProfile?['displayName'] ??
                        'User',
                    avatarUrl: _userProfile?['profilePicture'],
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.cardBlack,
              foregroundColor: AppTheme.cryptoGold,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: AppTheme.cryptoGold),
              ),
            ),
            child: const Icon(Icons.chat_bubble_outline),
          ),
        ],
      ),
    ).animate().slideY(begin: 0.3, delay: 700.ms);
  }

  Widget _buildArticlesSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBlack,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.pureWhite.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Articles (${_userArticles.length})',
              style: AppTheme.h3.copyWith(
                color: AppTheme.pureWhite,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (_userArticles.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'No articles published yet',
                style: AppTheme.body2.copyWith(color: AppTheme.greyText),
              ),
            )
          else
            ..._userArticles
                .map((article) => _buildArticleItem(article))
                .toList(),
        ],
      ),
    ).animate().slideY(begin: 0.3, delay: 800.ms);
  }

  Widget _buildArticleItem(Map<String, dynamic> article) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlack,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.pureWhite.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            article['title'] ?? 'Untitled Article',
            style: AppTheme.body1.copyWith(
              color: AppTheme.pureWhite,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (article['summary'] != null) ...[
            const SizedBox(height: 8),
            Text(
              article['summary'],
              style: AppTheme.body2.copyWith(color: AppTheme.greyText),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.favorite_outline, size: 16, color: AppTheme.greyText),
              const SizedBox(width: 4),
              Text(
                '${article['likesCount'] ?? 0}',
                style: AppTheme.caption.copyWith(color: AppTheme.greyText),
              ),
              const SizedBox(width: 16),
              Icon(Icons.comment_outlined, size: 16, color: AppTheme.greyText),
              const SizedBox(width: 4),
              Text(
                '${article['commentsCount'] ?? 0}',
                style: AppTheme.caption.copyWith(color: AppTheme.greyText),
              ),
              const Spacer(),
              Text(
                _formatDate(article['createdAt']),
                style: AppTheme.caption.copyWith(color: AppTheme.greyText),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return '';
    try {
      final dateTime =
          date is DateTime ? date : DateTime.parse(date.toString());
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else {
        return '${difference.inMinutes}m ago';
      }
    } catch (e) {
      return '';
    }
  }
}
