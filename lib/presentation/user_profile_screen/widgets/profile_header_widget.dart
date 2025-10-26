import 'package:flutter/material.dart';
import '../../../widgets/custom_image_widget.dart'; // Ensure this path is correct

class ProfileHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onEditProfile;
  final VoidCallback onCameraPressed;

  const ProfileHeaderWidget({
    super.key,
    required this.userData,
    required this.onEditProfile,
    required this.onCameraPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // --- FIX: Use ?? to provide default values ---
    final String name = userData["name"] ?? 'Unnamed User';
    final String email = userData["email"] ?? 'No email provided';
    final String avatarUrl = userData["avatar"] ?? ''; // Use empty string for no image
    final int level = userData["level"] ?? 1;
    final String complaints = (userData["complaintsSubmitted"] ?? 0).toString();
    final String resolved = (userData["issuesResolved"] ?? 0).toString();
    final String impact = (userData["communityImpactScore"] ?? 0).toString();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.2),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Avatar
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: theme.colorScheme.primary,
                child: CircleAvatar(
                  radius: 47,
                  backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
                  child: avatarUrl.isEmpty ? const Icon(Icons.person, size: 50) : null,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onCameraPressed,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: theme.colorScheme.primary,
                    child: Icon(Icons.camera_alt, color: theme.colorScheme.onPrimary, size: 20),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // User Info
          Text(name, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(email, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: 8),
          Chip(label: Text('Level $level'), backgroundColor: theme.colorScheme.primaryContainer),
          const SizedBox(height: 24),
          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(theme, 'Complaints', complaints, Icons.assignment),
              _buildStatItem(theme, 'Resolved', resolved, Icons.check_circle),
              _buildStatItem(theme, 'Impact', impact, Icons.trending_up),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(ThemeData theme, String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 28),
        const SizedBox(height: 4),
        Text(value, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}