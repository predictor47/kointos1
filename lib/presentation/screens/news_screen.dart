import 'package:flutter/material.dart';
import 'package:kointos/core/services/crypto_news_service.dart';
import 'package:kointos/core/services/service_locator.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late final CryptoNewsService _newsService;

  List<Map<String, dynamic>> _news = [];
  List<Map<String, dynamic>> _filteredNews = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _newsService = getService<CryptoNewsService>();
    _loadNews();
  }

  Future<void> _loadNews() async {
    try {
      final news = await _newsService.getLatestNews(limit: 50);
      setState(() {
        _news = news;
        _filteredNews = news;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _filterNews() {
    List<Map<String, dynamic>> filtered = _news;

    // Filter by category
    if (_selectedCategory != 'All') {
      filtered = filtered.where((article) {
        final tags = (article['tags'] as List<dynamic>?)?.cast<String>() ?? [];
        final mentionedCryptos =
            (article['mentionedCryptos'] as List<dynamic>?)?.cast<String>() ??
                [];

        switch (_selectedCategory) {
          case 'Bitcoin':
            return tags.any((tag) =>
                    tag.toLowerCase().contains('bitcoin') ||
                    tag.toLowerCase().contains('btc')) ||
                mentionedCryptos
                    .any((crypto) => crypto.toLowerCase().contains('btc'));
          case 'Ethereum':
            return tags.any((tag) =>
                    tag.toLowerCase().contains('ethereum') ||
                    tag.toLowerCase().contains('eth')) ||
                mentionedCryptos
                    .any((crypto) => crypto.toLowerCase().contains('eth'));
          case 'DeFi':
            return tags.any((tag) => tag.toLowerCase().contains('defi'));
          case 'NFT':
            return tags.any((tag) => tag.toLowerCase().contains('nft'));
          case 'Regulation':
            return tags.any((tag) =>
                tag.toLowerCase().contains('regulation') ||
                tag.toLowerCase().contains('regulatory'));
          case 'Institutional':
            return tags
                .any((tag) => tag.toLowerCase().contains('institutional'));
          case 'Technology':
            return tags.any((tag) =>
                tag.toLowerCase().contains('technology') ||
                tag.toLowerCase().contains('blockchain'));
          default:
            return true;
        }
      }).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((article) {
        final title = article['title']?.toString().toLowerCase() ?? '';
        final content = article['content']?.toString().toLowerCase() ?? '';
        final summary = article['summary']?.toString().toLowerCase() ?? '';
        return title.contains(query) ||
            content.contains(query) ||
            summary.contains(query);
      }).toList();
    }

    setState(() => _filteredNews = filtered);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Crypto News', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadNews,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                _searchQuery = value;
                _filterNews();
              },
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search news...',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Category filter
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _newsService.getNewsCategories().length,
              itemBuilder: (context, index) {
                final category = _newsService.getNewsCategories()[index];
                return _buildCategoryChip(category);
              },
            ),
          ),

          const SizedBox(height: 16),

          // News list
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.amber))
                : _filteredNews.isEmpty
                    ? const Center(
                        child: Text(
                          'No news articles found',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadNews,
                        color: Colors.amber,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _filteredNews.length,
                          itemBuilder: (context, index) {
                            final article = _filteredNews[index];
                            return _buildNewsCard(article);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(category),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = category;
            _filterNews();
          });
        },
        selectedColor: Colors.amber,
        backgroundColor: Colors.grey[800],
        labelStyle: TextStyle(
          color: isSelected ? Colors.black : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildNewsCard(Map<String, dynamic> article) {
    final sentiment = article['sentiment']?.toString() ?? 'NEUTRAL';
    final sentimentColor =
        Color(int.parse(_newsService.getSentimentColor(sentiment)));
    final sentimentIcon = _newsService.getSentimentIcon(sentiment);

    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _showArticleDetails(article),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with sentiment and timestamp
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: sentimentColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: sentimentColor.withOpacity(0.5)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(sentimentIcon,
                            style: const TextStyle(fontSize: 12)),
                        const SizedBox(width: 4),
                        Text(
                          sentiment,
                          style: TextStyle(
                            color: sentimentColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatPublishTime(article['publishedAt']),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Title
              Text(
                article['title'] ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 8),

              // Summary
              if (article['summary'] != null) ...[
                Text(
                  article['summary'],
                  style: const TextStyle(
                    color: Colors.grey[300],
                    fontSize: 14,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
              ],

              // Tags
              if (article['tags'] != null &&
                  (article['tags'] as List).isNotEmpty) ...[
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: (article['tags'] as List<dynamic>)
                      .take(4)
                      .map((tag) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '#$tag',
                              style: const TextStyle(
                                color: Colors.amber,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 12),
              ],

              // Author and source
              Row(
                children: [
                  const Icon(Icons.person, color: Colors.grey, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    article['author'] ?? 'Unknown Author',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const Spacer(),
                  if (article['sourceUrl'] != null &&
                      article['sourceUrl'].toString().isNotEmpty)
                    const Icon(Icons.open_in_new,
                        color: Colors.amber, size: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showArticleDetails(Map<String, dynamic> article) {
    showDialog(
      context: context,
      builder: (context) => ArticleDetailsDialog(
        article: article,
        newsService: _newsService,
      ),
    );
  }

  String _formatPublishTime(String? publishedAt) {
    if (publishedAt == null) return 'Unknown';

    try {
      final publishTime = DateTime.parse(publishedAt);
      final now = DateTime.now();
      final difference = now.difference(publishTime);

      if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return '${publishTime.day}/${publishTime.month}/${publishTime.year}';
      }
    } catch (e) {
      return 'Unknown';
    }
  }
}

class ArticleDetailsDialog extends StatelessWidget {
  final Map<String, dynamic> article;
  final CryptoNewsService newsService;

  const ArticleDetailsDialog({
    super.key,
    required this.article,
    required this.newsService,
  });

  @override
  Widget build(BuildContext context) {
    final sentiment = article['sentiment']?.toString() ?? 'NEUTRAL';
    final sentimentColor =
        Color(int.parse(newsService.getSentimentColor(sentiment)));
    final sentimentIcon = newsService.getSentimentIcon(sentiment);

    return Dialog(
      backgroundColor: Colors.grey[900],
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: sentimentColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: sentimentColor.withOpacity(0.5)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(sentimentIcon,
                            style: const TextStyle(fontSize: 12)),
                        const SizedBox(width: 4),
                        Text(
                          sentiment,
                          style: TextStyle(
                            color: sentimentColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      article['title'] ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Author and date
                    Row(
                      children: [
                        const Icon(Icons.person, color: Colors.grey, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          article['author'] ?? 'Unknown Author',
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.access_time,
                            color: Colors.grey, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          _formatPublishTime(article['publishedAt']),
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Content
                    Text(
                      article['content'] ?? '',
                      style: const TextStyle(
                        color: Colors.grey[300],
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Tags
                    if (article['tags'] != null &&
                        (article['tags'] as List).isNotEmpty) ...[
                      const Text(
                        'Tags:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: (article['tags'] as List<dynamic>)
                            .map((tag) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    '#$tag',
                                    style: const TextStyle(
                                      color: Colors.amber,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Mentioned cryptocurrencies
                    if (article['mentionedCryptos'] != null &&
                        (article['mentionedCryptos'] as List).isNotEmpty) ...[
                      const Text(
                        'Mentioned Cryptocurrencies:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: (article['mentionedCryptos'] as List<dynamic>)
                            .map((crypto) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    crypto.toString().toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Actions
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  if (article['sourceUrl'] != null &&
                      article['sourceUrl'].toString().isNotEmpty)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _launchUrl(article['sourceUrl']),
                        icon: const Icon(Icons.open_in_new),
                        label: const Text('Read Full Article'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPublishTime(String? publishedAt) {
    if (publishedAt == null) return 'Unknown';

    try {
      final publishTime = DateTime.parse(publishedAt);
      return '${publishTime.day}/${publishTime.month}/${publishTime.year} at ${publishTime.hour}:${publishTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Unknown';
    }
  }

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      // Handle error
    }
  }
}
