import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../routes/app_routes.dart';

/// A reusable widget to display a user-friendly error screen.
///
/// Used as a fallback when navigation fails or a critical error occurs.
class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/sad_face.svg',
                  height: 48,
                  width: 48,
                  colorFilter: ColorFilter.mode(
                    theme.colorScheme.onSurface.withOpacity(0.6),
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Something went wrong",
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'We encountered an unexpected error. Please try going back or restarting the application.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.of(context).pop();
                    } else {
                      // THE FIX: Use the correct route name 'splashScreen'
                      Navigator.pushNamed(context, AppRoutes.splashScreen);
                    }
                  },
                  icon: const Icon(Icons.arrow_back, size: 18),
                  label: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}