import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/app_export.dart';
import 'custom_icon_widget.dart';

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final BottomBarVariant variant;
  final bool showLabels;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.variant = BottomBarVariant.standard,
    this.showLabels = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color shadowColor = theme.colorScheme.shadow.withOpacity(0.1);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => _handleNavigation(context, index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.6),
          selectedLabelStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.4,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.4,
          ),
          showSelectedLabels: showLabels,
          showUnselectedLabels: showLabels,
          items: _getBottomNavItems(),
        ),
      ),
    );
  }

  // THE FIX: Updated the bottom navigation bar items
  List<BottomNavigationBarItem> _getBottomNavItems() {
    return [
      BottomNavigationBarItem(
        icon: _buildNavIcon(Icons.home_outlined, Icons.home_rounded, 0),
        label: 'Home',
        tooltip: 'Home dashboard',
      ),
      BottomNavigationBarItem(
        icon: _buildNavIcon(
            Icons.assignment_outlined, Icons.assignment_rounded, 1),
        label: 'My Issues',
        tooltip: 'Track your reports',
      ),
      BottomNavigationBarItem(
        icon: _buildNavIcon(
            Icons.add_circle_outline, Icons.add_circle, 2),
        label: 'Report Issue',
        tooltip: 'Submit a new issue',
      ),
      BottomNavigationBarItem(
        icon: _buildNavIcon(
            Icons.notifications_outlined, Icons.notifications_rounded, 3),
        label: 'Alerts',
        tooltip: 'View notifications',
      ),
      BottomNavigationBarItem(
        icon: _buildNavIcon(
            Icons.account_circle_outlined, Icons.account_circle_rounded, 4),
        label: 'Profile',
        tooltip: 'User profile and settings',
      ),
    ];
  }

  Widget _buildNavIcon(IconData outlinedIcon, IconData filledIcon, int index) {
    final isSelected = currentIndex == index;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
      child: Icon(
        isSelected ? filledIcon : outlinedIcon,
        key: ValueKey(isSelected),
        size: 24,
      ),
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    if (onTap != null) {
      onTap!(index);
    }
  }
}

enum BottomBarVariant {
  standard,
  material3,
  floating,
}