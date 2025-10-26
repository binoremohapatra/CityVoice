import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'widgets/gamification_panel_widget.dart';
import 'widgets/profile_header_widget.dart';
import 'widgets/settings_section_widget.dart';
import 'widgets/theme_preview_widget.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  // Mock state for settings toggles
  bool _isDarkMode = false;

  // Mock user data
  final Map<String, dynamic> _userData = {
    "name": "Sarah Johnson",
    "email": "sarah.johnson@email.com",
    "avatar": "https://images.unsplash.com/photo-1684262855358-88f296a2cfc2",
    "level": 7,
    "currentXP": 2450,
    "nextLevelXP": 3000,
    "complaintsSubmitted": 23,
    "issuesResolved": 18,
    "communityImpactScore": 847,
  };

  /// --- THE FIX: NEW FUNCTION TO SHOW THE SETTINGS BOTTOM SHEET ---
  void _showSettingsBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
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
              const SizedBox(height: 24),
              Text('Settings', style: theme.textTheme.headlineSmall),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Notification Preferences'),
                onTap: () {
                  Navigator.pop(context);
                  // In a real app, navigate to a notification settings screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.security),
                title: const Text('Privacy & Security'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Help & Support'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              ListTile(
                leading: Icon(Icons.logout, color: theme.colorScheme.error),
                title: Text('Log Out', style: TextStyle(color: theme.colorScheme.error)),
                onTap: () {
                  Navigator.pop(context);
                  // In a real app, perform logout logic
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            // --- THE FIX: CALL THE NEW FUNCTION ---
            onPressed: () => _showSettingsBottomSheet(context),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeaderWidget(userData: _userData, onEditProfile: () {}, onCameraPressed: () {}),
            GamificationPanelWidget(userData: _userData, onViewLeaderboard: () {}),
            ThemePreviewWidget(
              isDarkMode: _isDarkMode,
              onToggle: () => setState(() => _isDarkMode = !_isDarkMode),
            ),
            SettingsSectionWidget(
              title: 'ACCOUNT',
              items: [
                SettingsItem(
                  title: 'Edit Profile',
                  iconName: 'person',
                  iconColor: theme.colorScheme.primary,
                ),
                SettingsItem(
                  title: 'Change Password',
                  iconName: 'lock',
                  iconColor: theme.colorScheme.secondary,
                ),
              ],
            ),
            const SizedBox(height: 100), // Padding for end of scroll
          ],
        ),
      ),
    );
  }
}