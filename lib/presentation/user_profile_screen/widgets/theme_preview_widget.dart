import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ThemePreviewWidget extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggle;

  const ThemePreviewWidget({
    super.key,
    required this.isDarkMode,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(4.w),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SizedBox(height: 3.h),
          _buildThemeOptions(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(2.w),
          ),
          child: CustomIconWidget(
            iconName: 'palette',
            color: theme.colorScheme.primary,
            size: 6.w,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'App Theme',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Choose your preferred appearance',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildThemeOptions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildThemeOption(
            context,
            'Light',
            'brightness_5',
            !isDarkMode,
                () => !isDarkMode ? null : onToggle(),
            _buildLightPreview(context),
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: _buildThemeOption(
            context,
            'Dark',
            'brightness_2',
            isDarkMode,
                () => isDarkMode ? null : onToggle(),
            _buildDarkPreview(context),
          ),
        ),
      ],
    );
  }

  Widget _buildThemeOption(
      BuildContext context,
      String title,
      String iconName,
      bool isSelected,
      VoidCallback? onTap,
      Widget preview,
      ) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(3.w),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: iconName,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  title,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            preview,
          ],
        ),
      ),
    );
  }

  Widget _buildLightPreview(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 15.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary,
              borderRadius: BorderRadius.vertical(top: Radius.circular(2.w)),
            ),
            child: Row(
              children: [
                SizedBox(width: 3.w),
                Container(
                  width: 3.w,
                  height: 3.w,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Container(
                    height: 1.h,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.onPrimary
                          .withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(0.5.h),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(2.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 1.h,
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(0.5.h),
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Container(
                              width: 20.w,
                              height: 0.8.h,
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(0.4.h),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  // FIX: Added Expanded widgets to prevent overflow
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 2.h,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(1.h),
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Container(
                          height: 2.h,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(1.h),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDarkPreview(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 15.h,
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: AppTheme.darkTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppTheme.darkTheme.colorScheme.primary,
              borderRadius: BorderRadius.vertical(top: Radius.circular(2.w)),
            ),
            child: Row(
              children: [
                SizedBox(width: 3.w),
                Container(
                  width: 3.w,
                  height: 3.w,
                  decoration: BoxDecoration(
                    color: AppTheme.darkTheme.colorScheme.onPrimary,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Container(
                    height: 1.h,
                    decoration: BoxDecoration(
                      color: AppTheme.darkTheme.colorScheme.onPrimary
                          .withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(0.5.h),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(2.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          color: AppTheme.darkTheme.colorScheme.primary
                              .withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 1.h,
                              decoration: BoxDecoration(
                                color: AppTheme.darkTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(0.5.h),
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Container(
                              width: 20.w,
                              height: 0.8.h,
                              decoration: BoxDecoration(
                                color: AppTheme.darkTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(0.4.h),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  // FIX: Added Expanded widgets to prevent overflow
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 2.h,
                          decoration: BoxDecoration(
                            color: AppTheme.darkTheme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(1.h),
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Container(
                          height: 2.h,
                          decoration: BoxDecoration(
                            color: AppTheme.darkTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(1.h),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}