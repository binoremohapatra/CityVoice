import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_image_widget.dart';
import '../../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Add a simple state to track loading initialization status
  String _loadingStatus = "Initializing services...";

  @override
  void initState() {
    super.initState();
    // Start background tasks
    _initializeAndNavigate();
  }

  void _initializeAndNavigate() async {
    // --- STEP 1: Placeholder for Heavy Initialization Work ---
    // Simulate initial loading phase (e.g., configuring Dio, loading shared prefs)
    setState(() { _loadingStatus = "Configuring systems..."; });
    await Future.delayed(const Duration(milliseconds: 1000));

    // Simulate second loading phase (e.g., checking permissions, loading user data)
    setState(() { _loadingStatus = "Checking authentication..."; });
    await Future.delayed(const Duration(milliseconds: 1000));

    // Ensure a minimum display time before navigation
    await Future.delayed(const Duration(milliseconds: 500));

    // --- STEP 2: Navigate to the Main Entry Point ---
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.mainNavigationShell);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color darkTextColor = AppTheme.onBackgroundLight;
    final Color primaryColor = AppTheme.lightTheme.colorScheme.primary;

    // Define the colors for the soft gradient background
    final List<Color> subtleGradientColors = [
      AppTheme.surfaceLight, // Pure White at the start
      AppTheme.accentPink.withOpacity(0.2), // Soft Pink highlight
      AppTheme.accentTeal.withOpacity(0.1), // Soft Teal accent
      AppTheme.backgroundLight, // Light Blue-Gray at the end
    ];

    return Scaffold(
      body: Container(
        width: 100.w,
        height: 100.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: subtleGradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.0, 0.4, 0.7, 1.0], // Control the spread of colors
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // --- LOGO WRAPPED IN A CIRCLE (ClipOval) ---
            Container(
              padding: EdgeInsets.all(4.w), // Padding around the logo inside the circle
              decoration: BoxDecoration(
                color: AppTheme.surfaceLight, // White background for the circle
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowLight.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipOval(
                child: CustomImageWidget(
                  imageUrl: 'assets/images/logoapp.png',
                  width: 25.w, // Slightly smaller width for the logo itself
                  height: 25.w,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // --- END LOGO WRAPPER ---

            SizedBox(height: 3.h),
            Text(
              'CITY VOICE',
              style: GoogleFonts.inter(
                color: darkTextColor,
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Smart civic issue reporting system',
              style: GoogleFonts.inter(
                color: darkTextColor.withOpacity(0.7),
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),

            // Display Loading Status
            SizedBox(height: 5.h),
            Text(
              _loadingStatus,
              style: GoogleFonts.inter(
                color: darkTextColor.withOpacity(0.8),
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
              ),
            ),

            // Loading Indicator
            SizedBox(height: 1.h),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              strokeWidth: 4,
              backgroundColor: AppTheme.neutralGray,
            ),
          ],
        ),
      ),
    );
  }
}
