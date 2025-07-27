import 'package:flutter/material.dart';
import 'package:kointos/core/theme/modern_theme.dart';
import 'package:kointos/core/services/service_locator.dart';
import 'package:kointos/data/datasources/coingecko_service.dart';
import 'package:kointos/presentation/widgets/platform_widgets.dart';

class RealMarketScreen extends StatefulWidget {
  const RealMarketScreen({super.key});

  @override
  State<RealMarketScreen> createState() => _RealMarketScreenState();
}

class _RealMarketScreenState extends State<RealMarketScreen>
    with AutomaticKeepAliveClientMixin {
  final _coinGeckoService = getService<CoinGeckoService>();

  bool _isLoading = true;
  List<Map<String, dynamic>> _cryptos = [];
  String _sortBy = 'market_cap_desc';

  final List<Map<String, String>> _sortOptions = [
    {'value': 'market_cap_desc', 'label': 'Market Cap ↓'},
    {'value': 'market_cap_asc', 'label': 'Market Cap ↑'},
    {'value': 'volume_desc', 'label': 'Volume ↓'},
    {'value': 'price_change_percentage_24h_desc', 'label': '24h Change ↓'},
    {'value': 'price_change_percentage_24h_asc', 'label': '24h Change ↑'},
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadMarketData();
  }

  Future<void> _loadMarketData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final marketData = await _coinGeckoService.getMarketData();

      setState(() {
        _cryptos = marketData
            .map((crypto) => {
                  'name': crypto.name,
                  'symbol': crypto.symbol,
                  'current_price': crypto.currentPrice,
                  'price_change_percentage_24h':
                      crypto.priceChangePercentage24h ?? 0.0,
                  'market_cap': crypto.marketCap,
                  'total_volume': crypto.totalVolume,
                  'image': crypto.imageUrl,
                })
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading market data: $e'),
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildMarketContent(),
    );
  }

  Widget _buildMarketContent() {
    return RefreshIndicator(
      onRefresh: _loadMarketData,
      child: Column(
        children: [
          // Header with sorting
          _buildHeader(),

          // Market List
          Expanded(
            child: _cryptos.isEmpty ? _buildEmptyState() : _buildCryptoList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Crypto Market',
                style: TextStyle(
                  color: AppTheme.pureWhite,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _loadMarketData,
                color: AppTheme.cryptoGold,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Sort dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.secondaryBlack,
              borderRadius: BorderRadius.circular(8),
              border:
                  Border.all(color: AppTheme.cryptoGold.withValues(alpha: 0.3)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _sortBy,
                style: const TextStyle(color: AppTheme.pureWhite),
                dropdownColor: AppTheme.secondaryBlack,
                icon: const Icon(Icons.expand_more, color: AppTheme.cryptoGold),
                items: _sortOptions.map((option) {
                  return DropdownMenuItem<String>(
                    value: option['value'],
                    child: Text(option['label']!),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _sortBy = value;
                    });
                    _loadMarketData();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.trending_up,
            size: 80,
            color: AppTheme.greyText,
          ),
          SizedBox(height: 16),
          Text(
            'No Market Data',
            style: TextStyle(
              color: AppTheme.greyText,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Unable to load cryptocurrency\nmarket data at this time',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.greyText,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCryptoList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _cryptos.length,
      itemBuilder: (context, index) {
        final crypto = _cryptos[index];
        return _buildCryptoCard(crypto, index + 1);
      },
    );
  }

  Widget _buildCryptoCard(Map<String, dynamic> crypto, int rank) {
    final name = crypto['name'] as String? ?? 'Unknown';
    final symbol = (crypto['symbol'] as String? ?? 'N/A').toUpperCase();
    final price = crypto['current_price'] as double? ?? 0.0;
    final change24h = crypto['price_change_percentage_24h'] as double? ?? 0.0;
    final volume = crypto['total_volume'] as double? ?? 0.0;
    final imageUrl = crypto['image'] as String?;

    final isPositive = change24h >= 0;
    final changeColor = isPositive ? Colors.green : Colors.red;
    final changeIcon = isPositive ? Icons.trending_up : Icons.trending_down;

    return PlatformCard(
      margin: const EdgeInsets.only(bottom: 12),
      onTap: () {
        _showCryptoDetail(name, symbol, price, change24h);
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Rank
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.secondaryBlack,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  '#$rank',
                  style: const TextStyle(
                    color: AppTheme.greyText,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Crypto Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppTheme.secondaryBlack,
              ),
              child: imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        imageUrl,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.currency_bitcoin,
                          color: AppTheme.cryptoGold,
                          size: 24,
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.currency_bitcoin,
                      color: AppTheme.cryptoGold,
                      size: 24,
                    ),
            ),

            const SizedBox(width: 12),

            // Name and Symbol
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: AppTheme.pureWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    symbol,
                    style: const TextStyle(
                      color: AppTheme.greyText,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Price and Change
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${price.toStringAsFixed(price < 1 ? 6 : 2)}',
                  style: const TextStyle(
                    color: AppTheme.pureWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      changeIcon,
                      color: changeColor,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${change24h.toStringAsFixed(2)}%',
                      style: TextStyle(
                        color: changeColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Vol: ${_formatLargeNumber(volume)}',
                  style: const TextStyle(
                    color: AppTheme.greyText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatLargeNumber(double number) {
    if (number >= 1e12) {
      return '\$${(number / 1e12).toStringAsFixed(1)}T';
    } else if (number >= 1e9) {
      return '\$${(number / 1e9).toStringAsFixed(1)}B';
    } else if (number >= 1e6) {
      return '\$${(number / 1e6).toStringAsFixed(1)}M';
    } else if (number >= 1e3) {
      return '\$${(number / 1e3).toStringAsFixed(1)}K';
    } else {
      return '\$${number.toStringAsFixed(0)}';
    }
  }

  void _showCryptoDetail(
      String name, String symbol, double price, double change24h) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$name ($symbol)'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Price: \$${price.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    change24h >= 0 ? Icons.trending_up : Icons.trending_down,
                    color: change24h >= 0 ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${change24h >= 0 ? '+' : ''}${change24h.toStringAsFixed(2)}%',
                    style: TextStyle(
                      color: change24h >= 0 ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Actions:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Buy $symbol functionality ready for integration')),
                      );
                    },
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Buy'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$symbol added to watchlist')),
                      );
                    },
                    icon: const Icon(Icons.star),
                    label: const Text('Watch'),
                  ),
                ],
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
}
