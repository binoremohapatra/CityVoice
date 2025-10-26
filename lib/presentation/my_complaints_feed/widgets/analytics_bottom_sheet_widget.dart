import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AnalyticsBottomSheetWidget extends StatelessWidget {
  final Map<String, dynamic> analyticsData;

  const AnalyticsBottomSheetWidget({
    Key? key,
    required this.analyticsData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 3.h),
          // Title
          Row(
            children: [
              CustomIconWidget(
                iconName: 'analytics',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24.sp,
              ),
              SizedBox(width: 3.w),
              Text(
                'Your Civic Impact',
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          // Statistics grid
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Submitted',
                  (analyticsData['totalSubmitted'] ?? 0).toString(),
                  'description',
                  AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildStatCard(
                  'Resolved',
                  (analyticsData['resolvedCount'] ?? 0).toString(),
                  'check_circle',
                  AppTheme.successLight,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Avg. Resolution',
                  analyticsData['avgResolutionTime'] ?? '0 days',
                  'schedule',
                  AppTheme.warningLight,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildStatCard(
                  'Civic Score',
                  (analyticsData['civicScore'] ?? 0).toString(),
                  'star',
                  AppTheme.lightTheme.colorScheme.tertiary,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          // Achievement badges section
          Text(
            'Achievement Badges',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            height: 12.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: (analyticsData['badges'] as List?)?.length ?? 0,
              separatorBuilder: (context, index) => SizedBox(width: 3.w),
              itemBuilder: (context, index) {
                final badge = (analyticsData['badges'] as List)[index]
                as Map<String, dynamic>;
                return _buildBadgeCard(badge);
              },
            ),
          ),
          SizedBox(height: 3.h),
          // Monthly stats
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'calendar_month',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20.sp,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'This Month\'s Activity',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMonthlyStatItem(
                      'Reports Filed',
                      (analyticsData['monthlyReports'] ?? 0).toString(),
                    ),
                    _buildMonthlyStatItem(
                      'Issues Resolved',
                      (analyticsData['monthlyResolved'] ?? 0).toString(),
                    ),
                    _buildMonthlyStatItem(
                      'Community Rank',
                      '#${analyticsData['communityRank'] ?? 'N/A'}',
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          // Close button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Close',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, String iconName, Color color) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: color,
                size: 20.sp,
              ),
              const Spacer(),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 20.sp,
              color: color,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontSize: 11.sp,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeCard(Map<String, dynamic> badge) {
    return Container(
      width: 20.w,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: badge['icon'] ?? 'star',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 18.sp,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            badge['name'] ?? 'Badge',
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
            color: AppTheme.lightTheme.colorScheme.primary,
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
