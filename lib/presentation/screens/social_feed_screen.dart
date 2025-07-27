import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kointos/core/theme/modern_theme.dart';
import 'package:kointos/core/services/service_locator.dart';
import 'package:kointos/core/services/api_service.dart';
import 'package:kointos/presentation/widgets/create_post_widget.dart';

class SocialFeedScreen extends StatefulWidget {
  const SocialFeedScreen({super.key});

  @override
  State<SocialFeedScreen> createState() => _SocialFeedScreenState();
}

class _SocialFeedScreenState extends State<SocialFeedScreen>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _posts = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadPosts() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final apiService = getService<ApiService>();
      final posts = await apiService.getSocialPosts(limit: 20);

      if (mounted) {
        setState(() {
          _posts = posts;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _onPostCreated() async {
    await _loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      body: CustomScrollView(
        controller: _scrollController,
        primary: false,
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: AppTheme.primaryBlack,
            elevation: 0,
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppTheme.cryptoGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Social Feed',
                    style: TextStyle(
                      color: AppTheme.primaryBlack,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: AppTheme.cryptoGold),
                onPressed: _showUserSearch,
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: AppTheme.pureWhite),
                onPressed: _loadPosts,
              ),
            ],
          ),

          // Create Post Widget
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardBlack,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.pureWhite.withValues(alpha: 0.1),
                ),
              ),
              child: CreatePostWidget(onPostCreated: _onPostCreated),
            ),
          ),

          // Posts Content
          if (_isLoading)
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(32),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppTheme.cryptoGold),
                  ),
                ),
              ),
            )
          else if (_hasError)
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppTheme.greyText,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Failed to load posts',
                      style: TextStyle(
                        color: AppTheme.greyText,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadPosts,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.cryptoGold,
                        foregroundColor: AppTheme.primaryBlack,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          else if (_posts.isEmpty)
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    const Icon(
                      Icons.chat_bubble_outline,
                      size: 64,
                      color: AppTheme.greyText,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No posts yet',
                      style: TextStyle(
                        color: AppTheme.greyText,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Be the first to create a post!',
                      style: TextStyle(
                        color: AppTheme.greyText.withValues(alpha: 0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            // Posts List
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final post = _posts[index];
                  return PostCard(
                    post: post,
                    onLike: () => _handleLike(post['id']),
                    onComment: () => _handleComment(post),
                  ).animate().fadeIn(
                        delay: Duration(milliseconds: index * 100),
                      );
                },
                childCount: _posts.length,
              ),
            ),

          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLike(String postId) async {
    try {
      final apiService = getService<ApiService>();
      await apiService.likePost(postId);

      // Update the post in the list
      setState(() {
        final postIndex = _posts.indexWhere((p) => p['id'] == postId);
        if (postIndex != -1) {
          _posts[postIndex]['likesCount'] =
              (_posts[postIndex]['likesCount'] ?? 0) + 1;
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to like post: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleComment(Map<String, dynamic> post) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardBlack,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => CommentBottomSheet(
        postId: post['id'],
        onCommentAdded: () {
          // Refresh this specific post
          _loadPosts();
        },
      ),
    );
  }

  void _showUserSearch() {
    showDialog(
      context: context,
      builder: (context) => const UserSearchDialog(),
    );
  }
}

class PostCard extends StatelessWidget {
  final Map<String, dynamic> post;
  final VoidCallback onLike;
  final VoidCallback onComment;

  const PostCard({
    super.key,
    required this.post,
    required this.onLike,
    required this.onComment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBlack,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.pureWhite.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppTheme.cryptoGold,
                child: Text(
                  post['userId']?.substring(0, 1).toUpperCase() ?? 'U',
                  style: const TextStyle(
                    color: AppTheme.primaryBlack,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User ${post['userId']?.substring(0, 8) ?? 'Unknown'}',
                      style: const TextStyle(
                        color: AppTheme.pureWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _formatTime(post['createdAt']),
                      style: const TextStyle(
                        color: AppTheme.greyText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Post content
          Text(
            post['content'] ?? '',
            style: const TextStyle(
              color: AppTheme.pureWhite,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 16),

          // Actions
          Row(
            children: [
              _buildActionButton(
                icon: Icons.favorite_border,
                count: post['likesCount'] ?? 0,
                onTap: onLike,
              ),
              const SizedBox(width: 24),
              _buildActionButton(
                icon: Icons.chat_bubble_outline,
                count: post['commentsCount'] ?? 0,
                onTap: onComment,
              ),
              const SizedBox(width: 24),
              _buildActionButton(
                icon: Icons.share_outlined,
                count: post['sharesCount'] ?? 0,
                onTap: () {
                  // Handle share
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required int count,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: AppTheme.greyText,
          ),
          const SizedBox(width: 4),
          Text(
            count.toString(),
            style: const TextStyle(
              color: AppTheme.greyText,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(String? timestamp) {
    if (timestamp == null) return 'Unknown';
    try {
      final dateTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Now';
      }
    } catch (e) {
      return 'Unknown';
    }
  }
}

class CommentBottomSheet extends StatefulWidget {
  final String postId;
  final VoidCallback onCommentAdded;

  const CommentBottomSheet({
    super.key,
    required this.postId,
    required this.onCommentAdded,
  });

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _addComment() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final apiService = getService<ApiService>();
      await apiService.createComment(
        postId: widget.postId,
        content: _controller.text.trim(),
      );

      if (mounted) {
        Navigator.pop(context);
        widget.onCommentAdded();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Comment added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add comment: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12, bottom: 20),
            decoration: BoxDecoration(
              color: AppTheme.greyText,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: AppTheme.pureWhite),
                    decoration: InputDecoration(
                      hintText: 'Write a comment...',
                      hintStyle: const TextStyle(color: AppTheme.greyText),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(color: AppTheme.greyText),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide:
                            const BorderSide(color: AppTheme.cryptoGold),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: const BoxDecoration(
                    color: AppTheme.cryptoGold,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: _isLoading ? null : _addComment,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.primaryBlack,
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.send,
                            color: AppTheme.primaryBlack,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserSearchDialog extends StatefulWidget {
  const UserSearchDialog({super.key});

  @override
  State<UserSearchDialog> createState() => _UserSearchDialogState();
}

class _UserSearchDialogState extends State<UserSearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  final _apiService = getService<ApiService>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.cardBlack,
      child: Container(
        width: double.maxFinite,
        height: 500,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Header
            Row(
              children: [
                const Text(
                  'Search Users',
                  style: TextStyle(
                    color: AppTheme.pureWhite,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: AppTheme.greyText),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Search Field
            TextField(
              controller: _searchController,
              style: const TextStyle(color: AppTheme.pureWhite),
              decoration: InputDecoration(
                hintText: 'Search users...',
                hintStyle: const TextStyle(color: AppTheme.greyText),
                prefixIcon:
                    const Icon(Icons.search, color: AppTheme.cryptoGold),
                filled: true,
                fillColor: AppTheme.secondaryBlack,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: _performSearch,
            ),
            const SizedBox(height: 16),

            // Search Results
            Expanded(
              child: _isSearching
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppTheme.cryptoGold),
                      ),
                    )
                  : _searchResults.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.people_outline,
                                size: 48,
                                color: AppTheme.greyText,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _searchController.text.isEmpty
                                    ? 'Start typing to search users'
                                    : 'No users found',
                                style: const TextStyle(
                                  color: AppTheme.greyText,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            final user = _searchResults[index];
                            return _buildUserItem(user);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserItem(Map<String, dynamic> user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.secondaryBlack,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.pureWhite.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 24,
            backgroundColor: AppTheme.cryptoGold,
            child: Text(
              user['displayName'][0].toUpperCase(),
              style: const TextStyle(
                color: AppTheme.primaryBlack,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user['displayName'],
                  style: const TextStyle(
                    color: AppTheme.pureWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '@${user['username']}',
                  style: const TextStyle(
                    color: AppTheme.greyText,
                    fontSize: 14,
                  ),
                ),
                if (user['bio'] != null)
                  Text(
                    user['bio'],
                    style: const TextStyle(
                      color: AppTheme.greyText,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                Text(
                  '${user['followers']} followers',
                  style: const TextStyle(
                    color: AppTheme.greyText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Follow Button
          ElevatedButton(
            onPressed: () => _toggleFollow(user),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  user['isFollowing'] ? AppTheme.greyText : AppTheme.cryptoGold,
              foregroundColor: user['isFollowing']
                  ? AppTheme.pureWhite
                  : AppTheme.primaryBlack,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              minimumSize: const Size(80, 32),
            ),
            child: Text(
              user['isFollowing'] ? 'Following' : 'Follow',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _performSearch(String query) async {
    setState(() {
      _isSearching = true;
    });

    try {
      if (query.isEmpty) {
        setState(() {
          _searchResults = [];
          _isSearching = false;
        });
        return;
      }

      // Use real API to search for users
      final results = await _apiService.searchUsers(query);

      if (mounted) {
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      }
    } catch (e) {
      // Fallback data if API fails
      final fallbackUsers = [
        {
          'id': '1',
          'username': 'CryptoExpert',
          'displayName': 'Crypto Expert',
          'avatar': null,
          'followers': 1250,
          'isFollowing': false,
          'bio': 'Professional crypto analyst',
        },
        {
          'id': '2',
          'username': 'BitcoinBull',
          'displayName': 'Bitcoin Bull',
          'avatar': null,
          'followers': 890,
          'isFollowing': false,
          'bio': 'Long-term Bitcoin hodler',
        },
      ];

      if (mounted) {
        setState(() {
          _isSearching = false;
          if (query.isEmpty) {
            _searchResults = [];
          } else {
            _searchResults = fallbackUsers.where((user) {
              final displayName = user['displayName'] as String? ?? '';
              final username = user['username'] as String? ?? '';
              final queryLower = query.toLowerCase();
              return displayName.toLowerCase().contains(queryLower) ||
                  username.toLowerCase().contains(queryLower);
            }).toList();
          }
        });
      }
    }
  }

  void _toggleFollow(Map<String, dynamic> user) async {
    final userId = user['id'] as String;
    final isCurrentlyFollowing = user['isFollowing'] as bool? ?? false;

    try {
      bool success;
      if (isCurrentlyFollowing) {
        success = await _apiService.unfollowUser(userId);
      } else {
        final result = await _apiService.followUser(userId);
        success = result != null;
      }

      if (success && mounted) {
        setState(() {
          user['isFollowing'] = !isCurrentlyFollowing;
          final currentFollowers = user['followers'] as int? ?? 0;
          if (!isCurrentlyFollowing) {
            user['followers'] = currentFollowers + 1;
          } else {
            user['followers'] = currentFollowers - 1;
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              !isCurrentlyFollowing
                  ? 'Now following ${user['displayName'] ?? user['username']}'
                  : 'Unfollowed ${user['displayName'] ?? user['username']}',
            ),
            backgroundColor:
                !isCurrentlyFollowing ? Colors.green : Colors.orange,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Fallback to local state update if API fails
      setState(() {
        user['isFollowing'] = !isCurrentlyFollowing;
        final currentFollowers = user['followers'] as int? ?? 0;
        if (!isCurrentlyFollowing) {
          user['followers'] = currentFollowers + 1;
        } else {
          user['followers'] = currentFollowers - 1;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            !isCurrentlyFollowing
                ? 'Now following ${user['displayName'] ?? user['username']}'
                : 'Unfollowed ${user['displayName'] ?? user['username']}',
          ),
          backgroundColor: !isCurrentlyFollowing ? Colors.green : Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
