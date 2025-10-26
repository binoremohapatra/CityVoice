import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ComplaintCardWidget extends StatelessWidget {
  final Map<String, dynamic> complaint;
  final VoidCallback onTap;
  final VoidCallback onShare;
  final VoidCallback onAddUpdate;
  final VoidCallback onMarkResolved;
  final VoidCallback onArchive;

  const ComplaintCardWidget({
    Key? key,
    required this.complaint,
    required this.onTap,
    required this.onShare,
    required this.onAddUpdate,
    required this.onMarkResolved,
    required this.onArchive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String status = complaint['status'] ?? 'pending';
    final Color statusColor = _getStatusColor(status);
    final String urgency = complaint['urgency'] ?? 'medium';
    final double progress = (complaint['progress'] as num?)?.toDouble() ?? 0.0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Slidable(
        key: ValueKey(complaint['id']),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onShare(),
              backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
              foregroundColor: Colors.white,
              icon: Icons.share,
              label: 'Share',
              borderRadius: BorderRadius.circular(8),
            ),
            SlidableAction(
              onPressed: (_) => onAddUpdate(),
              backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
              foregroundColor: Colors.white,
              icon: Icons.add_comment,
              label: 'Update',
              borderRadius: BorderRadius.circular(8),
            ),
            if (status != 'resolved')
              SlidableAction(
                onPressed: (_) => onMarkResolved(),
                backgroundColor: AppTheme.successLight,
                foregroundColor: Colors.white,
                icon: Icons.check_circle,
                label: 'Resolve',
                borderRadius: BorderRadius.circular(8),
              ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onArchive(),
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
              foregroundColor: Colors.white,
              icon: Icons.archive,
              label: 'Archive',
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
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
                // Header with image and urgency indicator
                Container(
                  height: 20.h,
                  decoration: BoxDecoration(
                    borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                    color: AppTheme.lightTheme.colorScheme.surface,
                  ),
                  child: Stack(
                    children: [
                      // Complaint image
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12)),
                        child: CustomImageWidget(
                          imageUrl: complaint['image'] ?? '',
                          width: double.infinity,
                          height: 20.h,
                          fit: BoxFit.cover,
                          semanticLabel: complaint['semanticLabel'] ??
                              'Complaint image showing reported issue',
                        ),
                      ),
                      // Urgency indicator
                      Positioned(
                        top: 2.h,
                        right: 4.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: _getUrgencyColor(urgency),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            urgency.toUpperCase(),
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      ),
                      // Status badge
                      Positioned(
                        top: 2.h,
                        left: 4.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconWidget(
                                iconName: _getStatusIcon(status),
                                color: Colors.white,
                                size: 12.sp,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                status.toUpperCase(),
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Content section
                Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and category
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              complaint['title'] ?? 'Untitled Complaint',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              complaint['category'] ?? 'General',
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                                fontSize: 10.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      // Description
                      Text(
                        complaint['description'] ?? 'No description available',
                        style:
                        AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          fontSize: 12.sp,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 1.5.h),
                      // Location and date
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'location_on',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 14.sp,
                          ),
                          SizedBox(width: 1.w),
                          Expanded(
                            child: Text(
                              complaint['location'] ?? 'Location not specified',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                fontSize: 11.sp,
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            _formatDate(complaint['submittedDate']),
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              fontSize: 11.sp,
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.5.h),
                      // Progress bar for active issues
                      if (status == 'in_progress' ||
                          status == 'under_review') ...[
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Progress',
                                        style: AppTheme
                                            .lightTheme.textTheme.labelSmall
                                            ?.copyWith(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '${(progress * 100).toInt()}%',
                                        style: AppTheme
                                            .lightTheme.textTheme.labelSmall
                                            ?.copyWith(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w600,
                                          color: statusColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 0.5.h),
                                  LinearProgressIndicator(
                                    value: progress,
                                    backgroundColor: AppTheme
                                        .lightTheme.colorScheme.outline
                                        .withValues(alpha: 0.2),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        statusColor),
                                    minHeight: 0.8.h,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                      ],
                      // Estimated resolution time
                      if (complaint['estimatedResolution'] != null) ...[
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'schedule',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 14.sp,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              'Est. resolution: ${complaint['estimatedResolution']}',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                fontSize: 11.sp,
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'resolved':
        return AppTheme.successLight;
      case 'in_progress':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'under_review':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'rejected':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return AppTheme.warningLight;
    }
  }

  Color _getUrgencyColor(String urgency) {
    switch (urgency.toLowerCase()) {
      case 'high':
        return AppTheme.lightTheme.colorScheme.error;
      case 'medium':
        return AppTheme.warningLight;
      case 'low':
        return AppTheme.lightTheme.colorScheme.secondary;
      default:
        return AppTheme.warningLight;
    }
  }

  String _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'resolved':
        return 'check_circle';
      case 'in_progress':
        return 'hourglass_empty';
      case 'under_review':
        return 'visibility';
      case 'rejected':
        return 'cancel';
      default:
        return 'pending';
    }
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'Unknown';

    try {
      DateTime dateTime;
      if (date is String) {
        dateTime = DateTime.parse(date);
      } else if (date is DateTime) {
        dateTime = date;
      } else {
        return 'Unknown';
      }

      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Unknown';
    }
  }
}
