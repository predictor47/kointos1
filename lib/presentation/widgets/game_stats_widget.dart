import 'package:flutter/material.dart';
import 'package:kointos/core/theme/modern_theme.dart';
import 'package:kointos/core/services/service_locator.dart';
import 'package:kointos/core/services/gamification_service.dart';

class GameStatsWidget extends StatefulWidget {
  final bool isCompact;
  final bool showProgressBar;

  const GameStatsWidget({
    super.key,
    this.isCompact = false,
    this.showProgressBar = true,
  });

  @override
  State<GameStatsWidget> createState() => _GameStatsWidgetState();
}

class _GameStatsWidgetState extends State<GameStatsWidget>
    with SingleTickerProviderStateMixin {
  final _gamificationService = getService<GamificationService>();
  UserGameStats? _stats;
  bool _isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _loadStats();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadStats() async {
    try {
      final stats = await _gamificationService.getUserStats();
      setState(() {
        _stats = stats;
        _isLoading = false;
      });
      _animationController.forward();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_stats == null) {
      return _buildErrorState();
    }

    return widget.isCompact ? _buildCompactStats() : _buildFullStats();
  }

  Widget _buildLoadingState() {
    return Container(
      height: widget.isCompact ? 60 : 120,
      decoration: BoxDecoration(
        color: AppTheme.secondaryBlack,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.cryptoGold.withValues(alpha: 0.2)),
      ),
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation(AppTheme.cryptoGold),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      height: widget.isCompact ? 60 : 120,
      decoration: BoxDecoration(
        color: AppTheme.secondaryBlack,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.cryptoGold.withValues(alpha: 0.2)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: AppTheme.greyText,
              size: widget.isCompact ? 16 : 24,
            ),
            if (!widget.isCompact) ...[
              const SizedBox(height: 4),
              const Text(
                'Stats unavailable',
                style: TextStyle(
                  color: AppTheme.greyText,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCompactStats() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.cryptoGold.withValues(alpha: 0.1),
                AppTheme.cryptoGold.withValues(alpha: 0.05),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border:
                Border.all(color: AppTheme.cryptoGold.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildRankBadge(),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${_stats!.totalPoints} XP',
                    style: const TextStyle(
                      color: AppTheme.cryptoGold,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    _getRankName(_stats!.level),
                    style: TextStyle(
                      color: AppTheme.cryptoGold.withValues(alpha: 0.8),
                      fontSize: 11,
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

  Widget _buildFullStats() {
    // Calculate next level requirements (simplified)
    final currentLevel = _stats!.level;
    final nextLevel = currentLevel + 1;
    final currentLevelXP = _getLevelRequiredXP(currentLevel);
    final nextLevelXP = _getLevelRequiredXP(nextLevel);
    final progress = nextLevelXP > currentLevelXP
        ? (_stats!.totalPoints - currentLevelXP) /
            (nextLevelXP - currentLevelXP)
        : 1.0;
    final xpToNextLevel = nextLevelXP - _stats!.totalPoints;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.cryptoGold.withValues(alpha: 0.1),
                AppTheme.cryptoGold.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border:
                Border.all(color: AppTheme.cryptoGold.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Rank and XP
              Row(
                children: [
                  _buildRankBadge(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getRankName(_stats!.level),
                          style: const TextStyle(
                            color: AppTheme.cryptoGold,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '${_stats!.totalPoints} XP',
                          style: TextStyle(
                            color: AppTheme.cryptoGold.withValues(alpha: 0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (xpToNextLevel > 0)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Next Level',
                          style: TextStyle(
                            color: AppTheme.greyText,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '$xpToNextLevel XP',
                          style: const TextStyle(
                            color: AppTheme.cryptoGold,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                ],
              ),

              if (widget.showProgressBar && xpToNextLevel > 0) ...[
                const SizedBox(height: 16),

                // Progress Bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progress to Level $nextLevel',
                          style: const TextStyle(
                            color: AppTheme.greyText,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '${(progress * 100).toInt()}%',
                          style: const TextStyle(
                            color: AppTheme.cryptoGold,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress.clamp(0.0, 1.0),
                        backgroundColor: AppTheme.secondaryBlack,
                        valueColor:
                            const AlwaysStoppedAnimation(AppTheme.cryptoGold),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 16),

              // Stats Grid
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      'Total Badges',
                      _stats!.badges.length.toString(),
                      Icons.military_tech,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatItem(
                      'Streak',
                      '${_stats!.streak}d',
                      Icons.local_fire_department,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatItem(
                      'Global Rank',
                      '#${_stats!.rank}',
                      Icons.leaderboard,
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

  Widget _buildRankBadge() {
    return Container(
      width: widget.isCompact ? 32 : 48,
      height: widget.isCompact ? 32 : 48,
      decoration: BoxDecoration(
        gradient: AppTheme.cryptoGradient,
        borderRadius: BorderRadius.circular(widget.isCompact ? 16 : 24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.cryptoGold.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          _getRankIcon(_stats!.level),
          color: AppTheme.primaryBlack,
          size: widget.isCompact ? 16 : 24,
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.secondaryBlack.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.cryptoGold.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppTheme.cryptoGold,
            size: 20,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.cryptoGold,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.greyText,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getRankName(int level) {
    if (level >= 50) return 'Grandmaster';
    if (level >= 40) return 'Master';
    if (level >= 30) return 'Diamond';
    if (level >= 20) return 'Platinum';
    if (level >= 10) return 'Gold';
    if (level >= 5) return 'Silver';
    return 'Bronze';
  }

  int _getLevelRequiredXP(int level) {
    // Simple XP calculation: each level requires 100 more XP than the previous
    return level * 100;
  }

  IconData _getRankIcon(int level) {
    if (level >= 50) return Icons.whatshot;
    if (level >= 40) return Icons.emoji_events;
    if (level >= 30) return Icons.star;
    if (level >= 20) return Icons.diamond;
    if (level >= 10) return Icons.looks_one;
    if (level >= 5) return Icons.looks_two;
    return Icons.looks_3;
  }
}
