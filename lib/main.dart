import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'CivicConnect',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          onGenerateRoute: AppRoutes.onGenerateRoute,
          initialRoute: AppRoutes.splashScreen,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}