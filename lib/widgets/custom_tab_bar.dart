import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom Tab Bar widget for civic engagement application
/// Provides secondary navigation within screens and sections
class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<CustomTab> tabs;
  final TabController? controller;
  final ValueChanged<int>? onTap;
  final TabBarVariant variant;
  final bool isScrollable;
  final EdgeInsetsGeometry? padding;
  final Color? indicatorColor;
  final Color? labelColor;
  final Color? unselectedLabelColor;

  const CustomTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.onTap,
    this.variant = TabBarVariant.standard,
    this.isScrollable = false,
    this.padding,
    this.indicatorColor,
    this.labelColor,
    this.unselectedLabelColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    switch (variant) {
      case TabBarVariant.pills:
        return _buildPillTabBar(context);
      case TabBarVariant.segmented:
        return _buildSegmentedTabBar(context);
      case TabBarVariant.underlined:
        return _buildUnderlinedTabBar(context);
      case TabBarVariant.standard:
      default:
        return _buildStandardTabBar(context);
    }
  }

  Widget _buildStandardTabBar(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: controller,
        onTap: onTap,
        isScrollable: isScrollable,
        indicatorColor: indicatorColor ?? theme.colorScheme.primary,
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: labelColor ?? theme.colorScheme.primary,
        unselectedLabelColor: unselectedLabelColor ??
            theme.colorScheme.onSurface.withOpacity(0.6),
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.1,
        ),
        tabs: tabs
            .map((tab) => Tab(
          text: tab.label,
          icon: tab.icon != null ? Icon(tab.icon) : null,
          iconMargin: tab.icon != null
              ? const EdgeInsets.only(bottom: 4)
              : EdgeInsets.zero,
        ))
            .toList(),
      ),
    );
  }

  Widget _buildUnderlinedTabBar(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
      ),
      child: TabBar(
        controller: controller,
        onTap: onTap,
        isScrollable: isScrollable,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: indicatorColor ?? theme.colorScheme.primary,
            width: 2,
          ),
          insets: const EdgeInsets.symmetric(horizontal: 16),
        ),
        labelColor: labelColor ?? theme.colorScheme.primary,
        unselectedLabelColor: unselectedLabelColor ??
            theme.colorScheme.onSurface.withOpacity(0.6),
        labelStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.1,
        ),
        tabs: tabs
            .map((tab) => Tab(
          text: tab.label,
          icon: tab.icon != null ? Icon(tab.icon) : null,
          iconMargin: tab.icon != null
              ? const EdgeInsets.only(bottom: 8)
              : EdgeInsets.zero,
        ))
            .toList(),
      ),
    );
  }

  Widget _buildPillTabBar(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(tabs.length, (index) {
            final isSelected = controller?.index == index;
            final tab = tabs[index];

            return Padding(
              padding: EdgeInsets.only(right: index < tabs.length - 1 ? 8 : 0),
              child: GestureDetector(
                onTap: () {
                  controller?.animateTo(index);
                  onTap?.call(index);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (indicatorColor ?? theme.colorScheme.primary)
                        : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? (indicatorColor ?? theme.colorScheme.primary)
                          : theme.colorScheme.outline.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (tab.icon != null) ...[
                        Icon(
                          tab.icon,
                          size: 16,
                          color: isSelected
                              ? theme.colorScheme.onPrimary
                              : (unselectedLabelColor ??
                              theme.colorScheme.onSurface
                                  .withOpacity(0.6)),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        tab.label,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected
                              ? theme.colorScheme.onPrimary
                              : (unselectedLabelColor ??
                              theme.colorScheme.onSurface
                                  .withOpacity(0.6)),
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSegmentedTabBar(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = controller?.index == index;
          final tab = tabs[index];
          final isFirst = index == 0;
          final isLast = index == tabs.length - 1;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                controller?.animateTo(index);
                onTap?.call(index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (indicatorColor ?? theme.colorScheme.primary)
                      : Colors.transparent,
                  borderRadius: BorderRadius.horizontal(
                    left: isFirst ? const Radius.circular(11) : Radius.zero,
                    right: isLast ? const Radius.circular(11) : Radius.zero,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (tab.icon != null) ...[
                      Icon(
                        tab.icon,
                        size: 16,
                        color: isSelected
                            ? theme.colorScheme.onPrimary
                            : (unselectedLabelColor ??
                            theme.colorScheme.onSurface
                                .withOpacity(0.6)),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      tab.label,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected
                            ? theme.colorScheme.onPrimary
                            : (unselectedLabelColor ??
                            theme.colorScheme.onSurface
                                .withOpacity(0.6)),
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  Size get preferredSize {
    switch (variant) {
      case TabBarVariant.pills:
      case TabBarVariant.segmented:
        return const Size.fromHeight(64);
      case TabBarVariant.underlined:
        return const Size.fromHeight(56);
      case TabBarVariant.standard:
      default:
        return const Size.fromHeight(48);
    }
  }

  /// Factory constructor for complaint status tabs
  factory CustomTabBar.complaintStatus({
    TabController? controller,
    ValueChanged<int>? onTap,
    TabBarVariant variant = TabBarVariant.pills,
  }) {
    return CustomTabBar(
      controller: controller,
      onTap: onTap,
      variant: variant,
      isScrollable: true,
      tabs: const [
        CustomTab(
          label: 'All',
          icon: Icons.list_alt_rounded,
        ),
        CustomTab(
          label: 'Pending',
          icon: Icons.pending_outlined,
        ),
        CustomTab(
          label: 'In Progress',
          icon: Icons.work_outline_rounded,
        ),
        CustomTab(
          label: 'Resolved',
          icon: Icons.check_circle_outline_rounded,
        ),
      ],
    );
  }

  /// Factory constructor for notification tabs
  factory CustomTabBar.notifications({
    TabController? controller,
    ValueChanged<int>? onTap,
    TabBarVariant variant = TabBarVariant.standard,
  }) {
    return CustomTabBar(
      controller: controller,
      onTap: onTap,
      variant: variant,
      tabs: const [
        CustomTab(
          label: 'All',
          icon: Icons.notifications_outlined,
        ),
        CustomTab(
          label: 'Updates',
          icon: Icons.update_rounded,
        ),
        CustomTab(
          label: 'Alerts',
          icon: Icons.priority_high_rounded,
        ),
      ],
    );
  }

  /// Factory constructor for profile tabs
  factory CustomTabBar.profile({
    TabController? controller,
    ValueChanged<int>? onTap,
    TabBarVariant variant = TabBarVariant.underlined,
  }) {
    return CustomTabBar(
      controller: controller,
      onTap: onTap,
      variant: variant,
      tabs: const [
        CustomTab(
          label: 'Overview',
          icon: Icons.dashboard_outlined,
        ),
        CustomTab(
          label: 'Activity',
          icon: Icons.history_rounded,
        ),
        CustomTab(
          label: 'Settings',
          icon: Icons.settings_outlined,
        ),
      ],
    );
  }
}

/// Data class representing a custom tab
class CustomTab {
  final String label;
  final IconData? icon;
  final String? tooltip;

  const CustomTab({
    required this.label,
    this.icon,
    this.tooltip,
  });
}

/// Enum defining different Tab Bar variants for civic engagement contexts
enum TabBarVariant {
  standard, // Standard Material tab bar with underline indicator
  underlined, // Enhanced underlined tabs with better spacing
  pills, // Pill-shaped tabs with background fill
  segmented, // Segmented control style tabs
}