import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ComplaintHeroSectionWidget extends StatefulWidget {
  final Map<String, dynamic> complaint;

  const ComplaintHeroSectionWidget({
    Key? key,
    required this.complaint,
  }) : super(key: key);

  @override
  State<ComplaintHeroSectionWidget> createState() =>
      _ComplaintHeroSectionWidgetState();
}

class _ComplaintHeroSectionWidgetState
    extends State<ComplaintHeroSectionWidget> {
  PageController _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> images =
    (widget.complaint['images'] as List).cast<Map<String, dynamic>>();

    return Container(
      width: double.infinity,
      height: 30.h,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Container(
                width: double.infinity,
                height: 30.h,
                child: CustomImageWidget(
                  imageUrl: images[index]['url'],
                  width: double.infinity,
                  height: 30.h,
                  fit: BoxFit.cover,
                  semanticLabel: images[index]['semanticLabel'],
                ),
              );
            },
          ),
          if (widget.complaint['voiceNote'] != null)
            Positioned(
              top: 2.h,
              right: 4.w,
              child: GestureDetector(
                onTap: () {
                  // Handle voice note playback
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Playing voice note...'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: Container(
                  width: 12.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'play_arrow',
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          if (images.length > 1)
            Positioned(
              bottom: 2.h,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                      (index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 1.w),
                    width: _currentImageIndex == index ? 3.w : 2.w,
                    height: 1.h,
                    decoration: BoxDecoration(
                      color: _currentImageIndex == index
                          ? AppTheme.lightTheme.colorScheme.primary
                          : Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 8.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.3),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
