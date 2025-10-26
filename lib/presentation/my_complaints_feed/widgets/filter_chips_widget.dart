import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterChipsWidget extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;
  final Map<String, int> filterCounts;

  const FilterChipsWidget({
    Key? key,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.filterCounts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> filters = [
      {'key': 'all', 'label': 'All', 'icon': 'list'},
      {'key': 'active', 'label': 'Active', 'icon': 'pending_actions'},
      {'key': 'resolved', 'label': 'Resolved', 'icon': 'check_circle'},
      {'key': 'archived', 'label': 'Archived', 'icon': 'archive'},
    ];

    return Container(
      height: 6.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (context, index) => SizedBox(width: 2.w),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final String filterKey = filter['key'] as String;
          final String filterLabel = filter['label'] as String;
          final String filterIcon = filter['icon'] as String;
          final bool isSelected = selectedFilter == filterKey;
          final int count = filterCounts[filterKey] ?? 0;

          return GestureDetector(
            onTap: () => onFilterChanged(filterKey),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  width: 1,
                ),
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: filterIcon,
                    color: isSelected
                        ? Colors.white
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 16.sp,
                  ),
                  SizedBox(width: 1.5.w),
                  Text(
                    filterLabel,
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: isSelected
                          ? Colors.white
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 12.sp,
                    ),
                  ),
                  if (count > 0) ...[
                    SizedBox(width: 1.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 1.5.w, vertical: 0.2.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.2)
                            : AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        count.toString(),
                        style:
                        AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: isSelected
                              ? Colors.white
                              : AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
