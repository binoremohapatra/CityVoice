import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SettingsSectionWidget extends StatelessWidget {
  final String title;
  final List<SettingsItem> items;
  final EdgeInsetsGeometry? padding;

  const SettingsSectionWidget({
    super.key,
    required this.title,
    required this.items,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
            child: Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(3.w),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: theme.colorScheme.outline.withValues(alpha: 0.1),
                indent: 15.w,
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                return _buildSettingsItem(
                    context, item, index == 0, index == items.length - 1);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
      BuildContext context, SettingsItem item, bool isFirst, bool isLast) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.vertical(
          top: isFirst ? Radius.circular(3.w) : Radius.zero,
          bottom: isLast ? Radius.circular(3.w) : Radius.zero,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
          child: Row(
            children: [
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: item.iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: CustomIconWidget(
                  iconName: item.iconName,
                  color: item.iconColor,
                  size: 5.w,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: item.isDestructive
                            ? theme.colorScheme.error
                            : theme.colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.subtitle != null) ...[
                      SizedBox(height: 0.5.h),
                      Text(
                        item.subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: 2.w),
              _buildTrailingWidget(context, item),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrailingWidget(BuildContext context, SettingsItem item) {
    final theme = Theme.of(context);

    switch (item.type) {
      case SettingsItemType.toggle:
        return Switch(
          value: item.value as bool? ?? false,
          onChanged: item.onChanged as void Function(bool)?,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );
      case SettingsItemType.disclosure:
        return CustomIconWidget(
          iconName: 'arrow_forward_ios',
          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          size: 4.w,
        );
      case SettingsItemType.value:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.value != null) ...[
              Text(
                item.value.toString(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              SizedBox(width: 2.w),
            ],
            CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              size: 4.w,
            ),
          ],
        );
      case SettingsItemType.action:
      default:
        return SizedBox.shrink();
    }
  }
}

class SettingsItem {
  final String title;
  final String? subtitle;
  final String iconName;
  final Color iconColor;
  final SettingsItemType type;
  final dynamic value;
  final VoidCallback? onTap;
  final Function(dynamic)? onChanged;
  final bool isDestructive;

  const SettingsItem({
    required this.title,
    this.subtitle,
    required this.iconName,
    required this.iconColor,
    this.type = SettingsItemType.disclosure,
    this.value,
    this.onTap,
    this.onChanged,
    this.isDestructive = false,
  });
}

enum SettingsItemType {
  disclosure,
  toggle,
  value,
  action,
}
