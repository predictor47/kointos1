import 'package:flutter/material.dart';
import 'package:kointos/core/theme/modern_theme.dart';
import 'package:kointos/domain/entities/cryptocurrency.dart';
import 'dart:math' as math;

// Define required enums and classes
enum ChartTimeframe { day1, day7, day30, day90, year1 }
enum ChartType { line, candlestick, area }
enum TechnicalIndicator { sma, ema, rsi, macd }

class PriceData {
  final DateTime timestamp;
  final double price;
  final double volume;

  const PriceData({
    required this.timestamp,
    required this.price,
    required this.volume,
  });
}

class AdvancedCryptoChart extends StatefulWidget {
  final Cryptocurrency cryptocurrency;
  final List<PriceData> priceHistory;
  
  const AdvancedCryptoChart({
    super.key,
    required this.cryptocurrency,
    required this.priceHistory,
  });

  @override
  State<AdvancedCryptoChart> createState() => _AdvancedCryptoChartState();
}

class _AdvancedCryptoChartState extends State<AdvancedCryptoChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  ChartTimeframe _selectedTimeframe = ChartTimeframe.day1;
  ChartType _selectedChartType = ChartType.candlestick;
  final Set<TechnicalIndicator> _selectedIndicators = {TechnicalIndicator.sma};
  bool _showVolume = true;
  bool _showGrid = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildChartControls(),
        const SizedBox(height: 16),
        _buildChart(),
        if (_showVolume) ...[
          const SizedBox(height: 16),
          _buildVolumeChart(),
        ],
        const SizedBox(height: 16),
        _buildTechnicalIndicatorControls(),
      ],
    );
  }

  Widget _buildChartControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
      ),
      child: Column(
        children: [
          // Timeframe selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ChartTimeframe.values.map((timeframe) {
              return GestureDetector(
                onTap: () => setState(() => _selectedTimeframe = timeframe),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _selectedTimeframe == timeframe
                        ? AppTheme.pureWhite
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getTimeframeLabel(timeframe),
                    style: TextStyle(
                      color: _selectedTimeframe == timeframe
                          ? Colors.white
                          : Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 16),
          
          // Chart type and options
          Row(
            children: [
              // Chart type dropdown
              Expanded(
                child: DropdownButton<ChartType>(
                  value: _selectedChartType,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedChartType = value);
                    }
                  },
                  dropdownColor: AppTheme.cardColor,
                  style: const TextStyle(color: Colors.white),
                  items: ChartType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(_getChartTypeLabel(type)),
                    );
                  }).toList(),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Volume toggle
              Row(
                children: [
                  Switch(
                    value: _showVolume,
                    onChanged: (value) => setState(() => _showVolume = value),
                    activeColor: AppTheme.pureWhite,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Volume',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
              
              const SizedBox(width: 16),
              
              // Grid toggle
              Row(
                children: [
                  Switch(
                    value: _showGrid,
                    onChanged: (value) => setState(() => _showGrid = value),
                    activeColor: AppTheme.pureWhite,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Grid',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
      ),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return CustomPaint(
            painter: ChartPainter(
              priceHistory: widget.priceHistory,
              chartType: _selectedChartType,
              showGrid: _showGrid,
              animation: _animationController,
              indicators: _selectedIndicators,
            ),
            size: const Size(double.infinity, double.infinity),
          );
        },
      ),
    );
  }

  Widget _buildVolumeChart() {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
      ),
      child: CustomPaint(
        painter: VolumeChartPainter(
          priceHistory: widget.priceHistory,
          animation: _animationController,
        ),
        size: const Size(double.infinity, double.infinity),
      ),
    );
  }

  Widget _buildTechnicalIndicatorControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Technical Indicators',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: TechnicalIndicator.values.map((indicator) {
              final isSelected = _selectedIndicators.contains(indicator);
              return FilterChip(
                label: Text(_getIndicatorLabel(indicator)),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedIndicators.add(indicator);
                    } else {
                      _selectedIndicators.remove(indicator);
                    }
                  });
                },
                backgroundColor: Colors.transparent,
                selectedColor: AppTheme.pureWhite.withValues(alpha: 0.3),
                labelStyle: TextStyle(
                  color: isSelected ? AppTheme.pureWhite : Colors.white70,
                ),
                side: BorderSide(
                  color: isSelected ? AppTheme.pureWhite : Colors.white30,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _getTimeframeLabel(ChartTimeframe timeframe) {
    switch (timeframe) {
      case ChartTimeframe.day1:
        return '1D';
      case ChartTimeframe.day7:
        return '7D';
      case ChartTimeframe.day30:
        return '1M';
      case ChartTimeframe.day90:
        return '3M';
      case ChartTimeframe.year1:
        return '1Y';
    }
  }

  String _getChartTypeLabel(ChartType type) {
    switch (type) {
      case ChartType.line:
        return 'Line';
      case ChartType.candlestick:
        return 'Candlestick';
      case ChartType.area:
        return 'Area';
    }
  }

  String _getIndicatorLabel(TechnicalIndicator indicator) {
    switch (indicator) {
      case TechnicalIndicator.sma:
        return 'SMA';
      case TechnicalIndicator.ema:
        return 'EMA';
      case TechnicalIndicator.rsi:
        return 'RSI';
      case TechnicalIndicator.macd:
        return 'MACD';
    }
  }
}

// Custom painter for the main chart
class ChartPainter extends CustomPainter {
  final List<PriceData> priceHistory;
  final ChartType chartType;
  final bool showGrid;
  final Animation<double> animation;
  final Set<TechnicalIndicator> indicators;

  ChartPainter({
    required this.priceHistory,
    required this.chartType,
    required this.showGrid,
    required this.animation,
    required this.indicators,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (priceHistory.isEmpty) return;

    final paint = Paint()
      ..color = AppTheme.pureWhite
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw grid if enabled
    if (showGrid) {
      _drawGrid(canvas, size);
    }

    // Draw price chart based on type
    switch (chartType) {
      case ChartType.line:
        _drawLineChart(canvas, size, paint);
        break;
      case ChartType.candlestick:
        _drawCandlestickChart(canvas, size);
        break;
      case ChartType.area:
        _drawAreaChart(canvas, size, paint);
        break;
    }

    // Draw technical indicators
    _drawTechnicalIndicators(canvas, size);
  }

  void _drawGrid(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..strokeWidth = 1;

    // Vertical grid lines
    for (int i = 1; i < 5; i++) {
      final x = size.width * i / 5;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        gridPaint,
      );
    }

    // Horizontal grid lines
    for (int i = 1; i < 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }
  }

  void _drawLineChart(Canvas canvas, Size size, Paint paint) {
    if (priceHistory.length < 2) return;

    final path = Path();
    final animatedLength = (priceHistory.length * animation.value).floor();
    
    if (animatedLength < 2) return;

    final minPrice = priceHistory.map((d) => d.price).reduce(math.min);
    final maxPrice = priceHistory.map((d) => d.price).reduce(math.max);
    final priceRange = maxPrice - minPrice;

    for (int i = 0; i < animatedLength; i++) {
      final x = size.width * i / (priceHistory.length - 1);
      final y = size.height - (size.height * (priceHistory[i].price - minPrice) / priceRange);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  void _drawCandlestickChart(Canvas canvas, Size size) {
    // Simplified candlestick implementation
    final animatedLength = (priceHistory.length * animation.value).floor();
    
    if (animatedLength == 0) return;

    final minPrice = priceHistory.map((d) => d.price).reduce(math.min);
    final maxPrice = priceHistory.map((d) => d.price).reduce(math.max);
    final priceRange = maxPrice - minPrice;

    final candleWidth = size.width / priceHistory.length * 0.8;

    for (int i = 0; i < animatedLength; i++) {
      final x = size.width * i / (priceHistory.length - 1);
      final price = priceHistory[i].price;
      final y = size.height - (size.height * (price - minPrice) / priceRange);

      // Draw simple price bars
      final rect = Rect.fromCenter(
        center: Offset(x, y),
        width: candleWidth,
        height: 4,
      );

      final paint = Paint()
        ..color = AppTheme.pureWhite
        ..style = PaintingStyle.fill;

      canvas.drawRect(rect, paint);
    }
  }

  void _drawAreaChart(Canvas canvas, Size size, Paint paint) {
    if (priceHistory.length < 2) return;

    final path = Path();
    final animatedLength = (priceHistory.length * animation.value).floor();
    
    if (animatedLength < 2) return;

    final minPrice = priceHistory.map((d) => d.price).reduce(math.min);
    final maxPrice = priceHistory.map((d) => d.price).reduce(math.max);
    final priceRange = maxPrice - minPrice;

    path.moveTo(0, size.height);

    for (int i = 0; i < animatedLength; i++) {
      final x = size.width * i / (priceHistory.length - 1);
      final y = size.height - (size.height * (priceHistory[i].price - minPrice) / priceRange);

      if (i == 0) {
        path.lineTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.lineTo(size.width * (animatedLength - 1) / (priceHistory.length - 1), size.height);
    path.close();

    final fillPaint = Paint()
      ..color = AppTheme.pureWhite.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, paint);
  }

  void _drawTechnicalIndicators(Canvas canvas, Size size) {
    // Simplified technical indicators - just draw some example lines
    if (indicators.contains(TechnicalIndicator.sma)) {
      final smaPaint = Paint()
        ..color = Colors.orange
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;

      // Draw a simple moving average line
      final path = Path();
      for (int i = 0; i < (priceHistory.length * animation.value).floor(); i++) {
        final x = size.width * i / (priceHistory.length - 1);
        final y = size.height * 0.5; // Simplified SMA line

        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, smaPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Custom painter for volume chart
class VolumeChartPainter extends CustomPainter {
  final List<PriceData> priceHistory;
  final Animation<double> animation;

  VolumeChartPainter({
    required this.priceHistory,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (priceHistory.isEmpty) return;

    final animatedLength = (priceHistory.length * animation.value).floor();
    if (animatedLength == 0) return;

    final maxVolume = priceHistory.map((d) => d.volume).reduce(math.max);
    final barWidth = size.width / priceHistory.length * 0.8;

    for (int i = 0; i < animatedLength; i++) {
      final x = size.width * i / (priceHistory.length - 1);
      final volume = priceHistory[i].volume;
      final barHeight = size.height * (volume / maxVolume);

      final rect = Rect.fromLTWH(
        x - barWidth / 2,
        size.height - barHeight,
        barWidth,
        barHeight,
      );

      final paint = Paint()
        ..color = AppTheme.pureWhite.withValues(alpha: 0.7)
        ..style = PaintingStyle.fill;

      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
