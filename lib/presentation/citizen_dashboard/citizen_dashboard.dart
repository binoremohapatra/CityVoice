import 'package:civicconnect/presentation/citizen_dashboard/widget/civic_engagement_banner_widget.dart';
import 'package:civicconnect/presentation/citizen_dashboard/widget/issue_summary_card_widget.dart';
import 'package:civicconnect/presentation/citizen_dashboard/widget/search_filter_bar_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';


class CitizenDashboard extends StatefulWidget {
  const CitizenDashboard({Key? key}) : super(key: key);

  @override
  State<CitizenDashboard> createState() => _CitizenDashboardState();
}

class _CitizenDashboardState extends State<CitizenDashboard>
    with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late AnimationController _backgroundAnimationController;
  late AnimationController _contentAnimationController;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _contentFadeAnimation;
  late Animation<Offset> _contentSlideAnimation;

  Position? _currentPosition;
  List<Marker> _markers = [];
  String _searchQuery = '';
  bool _isLocationPermissionGranted = false;

  final List<Map<String, dynamic>> _nearbyIssues = [
    {
      "id": 1,
      "type": "Pothole",
      "status": "urgent",
      "description":
      "Large pothole causing traffic issues on Main Street. Multiple vehicles have been damaged.",
      "latitude": 37.7849,
      "longitude": -122.4094,
      "distance": "0.2 km",
      "timeAgo": "2 hours ago",
      "images": [
        {
          "url":
          "https://images.unsplash.com/photo-1728340964368-59c3192e44e6",
          "semanticLabel":
          "Large pothole in asphalt road with damaged edges and debris scattered around"
        },
      ],
      "timeline": [
        {"status": "reported", "timeAgo": "2 hours ago"},
        {"status": "acknowledged", "timeAgo": "1 hour ago"}
      ]
    },
    {
      "id": 2,
      "type": "Broken Streetlight",
      "status": "in-progress",
      "description":
      "Streetlight not working on Oak Avenue, creating safety concerns for pedestrians at night.",
      "latitude": 37.7849,
      "longitude": -122.4074,
      "distance": "0.5 km",
      "timeAgo": "1 day ago",
      "images": [
        {
          "url":
          "https://images.unsplash.com/photo-1689762854860-3d898839ea0d",
          "semanticLabel":
          "Dark street at night with non-functioning streetlight pole against cloudy sky"
        }
      ],
      "timeline": [
        {"status": "reported", "timeAgo": "1 day ago"},
        {"status": "in-progress", "timeAgo": "6 hours ago"}
      ]
    },
  ];

  final List<Map<String, dynamic>> _userBadges = [
    {"name": "Reporter", "icon": "🏆"},
    {"name": "Helper", "icon": "🤝"},
    {"name": "Advocate", "icon": "📢"}
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _requestLocationPermission();
    _getCurrentLocation();
  }

  void _initializeAnimations() {
    _backgroundAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _backgroundAnimationController,
        curve: Curves.easeIn,
      ),
    );
    _backgroundAnimationController.forward();

    _contentAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _contentFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentAnimationController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeIn),
      ),
    );
    _contentSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _contentAnimationController,
      curve: Curves.easeOutCubic,
    ));
    _contentAnimationController.forward();
  }

  Future<void> _requestLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        setState(() {
          _isLocationPermissionGranted = true;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Location permission error: $e');
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    if (!_isLocationPermissionGranted) return;
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
      });
      _createMarkers();
      _mapController.move(
        LatLng(position.latitude, position.longitude),
        15.0,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Location error: $e');
      }
      setState(() {
        _currentPosition = Position(
          latitude: 37.7849,
          longitude: -122.4094,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          altitudeAccuracy: 0,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0,
        );
      });
      _createMarkers();
    }
  }

  void _createMarkers() {
    List<Marker> markers = [];
    if (_currentPosition != null) {
      markers.add(
        Marker(
          point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          child: const Icon(Icons.location_pin, color: Colors.blue, size: 40),
        ),
      );
    }
    for (var issue in _filteredIssues) {
      markers.add(
        Marker(
          point: LatLng(issue['latitude'] as double, issue['longitude'] as double),
          child: Icon(_getMarkerIcon(issue['status'] as String), color: _getMarkerColor(issue['status'] as String), size: 40),
        ),
      );
    }
    setState(() {
      _markers = markers;
    });
  }

  IconData _getMarkerIcon(String status) {
    switch (status.toLowerCase()) {
      case 'urgent':
        return Icons.report_problem;
      case 'in-progress':
        return Icons.construction;
      case 'resolved':
        return Icons.check_circle;
      default:
        return Icons.location_on;
    }
  }

  Color _getMarkerColor(String status) {
    switch (status.toLowerCase()) {
      case 'urgent':
        return Colors.red;
      case 'in-progress':
        return Colors.orange;
      case 'resolved':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  List<Map<String, dynamic>> get _filteredIssues {
    if (_searchQuery.isEmpty) return _nearbyIssues;
    return _nearbyIssues.where((issue) {
      final type = (issue['type'] as String).toLowerCase();
      final description = (issue['description'] as String).toLowerCase();
      final query = _searchController.text.toLowerCase(); // Use controller text for current query
      return type.contains(query) || description.contains(query);
    }).toList();
  }

  void _showIssueDetails(Map<String, dynamic> issue) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          // Ensure surfaces use the new light theme color scheme
          color: AppTheme.surfaceLight,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                // Fix for the dark theme residual opacity method
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            issue['type'] as String,
                            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            color: _getStatusColor(issue['status'] as String),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            issue['status'] as String,
                            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      issue['description'] as String,
                      style: AppTheme.lightTheme.textTheme.bodyLarge,
                    ),
                    SizedBox(height: 3.h),
                    if (issue['images'] != null && (issue['images'] as List).isNotEmpty) ...[
                      Text(
                        'Photos',
                        style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      SizedBox(
                        height: 20.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: (issue['images'] as List).length,
                          itemBuilder: (context, index) {
                            final imageData = (issue['images'] as List)[index] as Map<String, dynamic>;
                            return Container(
                              margin: EdgeInsets.only(right: 3.w),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CustomImageWidget(
                                  imageUrl: imageData['url'] as String,
                                  width: 30.w,
                                  height: 20.h,
                                  fit: BoxFit.cover,
                                  semanticLabel: imageData['semanticLabel'] as String,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 3.h),
                    ],
                    Text(
                      'Timeline',
                      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    if (issue['timeline'] != null)
                      ...(issue['timeline'] as List).map((timelineItem) {
                        final item = timelineItem as Map<String, dynamic>;
                        return Container(
                          margin: EdgeInsets.only(bottom: 2.h),
                          child: Row(
                            children: [
                              Container(
                                width: 3.w,
                                height: 3.w,
                                decoration: BoxDecoration(
                                  color: _getStatusColor(item['status'] as String),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (item['status'] as String).toUpperCase(),
                                      style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: _getStatusColor(item['status'] as String),
                                      ),
                                    ),
                                    Text(
                                      item['timeAgo'] as String,
                                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'urgent':
        return AppTheme.lightTheme.colorScheme.error;
      case 'in-progress':
        return const Color(0xFFF57C00); // Orange
      case 'resolved':
        return AppTheme.lightTheme.colorScheme.secondary; // Teal
      default:
        return AppTheme.lightTheme.colorScheme.primary; // Primary blue
    }
  }

  void _onFabPressed() {
    Navigator.pushNamed(context, AppRoutes.reportIssueFlow);
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // Ensure dialog uses light theme
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        title: Text('Filter Issues', style: AppTheme.lightTheme.textTheme.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: const Text('Urgent'),
              value: true,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('In Progress'),
              value: true,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('Resolved'),
              value: false,
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: TextStyle(color: AppTheme.lightTheme.colorScheme.onBackground))),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Apply')),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    _searchController.dispose();
    _backgroundAnimationController.dispose();
    _contentAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Define the light tricolor gradient for the background
    final Color gradientStart = AppTheme.surfaceLight;
    final Color gradientEnd = AppTheme.backgroundLight;
    final Color accentColor = AppTheme.lightTheme.colorScheme.tertiary.withOpacity(0.1); // Soft pink accent

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildNavigationDrawer(),
      // The entire body content is placed inside a container with the gradient
      body: Container(
        width: 100.w,
        height: 100.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              gradientStart,
              gradientEnd,
              accentColor, // Subtle third color
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Background map layer (Hidden behind content, but necessary for the effect)
            Positioned.fill(
              child: _buildBackgroundMap(),
            ),

            // Main scrollable content
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _contentAnimationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _contentFadeAnimation,
                    child: SlideTransition(
                      position: _contentSlideAnimation,
                      child: _buildDashboardContent(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onFabPressed,
        // The FAB uses a solid primary color for contrast
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 8.0,
        icon: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 6.w,
        ),
        label: Text(
          'Report Issue',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundMap() {
    // Wrap the map in a container that fills the entire space
    return _currentPosition != null
        ? FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        initialZoom: 15.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.civicconnect',
        ),
        MarkerLayer(
          markers: _markers,
        ),
      ],
    )
        : Center(
      child: CircularProgressIndicator(
        color: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  Widget _buildDashboardContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Banner widget now uses Glassmorphism and light colors
          CivicEngagementBannerWidget(
            engagementScore: 1250,
            badges: _userBadges,
            onTap: () {
              // Navigate to gamification hub
            },
          ),
          // Search bar needs to be a Glassmorphism card too. Assuming search_filter_bar_widget uses Theme colors.
          SearchFilterBarWidget(
            searchController: _searchController,
            onFilterTap: _showFilterDialog,
            onSearchChanged: (query) {
              setState(() {
                _searchQuery = query;
              });
              _createMarkers();
            },
          ),
          SizedBox(height: 2.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Nearby Issues',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_filteredIssues.length} found',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 1.h),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _filteredIssues.length,
            itemBuilder: (context, index) {
              final issue = _filteredIssues[index];
              return IssueSummaryCardWidget(
                issue: issue,
                onTap: () => _showIssueDetails(issue),
                onDismiss: () {},
              );
            },
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildNavigationDrawer() {
    // Drawer should use a light background and light primary/accent colors.
    return Drawer(
      // Drawer background should be white/light
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                // Use light accent colors for a soft header background
                gradient: LinearGradient(
                  colors: [
                    AppTheme.lightTheme.colorScheme.secondary.withOpacity(0.8), // Soft Teal
                    AppTheme.lightTheme.colorScheme.tertiary.withOpacity(0.8), // Soft Pink
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 8.w,
                    backgroundColor: Colors.white.withOpacity(0.5),
                    child: CustomIconWidget(
                      iconName: 'person',
                      color: Colors.white,
                      size: 8.w,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'John Citizen',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      color: Colors.white, // White text on colored header
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Active Community Member',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.8), // White text on colored header
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                children: [
                  _buildDrawerItem(
                    iconName: 'leaderboard',
                    title: 'Community Leaderboard',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _buildDrawerItem(
                    iconName: 'info',
                    title: 'Civic Resources',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _buildDrawerItem(
                    iconName: 'help',
                    title: 'Help & Support',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _buildDrawerItem(
                    iconName: 'settings',
                    title: 'Settings',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(4.w),
              child: Text(
                'CivicConnect v1.0',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required String iconName,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        color: AppTheme.lightTheme.colorScheme.primary,
        size: 6.w,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge,
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
    );
  }
}
