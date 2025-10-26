import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CivicEngagementBannerWidget extends StatelessWidget {
  final int engagementScore;
  final List<Map<String, dynamic>> badges;
  final VoidCallback onTap;

  const CivicEngagementBannerWidget({
    Key? key,
    required this.engagementScore,
    required this.badges,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.lightTheme.colorScheme.primary,
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Civic Engagement Score',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      Text(
                        engagementScore.toString(),
                        style: AppTheme.lightTheme.textTheme.headlineMedium
                            ?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      CustomIconWidget(
                        iconName: 'trending_up',
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        size: 6.w,
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Keep making a difference!',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 4.w),
            Column(
              children: [
                Text(
                  'Recent Badges',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                SizedBox(height: 1.h),
                SizedBox(
                  height: 8.h,
                  width: 20.w,
                  child: badges.isNotEmpty
                      ? ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: badges.length > 3 ? 3 : badges.length,
                    itemBuilder: (context, index) {
                      final badge = badges[index]
                      as Map<String, dynamic>;
                      return Container(
                        margin: EdgeInsets.only(right: 1.w),
                        child: Column(
                          children: [
                            Container(
                              width: 6.w,
                              height: 6.w,
                              decoration: BoxDecoration(
                                color:
                                Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  badge['icon'] as String,
                                  style: TextStyle(fontSize: 4.w),
                                ),
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              badge['name'] as String,
                              style: AppTheme
                                  .lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 8.sp,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  )
                      : Center(
                    child: Text(
                      'No badges yet',
                      style: AppTheme.lightTheme.textTheme.bodySmall
                          ?.copyWith(
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}