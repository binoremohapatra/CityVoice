import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class NotificationCardWidget extends StatelessWidget {
  final Map<String, dynamic> notification;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const NotificationCardWidget({
    super.key,
    required this.notification,
    this.onTap,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRead = notification['isRead'] as bool? ?? false;
    final isEmergency = notification['type'] == 'emergency';
    final timestamp = notification['timestamp'] as DateTime;
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    return Dismissible(
      key: Key(notification['id'].toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 4.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.error,
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomIconWidget(
          iconName: 'delete',
          color: theme.colorScheme.onError,
          size: 24,
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: isEmergency
                    ? theme.colorScheme.error.withValues(alpha: 0.05)
                    : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isEmergency
                      ? theme.colorScheme.error.withValues(alpha: 0.3)
                      : theme.colorScheme.outline.withValues(alpha: 0.1),
                  width: isEmergency ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNotificationIcon(theme, isEmergency),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                notification['title'] as String,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: isRead
                                      ? FontWeight.w500
                                      : FontWeight.w600,
                                  color: isEmergency
                                      ? theme.colorScheme.error
                                      : theme.colorScheme.onSurface,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (!isRead) ...[
                              SizedBox(width: 2.w),
                              Container(
                                width: 2.w,
                                height: 2.w,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          notification['message'] as String,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          _formatTimestamp(difference),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isEmergency)
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'URGENT',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onError,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(ThemeData theme, bool isEmergency) {
    final type = notification['type'] as String;
    String iconName;
    Color iconColor;

    switch (type) {
      case 'complaint_update':
        iconName = 'assignment';
        iconColor = theme.colorScheme.primary;
        break;
      case 'community_achievement':
        iconName = 'emoji_events';
        iconColor = Colors.amber;
        break;
      case 'authority_response':
        iconName = 'support_agent';
        iconColor = theme.colorScheme.secondary;
        break;
      case 'system_message':
        iconName = 'info';
        iconColor = theme.colorScheme.tertiary;
        break;
      case 'emergency':
        iconName = 'warning';
        iconColor = theme.colorScheme.error;
        break;
      default:
        iconName = 'notifications';
        iconColor = theme.colorScheme.onSurface.withValues(alpha: 0.6);
    }

    return Container(
      width: 10.w,
      height: 10.w,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: CustomIconWidget(
          iconName: iconName,
          color: iconColor,
          size: 20,
        ),
      ),
    );
  }

  String _formatTimestamp(Duration difference) {
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${(difference.inDays / 7).floor()}w ago';
    }
  }
}
