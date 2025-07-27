import 'package:flutter/material.dart';
import 'package:kointos/core/theme/modern_theme.dart';

class MarketHeader extends StatelessWidget {
  final Map<String, dynamic>? marketData;
  final String sortBy;
  final ValueChanged<String> onSortChanged;

  const MarketHeader({
    super.key,
    this.marketData,
    required this.sortBy,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlack,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.pureWhite.withValues(alpha: 0.25),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGlobalStats(),
          const SizedBox(height: 16),
          _buildSortOptions(),
        ],
      ),
    );
  }

  Widget _buildGlobalStats() {
    if (marketData == null) {
      return const SizedBox(
        height: 100,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final totalMarketCap = marketData!['total_market_cap']['usd'] as double;
    final totalVolume = marketData!['total_volume']['usd'] as double;
    final btcDominance = marketData!['market_cap_percentage']['btc'] as double;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Market Overview',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatItem(
                'Market Cap',
                _formatLargeNumber(totalMarketCap),
              ),
            ),
            Expanded(
              child: _buildStatItem(
                '24h Volume',
                _formatLargeNumber(totalVolume),
              ),
            ),
            Expanded(
              child: _buildStatItem(
                'BTC Dominance',
                '${btcDominance.toStringAsFixed(1)}%',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.greyText,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSortOptions() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildSortButton(
            'Market Cap',
            'market_cap_desc',
          ),
          _buildSortButton(
            'Price',
            'price_desc',
          ),
          _buildSortButton(
            'Volume',
            'volume_desc',
          ),
          _buildSortButton(
            'Price Change',
            'price_change_24h_desc',
          ),
        ],
      ),
    );
  }

  Widget _buildSortButton(String label, String value) {
    final isSelected = sortBy == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: () => onSortChanged(value),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? AppTheme.pureWhite
              : AppTheme.pureWhite.withValues(alpha: 0.25),
          foregroundColor: isSelected ? Colors.white : AppTheme.pureWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(label),
      ),
    );
  }

  String _formatLargeNumber(double value) {
    if (value >= 1e12) {
      return '\$${(value / 1e12).toStringAsFixed(2)}T';
    }
    if (value >= 1e9) {
      return '\$${(value / 1e9).toStringAsFixed(2)}B';
    }
    if (value >= 1e6) {
      return '\$${(value / 1e6).toStringAsFixed(2)}M';
    }
    return '\$${value.toStringAsFixed(2)}';
  }
}
