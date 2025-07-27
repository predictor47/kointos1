import 'package:flutter/material.dart';
import 'package:kointos/core/utils/platform_utils.dart';
import 'package:kointos/core/utils/responsive_utils.dart';

/// Adaptive layout widget that renders different UI based on platform
class AdaptiveLayoutBuilder extends StatelessWidget {
  final Widget Function(BuildContext context) androidBuilder;
  final Widget Function(BuildContext context) webBuilder;
  final Widget Function(BuildContext context)? fallbackBuilder;

  const AdaptiveLayoutBuilder({
    super.key,
    required this.androidBuilder,
    required this.webBuilder,
    this.fallbackBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (PlatformUtils.isAndroid) {
      return androidBuilder(context);
    } else if (PlatformUtils.isWeb) {
      return webBuilder(context);
    } else {
      return fallbackBuilder?.call(context) ?? androidBuilder(context);
    }
  }
}

/// Platform-specific card widget with different styling approaches
class AdaptiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double? elevation;
  final BorderRadiusGeometry? borderRadius;
  final VoidCallback? onTap;

  const AdaptiveCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayoutBuilder(
      androidBuilder: (context) => _buildAndroidCard(context),
      webBuilder: (context) => _buildWebCard(context),
    );
  }

  Widget _buildAndroidCard(BuildContext context) {
    return Card(
      elevation: elevation ?? PlatformTheme.getCardElevation(),
      margin: margin ?? const EdgeInsets.all(8),
      color: backgroundColor ?? PlatformTheme.getCardColor(context),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius:
            (borderRadius as BorderRadius?) ?? BorderRadius.circular(12),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }

  Widget _buildWebCard(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor ?? PlatformTheme.getCardColor(context),
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius:
              (borderRadius as BorderRadius?) ?? BorderRadius.circular(8),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(20),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Platform-specific button widget with different interaction patterns
class AdaptiveButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final bool isPrimary;

  const AdaptiveButton({
    super.key,
    required this.child,
    this.onPressed,
    this.style,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayoutBuilder(
      androidBuilder: (context) => _buildAndroidButton(context),
      webBuilder: (context) => _buildWebButton(context),
    );
  }

  Widget _buildAndroidButton(BuildContext context) {
    if (isPrimary) {
      return ElevatedButton(
        onPressed: onPressed,
        style: style ?? PlatformTheme.getPrimaryButtonStyle(context),
        child: child,
      );
    } else {
      return OutlinedButton(
        onPressed: onPressed,
        style: style ?? PlatformTheme.getSecondaryButtonStyle(context),
        child: child,
      );
    }
  }

  Widget _buildWebButton(BuildContext context) {
    return SizedBox(
      height: 48,
      child: isPrimary
          ? ElevatedButton(
              onPressed: onPressed,
              style: (style ?? PlatformTheme.getPrimaryButtonStyle(context))
                  .copyWith(
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                ),
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
              child: child,
            )
          : OutlinedButton(
              onPressed: onPressed,
              style: (style ?? PlatformTheme.getSecondaryButtonStyle(context))
                  .copyWith(
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                ),
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
              child: child,
            ),
    );
  }
}

/// Platform-specific navigation drawer/sidebar
class AdaptiveNavigation extends StatelessWidget {
  final List<AdaptiveNavItem> items;
  final int selectedIndex;
  final Function(int) onItemSelected;
  final Widget? header;
  final Widget? footer;

  const AdaptiveNavigation({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
    this.header,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayoutBuilder(
      androidBuilder: (context) => _buildAndroidNavigation(context),
      webBuilder: (context) => _buildWebNavigation(context),
    );
  }

  Widget _buildAndroidNavigation(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          if (header != null) header!,
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  leading: Icon(item.icon),
                  title: Text(item.label),
                  selected: selectedIndex == index,
                  onTap: () {
                    onItemSelected(index);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          if (footer != null) footer!,
        ],
      ),
    );
  }

  Widget _buildWebNavigation(BuildContext context) {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: PlatformTheme.getCardColor(context),
        border: Border(
          right: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Column(
        children: [
          if (header != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: header!,
            ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = selectedIndex == index;

                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                        : null,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: Icon(
                      item.icon,
                      color: isSelected ? Theme.of(context).primaryColor : null,
                    ),
                    title: Text(
                      item.label,
                      style: TextStyle(
                        color:
                            isSelected ? Theme.of(context).primaryColor : null,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    onTap: () => onItemSelected(index),
                    dense: true,
                  ),
                );
              },
            ),
          ),
          if (footer != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: footer!,
            ),
        ],
      ),
    );
  }
}

/// Navigation item data class
class AdaptiveNavItem {
  final String label;
  final IconData icon;
  final String? badge;

  const AdaptiveNavItem({
    required this.label,
    required this.icon,
    this.badge,
  });
}

/// Platform-specific grid/list view
class AdaptiveGridView extends StatelessWidget {
  final List<Widget> children;
  final double childAspectRatio;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;

  const AdaptiveGridView({
    super.key,
    required this.children,
    this.childAspectRatio = 1.0,
    this.mainAxisSpacing = 8.0,
    this.crossAxisSpacing = 8.0,
    this.padding,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayoutBuilder(
      androidBuilder: (context) => _buildAndroidGrid(context),
      webBuilder: (context) => _buildWebGrid(context),
    );
  }

  Widget _buildAndroidGrid(BuildContext context) {
    final crossAxisCount = ResponsiveUtils.getCrossAxisCount(
      MediaQuery.of(context).size.width,
    );

    return GridView.count(
      crossAxisCount: crossAxisCount,
      childAspectRatio: childAspectRatio,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      padding: padding ?? const EdgeInsets.all(16),
      physics: physics,
      children: children,
    );
  }

  Widget _buildWebGrid(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = ResponsiveUtils.getCrossAxisCount(screenWidth);

    // For web, use different spacing and layout
    return GridView.count(
      crossAxisCount: crossAxisCount,
      childAspectRatio: childAspectRatio,
      mainAxisSpacing: mainAxisSpacing * 1.5,
      crossAxisSpacing: crossAxisSpacing * 1.5,
      padding: padding ??
          EdgeInsets.all(
            ResponsiveUtils.isMobileWidth(screenWidth) ? 16 : 24,
          ),
      physics: physics,
      children: children,
    );
  }
}

/// Platform-specific app bar
class AdaptiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final double? elevation;
  final bool centerTitle;

  const AdaptiveAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.elevation,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayoutBuilder(
      androidBuilder: (context) => _buildAndroidAppBar(context),
      webBuilder: (context) => _buildWebAppBar(context),
    );
  }

  Widget _buildAndroidAppBar(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: actions,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColor,
      elevation: elevation ?? PlatformTheme.getAppBarElevation(),
      centerTitle: centerTitle,
    );
  }

  Widget _buildWebAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: actions,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColor ?? PlatformTheme.getCardColor(context),
      elevation: 0,
      centerTitle: false, // Web typically left-aligns titles
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(
          height: 1,
          color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}
