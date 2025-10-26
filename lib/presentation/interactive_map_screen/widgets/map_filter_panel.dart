import 'package:flutter/material.dart';

class MapFilterPanel extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final ValueChanged<Map<String, dynamic>> onFiltersChanged;

  const MapFilterPanel({
    super.key,
    required this.currentFilters,
    required this.onFiltersChanged,
  });

  @override
  State<MapFilterPanel> createState() => _MapFilterPanelState();
}

class _MapFilterPanelState extends State<MapFilterPanel> {
  late Set<String> _selectedStatuses;

  @override
  void initState() {
    super.initState();
    _selectedStatuses = Set<String>.from(widget.currentFilters['statuses'] ?? {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center( /* ... Drag handle ... */ ),
          Text('Filter by Status', style: theme.textTheme.titleLarge),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8.0,
            children: ['open', 'in_progress', 'resolved'].map((status) {
              final isSelected = _selectedStatuses.contains(status);
              return FilterChip(
                label: Text(status),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedStatuses.add(status);
                    } else {
                      _selectedStatuses.remove(status);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onFiltersChanged({'statuses': _selectedStatuses.toList()});
              },
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }
}