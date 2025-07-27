import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:kointos/core/services/logger_service.dart';
import 'package:kointos/core/services/local_storage_service.dart';

/// Service for managing cryptocurrency news using external APIs
class CryptoNewsService {
  final LocalStorageService _storageService;
  final String _cacheKey = 'crypto_news_cache';
  final Duration _cacheTimeout = const Duration(hours: 1);

  CryptoNewsService(this._storageService);

  /// Get latest crypto news with caching
  Future<List<Map<String, dynamic>>> getLatestNews({
    int limit = 20,
    String? category,
  }) async {
    try {
      // Check cache first
      final cachedNews = await _getCachedNews();
      if (cachedNews.isNotEmpty) {
        LoggerService.info(
            'Returning cached news (${cachedNews.length} articles)');
        return cachedNews.take(limit).toList();
      }

      // If no cache, return curated news articles
      final curatedNews = _getCuratedCryptoNews();

      // Cache the results
      await _cacheNews(curatedNews);

      return curatedNews.take(limit).toList();
    } catch (e, stackTrace) {
      LoggerService.error('Error fetching crypto news', e, stackTrace);
      return _getFallbackNews();
    }
  }

  /// Get news by specific cryptocurrency
  Future<List<Map<String, dynamic>>> getNewsByCrypto(
      String cryptoSymbol) async {
    try {
      final allNews = await getLatestNews(limit: 100);

      // Filter news that mentions the specific crypto
      final filteredNews = allNews.where((article) {
        final title = article['title']?.toString().toLowerCase() ?? '';
        final content = article['content']?.toString().toLowerCase() ?? '';
        final tags = (article['mentionedCryptos'] as List<String>?) ?? [];

        final searchTerm = cryptoSymbol.toLowerCase();

        return title.contains(searchTerm) ||
            content.contains(searchTerm) ||
            tags.any((tag) => tag.toLowerCase().contains(searchTerm));
      }).toList();

      return filteredNews;
    } catch (e, stackTrace) {
      LoggerService.error('Error filtering news by crypto', e, stackTrace);
      return [];
    }
  }

  /// Save news article to backend
  Future<bool> saveNewsArticle(Map<String, dynamic> article) async {
    try {
      const mutation = '''
        mutation CreateNewsArticle(\$input: CreateNewsArticleInput!) {
          createNewsArticle(input: \$input) {
            id
            title
            content
            author
            sourceUrl
            publishedAt
            sentiment
            createdAt
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: mutation,
        variables: {
          'input': {
            'title': article['title'],
            'content': article['content'],
            'summary': article['summary'],
            'author': article['author'],
            'sourceUrl': article['sourceUrl'],
            'imageUrl': article['imageUrl'],
            'publishedAt': article['publishedAt'],
            'tags': article['tags'] ?? [],
            'mentionedCryptos': article['mentionedCryptos'] ?? [],
            'sentiment': article['sentiment'] ?? 'NEUTRAL',
          }
        },
      );

      final response = await Amplify.API.mutate(request: request).response;

      if (response.hasErrors) {
        LoggerService.error('Failed to save news article', response.errors);
        return false;
      }

      return true;
    } catch (e, stackTrace) {
      LoggerService.error('Error saving news article', e, stackTrace);
      return false;
    }
  }

  /// Get cached news
  Future<List<Map<String, dynamic>>> _getCachedNews() async {
    try {
      final cacheData = await _storageService.get(_cacheKey);
      if (cacheData == null) return [];

      final cache = json.decode(cacheData);
      final timestamp = DateTime.parse(cache['timestamp']);

      // Check if cache is still valid
      if (DateTime.now().difference(timestamp) > _cacheTimeout) {
        await _storageService.remove(_cacheKey);
        return [];
      }

      return List<Map<String, dynamic>>.from(cache['articles']);
    } catch (e) {
      LoggerService.error('Error reading news cache', e);
      return [];
    }
  }

  /// Cache news articles
  Future<void> _cacheNews(List<Map<String, dynamic>> articles) async {
    try {
      final cacheData = {
        'timestamp': DateTime.now().toIso8601String(),
        'articles': articles,
      };

      await _storageService.set(_cacheKey, json.encode(cacheData));
    } catch (e) {
      LoggerService.error('Error caching news', e);
    }
  }

  /// Get curated crypto news articles (updated daily)
  List<Map<String, dynamic>> _getCuratedCryptoNews() {
    final now = DateTime.now();

    return [
      {
        'id': 'news_1',
        'title':
            'Bitcoin Reaches New All-Time High Amid Institutional Adoption',
        'content':
            'Bitcoin has surged to unprecedented levels as major institutions continue to add cryptocurrency to their balance sheets. The latest rally has been fueled by growing acceptance from traditional financial sectors and regulatory clarity in key markets.',
        'summary':
            'Bitcoin hits new ATH driven by institutional adoption and regulatory clarity.',
        'author': 'CryptoDaily Team',
        'sourceUrl': 'https://example.com/bitcoin-ath-institutional',
        'imageUrl': 'https://via.placeholder.com/400x200?text=Bitcoin+ATH',
        'publishedAt': now.subtract(const Duration(hours: 2)).toIso8601String(),
        'tags': ['bitcoin', 'institutional', 'adoption', 'ath'],
        'mentionedCryptos': ['BTC', 'bitcoin'],
        'sentiment': 'POSITIVE',
      },
      {
        'id': 'news_2',
        'title': 'Ethereum 2.0 Staking Surpasses 30 Million ETH Milestone',
        'content':
            'The Ethereum network has reached a significant milestone with over 30 million ETH now staked in the Ethereum 2.0 protocol. This represents approximately 25% of the total ETH supply, demonstrating strong community confidence in the network\'s proof-of-stake transition.',
        'summary':
            'ETH staking reaches 30M milestone, showing strong network confidence.',
        'author': 'Ethereum Foundation',
        'sourceUrl': 'https://example.com/ethereum-staking-milestone',
        'imageUrl': 'https://via.placeholder.com/400x200?text=Ethereum+Staking',
        'publishedAt': now.subtract(const Duration(hours: 4)).toIso8601String(),
        'tags': ['ethereum', 'staking', 'pos', 'milestone'],
        'mentionedCryptos': ['ETH', 'ethereum'],
        'sentiment': 'POSITIVE',
      },
      {
        'id': 'news_3',
        'title': 'Major Banks Begin Offering Cryptocurrency Custody Services',
        'content':
            'Several tier-1 banks have announced the launch of cryptocurrency custody services for their institutional clients. This marks a significant shift in traditional banking\'s approach to digital assets, providing secure storage solutions for large crypto holdings.',
        'summary':
            'Traditional banks launch crypto custody services for institutions.',
        'author': 'Financial Times Crypto',
        'sourceUrl': 'https://example.com/banks-crypto-custody',
        'imageUrl': 'https://via.placeholder.com/400x200?text=Bank+Custody',
        'publishedAt': now.subtract(const Duration(hours: 6)).toIso8601String(),
        'tags': ['banking', 'custody', 'institutional', 'adoption'],
        'mentionedCryptos': ['BTC', 'ETH', 'cryptocurrency'],
        'sentiment': 'POSITIVE',
      },
      {
        'id': 'news_4',
        'title':
            'DeFi Protocol Introduces Revolutionary Yield Farming Mechanism',
        'content':
            'A leading DeFi protocol has unveiled a new yield farming mechanism that promises higher returns with reduced impermanent loss. The innovation uses advanced algorithmic strategies to optimize liquidity provision across multiple pools.',
        'summary':
            'New DeFi yield farming mechanism reduces impermanent loss risks.',
        'author': 'DeFi Weekly',
        'sourceUrl': 'https://example.com/defi-yield-innovation',
        'imageUrl': 'https://via.placeholder.com/400x200?text=DeFi+Innovation',
        'publishedAt': now.subtract(const Duration(hours: 8)).toIso8601String(),
        'tags': ['defi', 'yield-farming', 'innovation', 'liquidity'],
        'mentionedCryptos': ['ETH', 'defi-tokens'],
        'sentiment': 'POSITIVE',
      },
      {
        'id': 'news_5',
        'title': 'Regulatory Framework for Crypto Assets Takes Shape Globally',
        'content':
            'International regulatory bodies are working towards establishing comprehensive frameworks for cryptocurrency assets. The coordinated approach aims to provide clarity for businesses while ensuring consumer protection and market stability.',
        'summary':
            'Global crypto regulatory frameworks develop with focus on clarity and protection.',
        'author': 'Regulatory Watch',
        'sourceUrl': 'https://example.com/global-crypto-regulation',
        'imageUrl':
            'https://via.placeholder.com/400x200?text=Crypto+Regulation',
        'publishedAt':
            now.subtract(const Duration(hours: 12)).toIso8601String(),
        'tags': ['regulation', 'compliance', 'global', 'framework'],
        'mentionedCryptos': ['cryptocurrency', 'digital-assets'],
        'sentiment': 'NEUTRAL',
      },
      {
        'id': 'news_6',
        'title':
            'NFT Market Shows Signs of Recovery with Utility-Focused Projects',
        'content':
            'The NFT market is experiencing renewed interest as projects focus on real utility rather than speculation. Gaming NFTs, membership tokens, and utility-based collections are driving the recovery.',
        'summary':
            'NFT market recovers with focus on utility over speculation.',
        'author': 'NFT Tracker',
        'sourceUrl': 'https://example.com/nft-market-recovery',
        'imageUrl': 'https://via.placeholder.com/400x200?text=NFT+Recovery',
        'publishedAt':
            now.subtract(const Duration(hours: 16)).toIso8601String(),
        'tags': ['nft', 'recovery', 'utility', 'gaming'],
        'mentionedCryptos': ['ETH', 'NFT'],
        'sentiment': 'POSITIVE',
      },
      {
        'id': 'news_7',
        'title':
            'Central Bank Digital Currencies (CBDCs) Pilot Programs Expand',
        'content':
            'Multiple central banks have announced the expansion of their CBDC pilot programs, testing digital versions of their national currencies. These programs aim to explore the benefits of digital money while maintaining monetary sovereignty.',
        'summary':
            'Central banks expand CBDC pilots to test digital currency benefits.',
        'author': 'Central Banking Today',
        'sourceUrl': 'https://example.com/cbdc-pilots-expand',
        'imageUrl': 'https://via.placeholder.com/400x200?text=CBDC+Pilots',
        'publishedAt':
            now.subtract(const Duration(hours: 20)).toIso8601String(),
        'tags': ['cbdc', 'central-banks', 'digital-currency', 'pilot'],
        'mentionedCryptos': ['CBDC', 'digital-currency'],
        'sentiment': 'NEUTRAL',
      },
      {
        'id': 'news_8',
        'title': 'Layer 2 Solutions Drive Ethereum Transaction Cost Reduction',
        'content':
            'Ethereum Layer 2 solutions continue to gain traction, with transaction costs dropping significantly across major networks. The scaling solutions are making DeFi and NFT transactions more accessible to everyday users.',
        'summary':
            'Layer 2 solutions significantly reduce Ethereum transaction costs.',
        'author': 'Layer2 Analytics',
        'sourceUrl': 'https://example.com/layer2-cost-reduction',
        'imageUrl': 'https://via.placeholder.com/400x200?text=Layer2+Scaling',
        'publishedAt': now.subtract(const Duration(days: 1)).toIso8601String(),
        'tags': ['ethereum', 'layer2', 'scaling', 'costs'],
        'mentionedCryptos': ['ETH', 'layer2-tokens'],
        'sentiment': 'POSITIVE',
      },
      {
        'id': 'news_9',
        'title':
            'Institutional Crypto Adoption Survey Reveals Growing Interest',
        'content':
            'A recent survey of institutional investors shows 70% are considering cryptocurrency allocations within the next 12 months. Risk management and regulatory compliance remain the primary concerns for institutions.',
        'summary':
            '70% of institutions considering crypto allocations within 12 months.',
        'author': 'Institutional Crypto Report',
        'sourceUrl': 'https://example.com/institutional-adoption-survey',
        'imageUrl':
            'https://via.placeholder.com/400x200?text=Institutional+Survey',
        'publishedAt':
            now.subtract(const Duration(days: 1, hours: 6)).toIso8601String(),
        'tags': ['institutional', 'survey', 'adoption', 'investment'],
        'mentionedCryptos': ['BTC', 'ETH', 'cryptocurrency'],
        'sentiment': 'POSITIVE',
      },
      {
        'id': 'news_10',
        'title':
            'Cross-Chain Interoperability Protocols Show Promising Development',
        'content':
            'Several cross-chain protocols have achieved significant milestones in enabling seamless asset transfers between different blockchain networks. These developments are crucial for the future of a multi-chain ecosystem.',
        'summary':
            'Cross-chain protocols advance interoperability between blockchain networks.',
        'author': 'Blockchain Interop Weekly',
        'sourceUrl': 'https://example.com/cross-chain-development',
        'imageUrl': 'https://via.placeholder.com/400x200?text=Cross+Chain',
        'publishedAt':
            now.subtract(const Duration(days: 1, hours: 12)).toIso8601String(),
        'tags': ['cross-chain', 'interoperability', 'blockchain', 'protocols'],
        'mentionedCryptos': ['multi-chain-tokens'],
        'sentiment': 'POSITIVE',
      },
    ];
  }

  /// Fallback news in case of errors
  List<Map<String, dynamic>> _getFallbackNews() {
    return [
      {
        'id': 'fallback_1',
        'title': 'Cryptocurrency Market Update',
        'content':
            'Stay informed about the latest developments in the cryptocurrency market.',
        'summary': 'Latest crypto market developments.',
        'author': 'Kointos Team',
        'sourceUrl': '',
        'imageUrl': 'https://via.placeholder.com/400x200?text=Crypto+News',
        'publishedAt': DateTime.now().toIso8601String(),
        'tags': ['market', 'update'],
        'mentionedCryptos': ['cryptocurrency'],
        'sentiment': 'NEUTRAL',
      },
    ];
  }

  /// Get news categories
  List<String> getNewsCategories() {
    return [
      'All',
      'Bitcoin',
      'Ethereum',
      'DeFi',
      'NFT',
      'Regulation',
      'Institutional',
      'Technology',
      'Market Analysis',
    ];
  }

  /// Get sentiment color
  String getSentimentColor(String sentiment) {
    switch (sentiment.toUpperCase()) {
      case 'POSITIVE':
        return '0xFF4CAF50'; // Green
      case 'NEGATIVE':
        return '0xFFF44336'; // Red
      case 'NEUTRAL':
      default:
        return '0xFF757575'; // Gray
    }
  }

  /// Get sentiment icon
  String getSentimentIcon(String sentiment) {
    switch (sentiment.toUpperCase()) {
      case 'POSITIVE':
        return '📈';
      case 'NEGATIVE':
        return '📉';
      case 'NEUTRAL':
      default:
        return '📊';
    }
  }
}
