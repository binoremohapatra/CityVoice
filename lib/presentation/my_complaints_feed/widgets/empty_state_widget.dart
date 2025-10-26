import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onReportFirstIssue;

  const EmptyStateWidget({
    Key? key,
    required this.onReportFirstIssue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'report_problem',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20.w,
              ),
            ),
            SizedBox(height: 4.h),
            // Title
            Text(
              'No Complaints Yet',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 20.sp,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            // Description
            Text(
              'Start making a difference in your community by reporting your first civic issue. Every report helps build a better neighborhood.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            // Call to action button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onReportFirstIssue,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'add_circle',
                      color: Colors.white,
                      size: 20.sp,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Report First Issue',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 3.h),
            // Secondary action
            TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, '/citizen-dashboard'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'explore',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 18.sp,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Explore Community Issues',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 6.h),
            // Motivational stats
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.secondary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.secondary
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'groups',
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        size: 20.sp,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Community Impact',
                        style:
                        AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                          color: AppTheme.lightTheme.colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildImpactStat('1,247', 'Issues Resolved'),
                      _buildImpactStat('89%', 'Success Rate'),
                      _buildImpactStat('3.2 days', 'Avg Response'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImpactStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
            color: AppTheme.lightTheme.colorScheme.secondary,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            fontSize: 10.sp,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
