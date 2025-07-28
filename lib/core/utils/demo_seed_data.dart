/// Demo seed data for the Kointoss app
class DemoSeedData {
  /// Sample cryptocurrencies
  static final List<Map<String, dynamic>> sampleCryptos = [
    {
      'id': 'bitcoin',
      'symbol': 'BTC',
      'name': 'Bitcoin',
      'currentPrice': 45234.56,
      'priceChange24h': 2.34,
      'priceChangePercentage24h': 5.2,
      'marketCap': 883456789012,
      'totalVolume': 28456789012,
      'high24h': 46123.45,
      'low24h': 44123.45,
      'circulatingSupply': 19500000,
      'totalSupply': 21000000,
      'imageUrl':
          'https://assets.coingecko.com/coins/images/1/large/bitcoin.png',
    },
    {
      'id': 'ethereum',
      'symbol': 'ETH',
      'name': 'Ethereum',
      'currentPrice': 2456.78,
      'priceChange24h': 45.67,
      'priceChangePercentage24h': 1.89,
      'marketCap': 295678901234,
      'totalVolume': 15678901234,
      'high24h': 2512.34,
      'low24h': 2398.76,
      'circulatingSupply': 120400000,
      'totalSupply': null,
      'imageUrl':
          'https://assets.coingecko.com/coins/images/279/large/ethereum.png',
    },
    {
      'id': 'binancecoin',
      'symbol': 'BNB',
      'name': 'BNB',
      'currentPrice': 312.45,
      'priceChange24h': -5.23,
      'priceChangePercentage24h': -1.65,
      'marketCap': 48123456789,
      'totalVolume': 1234567890,
      'high24h': 318.90,
      'low24h': 309.12,
      'circulatingSupply': 153856150,
      'totalSupply': 200000000,
      'imageUrl':
          'https://assets.coingecko.com/coins/images/825/large/bnb-icon2_2x.png',
    },
    {
      'id': 'ripple',
      'symbol': 'XRP',
      'name': 'XRP',
      'currentPrice': 0.5234,
      'priceChange24h': 0.0123,
      'priceChangePercentage24h': 2.41,
      'marketCap': 27890123456,
      'totalVolume': 1890123456,
      'high24h': 0.5345,
      'low24h': 0.5098,
      'circulatingSupply': 53280000000,
      'totalSupply': 100000000000,
      'imageUrl':
          'https://assets.coingecko.com/coins/images/44/large/xrp-symbol-white-128.png',
    },
    {
      'id': 'cardano',
      'symbol': 'ADA',
      'name': 'Cardano',
      'currentPrice': 0.3856,
      'priceChange24h': 0.0234,
      'priceChangePercentage24h': 6.46,
      'marketCap': 13567890123,
      'totalVolume': 567890123,
      'high24h': 0.3912,
      'low24h': 0.3612,
      'circulatingSupply': 35200000000,
      'totalSupply': 45000000000,
      'imageUrl':
          'https://assets.coingecko.com/coins/images/975/large/cardano.png',
    },
  ];

  /// Sample articles
  static final List<Map<String, dynamic>> sampleArticles = [
    {
      'id': '1',
      'title': 'Bitcoin Halving 2024: What to Expect',
      'content': '''
The Bitcoin halving is one of the most anticipated events in the cryptocurrency world. Occurring approximately every four years, this event reduces the reward for mining new blocks by half, effectively decreasing the rate at which new bitcoins enter circulation.

## Historical Impact

Previous halvings have had significant impacts on Bitcoin's price:
- 2012: Price increased from \$12 to \$1,200 within a year
- 2016: Price rose from \$650 to \$20,000 by end of 2017
- 2020: Price jumped from \$8,000 to \$69,000 by 2021

## What This Means for 2024

The 2024 halving will reduce block rewards from 6.25 to 3.125 BTC. This reduction in supply, combined with increasing institutional adoption, could create significant upward pressure on price.

### Key Factors to Consider:
1. **Reduced Supply**: Lower mining rewards mean fewer new bitcoins
2. **Institutional Interest**: Growing adoption by major corporations
3. **Macroeconomic Factors**: Global economic conditions and inflation
4. **Regulatory Environment**: Evolving cryptocurrency regulations

## Investment Strategies

Investors should consider:
- Dollar-cost averaging leading up to the halving
- Diversifying across multiple cryptocurrencies
- Understanding the risks involved
- Long-term holding strategies

Remember, past performance doesn't guarantee future results. Always do your own research and invest responsibly.
      ''',
      'summary':
          'An in-depth analysis of the upcoming Bitcoin halving event and its potential impact on the cryptocurrency market.',
      'authorId': 'author1',
      'authorName': 'Sarah Chen',
      'category': 'Analysis',
      'tags': ['Bitcoin', 'Halving', 'Investment', 'Market Analysis'],
      'imageUrl': 'https://example.com/bitcoin-halving.jpg',
      'publishedAt':
          DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
      'readTime': 8,
      'likes': 234,
      'views': 5678,
      'isPremium': false,
    },
    {
      'id': '2',
      'title': 'DeFi Revolution: Understanding Decentralized Finance',
      'content': '''
Decentralized Finance (DeFi) represents a paradigm shift in how we think about financial services. By leveraging blockchain technology, DeFi eliminates intermediaries and creates open, permissionless financial systems.

## Core Components of DeFi

### 1. Decentralized Exchanges (DEXs)
- Uniswap, SushiSwap, PancakeSwap
- Automated Market Makers (AMMs)
- Liquidity pools and yield farming

### 2. Lending Protocols
- Aave, Compound, MakerDAO
- Collateralized loans
- Flash loans

### 3. Yield Aggregators
- Yearn Finance, Harvest Finance
- Automated yield optimization
- Vault strategies

## Benefits and Risks

**Benefits:**
- 24/7 accessibility
- No geographical restrictions
- Transparent and auditable
- Higher potential yields

**Risks:**
- Smart contract vulnerabilities
- Impermanent loss
- Regulatory uncertainty
- High gas fees

## Getting Started with DeFi

1. Set up a Web3 wallet (MetaMask, Trust Wallet)
2. Acquire some ETH for gas fees
3. Start with established protocols
4. Always DYOR (Do Your Own Research)

The DeFi ecosystem continues to evolve rapidly, offering new opportunities and challenges for users worldwide.
      ''',
      'summary':
          'A comprehensive guide to understanding DeFi protocols, their benefits, risks, and how to get started.',
      'authorId': 'author2',
      'authorName': 'Michael Torres',
      'category': 'Education',
      'tags': ['DeFi', 'Ethereum', 'Smart Contracts', 'Yield Farming'],
      'imageUrl': 'https://example.com/defi-ecosystem.jpg',
      'publishedAt':
          DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
      'readTime': 12,
      'likes': 456,
      'views': 8901,
      'isPremium': true,
    },
    {
      'id': '3',
      'title': 'NFTs Beyond Art: Real-World Use Cases',
      'content': '''
While NFTs gained mainstream attention through digital art and collectibles, their potential extends far beyond. Non-fungible tokens are revolutionizing various industries through unique applications.

## Emerging NFT Use Cases

### 1. Real Estate
- Property deeds as NFTs
- Fractional ownership
- Streamlined transactions

### 2. Gaming
- True ownership of in-game assets
- Cross-game interoperability
- Play-to-earn economies

### 3. Identity and Credentials
- Digital identity verification
- Academic certificates
- Professional licenses

### 4. Supply Chain
- Product authentication
- Tracking provenance
- Combating counterfeits

## The Technology Behind NFTs

NFTs leverage blockchain's immutability and transparency to create verifiable digital ownership. Smart contracts enable programmable features like royalties and access control.

## Future Outlook

As the technology matures, we expect to see:
- Integration with IoT devices
- Enhanced privacy features
- Improved scalability solutions
- Mainstream enterprise adoption

The NFT revolution is just beginning, with innovations continuing to emerge across industries.
      ''',
      'summary':
          'Exploring innovative NFT applications beyond digital art, from real estate to supply chain management.',
      'authorId': 'author3',
      'authorName': 'Emma Rodriguez',
      'category': 'Technology',
      'tags': ['NFT', 'Blockchain', 'Innovation', 'Web3'],
      'imageUrl': 'https://example.com/nft-usecases.jpg',
      'publishedAt':
          DateTime.now().subtract(const Duration(days: 7)).toIso8601String(),
      'readTime': 10,
      'likes': 321,
      'views': 6543,
      'isPremium': false,
    },
  ];

  /// Sample posts for social feed
  static final List<Map<String, dynamic>> samplePosts = [
    {
      'id': '1',
      'userId': 'user123',
      'username': 'CryptoTrader',
      'userAvatar': 'https://i.pravatar.cc/150?img=1',
      'content':
          'Just hit my first 100% gain on \$ETH! 🚀 Started investing 6 months ago and the journey has been incredible. Remember to always DYOR and never invest more than you can afford to lose. #Ethereum #CryptoGains',
      'imageUrls': [],
      'likes': 89,
      'comments': 23,
      'shares': 12,
      'timestamp':
          DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
      'isLiked': false,
    },
    {
      'id': '2',
      'userId': 'user456',
      'username': 'BlockchainDev',
      'userAvatar': 'https://i.pravatar.cc/150?img=2',
      'content':
          'Working on a new DeFi protocol that aims to solve the liquidity fragmentation problem. Early tests show 40% improvement in capital efficiency! Can\'t wait to share more details soon. 💡 #DeFi #Web3Development',
      'imageUrls': ['https://picsum.photos/400/300?random=1'],
      'likes': 156,
      'comments': 45,
      'shares': 34,
      'timestamp':
          DateTime.now().subtract(const Duration(hours: 5)).toIso8601String(),
      'isLiked': true,
    },
    {
      'id': '3',
      'userId': 'user789',
      'username': 'NFTCollector',
      'userAvatar': 'https://i.pravatar.cc/150?img=3',
      'content':
          'My NFT collection just reached 50 pieces! From generative art to utility NFTs, each one tells a unique story. What\'s your favorite NFT project and why? Drop your thoughts below! 🎨 #NFTCommunity #DigitalArt',
      'imageUrls': [
        'https://picsum.photos/400/400?random=2',
        'https://picsum.photos/400/400?random=3',
        'https://picsum.photos/400/400?random=4',
      ],
      'likes': 234,
      'comments': 67,
      'shares': 23,
      'timestamp':
          DateTime.now().subtract(const Duration(hours: 8)).toIso8601String(),
      'isLiked': false,
    },
    {
      'id': '4',
      'userId': 'user101',
      'username': 'CryptoEducator',
      'userAvatar': 'https://i.pravatar.cc/150?img=4',
      'content': '''
🧵 Thread: Understanding Market Cycles

1/ Crypto markets move in cycles. Recognizing where we are can help make better investment decisions.

2/ Accumulation Phase: Smart money buys while sentiment is low
3/ Markup Phase: Prices rise as more investors join
4/ Distribution Phase: Early investors take profits
5/ Markdown Phase: Prices decline, weak hands sell

Understanding these phases is crucial for long-term success! 📊
      ''',
      'imageUrls': [],
      'likes': 567,
      'comments': 89,
      'shares': 123,
      'timestamp':
          DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      'isLiked': true,
    },
  ];

  /// Sample user profiles
  static final List<Map<String, dynamic>> sampleUsers = [
    {
      'userId': 'user123',
      'username': 'CryptoTrader',
      'displayName': 'Alex Thompson',
      'bio':
          'Crypto enthusiast | Day trader | Always learning | Not financial advice',
      'avatarUrl': 'https://i.pravatar.cc/150?img=1',
      'coverImageUrl': 'https://picsum.photos/800/200?random=5',
      'followersCount': 1234,
      'followingCount': 567,
      'postsCount': 89,
      'level': 15,
      'experiencePoints': 3456,
      'badges': ['early_adopter', 'active_trader', 'helpful_member'],
      'joinedDate':
          DateTime.now().subtract(const Duration(days: 180)).toIso8601String(),
      'isVerified': true,
      'isPremium': false,
    },
    {
      'userId': 'user456',
      'username': 'BlockchainDev',
      'displayName': 'Sarah Chen',
      'bio':
          'Blockchain Developer | Smart Contract Auditor | Building the future of finance',
      'avatarUrl': 'https://i.pravatar.cc/150?img=2',
      'coverImageUrl': 'https://picsum.photos/800/200?random=6',
      'followersCount': 5678,
      'followingCount': 234,
      'postsCount': 156,
      'level': 25,
      'experiencePoints': 8901,
      'badges': ['developer', 'contributor', 'expert', 'verified'],
      'joinedDate':
          DateTime.now().subtract(const Duration(days: 365)).toIso8601String(),
      'isVerified': true,
      'isPremium': true,
    },
    {
      'userId': 'user789',
      'username': 'NFTCollector',
      'displayName': 'Marcus Johnson',
      'bio': 'NFT Collector & Curator | Supporting digital artists | WAGMI 🚀',
      'avatarUrl': 'https://i.pravatar.cc/150?img=3',
      'coverImageUrl': 'https://picsum.photos/800/200?random=7',
      'followersCount': 3456,
      'followingCount': 890,
      'postsCount': 234,
      'level': 20,
      'experiencePoints': 5678,
      'badges': ['nft_collector', 'art_supporter', 'community_builder'],
      'joinedDate':
          DateTime.now().subtract(const Duration(days: 270)).toIso8601String(),
      'isVerified': false,
      'isPremium': true,
    },
  ];

  /// Sample portfolio data
  static Map<String, dynamic> getSamplePortfolio() {
    return {
      'totalValue': 25678.90,
      'totalGainLoss': 3456.78,
      'totalGainLossPercentage': 15.54,
      'holdings': [
        {
          'cryptoId': 'bitcoin',
          'symbol': 'BTC',
          'name': 'Bitcoin',
          'amount': 0.5,
          'averageBuyPrice': 40000,
          'currentPrice': 45234.56,
          'value': 22617.28,
          'gainLoss': 2617.28,
          'gainLossPercentage': 13.09,
          'imageUrl':
              'https://assets.coingecko.com/coins/images/1/large/bitcoin.png',
        },
        {
          'cryptoId': 'ethereum',
          'symbol': 'ETH',
          'name': 'Ethereum',
          'amount': 2.5,
          'averageBuyPrice': 2000,
          'currentPrice': 2456.78,
          'value': 6141.95,
          'gainLoss': 1141.95,
          'gainLossPercentage': 22.84,
          'imageUrl':
              'https://assets.coingecko.com/coins/images/279/large/ethereum.png',
        },
        {
          'cryptoId': 'cardano',
          'symbol': 'ADA',
          'name': 'Cardano',
          'amount': 5000,
          'averageBuyPrice': 0.30,
          'currentPrice': 0.3856,
          'value': 1928.00,
          'gainLoss': 428.00,
          'gainLossPercentage': 28.53,
          'imageUrl':
              'https://assets.coingecko.com/coins/images/975/large/cardano.png',
        },
      ],
    };
  }

  /// Sample leaderboard data
  static List<Map<String, dynamic>> getSampleLeaderboard() {
    return [
      {
        'rank': 1,
        'userId': 'user456',
        'username': 'BlockchainDev',
        'displayName': 'Sarah Chen',
        'avatarUrl': 'https://i.pravatar.cc/150?img=2',
        'level': 25,
        'experiencePoints': 8901,
        'badges': ['developer', 'contributor', 'expert'],
        'isCurrentUser': false,
      },
      {
        'rank': 2,
        'userId': 'user789',
        'username': 'NFTCollector',
        'displayName': 'Marcus Johnson',
        'avatarUrl': 'https://i.pravatar.cc/150?img=3',
        'level': 20,
        'experiencePoints': 5678,
        'badges': ['nft_collector', 'art_supporter'],
        'isCurrentUser': false,
      },
      {
        'rank': 3,
        'userId': 'user123',
        'username': 'CryptoTrader',
        'displayName': 'Alex Thompson',
        'avatarUrl': 'https://i.pravatar.cc/150?img=1',
        'level': 15,
        'experiencePoints': 3456,
        'badges': ['early_adopter', 'active_trader'],
        'isCurrentUser': true,
      },
      {
        'rank': 4,
        'userId': 'user202',
        'username': 'DeFiExpert',
        'displayName': 'Emma Wilson',
        'avatarUrl': 'https://i.pravatar.cc/150?img=5',
        'level': 12,
        'experiencePoints': 2890,
        'badges': ['defi_user', 'liquidity_provider'],
        'isCurrentUser': false,
      },
      {
        'rank': 5,
        'userId': 'user303',
        'username': 'CryptoNews',
        'displayName': 'David Lee',
        'avatarUrl': 'https://i.pravatar.cc/150?img=6',
        'level': 10,
        'experiencePoints': 2345,
        'badges': ['news_contributor', 'fact_checker'],
        'isCurrentUser': false,
      },
    ];
  }

  /// Sample chat messages
  static List<Map<String, dynamic>> getSampleChatMessages() {
    return [
      {
        'id': '1',
        'senderId': 'user456',
        'content': 'Hey! I saw your post about ETH gains. Congrats! 🎉',
        'timestamp': DateTime.now()
            .subtract(const Duration(minutes: 30))
            .toIso8601String(),
        'isRead': true,
      },
      {
        'id': '2',
        'senderId': 'currentUser',
        'content':
            'Thanks! It\'s been quite a journey. Started with just \$500.',
        'timestamp': DateTime.now()
            .subtract(const Duration(minutes: 28))
            .toIso8601String(),
        'isRead': true,
      },
      {
        'id': '3',
        'senderId': 'user456',
        'content': 'That\'s amazing! Any tips for someone just starting out?',
        'timestamp': DateTime.now()
            .subtract(const Duration(minutes: 25))
            .toIso8601String(),
        'isRead': true,
      },
      {
        'id': '4',
        'senderId': 'currentUser',
        'content':
            'Sure! 1. Start small 2. DYOR always 3. Don\'t FOMO 4. Have a strategy',
        'timestamp': DateTime.now()
            .subtract(const Duration(minutes: 20))
            .toIso8601String(),
        'isRead': true,
      },
      {
        'id': '5',
        'senderId': 'user456',
        'content':
            'Great advice! I\'ll keep that in mind. What resources do you recommend?',
        'timestamp': DateTime.now()
            .subtract(const Duration(minutes: 15))
            .toIso8601String(),
        'isRead': false,
      },
    ];
  }

  /// Sample notifications
  static List<Map<String, dynamic>> getSampleNotifications() {
    return [
      {
        'id': '1',
        'type': 'price_alert',
        'title': 'Price Alert: Bitcoin',
        'body': 'Bitcoin has reached \$45,000! 🚀',
        'timestamp': DateTime.now()
            .subtract(const Duration(minutes: 5))
            .toIso8601String(),
        'isRead': false,
        'data': {'cryptoId': 'bitcoin', 'price': 45000},
      },
      {
        'id': '2',
        'type': 'social',
        'title': 'New Follower',
        'body': 'BlockchainDev started following you',
        'timestamp':
            DateTime.now().subtract(const Duration(hours: 1)).toIso8601String(),
        'isRead': false,
        'data': {'userId': 'user456'},
      },
      {
        'id': '3',
        'type': 'achievement',
        'title': 'Achievement Unlocked!',
        'body': 'You\'ve earned the "Active Trader" badge!',
        'timestamp':
            DateTime.now().subtract(const Duration(hours: 3)).toIso8601String(),
        'isRead': true,
        'data': {'badgeId': 'active_trader', 'xpEarned': 100},
      },
      {
        'id': '4',
        'type': 'article',
        'title': 'New Article Published',
        'body':
            'Check out "DeFi Revolution: Understanding Decentralized Finance"',
        'timestamp':
            DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        'isRead': true,
        'data': {'articleId': '2'},
      },
    ];
  }

  /// Sample AI chatbot responses
  static final List<Map<String, String>> sampleChatbotResponses = [
    {
      'question': 'What is Bitcoin?',
      'answer':
          'Bitcoin is the first and most well-known cryptocurrency, created in 2009 by an anonymous person or group using the pseudonym Satoshi Nakamoto. It\'s a decentralized digital currency that operates on blockchain technology, allowing peer-to-peer transactions without the need for intermediaries like banks.',
    },
    {
      'question': 'How do I start investing in crypto?',
      'answer':
          '''Here's a step-by-step guide to start investing in cryptocurrency:

1. **Educate Yourself**: Learn about blockchain technology and different cryptocurrencies
2. **Choose a Reputable Exchange**: Sign up with established platforms like Coinbase, Binance, or Kraken
3. **Secure Your Investment**: Set up 2FA and consider using a hardware wallet
4. **Start Small**: Begin with a small amount you can afford to lose
5. **Diversify**: Don't put all your money in one cryptocurrency
6. **HODL or Trade**: Decide on your investment strategy
7. **Stay Informed**: Keep up with market news and developments

Remember: Only invest what you can afford to lose, and always do your own research!''',
    },
    {
      'question': 'What is DeFi?',
      'answer':
          'DeFi stands for Decentralized Finance. It refers to financial services built on blockchain technology that operate without traditional intermediaries like banks or brokers. DeFi applications include lending platforms, decentralized exchanges (DEXs), yield farming, and more. These services are typically built on Ethereum and other smart contract platforms.',
    },
  ];
}
