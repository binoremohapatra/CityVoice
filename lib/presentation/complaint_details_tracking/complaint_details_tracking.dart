import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import 'widgets/comment_system_widget.dart';
import 'widgets/complaint_header_widget.dart';
import 'widgets/complaint_hero_section_widget.dart';
import 'widgets/complaint_metadata_widget.dart';
import 'widgets/status_timeline_widget.dart';
import 'widgets/related_complaints_section.dart';
import 'widgets/complaint_location_card.dart';

class ComplaintDetailsTracking extends StatefulWidget {
  const ComplaintDetailsTracking({Key? key, Map<String, dynamic>? complaint}) : super(key: key);

  @override
  State<ComplaintDetailsTracking> createState() =>
      _ComplaintDetailsTrackingState();
}

class _ComplaintDetailsTrackingState extends State<ComplaintDetailsTracking>
    with TickerProviderStateMixin {
  late AnimationController _fabAnimationController;
  late Animation<double> _fabScaleAnimation;
  final ScrollController _scrollController = ScrollController();
  bool _showFab = true;
  bool _hasNewUpdates = true;

  // Mock complaint data
  final Map<String, dynamic> _complaintData = {
    'id': 'CMP-2024-001234',
    'trackingId': 'TRK-CC-789456',
    'title': 'Broken Street Light on Main Avenue',
    'description':
    'The street light at the intersection of Main Avenue and Oak Street has been non-functional for over a week. This creates a safety hazard for pedestrians and drivers, especially during evening hours. The light appears to have electrical issues as it flickers occasionally before going completely dark.',
    'category': 'Street Lighting',
    'urgency': 'Medium',
    'status': 'In Progress',
    'submissionDate': 'October 8, 2024',
    'images': [
      {
        'url': 'https://images.unsplash.com/photo-1704562877369-35e38fe3eeb8',
        'semanticLabel':
        'Broken street light pole with damaged electrical housing at night on Main Avenue intersection'
      },
      {
        'url': 'https://images.unsplash.com/photo-1498388175323-4267e069383b',
        'semanticLabel':
        'Close-up view of damaged street light fixture showing exposed wiring and broken glass cover'
      },
      {
        'url': 'https://images.unsplash.com/photo-1681584231979-66dac3e1b19d',
        'semanticLabel':
        'Wide angle view of dark intersection showing lack of proper lighting creating safety hazard'
      }
    ],
    'voiceNote': 'voice_note_url.mp3',
    'location': {
      'latitude': 40.7128,
      'longitude': -74.0060,
      'address':
      'Main Avenue & Oak Street, Downtown District, New York, NY 10001'
    }
  };

  final List<Map<String, dynamic>> _timelineData = [
    {
      'status': 'Submitted',
      'description': 'Complaint submitted successfully and assigned tracking ID',
      'timestamp': 'Oct 8, 2024 - 2:30 PM',
      'officialComment': null,
      'officialName': null,
      'officialAvatar': null,
    },
    {
      'status': 'Under Review',
      'description': 'Complaint reviewed by Municipal Services Department',
      'timestamp': 'Oct 9, 2024 - 9:15 AM',
      'officialComment':
      'Thank you for reporting this issue. We have verified the location and confirmed the street light malfunction. The issue has been escalated to our electrical maintenance team for immediate attention.',
      'officialName': 'Sarah Johnson - Municipal Services',
      'officialAvatar':
      'https://images.unsplash.com/photo-1531660363117-070f211f3398',
    },
    {
      'status': 'In Progress',
      'description': 'Electrical maintenance team dispatched to location',
      'timestamp': 'Oct 10, 2024 - 11:45 AM',
      'officialComment':
      'Our electrical team has assessed the damage and ordered replacement parts. The light fixture requires a new electrical housing and LED bulb assembly. Work is scheduled to begin tomorrow morning.',
      'officialName': 'Mike Rodriguez - Electrical Supervisor',
      'officialAvatar':
      'https://images.unsplash.com/photo-1727818716161-40384d79e822',
    }
  ];

  final List<Map<String, dynamic>> _commentsData = [
    {
      'id': 1,
      'author': 'Jennifer Chen',
      'avatar':
      'https://images.unsplash.com/photo-1646041805292-fd77781436f9',
      'semanticLabel':
      'Profile photo of Asian woman with long black hair wearing professional attire',
      'content':
      'I walk through this intersection every evening after work. The lack of lighting makes it really dangerous, especially with the increased foot traffic in this area.',
      'timestamp': '2 days ago',
      'isOfficial': false,
      'replies': [
        {
          'author': 'Sarah Johnson - Municipal Services',
          'avatar':
          'https://images.unsplash.com/photo-1559271470-4449510bfbb6',
          'semanticLabel':
          'Official profile photo of municipal services representative',
          'content':
          'Thank you for the additional context, Jennifer. We understand the safety concerns and are prioritizing this repair.',
          'timestamp': '1 day ago',
        }
      ],
    },
    {
      'id': 2,
      'author': 'David Park',
      'avatar':
      'https://images.unsplash.com/photo-1735651705945-64bc6d18d555',
      'semanticLabel':
      'Profile photo of middle-aged man with glasses wearing casual shirt',
      'content':
      'Great to see quick action on this! When can we expect the repair to be completed?',
      'timestamp': '1 day ago',
      'isOfficial': false,
      'replies': [],
    }
  ];

  final List<Map<String, dynamic>> _relatedComplaints = [
    {
      'id': 'CMP-2024-001235',
      'title': 'Pothole on Oak Street',
      'status': 'Resolved',
      'distance': '0.2',
      'category': 'Roads',
      'location': 'Oak Street, Downtown District',
      'reporterName': 'Jane Doe',
      'reporterAvatar':
      'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
      'submittedDate': 'Oct 7, 2024',
    },
    {
      'id': 'CMP-2024-001236',
      'title': 'Broken Sidewalk',
      'status': 'In Progress',
      'distance': '0.4',
      'category': 'Roads',
      'location': 'Main Avenue, near City Hall',
      'reporterName': 'Peter Jones',
      'reporterAvatar':
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
      'submittedDate': 'Oct 6, 2024',
    },
  ];

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fabScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeInOut),
    );
    _fabAnimationController.forward();

    _scrollController.addListener(() {
      if (_scrollController.offset > 100 && _showFab) {
        setState(() {
          _showFab = false;
        });
      } else if (_scrollController.offset <= 100 && !_showFab) {
        setState(() {
          _showFab = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleShare() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Complaint details shared successfully'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleAddMedia() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                margin: EdgeInsets.only(top: 2.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  children: [
                    Text(
                      'Add Additional Information',
                      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    _buildActionTile(
                      icon: 'camera_alt',
                      title: 'Take Photo',
                      subtitle: 'Capture additional evidence',
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Camera opened')),
                        );
                      },
                    ),
                    _buildActionTile(
                      icon: 'photo_library',
                      title: 'Choose from Gallery',
                      subtitle: 'Select existing photos',
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Gallery opened')),
                        );
                      },
                    ),
                    _buildActionTile(
                      icon: 'mic',
                      title: 'Record Voice Note',
                      subtitle: 'Add audio description',
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Voice recorder opened')),
                        );
                      },
                    ),
                    _buildActionTile(
                      icon: 'help_outline',
                      title: 'Ask Question',
                      subtitle: 'Inquire about status',
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Question form opened')),
                        );
                      },
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 2.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
            AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: icon,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color:
                      AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showRelatedIssues() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                margin: EdgeInsets.only(top: 2.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Text(
                  'Related Issues Nearby',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    final relatedIssues = [
                      {
                        'title': 'Pothole on Oak Street',
                        'status': 'Resolved',
                        'distance': '0.2 miles away',
                        'category': 'Road Maintenance'
                      },
                      {
                        'title': 'Broken Sidewalk',
                        'status': 'In Progress',
                        'distance': '0.4 miles away',
                        'category': 'Infrastructure'
                      },
                      {
                        'title': 'Faulty Traffic Signal',
                        'status': 'Under Review',
                        'distance': '0.6 miles away',
                        'category': 'Traffic Management'
                      },
                    ];

                    final issue = relatedIssues[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 2.h),
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  issue['title']!,
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                  color: issue['status'] == 'Resolved'
                                      ? AppTheme
                                      .lightTheme.colorScheme.secondary
                                      .withValues(alpha: 0.1)
                                      : AppTheme.lightTheme.colorScheme.primary
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  issue['status']!,
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: issue['status'] == 'Resolved'
                                        ? AppTheme
                                        .lightTheme.colorScheme.secondary
                                        : AppTheme
                                        .lightTheme.colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Row(
                            children: [
                              Text(
                                issue['category']!,
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                ' • ${issue['distance']}',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          setState(() {
            _hasNewUpdates = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Status updated successfully'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  ComplaintHeaderWidget(
                    complaint: _complaintData,
                    onShare: _handleShare,
                  ),
                  ComplaintHeroSectionWidget(
                    complaint: _complaintData,
                  ),
                  ComplaintMetadataWidget(
                    complaint: _complaintData,
                  ),
                  StatusTimelineWidget(
                    timeline: _timelineData,
                  ),
                  // Using the new, corrected widget
                  ComplaintLocationCard(
                    locationData: _complaintData['location'] ?? {},
                  ),
                  CommentSystemWidget(
                    comments: _commentsData,
                  ),
                  // This is the new widget call
                  RelatedComplaintsSection(
                    relatedComplaints: _relatedComplaints,
                    onComplaintTap: (complaint) {
                      // Navigate to the tapped complaint's details
                    },
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: AnimatedScale(
        scale: _showFab ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Stack(
          children: [
            FloatingActionButton.extended(
              onPressed: _handleAddMedia,
              icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 24,
              ),
              label: const Text('Add Info'),
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
            ),
            if (_hasNewUpdates)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 3.w,
                  height: 1.5.h,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton.icon(
            onPressed: _showRelatedIssues,
            icon: CustomIconWidget(
              iconName: 'map',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 20,
            ),
            label: const Text('View Related Issues'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}