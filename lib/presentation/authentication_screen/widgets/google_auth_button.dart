import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GoogleAuthButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const GoogleAuthButton({
    Key? key,
    required this.isLoading,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 6.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 2,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.grey, width: 0.5),
          ),
        ),
        child: isLoading
            ? SizedBox(
          width: 5.w,
          height: 5.w,
          child: const CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImageWidget(
              imageUrl:
              "https://developers.google.com/identity/images/g-logo.png",
              width: 5.w,
              height: 5.w,
              fit: BoxFit.contain,
              semanticLabel:
              "Google logo with colorful G letter in blue, red, yellow and green",
            ),
            SizedBox(width: 3.w),
            Text(
              'Continue with Google',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
