import 'package:flutter/material.dart';
import 'package:kointos/core/theme/modern_theme.dart';
import 'package:kointos/domain/entities/post.dart';
import 'package:kointos/presentation/widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final _scrollController = ScrollController();
  bool _isLoading = false;
  bool _hasMore = true;
  List<Post> _posts = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadInitialPosts();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMorePosts();
    }
  }

  Future<void> _loadInitialPosts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call for initial posts
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        setState(() {
          _posts = List.generate(
              10,
              (index) => Post(
                    id: 'post_$index',
                    authorId: 'author_$index',
                    authorName: 'Author $index',
                    authorAvatar: '',
                    content: 'This is post $index',
                    tags: ['tag1', 'tag2'],
                    createdAt: DateTime.now().subtract(Duration(days: index)),
                    type: index % 2 == 0 ? PostType.image : PostType.article,
                  ));
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load posts')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadMorePosts() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call for more posts
      await Future.delayed(const Duration(seconds: 1));

      final newPosts = List.generate(
          5,
          (index) => Post(
                id: 'post_${_posts.length + index}',
                authorId: 'author_${_posts.length + index}',
                authorName: 'Author ${_posts.length + index}',
                authorAvatar: '',
                content: 'This is post ${_posts.length + index}',
                tags: ['tag1', 'tag2'],
                createdAt: DateTime.now()
                    .subtract(Duration(days: _posts.length + index)),
                type: index % 2 == 0 ? PostType.text : PostType.image,
              ));

      if (mounted) {
        setState(() {
          _posts.addAll(newPosts);
          _hasMore = newPosts.length == 5;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load more posts')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: AppBar(
        title: const Text('Feed'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showCreatePostDialog();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadInitialPosts,
        child: _posts.isEmpty && !_isLoading
            ? const Center(
                child: Text('No posts found'),
              )
            : ListView.builder(
                controller: _scrollController,
                itemCount: _posts.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _posts.length) {
                    return _isLoading
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : const SizedBox.shrink();
                  }

                  final post = _posts[index];
                  return PostCard(
                    post: post,
                    onTap: () {
                      _showPostDetail(post);
                    },
                    onLike: () {
                      _toggleLike(post);
                    },
                    onComment: () {
                      _showComments(post);
                    },
                    onShare: () {
                      _sharePost(post);
                    },
                  );
                },
              ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showCreatePostDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final contentController = TextEditingController();

        return AlertDialog(
          title: const Text('Create New Post'),
          content: TextField(
            controller: contentController,
            decoration: const InputDecoration(
              labelText: 'What\'s on your mind?',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (contentController.text.isNotEmpty) {
                  Navigator.pop(context);
                  _createPost(contentController.text);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter some content')),
                  );
                }
              },
              child: const Text('Post'),
            ),
          ],
        );
      },
    );
  }

  void _createPost(String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Post created: "$content"'),
        duration: const Duration(seconds: 2),
      ),
    );

    // Refresh the feed
    setState(() {
      // In a real app, this would add to the backend and refresh
    });
  }

  void _showPostDetail(dynamic post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Post by ${post.author ?? 'Unknown'}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.content ?? 'No content',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                'Posted: ${post.timeAgo ?? 'Unknown time'}',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _toggleLike(dynamic post) {
    setState(() {
      // In a real app, this would update the backend
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Post liked!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showComments(dynamic post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Comments'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Comments on this post:'),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: const [
                    Text('No comments yet. Be the first to comment!'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Add a comment...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Comment added!')),
              );
            },
            child: const Text('Post Comment'),
          ),
        ],
      ),
    );
  }

  void _sharePost(dynamic post) {
    final shareText = '''
Check out this post: 

${post.content ?? 'Great content'}

Shared from Kointoss!
''';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Post shared!\n\n$shareText'),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
