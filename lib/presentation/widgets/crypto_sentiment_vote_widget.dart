import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kointos/core/theme/modern_theme.dart';
import 'package:kointos/core/services/crypto_sentiment_service.dart';
import 'package:kointos/core/services/service_locator.dart';

/// Widget for voting on crypto sentiment with bullish/bearish buttons
class CryptoSentimentVoteWidget extends StatefulWidget {
  final String cryptoSymbol;
  final String cryptoName;
  final double? currentPrice;
  final bool showResults;
  final VoidCallback? onVoteSubmitted;

  const CryptoSentimentVoteWidget({
    super.key,
    required this.cryptoSymbol,
    required this.cryptoName,
    this.currentPrice,
    this.showResults = true,
    this.onVoteSubmitted,
  });

  @override
  State<CryptoSentimentVoteWidget> createState() =>
      _CryptoSentimentVoteWidgetState();
}

class _CryptoSentimentVoteWidgetState extends State<CryptoSentimentVoteWidget>
    with TickerProviderStateMixin {
  final _sentimentService = getService<CryptoSentimentService>();

  bool _isLoading = false;
  bool _hasVoted = false;
  SentimentType? _selectedSentiment;
  CryptoSentiment? _currentSentiment;

  late AnimationController _pulseController;
  late AnimationController _voteController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _voteController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _loadSentimentData();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _voteController.dispose();
    super.dispose();
  }

  Future<void> _loadSentimentData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final sentiment = await _sentimentService.getCryptoSentiment(
        widget.cryptoSymbol,
      );
      setState(() {
        _currentSentiment = sentiment;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _submitVote(SentimentType sentiment) async {
    if (_hasVoted) return;

    setState(() {
      _isLoading = true;
      _selectedSentiment = sentiment;
    });

    try {
      final result = await _sentimentService.submitVote(
        cryptoSymbol: widget.cryptoSymbol,
        sentiment: sentiment,
        confidenceLevel: 0.8, // Could be user-adjustable
      );

      if (result.success) {
        setState(() {
          _hasVoted = true;
        });

        await _voteController.forward();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.message),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }

        // Reload sentiment data
        await _loadSentimentData();

        widget.onVoteSubmitted?.call();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting vote: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12), // Reduced from 16
      decoration: BoxDecoration(
        color: AppTheme.cardBlack,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.pureWhite.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Use minimum space
        children: [
          _buildHeader(),
          const SizedBox(height: 12), // Reduced from 16
          if (!_hasVoted) _buildVotingButtons(),
          if (_hasVoted) _buildVoteConfirmation(),
          if (widget.showResults && _currentSentiment != null) ...[
            const SizedBox(height: 12), // Reduced from 16
            _buildSentimentResults(),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: AppTheme.cryptoGradient,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              widget.cryptoSymbol.substring(0, 1),
              style: const TextStyle(
                color: AppTheme.primaryBlack,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.cryptoName,
                style: const TextStyle(
                  color: AppTheme.pureWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                widget.cryptoSymbol.toUpperCase(),
                style: const TextStyle(color: AppTheme.greyText, fontSize: 14),
              ),
            ],
          ),
        ),
        if (widget.currentPrice != null)
          Text(
            '\$${widget.currentPrice!.toStringAsFixed(2)}',
            style: const TextStyle(
              color: AppTheme.cryptoGold,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
      ],
    );
  }

  Widget _buildVotingButtons() {
    return Column(
      children: [
        Text(
          'What\'s your sentiment on ${widget.cryptoSymbol}?',
          style: const TextStyle(
            color: AppTheme.greyText,
            fontSize: 13, // Reduced from 14
          ),
        ),
        const SizedBox(height: 8), // Reduced from 12
        Row(
          children: [
            Expanded(
              child: _buildSentimentButton(
                sentiment: SentimentType.bullish,
                label: 'Bullish',
                icon: Icons.trending_up,
                color: Colors.green,
                emoji: '🚀',
              ),
            ),
            const SizedBox(width: 8), // Reduced from 12
            Expanded(
              child: _buildSentimentButton(
                sentiment: SentimentType.bearish,
                label: 'Bearish',
                icon: Icons.trending_down,
                color: Colors.red,
                emoji: '📉',
              ),
            ),
            const SizedBox(width: 8), // Reduced from 12
            Expanded(
              child: _buildSentimentButton(
                sentiment: SentimentType.neutral,
                label: 'Neutral',
                icon: Icons.trending_flat,
                color: Colors.grey,
                emoji: '😐',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSentimentButton({
    required SentimentType sentiment,
    required String label,
    required IconData icon,
    required Color color,
    required String emoji,
  }) {
    final isSelected = _selectedSentiment == sentiment;
    final isLoading = _isLoading && isSelected;

    return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: ElevatedButton(
            onPressed: _isLoading ? null : () => _submitVote(sentiment),
            style: ElevatedButton.styleFrom(
              backgroundColor: isSelected
                  ? color.withValues(alpha: 0.2)
                  : AppTheme.secondaryBlack,
              foregroundColor: color,
              side: BorderSide(
                color: isSelected ? color : color.withValues(alpha: 0.3),
                width: isSelected ? 2 : 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Reduced from 12
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 8,
              ), // Reduced from 12
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLoading)
                  SizedBox(
                    width: 16, // Reduced from 20
                    height: 16, // Reduced from 20
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  )
                else ...[
                  Text(
                    emoji,
                    style: const TextStyle(fontSize: 16), // Reduced from 20
                  ),
                  const SizedBox(height: 2), // Reduced from 4
                  Icon(icon, size: 14), // Reduced from 16
                  const SizedBox(height: 1), // Reduced from 2
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 11, // Reduced from 12
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        )
        .animate(target: isSelected ? 1 : 0)
        .scale(duration: 200.ms)
        .shimmer(duration: isSelected ? 1000.ms : 0.ms);
  }

  Widget _buildVoteConfirmation() {
    final sentiment = _selectedSentiment!;
    final color = sentiment == SentimentType.bullish
        ? Colors.green
        : sentiment == SentimentType.bearish
        ? Colors.red
        : Colors.grey;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Your ${sentiment.toString().split('.').last} vote has been recorded! +15 XP earned',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.5);
  }

  Widget _buildSentimentResults() {
    final sentiment = _currentSentiment!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Community Sentiment',
              style: TextStyle(
                color: AppTheme.greyText,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${sentiment.totalVotes} votes',
              style: const TextStyle(color: AppTheme.greyText, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 6),

        // Sentiment score display
        Row(
          children: [
            Text(
              sentiment.sentimentEmoji,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 6),
            Text(
              sentiment.sentimentText,
              style: const TextStyle(
                color: AppTheme.pureWhite,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            Text(
              '${(sentiment.sentimentScore * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                color: sentiment.sentimentScore >= 0
                    ? Colors.green
                    : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Vote distribution bars
        _buildVoteBar(
          'Bullish',
          sentiment.bullishVotes,
          sentiment.totalVotes,
          Colors.green,
        ),
        const SizedBox(height: 3),
        _buildVoteBar(
          'Bearish',
          sentiment.bearishVotes,
          sentiment.totalVotes,
          Colors.red,
        ),
        const SizedBox(height: 3),
        _buildVoteBar(
          'Neutral',
          sentiment.neutralVotes,
          sentiment.totalVotes,
          Colors.grey,
        ),
      ],
    );
  }

  Widget _buildVoteBar(String label, int votes, int totalVotes, Color color) {
    final percentage = totalVotes > 0 ? votes / totalVotes : 0.0;

    return Row(
      children: [
        SizedBox(
          width: 55,
          child: Text(
            label,
            style: const TextStyle(color: AppTheme.greyText, fontSize: 11),
          ),
        ),
        Expanded(
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              color: AppTheme.secondaryBlack,
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        SizedBox(
          width: 28,
          child: Text(
            '${(percentage * 100).toInt()}%',
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
