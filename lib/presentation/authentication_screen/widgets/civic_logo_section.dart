import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CivicLogoSection extends StatelessWidget {
  const CivicLogoSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main App Logo
        Container(
          width: 25.w,
          height: 25.w,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.primary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: 'account_balance',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 12.w,
            ),
          ),
        ),
        SizedBox(height: 3.h),

        // App Name
        Text(
          'CivicConnect',
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 1.h),

        // App Tagline
        Text(
          'Connecting Citizens with Government',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4.h),

        // Government Partnership Badges
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTrustBadge(
              icon: 'verified_user',
              label: 'Secure',
            ),
            SizedBox(width: 6.w),
            _buildTrustBadge(
              icon: 'gavel',
              label: 'Official',
            ),
            SizedBox(width: 6.w),
            _buildTrustBadge(
              icon: 'shield',
              label: 'Trusted',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTrustBadge({
    required String icon,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.secondary
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.secondary,
              size: 5.w,
            ),
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
