import 'package:flutter/material.dart';

class MapSearchBar extends StatelessWidget {
  final VoidCallback onFilterTap;
  final VoidCallback onSearchTap;

  const MapSearchBar({
    super.key,
    required this.onFilterTap,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(30),
        shadowColor: theme.shadowColor.withOpacity(0.2),
        child: InkWell(
          onTap: onSearchTap,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                Icon(Icons.search, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Search for a location...',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ),
                const SizedBox(height: 24, child: VerticalDivider()),
                IconButton(
                  onPressed: onFilterTap,
                  icon: Icon(Icons.tune, color: theme.colorScheme.primary),
                  tooltip: 'Filter',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}