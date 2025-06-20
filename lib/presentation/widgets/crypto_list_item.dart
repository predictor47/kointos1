import 'package:flutter/material.dart';
import 'package:kointos/core/theme/app_theme.dart';
import 'package:kointos/domain/entities/cryptocurrency.dart';

class CryptoListItem extends StatelessWidget {
  final Cryptocurrency cryptocurrency;
  final VoidCallback? onTap;
  final Function(bool) onToggleFavorite;

  const CryptoListItem({
    super.key,
    required this.cryptocurrency,
    this.onTap,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Crypto Icon
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  cryptocurrency.imageUrl,
                  width: 40,
                  height: 40,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.error_outline,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Name and Symbol
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cryptocurrency.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      cryptocurrency.symbol.toUpperCase(),
                      style: const TextStyle(
                        color: AppTheme.textSecondaryColor,
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
                    '\$${cryptocurrency.currentPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    cryptocurrency.formattedPriceChange,
                    style: TextStyle(
                      color: cryptocurrency.hasPositivePriceChange
                          ? AppTheme.positiveChangeColor
                          : AppTheme.negativeChangeColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              // Favorite Button
              IconButton(
                icon: Icon(
                  cryptocurrency.isFavorite ? Icons.star : Icons.star_border,
                  color: cryptocurrency.isFavorite
                      ? AppTheme.accentColor
                      : AppTheme.textSecondaryColor,
                ),
                onPressed: () => onToggleFavorite(!cryptocurrency.isFavorite),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
