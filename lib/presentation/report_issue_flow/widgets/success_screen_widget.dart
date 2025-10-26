import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SuccessScreenWidget extends StatefulWidget {
  final String trackingNumber;
  final String estimatedResponseTime;
  final VoidCallback onDone;
  final VoidCallback onTrackComplaint;

  const SuccessScreenWidget({
    Key? key,
    required this.trackingNumber,
    required this.estimatedResponseTime,
    required this.onDone,
    required this.onTrackComplaint,
  }) : super(key: key);

  @override
  State<SuccessScreenWidget> createState() => _SuccessScreenWidgetState();
}

class _SuccessScreenWidgetState extends State<SuccessScreenWidget>
    with TickerProviderStateMixin {
  late AnimationController _celebrationController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _celebrationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _celebrationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _celebrationController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _fadeController.forward();
    });

    HapticFeedback.lightImpact();
    Future.delayed(const Duration(milliseconds: 200), () {
      HapticFeedback.mediumImpact();
    });
  }

  void _copyTrackingNumber() {
    Clipboard.setData(ClipboardData(text: widget.trackingNumber));
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tracking number copied to clipboard',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onInverseSurface,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.inverseSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(6.w),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _scaleAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Container(
                            width: 25.w,
                            height: 25.w,
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.secondary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme
                                      .lightTheme.colorScheme.secondary
                                      .withValues(alpha: 0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: CustomIconWidget(
                              iconName: 'check',
                              color:
                              AppTheme.lightTheme.colorScheme.onSecondary,
                              size: 12.w,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 4.h),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          Text(
                            'Report Submitted Successfully!',
                            style: AppTheme.lightTheme.textTheme.headlineMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Thank you for helping improve our community. Your report has been received and will be reviewed by the appropriate authorities.',
                            style: AppTheme.lightTheme.textTheme.bodyLarge
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(5.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'confirmation_number',
                                  color:
                                  AppTheme.lightTheme.colorScheme.primary,
                                  size: 6.w,
                                ),
                                SizedBox(width: 3.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Tracking Number',
                                        style: AppTheme
                                            .lightTheme.textTheme.titleSmall
                                            ?.copyWith(
                                          color: AppTheme
                                              .lightTheme.colorScheme.primary,
                                        ),
                                      ),
                                      Text(
                                        widget.trackingNumber,
                                        style: AppTheme
                                            .lightTheme.textTheme.titleLarge
                                            ?.copyWith(
                                          color: AppTheme.lightTheme.colorScheme
                                              .onSurface,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: _copyTrackingNumber,
                                  child: Container(
                                    padding: EdgeInsets.all(2.w),
                                    decoration: BoxDecoration(
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: CustomIconWidget(
                                      iconName: 'content_copy',
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary,
                                      size: 5.w,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 3.h),
                            Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'schedule',
                                  color:
                                  AppTheme.lightTheme.colorScheme.secondary,
                                  size: 6.w,
                                ),
                                SizedBox(width: 3.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Estimated Response Time',
                                        style: AppTheme
                                            .lightTheme.textTheme.titleSmall
                                            ?.copyWith(
                                          color: AppTheme.lightTheme.colorScheme
                                              .secondary,
                                        ),
                                      ),
                                      Text(
                                        widget.estimatedResponseTime,
                                        style: AppTheme.lightTheme.textTheme
                                            .titleMedium
                                            ?.copyWith(
                                          color: AppTheme.lightTheme.colorScheme
                                              .onSurface,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.secondary
                              .withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.secondary
                                .withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'info',
                              color: AppTheme.lightTheme.colorScheme.secondary,
                              size: 5.w,
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Text(
                                'You will receive notifications about the status of your report. You can also track progress using your tracking number.',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme.lightTheme.colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: widget.onTrackComplaint,
                        icon: CustomIconWidget(
                          iconName: 'track_changes',
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          size: 5.w,
                        ),
                        label: Text(
                          'Track This Complaint',
                          style: AppTheme.lightTheme.textTheme.labelLarge
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: widget.onDone,
                        icon: CustomIconWidget(
                          iconName: 'home',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 5.w,
                        ),
                        label: Text(
                          'Back to Dashboard',
                          style: AppTheme.lightTheme.textTheme.labelLarge
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }
}