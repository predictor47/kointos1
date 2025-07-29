import 'dart:math';
import 'package:kointos/core/services/api_service.dart';
import 'package:kointos/core/services/logger_service.dart';

/// Service to populate the app with realistic dummy data for demonstration
class DummyDataService {
  final ApiService _apiService;

  DummyDataService({
    required ApiService apiService,
  }) : _apiService = apiService;

  static final Random _random = Random();

  // Realistic dummy users
  static const List<Map<String, String>> _dummyUsers = [
    {
      'username': 'cryptomaster88',
      'displayName': 'Alex Chen',
      'bio': 'Bitcoin maximalist since 2013. HODL forever! 🚀',
    },
    {
      'username': 'defi_queen',
      'displayName': 'Sarah Johnson',
      'bio':
          'DeFi enthusiast | Yield farming expert | Building the future of finance',
    },
    {
      'username': 'nft_collector',
      'displayName': 'Mike Rodriguez',
      'bio': 'NFT collector and artist. 1000+ pieces in collection',
    },
    {
      'username': 'blockchain_dev',
      'displayName': 'Emma Thompson',
      'bio': 'Smart contract developer | Solidity | Web3 builder',
    },
    {
      'username': 'crypto_analyst',
      'displayName': 'David Park',
      'bio': 'Technical analyst | Chart reader | Market predictions',
    },
    {
      'username': 'hodl_gang',
      'displayName': 'Jessica Martinez',
      'bio': 'Long-term investor | Portfolio: BTC, ETH, ADA, DOT',
    },
    {
      'username': 'degentrader',
      'displayName': 'Ryan Kim',
      'bio': 'Day trader | High risk high reward | Not financial advice',
    },
    {
      'username': 'metaverse_girl',
      'displayName': 'Ashley Lee',
      'bio':
          'Metaverse explorer | VR enthusiast | Digital real estate investor',
    },
  ];

  // Realistic social posts
  static const List<Map<String, dynamic>> _dummyPosts = [
    {
      'content':
          'Just bought the Bitcoin dip! 🚀 Anyone else accumulating at these levels? #BTC #HODL',
      'cryptoSymbol': 'BTC',
      'imageUrl':
          'https://images.unsplash.com/photo-1518546305927-5a555bb7020d?w=400&h=300&fit=crop',
    },
    {
      'content':
          'Ethereum gas fees are finally reasonable again! Perfect time to interact with DeFi protocols 🔥 #ETH #DeFi',
      'cryptoSymbol': 'ETH',
      'imageUrl':
          'https://images.unsplash.com/photo-1639762681485-074b7f938ba0?w=400&h=300&fit=crop',
    },
    {
      'content':
          'This NFT collection just dropped and it\'s absolutely stunning! The artwork is next level 🎨 #NFT',
      'cryptoSymbol': null,
      'imageUrl':
          'https://images.unsplash.com/photo-1641580314985-e7597f1e16a5?w=400&h=300&fit=crop',
    },
    {
      'content':
          'Solana ecosystem is growing so fast! New projects launching every day. What\'s your favorite SOL project? #SOL',
      'cryptoSymbol': 'SOL',
      'imageUrl': null,
    },
    {
      'content':
          'Market analysis: Looking at the charts, we might see a breakout soon. Bullish on altcoins! 📈 #Crypto',
      'cryptoSymbol': null,
      'imageUrl':
          'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?w=400&h=300&fit=crop',
    },
    {
      'content':
          'Just staked my ADA! Earning passive income while supporting the network. Love Cardano\'s approach 💜 #ADA',
      'cryptoSymbol': 'ADA',
      'imageUrl': null,
    },
    {
      'content':
          'Polygon\'s layer 2 solution is a game changer. So fast and cheap! Web3 gaming will thrive here 🎮 #MATIC',
      'cryptoSymbol': 'MATIC',
      'imageUrl': null,
    },
    {
      'content':
          'Web3 social media is the future! Finally, true ownership of our data and content. Exciting times! 🌐',
      'cryptoSymbol': null,
      'imageUrl':
          'https://images.unsplash.com/photo-1639322537228-f710d846310a?w=400&h=300&fit=crop',
    },
    {
      'content':
          'DeFi yields are getting more competitive. Just found a 15% APY on stablecoins! DYOR though 💰 #DeFi',
      'cryptoSymbol': null,
      'imageUrl': null,
    },
    {
      'content':
          'Bitcoin dominance is decreasing. Alt season incoming? What coins are you watching? 👀 #AltSeason',
      'cryptoSymbol': null,
      'imageUrl': null,
    },
  ];

  // Realistic articles
  static const List<Map<String, dynamic>> _dummyArticles = [
    {
      'title': 'The Complete Guide to DeFi Yield Farming in 2025',
      'content': '''
# The Complete Guide to DeFi Yield Farming in 2025

Decentralized Finance (DeFi) has revolutionized how we think about earning passive income through cryptocurrency. Yield farming, one of DeFi's most popular mechanisms, allows users to earn rewards by providing liquidity to various protocols.

## What is Yield Farming?

Yield farming involves lending your crypto assets to others through smart contracts in return for rewards, typically in the form of additional cryptocurrency. These rewards come from transaction fees, new token distributions, or protocol incentives.

## Popular Yield Farming Strategies

### 1. Liquidity Provision
Provide liquidity to decentralized exchanges like Uniswap, SushiSwap, or PancakeSwap by depositing token pairs into liquidity pools.

### 2. Lending Protocols
Lend your assets on platforms like Aave, Compound, or Venus to earn interest from borrowers.

### 3. Stablecoin Farming
Focus on stablecoin pairs to minimize impermanent loss while earning steady yields.

## Risk Management

- **Impermanent Loss**: Understand how price divergence affects LP positions
- **Smart Contract Risk**: Only use audited protocols with proven track records
- **Rug Pulls**: Avoid unverified or new protocols with astronomical yields

## Getting Started

1. Research protocols thoroughly
2. Start with small amounts
3. Diversify across multiple strategies
4. Monitor your positions regularly

Remember: High yields often come with high risks. Always do your own research and never invest more than you can afford to lose.
      ''',
      'category': 'DeFi',
      'tags': ['DeFi', 'Yield Farming', 'Liquidity', 'Passive Income'],
      'imageUrl':
          'https://images.unsplash.com/photo-1640340434855-6084b1f4901c?w=600&h=400&fit=crop',
    },
    {
      'title': 'Bitcoin Technical Analysis: Key Levels to Watch',
      'content': '''
# Bitcoin Technical Analysis: Key Levels to Watch

Bitcoin continues to show strong momentum as we enter Q1 2025. Here's a comprehensive technical analysis of key levels and potential price movements.

## Current Market Structure

Bitcoin is currently trading in a ascending triangle pattern, with strong support at \$65,000 and resistance near \$73,000. This pattern typically indicates bullish continuation.

## Key Support and Resistance Levels

### Support Levels:
- **\$65,000** - Strong psychological level and previous resistance turned support
- **\$62,000** - 20-day moving average
- **\$58,000** - 50-day moving average and major support zone

### Resistance Levels:
- **\$73,000** - All-time high resistance
- **\$78,000** - Next psychological target
- **\$85,000** - Long-term target based on Fibonacci extension

## Technical Indicators

### RSI (Relative Strength Index)
Currently at 58, indicating healthy bullish momentum without being overbought.

### MACD
The MACD line recently crossed above the signal line, suggesting bullish momentum.

### Volume Analysis
Volume has been increasing on green days and decreasing on red days, confirming the bullish trend.

## Price Predictions

**Short-term (1-2 months)**: \$75,000 - \$80,000
**Medium-term (3-6 months)**: \$85,000 - \$95,000
**Long-term (12 months)**: \$100,000+

## Risk Factors

- Global economic uncertainty
- Regulatory changes
- Market manipulation by large holders

Remember, this is not financial advice. Always do your own research and manage risk appropriately.
      ''',
      'category': 'Bitcoin',
      'tags': ['Bitcoin', 'Technical Analysis', 'Trading', 'Price Prediction'],
      'imageUrl':
          'https://images.unsplash.com/photo-1518546305927-5a555bb7020d?w=600&h=400&fit=crop',
    },
    {
      'title': 'NFT Gaming: The Future of Play-to-Earn',
      'content': '''
# NFT Gaming: The Future of Play-to-Earn

The gaming industry is experiencing a paradigm shift with the integration of blockchain technology and NFTs. Play-to-earn games are changing how players interact with virtual worlds.

## What Are Play-to-Earn Games?

Play-to-earn (P2E) games reward players with cryptocurrency or NFTs for their time and skill invested in gameplay. Unlike traditional games where items have no real-world value, P2E games create actual economic value.

## Popular P2E Games in 2025

### 1. Axie Infinity
Still the pioneer, with continuous updates and improvements to gameplay mechanics.

### 2. The Sandbox
A metaverse where players can create, own, and monetize their gaming experiences.

### 3. Gods Unchained
A trading card game where players truly own their cards as NFTs.

### 4. Splinterlands
A collectible card game with a thriving marketplace and competitive scene.

## Benefits of NFT Gaming

- **True Ownership**: Players actually own their in-game assets
- **Interoperability**: Assets can potentially be used across different games
- **Economic Opportunities**: Skilled players can earn real income
- **Community Governance**: Token holders can influence game development

## Challenges and Considerations

### Sustainability
Many P2E games struggle with economic sustainability as token values fluctuate.

### Gaming Quality
Some games focus too much on earning mechanics at the expense of fun gameplay.

### Regulatory Uncertainty
Governments are still determining how to regulate blockchain games.

## The Future

NFT gaming is evolving beyond simple P2E mechanics to create genuinely engaging experiences that happen to have economic value. The most successful games will balance fun gameplay with sustainable economics.

As technology improves and more mainstream gamers adopt blockchain games, we expect to see higher production values and more innovative game mechanics.
      ''',
      'category': 'NFTs',
      'tags': ['NFT', 'Gaming', 'Play-to-Earn', 'Blockchain', 'Metaverse'],
      'imageUrl':
          'https://images.unsplash.com/photo-1641580314985-e7597f1e16a5?w=600&h=400&fit=crop',
    },
  ];

  /// Create dummy user profiles in the database
  Future<void> createDummyUsers() async {
    try {
      LoggerService.info('Creating dummy users...');

      for (int i = 0; i < _dummyUsers.length; i++) {
        final user = _dummyUsers[i];

        // Create a fake user ID (in real app, these would be from Cognito)
        final fakeUserId = 'dummy-user-${i + 1}';

        try {
          await _apiService.createUserProfile(
            userId: fakeUserId,
            email: '${user['username']}@example.com',
            username: user['username']!,
            displayName: user['displayName']!,
            bio: user['bio']!,
          );
          LoggerService.info('Created dummy user: ${user['username']}');
        } catch (e) {
          LoggerService.error(
            'Failed to create dummy user ${user['username']}: $e',
          );
        }
      }

      LoggerService.info('Dummy users creation completed');
    } catch (e) {
      LoggerService.error('Failed to create dummy users: $e');
    }
  }

  /// Create dummy social posts
  Future<void> createDummyPosts() async {
    try {
      LoggerService.info('Creating dummy posts...');

      for (int i = 0; i < _dummyPosts.length; i++) {
        final post = _dummyPosts[i];

        try {
          await _apiService.createPost(
            content: post['content'],
            imageUrl: post['imageUrl'],
            tags: post['cryptoSymbol'] != null ? [post['cryptoSymbol']] : null,
            mentionedCryptos:
                post['cryptoSymbol'] != null ? [post['cryptoSymbol']] : null,
          );
          LoggerService.info('Created dummy post ${i + 1}');
        } catch (e) {
          LoggerService.error('Failed to create dummy post ${i + 1}: $e');
        }
      }

      LoggerService.info('Dummy posts creation completed');
    } catch (e) {
      LoggerService.error('Failed to create dummy posts: $e');
    }
  }

  /// Create dummy articles
  Future<void> createDummyArticles() async {
    try {
      LoggerService.info('Creating dummy articles...');

      for (int i = 0; i < _dummyArticles.length; i++) {
        final article = _dummyArticles[i];
        final userIndex = _random.nextInt(_dummyUsers.length);
        final fakeUserId = 'dummy-user-${userIndex + 1}';
        final authorName = _dummyUsers[userIndex]['displayName']!;

        try {
          await _apiService.createArticle(
            authorId: fakeUserId,
            authorName: authorName,
            title: article['title'],
            content: article['content'],
            contentKey: 'dummy-article-${i + 1}',
            tags: List<String>.from(article['tags']),
            coverImageUrl: article['imageUrl'],
            status: 'PUBLISHED',
          );
          LoggerService.info('Created dummy article: ${article['title']}');
        } catch (e) {
          LoggerService.error(
            'Failed to create dummy article ${article['title']}: $e',
          );
        }
      }

      LoggerService.info('Dummy articles creation completed');
    } catch (e) {
      LoggerService.error('Failed to create dummy articles: $e');
    }
  }

  /// Create dummy comments for posts
  Future<void> createDummyComments() async {
    try {
      LoggerService.info('Creating dummy comments...');

      // First get some posts to comment on
      final posts = await _apiService.getSocialPosts();

      final comments = [
        'Great insights! Thanks for sharing 🙌',
        'I totally agree with this analysis',
        'What do you think about the long-term prospects?',
        'This is exactly what I was looking for!',
        'Interesting perspective 🤔',
        'Thanks for the detailed explanation',
        'Do you have any sources for this information?',
        'I had a similar experience recently',
        'This post is very helpful 👍',
        'Great timing on this post!',
      ];

      for (final post in posts.take(5)) {
        final numComments = _random.nextInt(3) + 1; // 1-3 comments per post

        for (int i = 0; i < numComments; i++) {
          final comment = comments[_random.nextInt(comments.length)];

          try {
            await _apiService.createComment(
              postId: post['id'],
              content: comment,
            );
            LoggerService.info('Created dummy comment on post ${post['id']}');
          } catch (e) {
            LoggerService.error('Failed to create dummy comment: $e');
          }
        }
      }
      LoggerService.info('Dummy comments creation completed');
    } catch (e) {
      LoggerService.error('Failed to create dummy comments: $e');
    }
  }

  /// Initialize all dummy data
  Future<void> initializeAllDummyData() async {
    try {
      LoggerService.info('Starting dummy data initialization...');

      await createDummyUsers();
      await Future.delayed(
        const Duration(seconds: 2),
      ); // Allow time for users to be created

      await createDummyPosts();
      await Future.delayed(
        const Duration(seconds: 2),
      ); // Allow time for posts to be created

      await createDummyArticles();
      await Future.delayed(
        const Duration(seconds: 2),
      ); // Allow time for articles to be created

      await createDummyComments();

      LoggerService.info('Dummy data initialization completed successfully!');
    } catch (e) {
      LoggerService.error('Failed to initialize dummy data: $e');
    }
  }
}
