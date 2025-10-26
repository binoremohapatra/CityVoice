import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class EmptyNotificationsWidget extends StatelessWidget {
  final VoidCallback? onEnableNotifications;

  const EmptyNotificationsWidget({
    super.key,
    this.onEnableNotifications,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'notifications_off',
                  color: theme.colorScheme.primary,
                  size: 60,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'No Notifications Yet',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'Stay connected with your community! Enable notifications to receive updates about your complaints, community activities, and important civic announcements.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            ElevatedButton.icon(
              onPressed: onEnableNotifications,
              icon: CustomIconWidget(
                iconName: 'notifications_active',
                color: theme.colorScheme.onPrimary,
                size: 20,
              ),
              label: Text('Enable Notifications'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/interactive-map-screen');
              },
              child: Text('Explore Community Map'),
            ),
          ],
        ),
      ),
    );
  }
}
