import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

class ComplaintPreviewSheet extends StatelessWidget {
  final Map<String, dynamic> complaint;
  final VoidCallback onViewDetails;

  const ComplaintPreviewSheet({
    super.key,
    required this.complaint,
    required this.onViewDetails,
  });

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
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(complaint['title'], style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(complaint['description'], style: theme.textTheme.bodyMedium, maxLines: 3),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onViewDetails,
              child: const Text('View Full Details'),
            ),
          ),
        ],
      ),
    );
  }
}