import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class NotificationSettingsWidget extends StatefulWidget {
  final Map<String, bool> settings;
  final ValueChanged<Map<String, bool>> onSettingsChanged;

  const NotificationSettingsWidget({
    super.key,
    required this.settings,
    required this.onSettingsChanged,
  });

  @override
  State<NotificationSettingsWidget> createState() =>
      _NotificationSettingsWidgetState();
}

class _NotificationSettingsWidgetState
    extends State<NotificationSettingsWidget> {
  late Map<String, bool> _currentSettings;

  @override
  void initState() {
    super.initState();
    _currentSettings = Map.from(widget.settings);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10.w,
            height: 0.5.h,
            margin: EdgeInsets.only(top: 2.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notification Settings',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 3.h),
                _buildSettingTile(
                  theme,
                  'Push Notifications',
                  'Receive notifications on your device',
                  'notifications',
                  'pushNotifications',
                ),
                _buildSettingTile(
                  theme,
                  'Complaint Updates',
                  'Get notified about your complaint status',
                  'assignment',
                  'complaintUpdates',
                ),
                _buildSettingTile(
                  theme,
                  'Community Updates',
                  'Stay informed about community activities',
                  'groups',
                  'communityUpdates',
                ),
                _buildSettingTile(
                  theme,
                  'System Messages',
                  'Important system announcements',
                  'info',
                  'systemMessages',
                ),
                _buildSettingTile(
                  theme,
                  'Emergency Alerts',
                  'Critical emergency notifications',
                  'warning',
                  'emergencyAlerts',
                ),
                SizedBox(height: 2.h),
                _buildQuietHoursSection(theme),
                SizedBox(height: 2.h),
                _buildSoundSection(theme),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onSettingsChanged(_currentSettings);
                          Navigator.pop(context);
                        },
                        child: Text('Save Settings'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(
      ThemeData theme,
      String title,
      String subtitle,
      String iconName,
      String settingKey,
      ) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: iconName,
                color: theme.colorScheme.primary,
                size: 20,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _currentSettings[settingKey] ?? true,
            onChanged: (value) {
              setState(() {
                _currentSettings[settingKey] = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuietHoursSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quiet Hours',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'bedtime',
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                size: 20,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  '10:00 PM - 8:00 AM',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              Switch(
                value: _currentSettings['quietHours'] ?? false,
                onChanged: (value) {
                  setState(() {
                    _currentSettings['quietHours'] = value;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSoundSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sound & Vibration',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'volume_up',
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Notification Sound',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  Switch(
                    value: _currentSettings['notificationSound'] ?? true,
                    onChanged: (value) {
                      setState(() {
                        _currentSettings['notificationSound'] = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'vibration',
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Vibration',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  Switch(
                    value: _currentSettings['vibration'] ?? true,
                    onChanged: (value) {
                      setState(() {
                        _currentSettings['vibration'] = value;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
