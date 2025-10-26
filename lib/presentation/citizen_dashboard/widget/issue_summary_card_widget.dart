import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class IssueSummaryCardWidget extends StatelessWidget {
  final Map<String, dynamic> issue;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const IssueSummaryCardWidget({
    Key? key,
    required this.issue,
    required this.onTap,
    required this.onDismiss,
  }) : super(key: key);

  Color _getStatusColor() {
    switch ((issue['status'] as String).toLowerCase()) {
      case 'urgent':
        return AppTheme.lightTheme.colorScheme.error;
      case 'in-progress':
        return const Color(0xFFF57C00);
      case 'resolved':
        return AppTheme.lightTheme.colorScheme.secondary;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  String _getStatusIcon() {
    switch ((issue['status'] as String).toLowerCase()) {
      case 'urgent':
        return 'warning';
      case 'in-progress':
        return 'schedule';
      case 'resolved':
        return 'check_circle';
      default:
        return 'info';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: _getStatusIcon(),
                    color: _getStatusColor(),
                    size: 5.w,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        issue['type'] as String,
                        style: AppTheme.lightTheme.textTheme.titleMedium
                            ?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'location_on',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 4.w,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '${issue['distance']} away',
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: _getStatusColor(),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    issue['status'] as String,
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              issue['description'] as String,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (issue['images'] != null &&
                (issue['images'] as List).isNotEmpty) ...[
              SizedBox(height: 2.h),
              SizedBox(
                height: 8.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: (issue['images'] as List).length,
                  itemBuilder: (context, index) {
                    final imageData = (issue['images'] as List)[index]
                    as Map<String, dynamic>;
                    return Container(
                      margin: EdgeInsets.only(right: 2.w),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CustomImageWidget(
                          imageUrl: imageData['url'] as String,
                          width: 12.w,
                          height: 8.h,
                          fit: BoxFit.cover,
                          semanticLabel: imageData['semanticLabel'] as String,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Reported ${issue['timeAgo']}',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme
                        .lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (issue['timeline'] != null &&
                    (issue['timeline'] as List).isNotEmpty)
                  Text(
                    'Updated ${(issue['timeline'] as List).last['timeAgo']}',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: _getStatusColor(),
                      fontWeight: FontWeight.w500,
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