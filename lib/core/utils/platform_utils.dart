import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kointos/core/utils/responsive_utils.dart';

/// Enhanced responsive utilities with platform-specific optimizations
class PlatformUtils {
  // Platform detection with more granular control
  static bool get isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  static bool get isWeb => kIsWeb;

  static bool isDesktopWeb(BuildContext context) =>
      kIsWeb && ResponsiveUtils.isDesktopScreen(context);
  static bool isMobileWeb(BuildContext context) =>
      kIsWeb && ResponsiveUtils.isMobileScreen(context);

  // UI Layout preferences by platform
  static bool shouldUseBottomNavigation(BuildContext context) {
    return isAndroid || ResponsiveUtils.isMobileScreen(context);
  }

  static bool shouldUseSideNavigation(BuildContext context) {
    return isWeb && ResponsiveUtils.isDesktopScreen(context);
  }

  static bool shouldUseRailNavigation(BuildContext context) {
    return ResponsiveUtils.isTabletScreen(context);
  }

  // Platform-specific spacing and sizing
  static double getCardPadding(BuildContext context) {
    if (isWeb && ResponsiveUtils.isDesktopScreen(context)) return 24.0;
    if (ResponsiveUtils.isTabletScreen(context)) return 20.0;
    return 16.0;
  }

  static double getContentMaxWidth(BuildContext context) {
    if (isWeb && ResponsiveUtils.isDesktopScreen(context)) return 1200.0;
    if (ResponsiveUtils.isTabletScreen(context)) return 800.0;
    return double.infinity;
  }

  static int getCrossAxisCount(BuildContext context) {
    if (ResponsiveUtils.isDesktopScreen(context)) return 3;
    if (ResponsiveUtils.isTabletScreen(context)) return 2;
    return 1;
  }

  // Animation preferences
  static Duration getAnimationDuration() {
    return isWeb
        ? const Duration(milliseconds: 200)
        : const Duration(milliseconds: 300);
  }

  // Input method detection
  static bool hasTouchInput(BuildContext context) => !isDesktopWeb(context);
  static bool hasHoverSupport(BuildContext context) => isDesktopWeb(context);
  static bool get hasKeyboardShortcuts => !isAndroid;
}

/// Platform-specific theme extensions
class PlatformTheme {
  static ThemeData getTheme(BuildContext context) {
    final baseTheme = _getBaseTheme();

    if (PlatformUtils.isAndroid) {
      return _getAndroidTheme(baseTheme);
    } else if (PlatformUtils.isWeb) {
      return _getWebTheme(baseTheme, context);
    }

    return baseTheme;
  }

  static ThemeData _getBaseTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: const Color(0xFF0D1117),
      cardColor: const Color(0xFF161B22),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF161B22),
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static ThemeData _getAndroidTheme(ThemeData base) {
    return base.copyWith(
      // Android-specific Material 3 components
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF161B22),
        indicatorColor: Colors.blue.withValues(alpha: 0.2),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    );
  }

  static ThemeData _getWebTheme(ThemeData base, BuildContext context) {
    return base.copyWith(
      // Web-specific theme adjustments
      cardTheme: CardThemeData(
        elevation: ResponsiveUtils.isDesktopScreen(context) ? 2 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      textTheme: base.textTheme.copyWith(
        bodyLarge: base.textTheme.bodyLarge?.copyWith(
          fontSize: ResponsiveUtils.isDesktopScreen(context) ? 16 : 14,
        ),
      ),
    );
  }

  // Platform-specific UI component helpers
  static double getCardElevation() {
    return PlatformUtils.isAndroid ? 4.0 : 0.0;
  }

  static Color getCardColor(BuildContext context) {
    return const Color(0xFF161B22); // AppTheme.cardBlack equivalent
  }

  static double getAppBarElevation() {
    return PlatformUtils.isAndroid ? 4.0 : 0.0;
  }

  static ButtonStyle getPrimaryButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      elevation: PlatformUtils.isAndroid ? 2.0 : 0.0,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(PlatformUtils.isAndroid ? 12 : 8),
      ),
    );
  }

  static ButtonStyle getSecondaryButtonStyle(BuildContext context) {
    return OutlinedButton.styleFrom(
      foregroundColor: Colors.white,
      side: const BorderSide(color: Colors.grey),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(PlatformUtils.isAndroid ? 12 : 8),
      ),
    );
  }
}
