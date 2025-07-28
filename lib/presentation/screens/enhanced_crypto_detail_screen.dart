import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:kointos/core/services/service_locator.dart';
import 'package:kointos/core/theme/modern_theme.dart';
import 'package:kointos/data/datasources/coingecko_service.dart';
import 'package:kointos/core/services/portfolio_service.dart';
import 'package:kointos/presentation/widgets/platform_widgets.dart';

class EnhancedCryptoDetailScreen extends StatefulWidget {
  final String coinId;
  final String symbol;
  final String name;
  final double currentPrice;
  final double change24h;
  final String? imageUrl;

  const EnhancedCryptoDetailScreen({
    super.key,
    required this.coinId,
    required this.symbol,
    required this.name,
    required this.currentPrice,
    required this.change24h,
    this.imageUrl,
  });

  @override
  State<EnhancedCryptoDetailScreen> createState() =>
      _EnhancedCryptoDetailScreenState();
}

class _EnhancedCryptoDetailScreenState extends State<EnhancedCryptoDetailScreen>
    with SingleTickerProviderStateMixin {
  final _coinGeckoService = getService<CoinGeckoService>();
  final _portfolioService = getService<PortfolioService>();

  late TabController _tabController;
  bool _isLoading = true;
  bool _isFavorite = false;

  // Market data
  Map<String, dynamic>? _detailedData;
  List<FlSpot>? _priceHistory;
  String _selectedTimeframe = '24h';

  // Technical indicators
  double? _rsi;
  double? _movingAverage;
  String? _trend;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      // For now, use simulated data since CoinGecko service doesn't have makeRequest
      // In production, this would use the actual API
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        setState(() {
          _detailedData = _getSimulatedDetailData();
          _priceHistory = _getSimulatedPriceHistory();
          _calculateIndicators();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Map<String, dynamic> _getSimulatedDetailData() {
    return {
      'market_data': {
        'high_24h': {'usd': widget.currentPrice * 1.05},
        'low_24h': {'usd': widget.currentPrice * 0.95},
        'total_volume': {'usd': 1234567890},
        'market_cap': {'usd': 987654321000},
        'circulating_supply': 19000000,
        'max_supply': 21000000,
        'ath': {'usd': widget.currentPrice * 2},
        'ath_date': {'usd': '2024-03-14T00:00:00.000Z'},
        'atl': {'usd': widget.currentPrice * 0.1},
      },
      'community_data': {
        'twitter_followers': 4500000,
        'reddit_subscribers': 3200000,
      },
      'description': {
        'en':
            'A decentralized digital currency, without a central bank or single administrator, that can be sent from user to user on the peer-to-peer network without the need for intermediaries.',
      },
      'links': {
        'homepage': ['https://bitcoin.org'],
        'blockchain_site': ['https://blockchain.info'],
      },
    };
  }

  List<FlSpot> _getSimulatedPriceHistory() {
    final List<FlSpot> spots = [];
    final random = Random();
    double basePrice = widget.currentPrice * 0.95;

    for (int i = 0; i < 100; i++) {
      basePrice += (random.nextDouble() - 0.5) * (widget.currentPrice * 0.01);
      spots.add(FlSpot(i.toDouble(), basePrice));
    }

    return spots;
  }

  List<FlSpot> _parsePriceHistory(List<dynamic> prices) {
    return prices.asMap().entries.map((entry) {
      final index = entry.key.toDouble();
      final price = (entry.value[1] as num).toDouble();
      return FlSpot(index, price);
    }).toList();
  }

  void _calculateIndicators() {
    if (_priceHistory == null || _priceHistory!.isEmpty) return;

    // Simple RSI calculation
    final prices = _priceHistory!.map((spot) => spot.y).toList();
    _rsi = _calculateRSI(prices);

    // Moving average
    _movingAverage = prices.length >= 20
        ? prices.skip(prices.length - 20).reduce((a, b) => a + b) / 20
        : prices.reduce((a, b) => a + b) / prices.length;

    // Trend determination
    final currentPrice = prices.last;
    _trend = currentPrice > _movingAverage! ? 'Bullish' : 'Bearish';
  }

  double _calculateRSI(List<double> prices, {int period = 14}) {
    if (prices.length < period + 1) return 50.0;

    double avgGain = 0;
    double avgLoss = 0;

    for (int i = 1; i <= period; i++) {
      final change = prices[i] - prices[i - 1];
      if (change > 0) {
        avgGain += change;
      } else {
        avgLoss += change.abs();
      }
    }

    avgGain /= period;
    avgLoss /= period;

    if (avgLoss == 0) return 100.0;

    final rs = avgGain / avgLoss;
    return 100 - (100 / (1 + rs));
  }

  int _getTimeframeDays() {
    switch (_selectedTimeframe) {
      case '24h':
        return 1;
      case '7d':
        return 7;
      case '30d':
        return 30;
      case '90d':
        return 90;
      case '1y':
        return 365;
      default:
        return 1;
    }
  }

  String _formatLargeNumber(double number) {
    if (number >= 1e12) {
      return '${(number / 1e12).toStringAsFixed(1)}T';
    } else if (number >= 1e9) {
      return '${(number / 1e9).toStringAsFixed(1)}B';
    } else if (number >= 1e6) {
      return '${(number / 1e6).toStringAsFixed(1)}M';
    } else if (number >= 1e3) {
      return '${(number / 1e3).toStringAsFixed(1)}K';
    } else {
      return number.toStringAsFixed(0);
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.cryptoGold),
              ),
            )
          : CustomScrollView(
              slivers: [
                _buildSliverAppBar(),
                SliverToBoxAdapter(child: _buildPriceSection()),
                SliverToBoxAdapter(child: _buildTimeframeSelector()),
                SliverToBoxAdapter(child: _buildPriceChart()),
                SliverToBoxAdapter(child: _buildTabBar()),
                SliverFillRemaining(child: _buildTabContent()),
              ],
            ),
      floatingActionButton: _buildActionButtons(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      backgroundColor: AppTheme.primaryBlack,
      flexibleSpace: FlexibleSpaceBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.imageUrl != null)
              Image.network(
                widget.imageUrl!,
                width: 24,
                height: 24,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.currency_bitcoin, size: 24),
              ),
            const SizedBox(width: 8),
            Text(
              widget.symbol.toUpperCase(),
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                widget.change24h >= 0
                    ? Colors.green.withValues(alpha: 0.3)
                    : Colors.red.withValues(alpha: 0.3),
                AppTheme.primaryBlack,
              ],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            _isFavorite ? Icons.star : Icons.star_border,
            color: _isFavorite ? AppTheme.cryptoGold : AppTheme.greyText,
          ),
          onPressed: () {
            setState(() => _isFavorite = !_isFavorite);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _isFavorite ? 'Added to favorites' : 'Removed from favorites',
                ),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.share, color: AppTheme.greyText),
          onPressed: () {
            // Share functionality
          },
        ),
      ],
    );
  }

  Widget _buildPriceSection() {
    final marketData = _detailedData?['market_data'] ?? {};
    final high24h = marketData['high_24h']?['usd'] ?? 0.0;
    final low24h = marketData['low_24h']?['usd'] ?? 0.0;
    final volume24h = marketData['total_volume']?['usd'] ?? 0.0;
    final marketCap = marketData['market_cap']?['usd'] ?? 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current price with animation
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: widget.currentPrice),
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeOutExpo,
            builder: (context, value, child) {
              return ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: widget.change24h >= 0
                      ? [Colors.green, const Color(0xFF00F0FF)]
                      : [Colors.red, Colors.orange],
                ).createShader(bounds),
                child: Text(
                  '\$${value.toStringAsFixed(value < 1 ? 6 : 2)}',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),

          // 24h change
          Row(
            children: [
              Icon(
                widget.change24h >= 0 ? Icons.trending_up : Icons.trending_down,
                color: widget.change24h >= 0 ? Colors.green : Colors.red,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                '${widget.change24h >= 0 ? '+' : ''}${widget.change24h.toStringAsFixed(2)}%',
                style: TextStyle(
                  color: widget.change24h >= 0 ? Colors.green : Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '24h',
                style: TextStyle(
                  color: AppTheme.greyText,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Market stats grid
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Market Cap',
                  _formatLargeNumber(marketCap),
                  Icons.account_balance,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  '24h Volume',
                  _formatLargeNumber(volume24h),
                  Icons.swap_horiz,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  '24h High',
                  '\$${high24h.toStringAsFixed(2)}',
                  Icons.arrow_upward,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  '24h Low',
                  '\$${low24h.toStringAsFixed(2)}',
                  Icons.arrow_downward,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon,
      {Color? color}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.cardBlack,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.greyText.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: color ?? AppTheme.greyText,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  color: AppTheme.greyText,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.pureWhite,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeframeSelector() {
    final timeframes = ['24h', '7d', '30d', '90d', '1y'];

    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: timeframes.map((timeframe) {
          final isSelected = _selectedTimeframe == timeframe;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedTimeframe = timeframe);
                _loadData();
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.cryptoGold : AppTheme.cardBlack,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    timeframe,
                    style: TextStyle(
                      color: isSelected
                          ? AppTheme.primaryBlack
                          : AppTheme.greyText,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPriceChart() {
    if (_priceHistory == null || _priceHistory!.isEmpty) {
      return const SizedBox(height: 200);
    }

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: AppTheme.greyText.withValues(alpha: 0.1),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: _priceHistory!,
              isCurved: true,
              gradient: LinearGradient(
                colors: widget.change24h >= 0
                    ? [Colors.green, const Color(0xFF00F0FF)]
                    : [Colors.red, Colors.orange],
              ),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: widget.change24h >= 0
                      ? [
                          Colors.green.withValues(alpha: 0.3),
                          const Color(0xFF00F0FF).withValues(alpha: 0.1),
                        ]
                      : [
                          Colors.red.withValues(alpha: 0.3),
                          Colors.orange.withValues(alpha: 0.1),
                        ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (spot) => AppTheme.cardBlack,
              tooltipRoundedRadius: 8,
              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                return touchedBarSpots.map((barSpot) {
                  return LineTooltipItem(
                    '\$${barSpot.y.toStringAsFixed(2)}',
                    const TextStyle(
                      color: AppTheme.pureWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.cardBlack,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: AppTheme.pureWhite,
        unselectedLabelColor: AppTheme.greyText,
        indicator: BoxDecoration(
          color: AppTheme.cryptoGold.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Analysis'),
          Tab(text: 'About'),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildOverviewTab(),
        _buildAnalysisTab(),
        _buildAboutTab(),
      ],
    );
  }

  Widget _buildOverviewTab() {
    final marketData = _detailedData?['market_data'] ?? {};
    final supply = marketData['circulating_supply'] ?? 0.0;
    final maxSupply = marketData['max_supply'];
    final ath = marketData['ath']?['usd'] ?? 0.0;
    final athDate = marketData['ath_date']?['usd'] ?? '';
    final atl = marketData['atl']?['usd'] ?? 0.0;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoRow('Circulating Supply',
            '${_formatLargeNumber(supply)} ${widget.symbol.toUpperCase()}'),
        if (maxSupply != null)
          _buildInfoRow('Max Supply',
              '${_formatLargeNumber(maxSupply)} ${widget.symbol.toUpperCase()}'),
        _buildInfoRow('All Time High', '\$${ath.toStringAsFixed(2)}',
            subtitle: athDate.isNotEmpty ? 'on ${_formatDate(athDate)}' : null),
        _buildInfoRow('All Time Low', '\$${atl.toStringAsFixed(2)}'),
        const SizedBox(height: 16),
        _buildSupplyChart(supply, maxSupply),
      ],
    );
  }

  Widget _buildAnalysisTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildIndicatorCard(
          'RSI (14)',
          _rsi?.toStringAsFixed(2) ?? 'N/A',
          _rsi != null
              ? _rsi! > 70
                  ? 'Overbought'
                  : _rsi! < 30
                      ? 'Oversold'
                      : 'Neutral'
              : 'N/A',
          _rsi != null
              ? _rsi! > 70
                  ? Colors.red
                  : _rsi! < 30
                      ? Colors.green
                      : Colors.orange
              : AppTheme.greyText,
        ),
        const SizedBox(height: 12),
        _buildIndicatorCard(
          'Moving Average (20)',
          '\$${_movingAverage?.toStringAsFixed(2) ?? 'N/A'}',
          _trend ?? 'N/A',
          _trend == 'Bullish' ? Colors.green : Colors.red,
        ),
        const SizedBox(height: 12),
        _buildSentimentCard(),
      ],
    );
  }

  Widget _buildAboutTab() {
    final description =
        _detailedData?['description']?['en'] ?? 'No description available.';
    final links = _detailedData?['links'] ?? {};

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'About ${widget.name}',
          style: const TextStyle(
            color: AppTheme.pureWhite,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          description,
          style: const TextStyle(
            color: AppTheme.greyText,
            fontSize: 14,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        if (links['homepage'] != null && (links['homepage'] as List).isNotEmpty)
          _buildLinkButton('Website', links['homepage'][0], Icons.language),
        if (links['blockchain_site'] != null &&
            (links['blockchain_site'] as List).isNotEmpty)
          _buildLinkButton(
              'Explorer', links['blockchain_site'][0], Icons.explore),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {String? subtitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppTheme.greyText,
                  fontSize: 14,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppTheme.greyText,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.pureWhite,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupplyChart(double circulating, double? max) {
    if (max == null) return const SizedBox.shrink();

    final percentage = (circulating / max) * 100;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBlack,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Supply Distribution',
            style: TextStyle(
              color: AppTheme.pureWhite,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: AppTheme.greyText.withValues(alpha: 0.2),
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppTheme.cryptoGold),
            minHeight: 8,
          ),
          const SizedBox(height: 8),
          Text(
            '${percentage.toStringAsFixed(1)}% in circulation',
            style: const TextStyle(
              color: AppTheme.greyText,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicatorCard(
      String title, String value, String status, Color statusColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBlack,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppTheme.greyText,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: AppTheme.pureWhite,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSentimentCard() {
    final communityData = _detailedData?['community_data'] ?? {};
    final twitterFollowers = communityData['twitter_followers'] ?? 0;
    final redditSubscribers = communityData['reddit_subscribers'] ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBlack,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Community Sentiment',
            style: TextStyle(
              color: AppTheme.pureWhite,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSocialStat(
                  'Twitter',
                  _formatLargeNumber(twitterFollowers.toDouble()),
                  Icons.flutter_dash,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSocialStat(
                  'Reddit',
                  _formatLargeNumber(redditSubscribers.toDouble()),
                  Icons.reddit,
                  Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialStat(
      String platform, String count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  platform,
                  style: const TextStyle(
                    color: AppTheme.greyText,
                    fontSize: 12,
                  ),
                ),
                Text(
                  count,
                  style: const TextStyle(
                    color: AppTheme.pureWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkButton(String label, String url, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: OutlinedButton.icon(
        onPressed: () {
          // Launch URL
        },
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.cryptoGold,
          side: const BorderSide(color: AppTheme.cryptoGold),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton.extended(
          onPressed: () => _showAddToPortfolioDialog(),
          backgroundColor: AppTheme.cryptoGold,
          foregroundColor: AppTheme.primaryBlack,
          icon: const Icon(Icons.add),
          label: const Text('Add to Portfolio'),
        ),
        const SizedBox(height: 8),
        FloatingActionButton.extended(
          onPressed: () => _showPriceAlertDialog(),
          backgroundColor: AppTheme.cardBlack,
          foregroundColor: AppTheme.cryptoGold,
          icon: const Icon(Icons.notifications),
          label: const Text('Set Alert'),
        ),
      ],
    );
  }

  void _showAddToPortfolioDialog() {
    final amountController = TextEditingController();
    final priceController = TextEditingController(
      text: widget.currentPrice.toStringAsFixed(2),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBlack,
        title: Text(
          'Add ${widget.symbol.toUpperCase()} to Portfolio',
          style: const TextStyle(color: AppTheme.pureWhite),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: AppTheme.pureWhite),
              decoration: InputDecoration(
                labelText: 'Amount',
                labelStyle: const TextStyle(color: AppTheme.greyText),
                suffixText: widget.symbol.toUpperCase(),
                suffixStyle: const TextStyle(color: AppTheme.greyText),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: AppTheme.pureWhite),
              decoration: const InputDecoration(
                labelText: 'Buy Price',
                labelStyle: TextStyle(color: AppTheme.greyText),
                prefixText: '\$',
                prefixStyle: TextStyle(color: AppTheme.greyText),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(amountController.text);
              final price = double.tryParse(priceController.text);

              if (amount != null && amount > 0 && price != null && price > 0) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Added $amount ${widget.symbol.toUpperCase()} to portfolio at \$$price',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.cryptoGold,
              foregroundColor: AppTheme.primaryBlack,
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showPriceAlertDialog() {
    final priceController = TextEditingController();
    String alertType = 'above';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: AppTheme.cardBlack,
          title: Text(
            'Set Price Alert for ${widget.symbol.toUpperCase()}',
            style: const TextStyle(color: AppTheme.pureWhite),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Current Price: \$${widget.currentPrice.toStringAsFixed(2)}',
                style: const TextStyle(color: AppTheme.greyText),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Above',
                          style: TextStyle(color: AppTheme.pureWhite)),
                      value: 'above',
                      groupValue: alertType,
                      onChanged: (value) => setState(() => alertType = value!),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Below',
                          style: TextStyle(color: AppTheme.pureWhite)),
                      value: 'below',
                      groupValue: alertType,
                      onChanged: (value) => setState(() => alertType = value!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: AppTheme.pureWhite),
                decoration: const InputDecoration(
                  labelText: 'Alert Price',
                  labelStyle: TextStyle(color: AppTheme.greyText),
                  prefixText: '\$',
                  prefixStyle: TextStyle(color: AppTheme.greyText),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final price = double.tryParse(priceController.text);

                if (price != null && price > 0) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Alert set: ${widget.symbol.toUpperCase()} $alertType \$$price',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.cryptoGold,
                foregroundColor: AppTheme.primaryBlack,
              ),
              child: const Text('Set Alert'),
            ),
          ],
        ),
      ),
    );
  }
}
