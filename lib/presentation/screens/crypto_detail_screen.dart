import 'package:flutter/material.dart';
import 'package:kointos/core/services/service_locator.dart';
import 'package:kointos/core/theme/modern_theme.dart';
import 'package:kointos/data/repositories/cryptocurrency_repository.dart';
import 'package:kointos/domain/entities/cryptocurrency.dart';

class CryptoDetailScreen extends StatefulWidget {
  final Cryptocurrency cryptocurrency;

  const CryptoDetailScreen({
    super.key,
    required this.cryptocurrency,
  });

  @override
  State<CryptoDetailScreen> createState() => _CryptoDetailScreenState();
}

class _CryptoDetailScreenState extends State<CryptoDetailScreen> {
  final _cryptoRepository = getService<CryptocurrencyRepository>();
  bool _isLoading = false;
  List<double>? _priceHistory;
  int _selectedDays = 7;
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.cryptocurrency.isFavorite;
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prices = await _cryptoRepository.getCryptocurrencyPriceHistory(
        widget.cryptocurrency.id,
        'usd',
        _selectedDays,
      );

      if (mounted) {
        setState(() {
          _priceHistory = prices;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load price history')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onTimeRangeChanged(int days) {
    setState(() {
      _selectedDays = days;
    });
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: AppBar(
        title: Text(widget.cryptocurrency.name),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.star : Icons.star_border,
              color: _isFavorite ? AppTheme.cryptoGold : AppTheme.greyText,
            ),
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isFavorite
                        ? 'Added to favorites!'
                        : 'Removed from favorites!',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildPriceSection(),
                  const SizedBox(height: 24),
                  _buildChartSection(),
                  const SizedBox(height: 24),
                  _buildStatsSection(),
                ],
              ),
            ),
    );
  }

  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.network(
              widget.cryptocurrency.imageUrl,
              width: 32,
              height: 32,
              errorBuilder: (_, __, ___) => const Icon(Icons.error_outline),
            ),
            const SizedBox(width: 8),
            Text(
              '\$${widget.cryptocurrency.currentPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          widget.cryptocurrency.formattedPriceChange,
          style: TextStyle(
            color: widget.cryptocurrency.hasPositivePriceChange
                ? AppTheme.successGreen
                : AppTheme.errorRed,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildChartSection() {
    if (_priceHistory == null || _priceHistory!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTimeRangeSelector(),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: CustomPaint(
            painter: PriceChartPainter(
              prices: _priceHistory!,
              color: AppTheme.pureWhite,
              fillColor: AppTheme.pureWhite.withValues(alpha: 0.25),
            ),
            size: const Size(double.infinity, 200),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeRangeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _timeRangeButton('1D', 1),
        _timeRangeButton('7D', 7),
        _timeRangeButton('1M', 30),
        _timeRangeButton('3M', 90),
        _timeRangeButton('1Y', 365),
      ],
    );
  }

  Widget _timeRangeButton(String label, int days) {
    final isSelected = _selectedDays == days;
    return TextButton(
      onPressed: () => _onTimeRangeChanged(days),
      style: TextButton.styleFrom(
        backgroundColor: isSelected
            ? AppTheme.pureWhite.withValues(alpha: 0.25)
            : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppTheme.pureWhite : AppTheme.greyText,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Statistics',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildStatRow('Market Cap', widget.cryptocurrency.formattedMarketCap),
        _buildStatRow('Volume 24h',
            '\$${widget.cryptocurrency.totalVolume.toStringAsFixed(2)}'),
        if (widget.cryptocurrency.circulatingSupply != null)
          _buildStatRow(
            'Circulating Supply',
            '${widget.cryptocurrency.circulatingSupply!.toStringAsFixed(0)} ${widget.cryptocurrency.symbol.toUpperCase()}',
          ),
        if (widget.cryptocurrency.totalSupply != null)
          _buildStatRow(
            'Total Supply',
            '${widget.cryptocurrency.totalSupply!.toStringAsFixed(0)} ${widget.cryptocurrency.symbol.toUpperCase()}',
          ),
        if (widget.cryptocurrency.maxSupply != null)
          _buildStatRow(
            'Max Supply',
            '${widget.cryptocurrency.maxSupply!.toStringAsFixed(0)} ${widget.cryptocurrency.symbol.toUpperCase()}',
          ),
      ],
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.greyText,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class PriceChartPainter extends CustomPainter {
  final List<double> prices;
  final Color color;
  final Color fillColor;

  PriceChartPainter({
    required this.prices,
    required this.color,
    required this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (prices.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    final minPrice = prices.reduce((a, b) => a < b ? a : b);
    final maxPrice = prices.reduce((a, b) => a > b ? a : b);
    final priceRange = maxPrice - minPrice;
    final stepX = size.width / (prices.length - 1);

    for (var i = 0; i < prices.length; i++) {
      final x = i * stepX;
      final normalizedPrice = (prices[i] - minPrice) / priceRange;
      final y = size.height - (normalizedPrice * size.height);

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
