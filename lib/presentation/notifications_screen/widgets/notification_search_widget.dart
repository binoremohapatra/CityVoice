import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class NotificationSearchWidget extends StatefulWidget {
  final ValueChanged<String> onSearchChanged;
  final List<String> recentSearches;
  final VoidCallback? onClearRecentSearches;

  const NotificationSearchWidget({
    super.key,
    required this.onSearchChanged,
    required this.recentSearches,
    this.onClearRecentSearches,
  });

  @override
  State<NotificationSearchWidget> createState() =>
      _NotificationSearchWidgetState();
}

class _NotificationSearchWidgetState extends State<NotificationSearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isSearchActive = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isSearchActive = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isSearchActive
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline.withValues(alpha: 0.3),
              width: _isSearchActive ? 2 : 1,
            ),
            boxShadow: _isSearchActive
                ? [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ]
                : null,
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _focusNode,
            onChanged: widget.onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search notifications...',
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'search',
                  color: _isSearchActive
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  size: 20,
                ),
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                onPressed: () {
                  _searchController.clear();
                  widget.onSearchChanged('');
                },
                icon: CustomIconWidget(
                  iconName: 'clear',
                  color:
                  theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  size: 20,
                ),
              )
                  : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 2.h),
            ),
          ),
        ),
        if (_isSearchActive && widget.recentSearches.isNotEmpty)
          _buildRecentSearches(theme),
      ],
    );
  }

  Widget _buildRecentSearches(ThemeData theme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Searches',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              GestureDetector(
                onTap: widget.onClearRecentSearches,
                child: Text(
                  'Clear All',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: widget.recentSearches.map((search) {
              return GestureDetector(
                onTap: () {
                  _searchController.text = search;
                  widget.onSearchChanged(search);
                  _focusNode.unfocus();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'history',
                        color: theme.colorScheme.primary,
                        size: 14,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        search,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
