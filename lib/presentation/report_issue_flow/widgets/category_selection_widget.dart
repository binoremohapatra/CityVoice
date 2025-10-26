import 'package:flutter/material.dart';

class CategorySelectionWidget extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategorySelectionWidget({
    super.key,
    this.selectedCategory,
    required this.onCategorySelected,
  });

  // Data for the category cards
  static final List<Map<String, String>> _categories = [
    {
      'name': 'Roads & Infrastructure',
      'icon': 'construction',
      'description': 'Potholes, broken roads, traffic signals',
    },
    {
      'name': 'Utilities',
      'icon': 'electrical_services',
      'description': 'Water leaks, power outages, gas issues',
    },
    {
      'name': 'Public Safety',
      'icon': 'security',
      'description': 'Broken street lights, safety concerns',
    },
    {
      'name': 'Waste & Environment',
      'icon': 'recycling',
      'description': 'Overflowing bins, pollution, dumping',
    },
    {
      'name': 'Public Transport',
      'icon': 'directions_bus',
      'description': 'Bus stops, metro station issues',
    },
    {
      'name': 'Parks & Recreation',
      'icon': 'park',
      'description': 'Playgrounds, gardens, sports facilities',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 1: Select Category',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Choose the category that best describes the issue to help us route it to the correct department.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = selectedCategory == category['name'];
              return _buildCategoryCard(context, theme, category, isSelected);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
      BuildContext context,
      ThemeData theme,
      Map<String, String> category,
      bool isSelected,
      ) {
    return GestureDetector(
      onTap: () => onCategorySelected(category['name']!),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primaryContainer.withOpacity(0.5)
              : theme.colorScheme.surfaceVariant.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withOpacity(0.5),
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              // A simple helper to get IconData from a String
              _getIconForName(category['icon']!),
              size: 40,
              color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
            ),
            const Spacer(),
            Text(
              category['name']!,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              category['description']!,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to map string names to IconData
  IconData _getIconForName(String name) {
    switch (name) {
      case 'construction': return Icons.construction;
      case 'electrical_services': return Icons.electrical_services;
      case 'security': return Icons.security;
      case 'recycling': return Icons.recycling;
      case 'directions_bus': return Icons.directions_bus;
      case 'park': return Icons.park;
      default: return Icons.help_outline;
    }
  }
}