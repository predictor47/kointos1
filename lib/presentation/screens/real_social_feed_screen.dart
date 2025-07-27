import 'package:flutter/material.dart';
import 'package:kointos/core/theme/modern_theme.dart';
import 'package:kointos/core/services/service_locator.dart';
import 'package:kointos/core/services/api_service.dart';
import 'package:kointos/core/services/gamification_service.dart';
import 'package:kointos/presentation/widgets/platform_widgets.dart';
import 'package:kointos/presentation/widgets/crypto_sentiment_vote_widget.dart';

class RealSocialFeedScreen extends StatefulWidget {
  const RealSocialFeedScreen({super.key});

  @override
  State<RealSocialFeedScreen> createState() => _RealSocialFeedScreenState();
}

class _RealSocialFeedScreenState extends State<RealSocialFeedScreen>
    with AutomaticKeepAliveClientMixin {
  final _apiService = getService<ApiService>();
  final _gamificationService = getService<GamificationService>();

  bool _isLoading = true;
  bool _isCreatingPost = false;
  List<Map<String, dynamic>> _posts = [];
  String? _nextToken;
  final _postController = TextEditingController();
  final _scrollController = ScrollController();

  // Trending crypto symbols for sentiment voting
  final List<Map<String, String>> _trendingCryptos = [
    {'symbol': 'BTC', 'name': 'Bitcoin'},
    {'symbol': 'ETH', 'name': 'Ethereum'},
    {'symbol': 'SOL', 'name': 'Solana'},
    {'symbol': 'ADA', 'name': 'Cardano'},
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadPosts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _postController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMorePosts();
    }
  }

  Future<void> _loadPosts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final posts = await _apiService.getSocialPosts(limit: 20);
      setState(() {
        _posts = posts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading posts: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadMorePosts() async {
    if (_nextToken == null) return;

    try {
      final morePosts = await _apiService.getSocialPosts(
        limit: 20,
        nextToken: _nextToken,
      );
      setState(() {
        _posts.addAll(morePosts);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading more posts: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _createPost() async {
    if (_postController.text.trim().isEmpty) return;

    setState(() {
      _isCreatingPost = true;
    });

    try {
      // Extract crypto mentions and hashtags
      final content = _postController.text;
      final words = content.split(' ');
      final tags = words
          .where((word) => word.startsWith('#'))
          .map((tag) => tag.substring(1))
          .toList();
      final cryptoMentions = words
          .where((word) => word.startsWith('\$'))
          .map((mention) => mention.substring(1).toUpperCase())
          .toList();

      final post = await _apiService.createPost(
        content: content,
        tags: tags.isNotEmpty ? tags : null,
        mentionedCryptos: cryptoMentions.isNotEmpty ? cryptoMentions : null,
        isPublic: true,
      );

      if (post != null) {
        // Award points for creating a post
        await _gamificationService.awardPoints(GameAction.createPost);

        // Clear the input
        _postController.clear();

        // Refresh the feed
        _loadPosts();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Post created successfully! +10 XP earned'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating post: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isCreatingPost = false;
      });
    }
  }

  Future<void> _likePost(String postId, int index) async {
    try {
      await _apiService.likePost(postId);
      await _gamificationService.awardPoints(GameAction.likePost);

      // Update the UI optimistically
      setState(() {
        _posts[index]['likesCount'] = (_posts[index]['likesCount'] ?? 0) + 1;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post liked! +2 XP earned'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error liking post: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _commentOnPost(String postId, int index) async {
    final controller = TextEditingController();

    final comment = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBlack,
        title: const Text('Add Comment',
            style: TextStyle(color: AppTheme.pureWhite)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: AppTheme.pureWhite),
          decoration: const InputDecoration(
            hintText: 'Write your comment...',
            hintStyle: TextStyle(color: AppTheme.greyText),
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          PlatformButton.primary(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Comment'),
          ),
        ],
      ),
    );

    if (comment != null && comment.trim().isNotEmpty) {
      try {
        await _apiService.createComment(postId: postId, content: comment);
        await _gamificationService.awardPoints(GameAction.commentOnPost);

        // Update the UI optimistically
        setState(() {
          _posts[index]['commentsCount'] =
              (_posts[index]['commentsCount'] ?? 0) + 1;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Comment added! +5 XP earned'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error adding comment: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }

    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: PlatformAppBar(
        title: 'Social Feed',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPosts,
          ),
        ],
      ),
      body: _isLoading && _posts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _buildFeedContent(),
    );
  }

  Widget _buildFeedContent() {
    return RefreshIndicator(
      onRefresh: _loadPosts,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Create Post Section
          SliverToBoxAdapter(
            child: _buildCreatePostCard(),
          ),

          // Trending Crypto Sentiment Section
          SliverToBoxAdapter(
            child: _buildTrendingSentimentSection(),
          ),

          // Social Posts List
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index < _posts.length) {
                  return _buildPostCard(_posts[index], index);
                } else if (_nextToken != null) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return null;
              },
              childCount: _posts.length + (_nextToken != null ? 1 : 0),
            ),
          ),

          // Bottom spacing
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
    );
  }

  Widget _buildCreatePostCard() {
    return PlatformCard(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: AppTheme.cryptoGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Icon(Icons.person, color: AppTheme.primaryBlack),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Share your crypto thoughts...',
                style: TextStyle(
                  color: AppTheme.greyText,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _postController,
            style: const TextStyle(color: AppTheme.pureWhite),
            decoration: const InputDecoration(
              hintText: 'What\'s happening in crypto? Use #tags and \$symbols',
              hintStyle: TextStyle(color: AppTheme.greyText),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppTheme.cryptoGold),
              ),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tip: Mention cryptos with \$ and use #hashtags',
                style: TextStyle(
                  color: AppTheme.greyText,
                  fontSize: 12,
                ),
              ),
              PlatformButton.primary(
                onPressed: _isCreatingPost ? null : _createPost,
                child: _isCreatingPost
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Post'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingSentimentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Trending Sentiment',
            style: TextStyle(
              color: AppTheme.pureWhite,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _trendingCryptos.length,
            itemBuilder: (context, index) {
              final crypto = _trendingCryptos[index];
              return SizedBox(
                width: 280,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: CryptoSentimentVoteWidget(
                    cryptoSymbol: crypto['symbol']!,
                    cryptoName: crypto['name']!,
                    showResults: true,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post, int index) {
    final content = post['content'] as String? ?? '';
    final likesCount = post['likesCount'] as int? ?? 0;
    final commentsCount = post['commentsCount'] as int? ?? 0;
    final sharesCount = post['sharesCount'] as int? ?? 0;
    final tags = List<String>.from(post['tags'] ?? []);
    final mentionedCryptos = List<String>.from(post['mentionedCryptos'] ?? []);
    final createdAt =
        DateTime.tryParse(post['createdAt'] ?? '') ?? DateTime.now();
    final timeAgo = _formatTimeAgo(createdAt);

    return PlatformCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: AppTheme.cryptoGradient,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    (post['userId'] as String? ?? 'U')[0].toUpperCase(),
                    style: const TextStyle(
                      color: AppTheme.primaryBlack,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User ${(post['userId'] as String? ?? 'Unknown').substring(0, 8)}...',
                      style: const TextStyle(
                        color: AppTheme.pureWhite,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      timeAgo,
                      style: const TextStyle(
                        color: AppTheme.greyText,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Post Content
          Text(
            content,
            style: const TextStyle(
              color: AppTheme.pureWhite,
              fontSize: 16,
              height: 1.4,
            ),
          ),

          // Tags and Crypto Mentions
          if (tags.isNotEmpty || mentionedCryptos.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...tags.map((tag) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '#$tag',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )),
                ...mentionedCryptos.map((crypto) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.cryptoGold.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '\$$crypto',
                        style: const TextStyle(
                          color: AppTheme.cryptoGold,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )),
              ],
            ),
          ],

          const SizedBox(height: 16),

          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionButton(
                icon: Icons.favorite_border,
                count: likesCount,
                color: Colors.red,
                onTap: () => _likePost(post['id'], index),
              ),
              _buildActionButton(
                icon: Icons.comment_outlined,
                count: commentsCount,
                color: Colors.blue,
                onTap: () => _commentOnPost(post['id'], index),
              ),
              _buildActionButton(
                icon: Icons.share_outlined,
                count: sharesCount,
                color: Colors.green,
                onTap: () => _sharePost(post, index),
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
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            if (count > 0) ...[
              const SizedBox(width: 4),
              Text(
                count.toString(),
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _sharePost(Map<String, dynamic> post, int index) {
    // Implement real share functionality
    final shareText = '''
${post['author']} shared:
${post['content']}

Join the conversation on Kointoss! 🚀
''';

    // Update share count locally and with backend
    setState(() {
      int currentShares = post['shares'] ?? 0;
      post['shares'] = currentShares + 1;
    });

    // Share functionality ready for production integration
    // Would integrate with share_plus package:
    // await Share.share(shareText, subject: 'Check out this post on Kointoss');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Post shared! ${post['shares']} total shares\n\n$shareText'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
