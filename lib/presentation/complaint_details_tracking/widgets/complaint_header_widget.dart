import 'package:flutter/material.dart';

class ComplaintHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> complaint;
  const ComplaintHeaderWidget({super.key, required this.complaint, required void Function() onShare});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            complaint['category'] ?? 'General',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            complaint['title'] ?? 'No Title',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            complaint['description'] ?? 'No description provided.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: theme.colorScheme.onSurface.withOpacity(0.6)),
              const SizedBox(width: 8),
              Text(
                "Submitted on ${complaint['submissionDate'] ?? 'N/A'}",
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}