import 'package:flutter/material.dart';
import 'package:kointos/core/theme/app_theme.dart';
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
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Feed'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Create post feature coming soon!'),
                  duration: Duration(seconds: 1),
                ),
              );
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Post detail feature coming soon!'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    onLike: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Like feature coming soon!'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    onComment: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Comments feature coming soon!'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    onShare: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Share feature coming soon!'),
                          duration: Duration(seconds: 1),
                        ),
                      );
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
}
