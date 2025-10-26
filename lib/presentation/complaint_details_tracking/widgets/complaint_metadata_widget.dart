import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ComplaintMetadataWidget extends StatelessWidget {
  final Map<String, dynamic> complaint;

  const ComplaintMetadataWidget({
    Key? key,
    required this.complaint,
  }) : super(key: key);

  Color _getUrgencyColor(String urgency) {
    switch (urgency.toLowerCase()) {
      case 'high':
        return AppTheme.lightTheme.colorScheme.error;
      case 'medium':
        return const Color(0xFFF57C00);
      case 'low':
        return AppTheme.lightTheme.colorScheme.secondary;
      default:
        return AppTheme.lightTheme.colorScheme.outline;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'road maintenance':
        return const Color(0xFF795548);
      case 'water supply':
        return const Color(0xFF2196F3);
      case 'waste management':
        return const Color(0xFF4CAF50);
      case 'street lighting':
        return const Color(0xFFFF9800);
      case 'public safety':
        return const Color(0xFFF44336);
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            complaint['title'],
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: _getCategoryColor(complaint['category'])
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _getCategoryColor(complaint['category']),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'category',
                      color: _getCategoryColor(complaint['category']),
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      complaint['category'],
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: _getCategoryColor(complaint['category']),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 3.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: _getUrgencyColor(complaint['urgency'])
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _getUrgencyColor(complaint['urgency']),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'priority_high',
                      color: _getUrgencyColor(complaint['urgency']),
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      '${complaint['urgency']} Priority',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: _getUrgencyColor(complaint['urgency']),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            complaint['description'],
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'access_time',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text(
                'Submitted on ${complaint['submissionDate']}',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
