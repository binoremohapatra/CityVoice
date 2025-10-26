import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TermsPrivacySection extends StatelessWidget {
  const TermsPrivacySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'By continuing, you agree to our',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 1.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _showTermsDialog(context),
              child: Text(
                'Terms of Service',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            Text(
              ' and ',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            GestureDetector(
              onTap: () => _showPrivacyDialog(context),
              child: Text(
                'Privacy Policy',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),

        // Government Compliance Badge
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.secondary
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.secondary
                  .withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: 'security',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Government Compliant',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Terms of Service',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: SingleChildScrollView(
            child: Text(
              'By using CivicConnect, you agree to:\n\n'
                  '• Provide accurate information when reporting issues\n'
                  '• Use the platform responsibly and lawfully\n'
                  '• Respect privacy of others and community guidelines\n'
                  '• Allow government authorities to contact you regarding your reports\n'
                  '• Understand that false reporting may result in account suspension\n\n'
                  'CivicConnect reserves the right to moderate content and suspend accounts that violate these terms.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Privacy Policy',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: SingleChildScrollView(
            child: Text(
              'CivicConnect Privacy Policy:\n\n'
                  '• We collect location data only when you report issues\n'
                  '• Personal information is shared only with relevant government authorities\n'
                  '• Photos and media are stored securely and used only for issue resolution\n'
                  '• We use cookies and analytics to improve app performance\n'
                  '• Your data is protected with government-grade encryption\n'
                  '• You can request data deletion by contacting support\n\n'
                  'We comply with all federal and state privacy regulations for government applications.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}