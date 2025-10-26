import 'package:flutter/material.dart';

class FloatingActionButtons extends StatelessWidget {
  final VoidCallback onCurrentLocation;
  final VoidCallback onToggleMapType;
  final VoidCallback onReportIssue;
  final bool isMapTypeNormal;
  final bool isLocationLoading;

  const FloatingActionButtons({
    super.key,
    required this.onCurrentLocation,
    required this.onToggleMapType,
    required this.onReportIssue,
    required this.isMapTypeNormal,
    required this.isLocationLoading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: 'location_fab',
          onPressed: onCurrentLocation,
          backgroundColor: theme.colorScheme.surface,
          child: isLocationLoading
              ? const CircularProgressIndicator(strokeWidth: 2)
              : Icon(Icons.my_location, color: theme.colorScheme.primary),
        ),
        const SizedBox(height: 16),
        FloatingActionButton(
          heroTag: 'map_type_fab',
          onPressed: onToggleMapType,
          backgroundColor: theme.colorScheme.surface,
          child: Icon(
            isMapTypeNormal ? Icons.satellite_alt : Icons.map,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        FloatingActionButton.extended(
          heroTag: 'report_fab',
          onPressed: onReportIssue,
          icon: const Icon(Icons.add),
          label: const Text('Report Issue'),
        ),
      ],
    );
  }
}