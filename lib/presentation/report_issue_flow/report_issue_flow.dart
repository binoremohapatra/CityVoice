import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:latlong2/latlong.dart';
import 'package:camera/camera.dart';

import '../../core/app_export.dart';
import 'widgets/category_selection_widget.dart';
import 'widgets/location_selection_widget.dart';
import 'widgets/media_capture_widget.dart';
import 'widgets/urgency_selection_widget.dart';
import 'widgets/review_submission_widget.dart';
import 'widgets/success_screen_widget.dart';

class ReportIssueFlow extends StatefulWidget {
  const ReportIssueFlow({super.key});

  @override
  State<ReportIssueFlow> createState() => _ReportIssueFlowState();
}

class _ReportIssueFlowState extends State<ReportIssueFlow> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 5;

  // Form data
  String? _selectedCategory;
  LatLng? _selectedLocation;
  List<XFile> _capturedImages = [];
  String? _audioRecordingPath;
  String _description = '';
  String? _selectedUrgency;

  // Submission state
  bool _isSubmitting = false;
  double _uploadProgress = 0.0;
  bool _showSuccess = false;
  String _trackingNumber = '';

  // Animation controllers
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  final List<Map<String, dynamic>> _categories = [
    {
      'id': 'roads',
      'title': 'Roads & Infrastructure',
      'description': 'Potholes, broken roads, traffic signals',
      'iconName': 'construction',
    },
    {
      'id': 'utilities',
      'title': 'Utilities',
      'description': 'Water leaks, power outages, gas issues',
      'iconName': 'electrical_services',
    },
    {
      'id': 'public_safety',
      'title': 'Public Safety',
      'description': 'Broken street lights, safety concerns',
      'iconName': 'security',
    },
    {
      'id': 'waste_environment',
      'title': 'Waste & Environment',
      'description': 'Overflowing bins, pollution, dumping',
      'iconName': 'recycling',
    },
    {
      'id': 'transportation',
      'title': 'Transportation',
      'description': 'Bus delays, damaged public transport facilities',
      'iconName': 'directions_bus',
    },
    {
      'id': 'parks_recreation',
      'title': 'Parks & Recreation',
      'description': 'Damaged park equipment, overgrown areas',
      'iconName': 'park',
    },
  ];

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));
    _updateProgress();
  }

  void _updateProgress() {
    final progress = (_currentStep + 1) / _totalSteps;
    _progressController.animateTo(progress);
  }

  void _nextStep() {
    if (_canProceedFromCurrentStep()) {
      if (_currentStep < _totalSteps - 1) {
        setState(() {
          _currentStep++;
        });
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _updateProgress();
        HapticFeedback.lightImpact();
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _updateProgress();
      HapticFeedback.lightImpact();
    }
  }

  void _goToStep(int step) {
    if (step >= 0 && step < _totalSteps) {
      setState(() {
        _currentStep = step;
      });
      _pageController.animateToPage(
        step,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _updateProgress();
    }
  }

  bool _canProceedFromCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _selectedCategory != null;
      case 1:
        return _selectedLocation != null;
      case 2:
        return _description.trim().isNotEmpty || _capturedImages.isNotEmpty || _audioRecordingPath != null;
      case 3:
        return _selectedUrgency != null;
      case 4:
        return true;
      default:
        return false;
    }
  }

  Future<void> _submitReport() async {
    setState(() {
      _isSubmitting = true;
      _uploadProgress = 0.0;
    });

    try {
      for (int i = 0; i <= 100; i += 10) {
        await Future.delayed(const Duration(milliseconds: 100));
        setState(() {
          _uploadProgress = i / 100.0;
        });
      }

      _trackingNumber = 'CVC${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';

      await Future.delayed(const Duration(milliseconds: 500));

      setState(() {
        _isSubmitting = false;
        _showSuccess = true;
      });

      HapticFeedback.mediumImpact();
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to submit report. Please try again.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onError,
              ),
            ),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _onEditSection(String section) {
    switch (section) {
      case 'category':
        _goToStep(0);
        break;
      case 'location':
        _goToStep(1);
        break;
      case 'media':
        _goToStep(2);
        break;
      case 'urgency':
        _goToStep(3);
        break;
    }
  }

  String _getEstimatedResponseTime() {
    switch (_selectedUrgency?.toLowerCase()) {
      case 'emergency':
        return '1-2 hours';
      case 'high':
        return '24-48 hours';
      case 'medium':
        return '3-5 business days';
      case 'low':
        return '1-2 weeks';
      default:
        return '3-5 business days';
    }
  }

  Future<bool> _onWillPop() async {
    if (_showSuccess) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.citizenDashboard,
            (route) => false,
      );
      return false;
    }
    if (_currentStep > 0) {
      _previousStep();
      return false;
    }
    if (_selectedCategory != null || _selectedLocation != null || _capturedImages.isNotEmpty || _description.isNotEmpty) {
      return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Discard Report?', style: AppTheme.lightTheme.textTheme.titleLarge),
          content: Text('Are you sure you want to leave? Your progress will be lost.', style: AppTheme.lightTheme.textTheme.bodyMedium),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel', style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(color: AppTheme.lightTheme.colorScheme.primary)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Discard', style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(color: AppTheme.lightTheme.colorScheme.error)),
            ),
          ],
        ),
      ) ?? false;
    }
    return true;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showSuccess) {
      return SuccessScreenWidget(
        trackingNumber: _trackingNumber,
        estimatedResponseTime: _getEstimatedResponseTime(),
        onDone: () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.citizenDashboard,
                (route) => false,
          );
        },
        onTrackComplaint: () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.complaintDetailsTracking,
                (route) => false,
          );
        },
      );
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        appBar: AppBar(
          title: Text('Report Issue', style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          )),
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
          elevation: 0,
          leading: IconButton(
            onPressed: () async {
              if (await _onWillPop()) {
                Navigator.of(context).pop();
              }
            },
            icon: CustomIconWidget(iconName: 'arrow_back', color: AppTheme.lightTheme.colorScheme.onPrimary, size: 6.w),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(8.h),
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Step ${_currentStep + 1} of $_totalSteps', style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary.withValues(alpha: 0.8),
                      )),
                      Text('${((_currentStep + 1) / _totalSteps * 100).toInt()}%', style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w600,
                      )),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  AnimatedBuilder(
                    animation: _progressController,
                    builder: (context, child) {
                      return LinearProgressIndicator(
                        value: _progressAnimation.value,
                        backgroundColor: AppTheme.lightTheme.colorScheme.onPrimary.withValues(alpha: 0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.lightTheme.colorScheme.onPrimary),
                        minHeight: 1.h,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildCategorySelection(context),
                  LocationSelectionWidget(
                    selectedLocation: _selectedLocation,
                    onLocationSelected: (location) {
                      setState(() {
                        _selectedLocation = location;
                      });
                    },
                  ),
                  MediaCaptureWidget(
                    capturedImages: _capturedImages,
                    audioRecordingPath: _audioRecordingPath,
                    description: _description,
                    onImagesChanged: (images) {
                      setState(() {
                        _capturedImages = images;
                      });
                    },
                    onAudioChanged: (audioPath) {
                      setState(() {
                        _audioRecordingPath = audioPath;
                      });
                    },
                    onDescriptionChanged: (description) {
                      setState(() {
                        _description = description;
                      });
                    },
                  ),
                  UrgencySelectionWidget(
                    selectedUrgency: _selectedUrgency,
                    onUrgencySelected: (urgency) {
                      setState(() {
                        _selectedUrgency = urgency;
                      });
                    },
                  ),
                  ReviewSubmissionWidget(
                    category: _selectedCategory ?? '',
                    location: _selectedLocation ?? const LatLng(0, 0),
                    images: _capturedImages,
                    audioPath: _audioRecordingPath,
                    description: _description,
                    urgency: _selectedUrgency ?? '',
                    isSubmitting: _isSubmitting,
                    uploadProgress: _uploadProgress,
                    onSubmit: _submitReport,
                    onEditSection: _onEditSection,
                  ),
                ],
              ),
            ),
            if (_currentStep < _totalSteps)
              _buildNavigationButtons(context),
          ],
        ),
      ),
    );
  }

  // Helper method for category selection since it's a grid and not a simple widget
  Widget _buildCategorySelection(BuildContext context) {
    final theme = Theme.of(context);
    // FIX: This section was copied directly into the build method
    // In a real app, you would have a dedicated CategorySelectionWidget file.
    // For now, this is a valid helper method.
    final List<Map<String, dynamic>> _categories = [
      {
        'id': 'roads',
        'title': 'Roads & Infrastructure',
        'description': 'Potholes, broken roads, traffic signals',
        'iconName': 'construction',
      },
      {
        'id': 'utilities',
        'title': 'Utilities',
        'description': 'Water leaks, power outages, gas issues',
        'iconName': 'electrical_services',
      },
      {
        'id': 'public_safety',
        'title': 'Public Safety',
        'description': 'Broken street lights, safety concerns',
        'iconName': 'security',
      },
      {
        'id': 'waste_environment',
        'title': 'Waste & Environment',
        'description': 'Overflowing bins, pollution, dumping',
        'iconName': 'recycling',
      },
      {
        'id': 'transportation',
        'title': 'Transportation',
        'description': 'Bus delays, damaged public transport facilities',
        'iconName': 'directions_bus',
      },
      {
        'id': 'parks_recreation',
        'title': 'Parks & Recreation',
        'description': 'Damaged park equipment, overgrown areas',
        'iconName': 'park',
      },
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 1: Select Category',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Choose the category that best describes the issue to help us route it to the correct department.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4.w,
              mainAxisSpacing: 4.w,
              childAspectRatio: 0.9,
            ),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              return _CategoryCard(
                title: category['title'] as String,
                description: category['description'] as String,
                iconName: category['iconName'] as String,
                isSelected: _selectedCategory == category['id'],
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() {
                    _selectedCategory = category['id'] as String;
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: ElevatedButton(
        onPressed: _canProceedFromCurrentStep() ? _nextStep : null,
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 6.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.w),
          ),
        ),
        child: Text(
          'Continue',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // New method to build navigation buttons
  Widget _buildNavigationButtons(BuildContext context) {
    final theme = Theme.of(context);
    final isLastStep = _currentStep == _totalSteps - 1;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _previousStep,
                icon: CustomIconWidget(
                  iconName: 'arrow_back',
                  color: theme.colorScheme.primary,
                  size: 5.w,
                ),
                label: Text(
                  'Previous',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
              ),
            ),
          if (_currentStep > 0) SizedBox(width: 4.w),
          Expanded(
            flex: _currentStep == 0 ? 1 : 1,
            child: ElevatedButton.icon(
              onPressed: _canProceedFromCurrentStep() ? _nextStep : null,
              icon: CustomIconWidget(
                iconName: 'arrow_forward',
                color: _canProceedFromCurrentStep()
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                size: 5.w,
              ),
              label: Text(
                isLastStep ? 'Submit' : 'Next',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: _canProceedFromCurrentStep()
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                backgroundColor: _canProceedFromCurrentStep()
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surface,
                foregroundColor: _canProceedFromCurrentStep()
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                side: _canProceedFromCurrentStep() ? null : BorderSide(color: theme.colorScheme.outline),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Category Card widget to be used in the grid
class _CategoryCard extends StatelessWidget {
  final String title;
  final String description;
  final String iconName;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.title,
    required this.description,
    required this.iconName,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(3.w),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary.withValues(alpha: 0.8)
                : theme.colorScheme.outline.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? theme.colorScheme.primary.withValues(alpha: 0.2)
                  : theme.shadowColor.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: AnimatedScale(
                duration: const Duration(milliseconds: 250),
                scale: isSelected ? 1.1 : 1.0,
                child: CustomIconWidget(
                  iconName: iconName,
                  color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.primary,
                  size: 8.w,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 0.5.h),
            Text(
              description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? theme.colorScheme.onPrimary.withValues(alpha: 0.7)
                    : theme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}