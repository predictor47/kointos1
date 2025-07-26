import 'package:flutter/material.dart';
import 'package:kointos/core/theme/modern_theme.dart';
import 'package:kointos/domain/entities/portfolio_item.dart';

class PortfolioAssetItem extends StatelessWidget {
  final PortfolioItem portfolioItem;
  final bool isPrivateMode;

  const PortfolioAssetItem({
    super.key,
    required this.portfolioItem,
    this.isPrivateMode = false,
  });

  String _formatNumber(double number) {
    if (number >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(2)}B';
    } else if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(2)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(2)}K';
    }
    return number.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to asset details
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Asset Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.surfaceColor,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    portfolioItem.symbol.substring(0, 1),
                    style: const TextStyle(
                      color: AppTheme.pureWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Asset Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      portfolioItem.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                    Text(
                      portfolioItem.symbol,
                      style: const TextStyle(
                        color: AppTheme.greyText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Amount and Value
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    isPrivateMode
                        ? '***'
                        : '${portfolioItem.amount.toStringAsFixed(4)} ${portfolioItem.symbol}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  Text(
                    isPrivateMode
                        ? '***'
                        : '\$${_formatNumber(portfolioItem.totalValue)}',
                    style: const TextStyle(
                      color: AppTheme.greyText,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '${portfolioItem.profitLossPercentage >= 0 ? '+' : ''}${portfolioItem.profitLossPercentage.toStringAsFixed(2)}%',
                    style: TextStyle(
                      color: portfolioItem.profitLossPercentage >= 0
                          ? AppTheme.successGreen
                          : AppTheme.errorRed,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
