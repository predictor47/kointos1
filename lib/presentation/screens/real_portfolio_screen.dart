import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kointos/core/theme/modern_theme.dart';
import 'package:kointos/core/services/service_locator.dart';
import 'package:kointos/core/services/gamification_service.dart';
import 'package:kointos/core/services/logger_service.dart';
import 'package:kointos/data/repositories/cryptocurrency_repository.dart';
import 'package:kointos/domain/entities/portfolio_item.dart';
import 'package:kointos/presentation/widgets/platform_widgets.dart';

class RealPortfolioScreen extends StatefulWidget {
  const RealPortfolioScreen({super.key});

  @override
  State<RealPortfolioScreen> createState() => _RealPortfolioScreenState();
}

class _RealPortfolioScreenState extends State<RealPortfolioScreen>
    with AutomaticKeepAliveClientMixin {
  final _gamificationService = getService<GamificationService>();

  bool _isLoading = true;
  bool _isPrivateMode = false;
  String _timeFilter = '24h';
  List<PortfolioItem> _portfolioItems = [];
  UserGameStats? _gameStats;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadPortfolioData();
    _loadGameStats();
  }

  Future<void> _loadPortfolioData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load real portfolio data from CoinGecko API integrated with user holdings
      final cryptoRepository = getService<CryptocurrencyRepository>();
      final cryptocurrencies =
          await cryptoRepository.getTopCryptocurrencies(perPage: 10);

      // Convert to portfolio items with simulated holdings (would be user's actual holdings in production)
      _portfolioItems = cryptocurrencies.take(5).map((crypto) {
        final random = Random();
        final holdings = 0.1 +
            random.nextDouble() * 2.0; // Random holdings between 0.1 and 2.1
        final avgBuyPrice = crypto.currentPrice *
            (0.8 +
                random.nextDouble() *
                    0.4); // Random buy price within 20% of current

        return PortfolioItem(
          id: crypto.id,
          userId:
              'current_user', // In production, this would be the actual user ID
          symbol: crypto.symbol.toUpperCase(),
          name: crypto.name,
          amount: holdings,
          averageBuyPrice: avgBuyPrice,
          currentPrice: crypto.currentPrice,
          lastUpdated: DateTime.now(),
          imageUrl: crypto.imageUrl,
        );
      }).toList();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading portfolio: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadGameStats() async {
    try {
      final stats = await _gamificationService.getUserStats();
      setState(() {
        _gameStats = stats;
      });
    } catch (e) {
      LoggerService.error('Error loading game stats: $e');
    }
  }

  double get _totalValue {
    return _portfolioItems.fold(0.0, (sum, item) => sum + item.totalValue);
  }

  double get _totalPnL {
    return _portfolioItems.fold(0.0, (sum, item) => sum + item.profitLoss);
  }

  double get _totalPnLPercentage {
    final totalInvested = _portfolioItems.fold(
        0.0, (sum, item) => sum + (item.amount * item.averageBuyPrice));
    return totalInvested > 0 ? (_totalPnL / totalInvested) * 100 : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: PlatformAppBar(
        title: 'Portfolio',
        actions: [
          IconButton(
            icon:
                Icon(_isPrivateMode ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _isPrivateMode = !_isPrivateMode),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPortfolioData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildPortfolioContent(),
    );
  }

  Widget _buildPortfolioContent() {
    return RefreshIndicator(
      onRefresh: _loadPortfolioData,
      child: CustomScrollView(
        slivers: [
          // Portfolio Summary
          SliverToBoxAdapter(
            child: _buildPortfolioSummary(),
          ),

          // Game Stats
          if (_gameStats != null)
            SliverToBoxAdapter(
              child: _buildGameStatsCard(),
            ),

          // Time Filter
          SliverToBoxAdapter(
            child: _buildTimeFilter(),
          ),

          // Holdings List
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return _buildPortfolioItem(_portfolioItems[index]);
              },
              childCount: _portfolioItems.length,
            ),
          ),

          // Bottom spacing
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
    );
  }

  Widget _buildPortfolioSummary() {
    return PlatformCard(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Balance',
                style: TextStyle(
                  color: AppTheme.greyText,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _totalPnL >= 0
                      ? Colors.green.withValues(alpha: 0.2)
                      : Colors.red.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_totalPnL >= 0 ? '+' : ''}${_totalPnLPercentage.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: _totalPnL >= 0 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _isPrivateMode ? '••••••' : '\$${_totalValue.toStringAsFixed(2)}',
            style: const TextStyle(
              color: AppTheme.pureWhite,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _isPrivateMode
                ? '••••••'
                : '${_totalPnL >= 0 ? '+' : ''}\$${_totalPnL.toStringAsFixed(2)}',
            style: TextStyle(
              color: _totalPnL >= 0 ? Colors.green : Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameStatsCard() {
    return PlatformCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.stars, color: AppTheme.cryptoGold, size: 20),
              SizedBox(width: 8),
              Text(
                'Your Progress',
                style: TextStyle(
                  color: AppTheme.pureWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Level',
                  '${_gameStats!.level}',
                  AppTheme.cryptoGold,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'XP',
                  '${_gameStats!.totalPoints}',
                  Colors.blue,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Streak',
                  '${_gameStats!.streak}',
                  Colors.orange,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Badges',
                  '${_gameStats!.badges.length}',
                  Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.greyText,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeFilter() {
    final filters = ['1h', '24h', '7d', '30d', '1y'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _timeFilter == filter;

          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: PlatformButton(
              isPrimary: isSelected,
              onPressed: () => setState(() => _timeFilter = filter),
              child: Text(filter),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPortfolioItem(PortfolioItem item) {
    final pnlColor = item.profitLoss >= 0 ? Colors.green : Colors.red;

    return PlatformCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      onTap: () {
        // Navigate to detailed crypto view
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('View ${item.name} details'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Row(
        children: [
          // Crypto Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: AppTheme.cryptoGradient,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Text(
                item.symbol.substring(0, 1),
                style: const TextStyle(
                  color: AppTheme.primaryBlack,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Crypto Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    color: AppTheme.pureWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${item.amount} ${item.symbol}',
                  style: const TextStyle(
                    color: AppTheme.greyText,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Values
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _isPrivateMode
                    ? '••••••'
                    : '\$${item.totalValue.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppTheme.pureWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                _isPrivateMode
                    ? '••••••'
                    : '${item.profitLoss >= 0 ? '+' : ''}\$${item.profitLoss.toStringAsFixed(2)}',
                style: TextStyle(
                  color: pnlColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
