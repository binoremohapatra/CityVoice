import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/app_export.dart';
import 'custom_icon_widget.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBackButton = true,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: Text(
        title,
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: foregroundColor ?? theme.colorScheme.onSurface,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
      elevation: elevation,
      surfaceTintColor: Colors.transparent,
      shadowColor: theme.shadowColor.withOpacity(0.1),
      leading: _buildLeading(context),
      actions: actions,
      automaticallyImplyLeading: false,
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;

    if (showBackButton && Navigator.of(context).canPop()) {
      return IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 24,
          color: foregroundColor ?? Theme.of(context).colorScheme.onSurface,
        ),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
        tooltip: 'Back',
      );
    }
    return null;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}