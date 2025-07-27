import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kointos/core/theme/modern_theme.dart';
import 'package:kointos/core/utils/responsive_utils.dart';
import 'package:kointos/presentation/widgets/enhanced_crypto_bot_widget.dart';
import 'package:kointos/presentation/screens/real_social_feed_screen.dart';
import 'package:kointos/presentation/screens/real_articles_screen.dart';
import 'package:kointos/presentation/screens/profile_screen.dart';
import 'package:kointos/presentation/screens/real_leaderboard_screen.dart';
import 'package:kointos/presentation/screens/real_portfolio_screen.dart';
import 'package:kointos/presentation/screens/real_market_screen.dart';
import 'package:kointos/presentation/screens/kointos_bot_screen.dart';
import 'package:kointos/presentation/screens/news_screen.dart';
import 'package:kointos/presentation/screens/notifications_screen.dart';

class AdaptiveMainScreen extends StatefulWidget {
  const AdaptiveMainScreen({super.key});

  @override
  State<AdaptiveMainScreen> createState() => _AdaptiveMainScreenState();
}

class _AdaptiveMainScreenState extends State<AdaptiveMainScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;

  final List<Widget> _screens = [
    const RealSocialFeedScreen(),
    const RealArticlesScreen(),
    const NewsScreen(),
    const RealPortfolioScreen(),
    const RealMarketScreen(),
    const RealLeaderboardScreen(),
    const KointosBotScreen(),
    const NotificationsScreen(),
    const ProfileScreen(),
  ];

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.dynamic_feed_rounded,
      label: 'Social',
      activeIcon: Icons.dynamic_feed,
    ),
    NavigationItem(
      icon: Icons.article_outlined,
      label: 'Articles',
      activeIcon: Icons.article,
    ),
    NavigationItem(
      icon: Icons.newspaper_outlined,
      label: 'News',
      activeIcon: Icons.newspaper,
    ),
    NavigationItem(
      icon: Icons.account_balance_wallet_outlined,
      label: 'Portfolio',
      activeIcon: Icons.account_balance_wallet,
    ),
    NavigationItem(
      icon: Icons.trending_up_outlined,
      label: 'Market',
      activeIcon: Icons.trending_up,
    ),
    NavigationItem(
      icon: Icons.leaderboard_outlined,
      label: 'Leaderboard',
      activeIcon: Icons.leaderboard,
    ),
    NavigationItem(
      icon: Icons.smart_toy_outlined,
      label: 'AI Assistant',
      activeIcon: Icons.smart_toy,
    ),
    NavigationItem(
      icon: Icons.notifications_outlined,
      label: 'Notifications',
      activeIcon: Icons.notifications,
    ),
    NavigationItem(
      icon: Icons.person_outline,
      label: 'Profile',
      activeIcon: Icons.person,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _screens.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine navigation type based on screen size and platform
        if (ResponsiveUtils.shouldUseSideNavigation(context)) {
          return _buildDesktopLayout();
        } else if (ResponsiveUtils.shouldUseRailNavigation(context)) {
          return _buildTabletLayout();
        } else {
          return _buildMobileLayout();
        }
      },
    );
  }

  // Desktop layout with side navigation
  Widget _buildDesktopLayout() {
    return Scaffold(
      body: Row(
        children: [
          // Side Navigation
          Container(
            width: 280,
            decoration: BoxDecoration(
              color: AppTheme.secondaryBlack,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(2, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                // App Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppTheme.greyText.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.cryptoGold.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.currency_bitcoin,
                          color: AppTheme.pureWhite,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kointoss',
                            style: TextStyle(
                              color: AppTheme.pureWhite,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Crypto Social Platform',
                            style: TextStyle(
                              color: AppTheme.greyText,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Navigation Items
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: _navigationItems.length,
                    itemBuilder: (context, index) {
                      final item = _navigationItems[index];
                      final isSelected = _selectedIndex == index;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: Icon(
                            isSelected ? item.activeIcon : item.icon,
                            color: isSelected
                                ? AppTheme.pureWhite
                                : AppTheme.greyText,
                            size: 24,
                          ),
                          title: Text(
                            item.label,
                            style: TextStyle(
                              color: isSelected
                                  ? AppTheme.pureWhite
                                  : AppTheme.greyText,
                              fontSize: 16,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                          selected: isSelected,
                          selectedTileColor:
                              AppTheme.pureWhite.withValues(alpha: 0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onTap: () => _onNavItemTapped(index),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: Stack(
              children: [
                IndexedStack(
                  index: _selectedIndex,
                  children: _screens,
                ),
                const EnhancedCryptoBotWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Tablet layout with navigation rail
  Widget _buildTabletLayout() {
    return Scaffold(
      body: Row(
        children: [
          // Navigation Rail
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onNavItemTapped,
            backgroundColor: AppTheme.secondaryBlack,
            selectedIconTheme: const IconThemeData(
              color: AppTheme.pureWhite,
              size: 28,
            ),
            unselectedIconTheme: const IconThemeData(
              color: AppTheme.greyText,
              size: 24,
            ),
            selectedLabelTextStyle: const TextStyle(
              color: AppTheme.pureWhite,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelTextStyle: const TextStyle(
              color: AppTheme.greyText,
              fontSize: 12,
            ),
            labelType: NavigationRailLabelType.all,
            destinations: _navigationItems.map((item) {
              return NavigationRailDestination(
                icon: Icon(item.icon),
                selectedIcon: Icon(item.activeIcon),
                label: Text(item.label),
              );
            }).toList(),
          ),

          // Main Content
          Expanded(
            child: Stack(
              children: [
                IndexedStack(
                  index: _selectedIndex,
                  children: _screens,
                ),
                const EnhancedCryptoBotWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Mobile layout with bottom navigation
  Widget _buildMobileLayout() {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            IndexedStack(
              index: _selectedIndex,
              children: _screens,
            ),
            const EnhancedCryptoBotWidget(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: ResponsiveUtils.isWeb ? 70 : 80,
        decoration: BoxDecoration(
          color: AppTheme.secondaryBlack,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(_navigationItems.length, (index) {
            // For mobile, show first 4 items + profile (last item)
            if (ResponsiveUtils.isMobileScreen(context)) {
              if (index > 3 && index != _navigationItems.length - 1) {
                return const SizedBox.shrink();
              }
            }

            final item = _navigationItems[index];
            final isSelected = _selectedIndex == index;

            return Expanded(
              child: GestureDetector(
                onTap: () => _onNavItemTapped(index),
                child: AnimatedContainer(
                  duration: AppTheme.normalAnimation,
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.pureWhite.withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSelected ? item.activeIcon : item.icon,
                        color:
                            isSelected ? AppTheme.pureWhite : AppTheme.greyText,
                        size: isSelected ? 26 : 22,
                      ).animate(target: isSelected ? 1 : 0).scale(
                            duration: AppTheme.fastAnimation,
                            curve: Curves.easeInOut,
                          ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          color: isSelected
                              ? AppTheme.pureWhite
                              : AppTheme.greyText,
                          fontSize:
                              ResponsiveUtils.isMobileScreen(context) ? 10 : 12,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ).animate(target: isSelected ? 1 : 0).fadeIn(
                            duration: AppTheme.fastAnimation,
                          ),
                    ],
                  ),
                ),
              )
                  .animate()
                  .fadeIn(
                    delay: Duration(milliseconds: index * 100),
                    duration: AppTheme.normalAnimation,
                  )
                  .slideY(
                    begin: 0.3,
                    duration: AppTheme.normalAnimation,
                    curve: Curves.easeOutBack,
                  ),
            );
          }),
        ),
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
