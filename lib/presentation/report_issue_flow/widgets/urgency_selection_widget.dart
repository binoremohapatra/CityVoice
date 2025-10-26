import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/services.dart';

import '../../../core/app_export.dart';

class UrgencySelectionWidget extends StatelessWidget {
  final String? selectedUrgency;
  final Function(String) onUrgencySelected;

  const UrgencySelectionWidget({
    Key? key,
    this.selectedUrgency,
    required this.onUrgencySelected,
  }) : super(key: key);

  final List<Map<String, dynamic>> urgencyLevels = const [
    {
      'level': 'Low',
      'description': 'Minor issues that can wait for regular maintenance.',
      'color': Colors.green,
      'icon': 'info',
    },
    {
      'level': 'Medium',
      'description': 'Issues that need attention within a few days.',
      'color': Colors.orange,
      'icon': 'warning',
    },
    {
      'level': 'High',
      'description': 'Important issues requiring prompt action.',
      'color': Colors.red,
      'icon': 'priority_high',
    },
    {
      'level': 'Emergency',
      'description': 'Critical issues requiring immediate attention.',
      'color': Colors.red,
      'icon': 'emergency',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 4: Select Urgency',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Help us prioritize your issue by selecting the appropriate urgency level.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: urgencyLevels.length,
            itemBuilder: (context, index) {
              final urgency = urgencyLevels[index];
              final isSelected = selectedUrgency == urgency['level'];
              final urgencyColor = urgency['color'] as Color;

              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onUrgencySelected(urgency['level'] as String);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  margin: EdgeInsets.only(bottom: 2.h),
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? urgencyColor.withOpacity(0.1)
                        : theme.colorScheme.surface,
                    border: Border.all(
                      color: isSelected ? urgencyColor : theme.colorScheme.outline.withOpacity(0.5),
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected
                            ? urgencyColor.withOpacity(0.2)
                            : theme.shadowColor.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          color: urgencyColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomIconWidget(
                          iconName: urgency['icon'] as String,
                          color: Colors.white,
                          size: 6.w,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              urgency['level'] as String,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isSelected ? urgencyColor : theme.colorScheme.onSurface,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              urgency['description'] as String,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: isSelected ? Colors.white70 : theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        AnimatedScale(
                          duration: const Duration(milliseconds: 200),
                          scale: isSelected ? 1.0 : 0.0,
                          child: CustomIconWidget(
                            iconName: 'check_circle',
                            color: urgencyColor,
                            size: 5.w,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}