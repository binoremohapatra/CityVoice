import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RelatedComplaintsSection extends StatelessWidget {
  final List<Map<String, dynamic>> relatedComplaints;
  final Function(Map<String, dynamic>)? onComplaintTap;

  const RelatedComplaintsSection({
    super.key,
    required this.relatedComplaints,
    this.onComplaintTap,
  });

  @override
  Widget build(BuildContext context) {
    if (relatedComplaints.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'link',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Related Complaints',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '${relatedComplaints.length} nearby',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 25.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              itemCount: relatedComplaints.length,
              itemBuilder: (context, index) {
                return _buildRelatedComplaintCard(
                    relatedComplaints[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedComplaintCard(Map<String, dynamic> complaint, int index) {
    return GestureDetector(
      onTap: () => onComplaintTap?.call(complaint),
      child: Container(
        width: 70.w,
        margin: EdgeInsets.only(right: 4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.lightTheme.colorScheme.outline
                .withValues(alpha: 0.2),
          ),
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
            _buildCardHeader(complaint),
            _buildCardContent(complaint),
            _buildCardFooter(complaint),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader(Map<String, dynamic> complaint) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: _getStatusColor(complaint['status'] as String? ?? 'pending')
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 2.w,
                  height: 2.w,
                  decoration: BoxDecoration(
                    color: _getStatusColor(
                        complaint['status'] as String? ?? 'pending'),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 1.w),
                Text(
                  _getStatusLabel(complaint['status'] as String? ?? 'pending'),
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: _getStatusColor(
                        complaint['status'] as String? ?? 'pending'),
                    fontWeight: FontWeight.w600,
                    fontSize: 9.sp,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Text(
            '${complaint['distance'] ?? '0.0'} km',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.6),
              fontSize: 9.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardContent(Map<String, dynamic> complaint) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              complaint['title'] as String? ?? 'Untitled Complaint',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 1.h),
            Text(
              complaint['description'] as String? ?? 'No description available',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.7),
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'location_on',
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                  size: 14,
                ),
                SizedBox(width: 1.w),
                Expanded(
                  child: Text(
                    complaint['location'] as String? ??
                        'Location not specified',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                      fontSize: 9.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardFooter(Map<String, dynamic> complaint) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Row(
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
            ),
            child: ClipOval(
              child: CustomImageWidget(
                imageUrl: complaint['reporterAvatar'] as String? ??
                    'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=100',
                width: 6.w,
                height: 6.w,
                fit: BoxFit.cover,
                semanticLabel: complaint['reporterSemanticLabel'] as String? ??
                    'Profile photo of complaint reporter',
              ),
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  complaint['reporterName'] as String? ?? 'Anonymous',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 9.sp,
                  ),
                ),
                Text(
                  complaint['submittedDate'] as String? ?? 'Unknown date',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                    fontSize: 8.sp,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color:
              _getCategoryColor(complaint['category'] as String? ?? 'other')
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              complaint['category'] as String? ?? 'Other',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: _getCategoryColor(
                    complaint['category'] as String? ?? 'other'),
                fontWeight: FontWeight.w500,
                fontSize: 8.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'in_progress':
        return Colors.blue;
      case 'resolved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return AppTheme.lightTheme.colorScheme.outline;
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'in_progress':
        return 'In Progress';
      case 'resolved':
        return 'Resolved';
      case 'rejected':
        return 'Rejected';
      default:
        return 'Unknown';
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'roads':
        return Colors.brown;
      case 'water':
        return Colors.blue;
      case 'electricity':
        return Colors.yellow.shade700;
      case 'waste':
        return Colors.green;
      case 'safety':
        return Colors.red;
      case 'parks':
        return Colors.green.shade700;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }
}