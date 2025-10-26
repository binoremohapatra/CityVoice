import 'package:flutter/material.dart';

import '../presentation/main_navigation_shell/main_navigation_shell.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/authentication_screen/authentication_screen.dart';

import '../presentation/my_complaints_feed/my_complaints_feed.dart';
import '../presentation/report_issue_flow/report_issue_flow.dart';
import '../presentation/complaint_details_tracking/complaint_details_tracking.dart';
import '../presentation/user_profile_screen/user_profile_screen.dart';
import '../presentation/notifications_screen/notifications_screen.dart';
import '../presentation/citizen_dashboard/citizen_dashboard.dart';
import '../presentation/interactive_map_screen/interactive_map_screen.dart';

class AppRoutes {
  static const String initialRoute = '/';
  static const String splashScreen = '/splash-screen';
  static const String authenticationScreen = '/authentication-screen';
  static const String mainNavigationShell = '/main-navigation-shell';

  static const String citizenDashboard = '/citizen-dashboard';
  static const String myComplaintsFeed = '/my-complaints-feed';
  static const String reportIssueFlow = '/report-issue-flow';
  static const String notificationsScreen = '/notifications-screen';
  static const String userProfileScreen = '/user-profile-screen';

  static const String complaintDetailsTracking = '/complaint-details-tracking';
  static const String interactiveMap = '/interactive-map-screen';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initialRoute:
      case splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case authenticationScreen:
        return MaterialPageRoute(builder: (_) => const AuthenticationScreen());

      case mainNavigationShell:
        return MaterialPageRoute(builder: (_) => const MainNavigationShell());

      case citizenDashboard:
        return MaterialPageRoute(builder: (_) => const CitizenDashboard());
      case myComplaintsFeed:
        return MaterialPageRoute(builder: (_) => const MyComplaintsFeed());
      case reportIssueFlow:
        return MaterialPageRoute(builder: (_) => const ReportIssueFlow());
      case notificationsScreen:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      case userProfileScreen:
        return MaterialPageRoute(builder: (_) => const UserProfileScreen());

      case complaintDetailsTracking:
        return MaterialPageRoute(builder: (_) => const ComplaintDetailsTracking());
      case interactiveMap:
        return MaterialPageRoute(builder: (_) => const InteractiveMapScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Error: Route Not Found'),
            ),
          ),
        );
    }
  }
}