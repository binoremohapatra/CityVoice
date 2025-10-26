import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LocationSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;
  final Function(String) onChanged;

  const LocationSearchBar({
    Key? key,
    required this.controller,
    required this.onSearch,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10.w),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: theme.colorScheme.onSurfaceVariant,
            size: 6.w,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              onSubmitted: (_) => onSearch(),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Search location...',
                hintStyle: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                border: InputBorder.none,
              ),
              style: theme.textTheme.bodyLarge,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: theme.colorScheme.primary,
              size: 6.w,
            ),
            onPressed: onSearch,
          ),
        ],
      ),
    );
  }
}