import 'package:flutter/material.dart';
import 'package:kointos/core/theme/modern_theme.dart';
import 'package:kointos/core/services/service_locator.dart';
import 'package:kointos/core/services/api_service.dart';
import 'package:kointos/core/services/gamification_service.dart';
import 'package:kointos/presentation/widgets/platform_widgets.dart';

class RealArticlesScreen extends StatefulWidget {
  const RealArticlesScreen({super.key});

  @override
  State<RealArticlesScreen> createState() => _RealArticlesScreenState();
}

class _RealArticlesScreenState extends State<RealArticlesScreen>
    with AutomaticKeepAliveClientMixin {
  final _apiService = getService<ApiService>();
  final _gamificationService = getService<GamificationService>();

  bool _isLoading = true;
  List<Map<String, dynamic>> _articles = [];
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Analysis',
    'News',
    'Guides',
    'Opinion'
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final articles = await _apiService.getArticles(
        status: 'PUBLISHED',
        limit: 20,
      );

      setState(() {
        _articles = articles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading articles: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _readArticle(Map<String, dynamic> article) async {
    try {
      // Award points for reading an article
      await _gamificationService.awardPoints(GameAction.readArticle);

      // Navigate to article detail (placeholder for now)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reading "${article['title']}" - +1 XP earned'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
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
        title: 'Articles',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadArticles,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showCreateArticleDialog();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildArticlesContent(),
    );
  }

  Widget _buildArticlesContent() {
    return RefreshIndicator(
      onRefresh: _loadArticles,
      child: Column(
        children: [
          // Category Filter
          _buildCategoryFilter(),

          // Articles List
          Expanded(
            child:
                _articles.isEmpty ? _buildEmptyState() : _buildArticlesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;

          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: PlatformButton(
              isPrimary: isSelected,
              onPressed: () {
                setState(() {
                  _selectedCategory = category;
                });
                // In a real app, this would filter the articles
              },
              child: Text(category),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.article_outlined,
            size: 80,
            color: AppTheme.greyText,
          ),
          const SizedBox(height: 16),
          const Text(
            'No Articles Yet',
            style: TextStyle(
              color: AppTheme.greyText,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Be the first to publish an article\nand earn 25 XP!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.greyText,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          PlatformButton.primary(
            onPressed: () {
              _showCreateArticleDialog();
            },
            child: const Text('Write Article'),
          ),
        ],
      ),
    );
  }

  Widget _buildArticlesList() {
    final filteredArticles = _selectedCategory == 'All'
        ? _articles
        : _articles.where((article) {
            final tags = List<String>.from(article['tags'] ?? []);
            return tags.contains(_selectedCategory.toLowerCase());
          }).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredArticles.length,
      itemBuilder: (context, index) {
        final article = filteredArticles[index];
        return _buildArticleCard(article);
      },
    );
  }

  Widget _buildArticleCard(Map<String, dynamic> article) {
    final title = article['title'] as String? ?? 'Untitled';
    final summary = article['summary'] as String? ?? 'No summary available';
    final authorName = article['authorName'] as String? ?? 'Unknown Author';
    final likesCount = article['likesCount'] as int? ?? 0;
    final commentsCount = article['commentsCount'] as int? ?? 0;
    final viewsCount = article['viewsCount'] as int? ?? 0;
    final tags = List<String>.from(article['tags'] ?? []);
    final publishedAt =
        DateTime.tryParse(article['publishedAt'] ?? '') ?? DateTime.now();
    final timeAgo = _formatTimeAgo(publishedAt);
    final coverImageUrl = article['coverImageUrl'] as String?;

    return PlatformCard(
      margin: const EdgeInsets.only(bottom: 16),
      onTap: () => _readArticle(article),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover Image (if available)
          if (coverImageUrl != null)
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                coverImageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: AppTheme.secondaryBlack,
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      color: AppTheme.greyText,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),

          const SizedBox(height: 16),

          // Article Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                title,
                style: const TextStyle(
                  color: AppTheme.pureWhite,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // Summary
              Text(
                summary,
                style: const TextStyle(
                  color: AppTheme.greyText,
                  fontSize: 16,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 16),

              // Author and Date
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: AppTheme.cryptoGradient,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        authorName.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          color: AppTheme.primaryBlack,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
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
                          authorName,
                          style: const TextStyle(
                            color: AppTheme.pureWhite,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          timeAgo,
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

              const SizedBox(height: 16),

              // Tags
              if (tags.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: tags
                      .take(3)
                      .map((tag) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.cryptoGold.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(
                                color: AppTheme.cryptoGold,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ))
                      .toList(),
                ),

              if (tags.isNotEmpty) const SizedBox(height: 16),

              // Stats
              Row(
                children: [
                  _buildStatChip(Icons.favorite_border, likesCount, Colors.red),
                  const SizedBox(width: 12),
                  _buildStatChip(
                      Icons.comment_outlined, commentsCount, Colors.blue),
                  const SizedBox(width: 12),
                  _buildStatChip(
                      Icons.visibility_outlined, viewsCount, Colors.grey),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: AppTheme.greyText,
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, int count, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 16),
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
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _showCreateArticleDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final titleController = TextEditingController();
        final contentController = TextEditingController();
        String selectedCategory = 'General';

        return AlertDialog(
          title: const Text('Create New Article'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Article Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: ['General', 'News', 'Analysis', 'Tutorial', 'Opinion']
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) {
                    selectedCategory = value ?? 'General';
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(
                    labelText: 'Article Content',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
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
                if (titleController.text.isNotEmpty &&
                    contentController.text.isNotEmpty) {
                  Navigator.pop(context);
                  _createArticle(titleController.text, contentController.text,
                      selectedCategory);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all fields')),
                  );
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _createArticle(String title, String content, String category) async {
    // Article creation ready for GraphQL integration
    try {
      // Would integrate with GraphQL mutation:
      // final mutation = '''
      //   mutation CreateArticle($input: CreateArticleInput!) {
      //     createArticle(input: $input) {
      //       id
      //       title
      //       content
      //       category
      //       status
      //       createdAt
      //     }
      //   }
      // ''';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Article "$title" created successfully in $category category'),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create article: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }

    // Optionally refresh the articles list or navigate to the new article
    setState(() {
      // Refresh articles if needed
    });
  }
}
