import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StatusTimelineWidget extends StatefulWidget {
  final List<Map<String, dynamic>> timeline;

  const StatusTimelineWidget({
    Key? key,
    required this.timeline,
  }) : super(key: key);

  @override
  State<StatusTimelineWidget> createState() => _StatusTimelineWidgetState();
}

class _StatusTimelineWidgetState extends State<StatusTimelineWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int? _expandedIndex;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'submitted':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'under review':
        return const Color(0xFFF57C00);
      case 'in progress':
        return const Color(0xFFFF9800);
      case 'resolved':
        return AppTheme.lightTheme.colorScheme.secondary;
      default:
        return AppTheme.lightTheme.colorScheme.outline;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'submitted':
        return Icons.assignment_turned_in;
      case 'under review':
        return Icons.rate_review;
      case 'in progress':
        return Icons.construction;
      case 'resolved':
        return Icons.check_circle;
      default:
        return Icons.circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status Timeline',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
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
                children: List.generate(
                  widget.timeline.length,
                      (index) => _buildTimelineItem(index),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(int index) {
    final item = widget.timeline[index];
    final isLast = index == widget.timeline.length - 1;
    final isExpanded = _expandedIndex == index;
    final statusColor = _getStatusColor(item['status']);

    return GestureDetector(
      onTap: () {
        setState(() {
          _expandedIndex = isExpanded ? null : index;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: isLast ? 0 : 2.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 10.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: statusColor.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      _getStatusIcon(item['status']),
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 6.h,
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                  ),
              ],
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item['status'],
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        item['timestamp'],
                        style:
                        AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme
                              .lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    item['description'],
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      height: 1.4,
                    ),
                  ),
                  if (item['officialComment'] != null &&
                      item['officialComment'].isNotEmpty)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: isExpanded ? null : 0,
                      child: isExpanded
                          ? Container(
                        margin: EdgeInsets.only(top: 1.h),
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 3.w,
                                  backgroundImage: NetworkImage(
                                      item['officialAvatar']),
                                ),
                                SizedBox(width: 2.w),
                                Expanded(
                                  child: Text(
                                    item['officialName'],
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              item['officialComment'],
                              style: AppTheme
                                  .lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      )
                          : const SizedBox.shrink(),
                    ),
                  if (item['officialComment'] != null &&
                      item['officialComment'].isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _expandedIndex = isExpanded ? null : index;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 1.h),
                        child: Row(
                          children: [
                            Text(
                              isExpanded
                                  ? 'Show less'
                                  : 'View official comment',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 1.w),
                            CustomIconWidget(
                              iconName: isExpanded
                                  ? 'keyboard_arrow_up'
                                  : 'keyboard_arrow_down',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}