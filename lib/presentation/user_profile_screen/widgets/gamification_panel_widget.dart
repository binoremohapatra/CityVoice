import 'package:flutter/material.dart';

class GamificationPanelWidget extends StatelessWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onViewLeaderboard;

  const GamificationPanelWidget({
    super.key,
    required this.userData,
    required this.onViewLeaderboard,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // --- FIX: Use ?? to provide default values ---
    final int currentXP = userData["currentXP"] ?? 0;
    final int nextLevelXP = userData["nextLevelXP"] ?? 3000;
    final double progress = (nextLevelXP > 0) ? currentXP / nextLevelXP : 0;

    // --- FIX: Safely cast list and provide empty list as default ---
    final List badges = userData["badges"] as List? ?? [];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your Progress', style: theme.textTheme.titleLarge),
          const SizedBox(height: 16),
          // XP Progress Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('XP', style: theme.textTheme.bodySmall),
              Text('$currentXP / $nextLevelXP', style: theme.textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: progress,
            borderRadius: BorderRadius.circular(5),
          ),
          const SizedBox(height: 24),
          // Badges Section
          Text('Badges (${badges.length})', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          SizedBox(
            height: 80,
            child: badges.isEmpty
                ? const Center(child: Text('No badges earned yet.'))
                : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: badges.length,
              itemBuilder: (context, index) {
                final badge = badges[index] as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Icon(
                          // Using a fallback icon
                          _getIconForName(badge['icon'] ?? 'star'),
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(badge['name'] ?? 'Badge', style: theme.textTheme.bodySmall),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper to map icon names to actual IconData
  IconData _getIconForName(String iconName) {
    switch (iconName) {
      case 'flag': return Icons.flag;
      case 'build': return Icons.build;
      case 'emoji_events': return Icons.emoji_events;
      case 'camera_alt': return Icons.camera_alt;
      default: return Icons.star;
    }
  }
}