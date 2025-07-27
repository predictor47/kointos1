import 'package:flutter/material.dart';
import 'package:kointos/core/theme/modern_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kointos/core/services/local_storage_service.dart';
import 'package:kointos/core/services/service_locator.dart';

class InteractiveTutorialScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const InteractiveTutorialScreen({
    super.key,
    required this.onComplete,
  });

  @override
  State<InteractiveTutorialScreen> createState() =>
      _InteractiveTutorialScreenState();
}

class _InteractiveTutorialScreenState extends State<InteractiveTutorialScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  int _currentPage = 0;

  final List<TutorialStep> _steps = [
    TutorialStep(
      title: "Welcome to Kointos",
      description: "Your all-in-one crypto portfolio and social platform",
      icon: Icons.rocket_launch,
      color: Colors.blue,
      interactive: false,
    ),
    TutorialStep(
      title: "Market Insights",
      description: "Get real-time crypto prices and market analysis",
      icon: Icons.trending_up,
      color: Colors.green,
      interactive: true,
      action: TutorialAction.marketDemo,
    ),
    TutorialStep(
      title: "Portfolio Tracking",
      description: "Track your investments and portfolio performance",
      icon: Icons.account_balance_wallet,
      color: Colors.orange,
      interactive: true,
      action: TutorialAction.portfolioDemo,
    ),
    TutorialStep(
      title: "Social Features",
      description: "Connect with other crypto enthusiasts and share insights",
      icon: Icons.people,
      color: Colors.purple,
      interactive: true,
      action: TutorialAction.socialDemo,
    ),
    TutorialStep(
      title: "AI Assistant",
      description: "Meet KryptoBot - your intelligent crypto companion",
      icon: Icons.smart_toy,
      color: Colors.cyan,
      interactive: true,
      action: TutorialAction.chatbotDemo,
    ),
    TutorialStep(
      title: "Ready to Explore!",
      description: "You're all set to start your crypto journey",
      icon: Icons.check_circle,
      color: Colors.green,
      interactive: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _steps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeTutorial();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipTutorial() {
    _completeTutorial();
  }

  void _completeTutorial() async {
    final localStorage = getService<LocalStorageService>();
    await localStorage.set('tutorial_completed', 'true');
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryBlack,
                  AppTheme.primaryBlack.withValues(alpha: 0.8),
                ],
              ),
            ),
          ),

          // Main content
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
              _animationController.reset();
              _animationController.forward();
            },
            itemCount: _steps.length,
            itemBuilder: (context, index) {
              return _buildTutorialPage(_steps[index]);
            },
          ),

          // Skip button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: TextButton(
              onPressed: _skipTutorial,
              child: Text(
                'Skip',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
              ),
            ),
          ),

          // Bottom navigation
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 32,
            left: 16,
            right: 16,
            child: _buildBottomNavigation(),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialPage(TutorialStep step) {
    return Padding(
      padding: AppTheme.screenPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: step.color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              step.icon,
              size: 60,
              color: step.color,
            ),
          )
              .animate(controller: _animationController)
              .scale(duration: 600.ms, curve: Curves.elasticOut)
              .fadeIn(duration: 400.ms),

          const SizedBox(height: AppTheme.largeSpacing),

          // Title
          Text(
            step.title,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          )
              .animate(controller: _animationController)
              .slideY(begin: 0.3, duration: 600.ms, curve: Curves.easeOut)
              .fadeIn(duration: 600.ms, delay: 200.ms),

          const SizedBox(height: AppTheme.spacing),

          // Description
          Text(
            step.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white70,
                ),
            textAlign: TextAlign.center,
          )
              .animate(controller: _animationController)
              .slideY(begin: 0.3, duration: 600.ms, curve: Curves.easeOut)
              .fadeIn(duration: 600.ms, delay: 400.ms),

          const SizedBox(height: AppTheme.largeSpacing * 2),

          // Interactive demo
          if (step.interactive)
            _buildInteractiveDemo(step)
                .animate(controller: _animationController)
                .slideY(begin: 0.5, duration: 800.ms, curve: Curves.easeOut)
                .fadeIn(duration: 800.ms, delay: 600.ms),
        ],
      ),
    );
  }

  Widget _buildInteractiveDemo(TutorialStep step) {
    switch (step.action) {
      case TutorialAction.marketDemo:
        return _buildMarketDemo();
      case TutorialAction.portfolioDemo:
        return _buildPortfolioDemo();
      case TutorialAction.socialDemo:
        return _buildSocialDemo();
      case TutorialAction.chatbotDemo:
        return _buildChatbotDemo();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildMarketDemo() {
    return Container(
      padding: AppTheme.cardPadding,
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.currency_bitcoin, color: Colors.white),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bitcoin',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'BTC',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$42,350',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '+5.2%',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                '📈 Live Price Chart',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioDemo() {
    return Container(
      padding: AppTheme.cardPadding,
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Portfolio Value',
                style: TextStyle(color: Colors.white70),
              ),
              Icon(Icons.visibility, color: Colors.white70, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '\$12,450.00',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            '+\$1,250.00 (+11.2%)',
            style: TextStyle(
              color: Colors.green,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        'Holdings',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '5',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        '24h Change',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '+8.5%',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialDemo() {
    return Container(
      padding: AppTheme.cardPadding,
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.pureWhite,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CryptoExpert',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '2 hours ago',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Just published my analysis on Bitcoin\'s recent movements. The technical indicators are showing strong bullish signals! 🚀 #Bitcoin #Crypto',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildInteractionButton(Icons.thumb_up, '24'),
              const SizedBox(width: 16),
              _buildInteractionButton(Icons.comment, '8'),
              const SizedBox(width: 16),
              _buildInteractionButton(Icons.share, '3'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChatbotDemo() {
    return Container(
      padding: AppTheme.cardPadding,
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.smart_toy, color: Colors.white),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'KryptoBot',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Your AI Assistant',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '👋 Hi! I can help you with crypto prices, market analysis, portfolio insights, and answer any crypto-related questions you have!',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.pureWhite,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'What\'s Bitcoin price?',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionButton(IconData icon, String count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(width: 4),
        Text(
          count,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildBottomNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Previous button
        if (_currentPage > 0)
          TextButton.icon(
            onPressed: _previousPage,
            icon: const Icon(Icons.arrow_back),
            label: const Text('Previous'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white70,
            ),
          )
        else
          const SizedBox(width: 100),

        // Page indicator
        Row(
          children: List.generate(_steps.length, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color:
                    index == _currentPage ? AppTheme.pureWhite : Colors.white30,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),

        // Next/Complete button
        ElevatedButton.icon(
          onPressed: _nextPage,
          icon: Icon(_currentPage == _steps.length - 1
              ? Icons.check
              : Icons.arrow_forward),
          label:
              Text(_currentPage == _steps.length - 1 ? 'Get Started' : 'Next'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.pureWhite,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}

class TutorialStep {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool interactive;
  final TutorialAction? action;

  TutorialStep({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.interactive = false,
    this.action,
  });
}

enum TutorialAction {
  marketDemo,
  portfolioDemo,
  socialDemo,
  chatbotDemo,
}
