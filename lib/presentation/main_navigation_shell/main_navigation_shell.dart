import 'package:flutter/material.dart';

import '../../widgets/custom_bottom_bar.dart';
import '../citizen_dashboard/citizen_dashboard.dart';
import '../my_complaints_feed/my_complaints_feed.dart';
import '../notifications_screen/notifications_screen.dart';
import '../report_issue_flow/report_issue_flow.dart';

import '../user_profile_screen/user_profile_screen.dart';

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentScreenIndex = 0;

  final List<Widget> _screens = const [
    CitizenDashboard(),
    MyComplaintsFeed(),
    ReportIssueFlow(),
    NotificationsScreen(),
    UserProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: IndexedStack(
        index: _currentScreenIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentScreenIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}