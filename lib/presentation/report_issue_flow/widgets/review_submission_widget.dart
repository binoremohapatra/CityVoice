import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ReviewSubmissionWidget extends StatelessWidget {
  final String category;
  final LatLng location;
  final List<XFile> images;
  final String? audioPath;
  final String description;
  final String urgency;
  final bool isSubmitting;
  final double uploadProgress;
  final VoidCallback onSubmit;
  final Function(String) onEditSection;

  const ReviewSubmissionWidget({
    Key? key,
    required this.category,
    required this.location,
    required this.images,
    this.audioPath,
    required this.description,
    required this.urgency,
    required this.isSubmitting,
    required this.uploadProgress,
    required this.onSubmit,
    required this.onEditSection,
  }) : super(key: key);

  Color _getUrgencyColor(String urgency) {
    switch (urgency.toLowerCase()) {
      case 'low':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'high':
        return Colors.red;
      case 'emergency':
        return Colors.red.shade800;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // FIX: Wrapped in SingleChildScrollView
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review & Submit',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Please review all information before submitting your report',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),

          _buildReviewSection(
            title: 'Category',
            content: category,
            icon: 'category',
            onEdit: () => onEditSection('category'),
          ),

          SizedBox(height: 2.h),

          _buildReviewSection(
            title: 'Location',
            content:
            'Lat: ${location.latitude.toStringAsFixed(6)}\nLng: ${location.longitude.toStringAsFixed(6)}',
            icon: 'location_on',
            onEdit: () => onEditSection('location'),
          ),

          SizedBox(height: 2.h),

          _buildMediaSection(),

          SizedBox(height: 2.h),

          _buildReviewSection(
            title: 'Description',
            content: description,
            icon: 'description',
            onEdit: () => onEditSection('media'),
          ),

          SizedBox(height: 2.h),

          _buildUrgencySection(),

          SizedBox(height: 4.h),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isSubmitting ? null : onSubmit,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: isSubmitting
                  ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 5.w,
                        height: 5.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.lightTheme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'Submitting Report...',
                        style: AppTheme.lightTheme.textTheme.labelLarge
                            ?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                  if (uploadProgress > 0) ...[
                    SizedBox(height: 1.h),
                    LinearProgressIndicator(
                      value: uploadProgress,
                      backgroundColor: AppTheme
                          .lightTheme.colorScheme.onPrimary
                          .withValues(alpha: 0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.colorScheme.onPrimary,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Uploading files: ${(uploadProgress * 100).toInt()}%',
                      style:
                      AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ],
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'send',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 5.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Submit Report',
                    style:
                    AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewSection({
    required String title,
    required String content,
    required String icon,
    required VoidCallback onEdit,
  }) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: icon,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onEdit,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: CustomIconWidget(
                    iconName: 'edit',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 4.w,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            content,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaSection() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'perm_media',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Media',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => onEditSection('media'),
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: CustomIconWidget(
                    iconName: 'edit',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 4.w,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          if (images.isNotEmpty) ...[
            Text(
              'Images (${images.length})',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            SizedBox(
              height: 12.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  final image = images[index];
                  return Container(
                    margin: EdgeInsets.only(right: 2.w),
                    width: 15.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: kIsWeb
                          ? Image.network(
                        image.path,
                        fit: BoxFit.cover,
                      )
                          : Image.file(
                        File(image.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ] else ...[
            Text(
              'No images attached',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],

          if (images.isNotEmpty && audioPath != null) SizedBox(height: 2.h),

          if (audioPath != null) ...[
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'audiotrack',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Voice recording attached',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ] else if (images.isEmpty) ...[
            Text(
              'No audio recording attached',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUrgencySection() {
    final urgencyColor = _getUrgencyColor(urgency);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'priority_high',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Urgency Level',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => onEditSection('urgency'),
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: CustomIconWidget(
                    iconName: 'edit',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 4.w,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: urgencyColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: urgencyColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 3.w,
                  height: 3.w,
                  decoration: BoxDecoration(
                    color: urgencyColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 2.w),
                Text(
                  urgency,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: urgencyColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}