import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ResponsiveUtils {
  // Breakpoints for responsive design
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;

  // Platform detection
  static bool get isWeb => kIsWeb;
  static bool get isMobile => !kIsWeb;

  // Screen size detection
  static bool isMobileScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  static bool isTabletScreen(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isDesktopScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }

  // Responsive values
  static double responsiveWidth(
    BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    if (isMobileScreen(context)) return mobile;
    if (isTabletScreen(context)) return tablet;
    return desktop;
  }

  static double responsiveFontSize(
    BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    if (isMobileScreen(context)) return mobile;
    if (isTabletScreen(context)) return tablet;
    return desktop;
  }

  static EdgeInsets responsivePadding(
    BuildContext context, {
    required EdgeInsets mobile,
    required EdgeInsets tablet,
    required EdgeInsets desktop,
  }) {
    if (isMobileScreen(context)) return mobile;
    if (isTabletScreen(context)) return tablet;
    return desktop;
  }

  // Navigation type detection
  static bool shouldUseBottomNavigation(BuildContext context) {
    return isMobileScreen(context) || (!isWeb && isTabletScreen(context));
  }

  static bool shouldUseSideNavigation(BuildContext context) {
    return isWeb && isDesktopScreen(context);
  }

  static bool shouldUseRailNavigation(BuildContext context) {
    return isWeb && isTabletScreen(context);
  }

  // Grid layout helpers
  static int getCrossAxisCount(double screenWidth) {
    if (screenWidth < mobileBreakpoint) {
      return 2; // Mobile: 2 columns
    } else if (screenWidth < tabletBreakpoint) {
      return 3; // Tablet: 3 columns
    } else if (screenWidth < desktopBreakpoint) {
      return 4; // Desktop: 4 columns
    } else {
      return 5; // Large desktop: 5 columns
    }
  }

  // Mobile detection by width
  static bool isMobileWidth(double screenWidth) {
    return screenWidth < mobileBreakpoint;
  }
}

// Device type enumeration
enum DeviceType {
  mobile,
  tablet,
  desktop,
}

extension DeviceTypeExtension on DeviceType {
  static DeviceType getDeviceType(BuildContext context) {
    if (ResponsiveUtils.isMobileScreen(context)) return DeviceType.mobile;
    if (ResponsiveUtils.isTabletScreen(context)) return DeviceType.tablet;
    return DeviceType.desktop;
  }
}
