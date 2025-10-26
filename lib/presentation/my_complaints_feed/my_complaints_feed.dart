import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import './widgets/analytics_bottom_sheet_widget.dart';
import './widgets/complaint_card_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_chips_widget.dart';

class MyComplaintsFeed extends StatefulWidget {
  const MyComplaintsFeed({Key? key}) : super(key: key);

  @override
  State<MyComplaintsFeed> createState() => _MyComplaintsFeedState();
}

class _MyComplaintsFeedState extends State<MyComplaintsFeed>
    with TickerProviderStateMixin {
  String _selectedFilter = 'all';
  bool _isSearchVisible = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _filteredComplaints = [];
  bool _isRefreshing = false;
  late AnimationController _searchAnimationController;
  late Animation<double> _searchAnimation;

  // Mock data for complaints
  final List<Map<String, dynamic>> _allComplaints = [
    {
      "id": 1,
      "title": "Broken Street Light on Main Street",
      "description":
      "The street light has been flickering for weeks and now completely stopped working. This creates safety concerns for pedestrians during evening hours.",
      "category": "Infrastructure",
      "status": "in_progress",
      "urgency": "high",
      "progress": 0.65,
      "location": "Main Street, Downtown",
      "submittedDate": "2025-10-10T14:30:00Z",
      "estimatedResolution": "2-3 days",
      "image":
      "https://images.unsplash.com/photo-1598319777103-040a1bb94dc2",
      "semanticLabel":
      "Broken street lamp post on urban sidewalk with damaged electrical components visible"
    },
    {
      "id": 2,
      "title": "Pothole on Elm Avenue",
      "description":
      "Large pothole causing damage to vehicles and creating hazardous driving conditions. Multiple cars have reported tire damage.",
      "category": "Roads",
      "status": "resolved",
      "urgency": "medium",
      "progress": 1.0,
      "location": "Elm Avenue, Residential Area",
      "submittedDate": "2025-10-08T09:15:00Z",
      "estimatedResolution": "Completed",
      "image":
      "https://images.unsplash.com/photo-1728340964368-59c3192e44e6",
      "semanticLabel":
      "Large pothole in asphalt road surface with cracked edges and debris"
    },
    {
      "id": 3,
      "title": "Overflowing Garbage Bin",
      "description":
      "Public garbage bin near the park has been overflowing for several days, attracting pests and creating unsanitary conditions.",
      "category": "Sanitation",
      "status": "under_review",
      "urgency": "medium",
      "progress": 0.3,
      "location": "Central Park, North Entrance",
      "submittedDate": "2025-10-12T16:45:00Z",
      "estimatedResolution": "1-2 days",
      "image":
      "https://images.unsplash.com/photo-1612626957978-6ba7195f329c",
      "semanticLabel":
      "Overflowing public waste bin with garbage scattered around base in park setting"
    },
    {
      "id": 4,
      "title": "Graffiti on Public Building",
      "description":
      "Vandalism on the side wall of the community center building. The graffiti covers a large area and needs professional cleaning.",
      "category": "Vandalism",
      "status": "pending",
      "urgency": "low",
      "progress": 0.0,
      "location": "Community Center, West Side",
      "submittedDate": "2025-10-11T11:20:00Z",
      "estimatedResolution": "5-7 days",
      "image":
      "https://images.unsplash.com/photo-1679047341236-c15d9c1fbdbb",
      "semanticLabel":
      "Colorful graffiti artwork on concrete wall of public building"
    },
    {
      "id": 5,
      "title": "Damaged Park Bench",
      "description":
      "Wooden park bench has broken slats and loose bolts, making it unsafe for public use. Located near the playground area.",
      "category": "Parks",
      "status": "resolved",
      "urgency": "medium",
      "progress": 1.0,
      "location": "Riverside Park, Playground Area",
      "submittedDate": "2025-10-05T13:10:00Z",
      "estimatedResolution": "Completed",
      "image":
      "https://images.unsplash.com/photo-1611305276643-28dc52e98303",
      "semanticLabel":
      "Wooden park bench with damaged slats and metal frame in outdoor park setting"
    },
    {
      "id": 6,
      "title": "Blocked Storm Drain",
      "description":
      "Storm drain is completely blocked with leaves and debris, causing water to pool during rain. This could lead to flooding issues.",
      "category": "Drainage",
      "status": "in_progress",
      "urgency": "high",
      "progress": 0.8,
      "location": "Oak Street, Intersection",
      "submittedDate": "2025-10-09T08:30:00Z",
      "estimatedResolution": "1 day",
      "image":
      "https://images.unsplash.com/photo-1597072956811-99b9e74e7136",
      "semanticLabel":
      "Clogged storm drain grate covered with fallen leaves and debris on street"
    }
  ];

  // Mock analytics data
  final Map<String, dynamic> _analyticsData = {
    "totalSubmitted": 12,
    "resolvedCount": 8,
    "avgResolutionTime": "4.2 days",
    "civicScore": 85,
    "monthlyReports": 3,
    "monthlyResolved": 2,
    "communityRank": 47,
    "badges": [
      {"name": "First Reporter", "icon": "flag"},
      {"name": "Problem Solver", "icon": "build"},
      {"name": "Community Hero", "icon": "star"},
      {"name": "Persistent", "icon": "trending_up"},
    ]
  };

  @override
  void initState() {
    super.initState();
    _filteredComplaints = _allComplaints;
    _searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _searchAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _searchAnimationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _searchAnimationController.dispose();
    super.dispose();
  }

  void _filterComplaints(String filter) {
    setState(() {
      _selectedFilter = filter;
      if (filter == 'all') {
        _filteredComplaints = _allComplaints;
      } else if (filter == 'active') {
        _filteredComplaints = _allComplaints
            .where((complaint) =>
        complaint['status'] == 'in_progress' ||
            complaint['status'] == 'under_review' ||
            complaint['status'] == 'pending')
            .toList();
      } else if (filter == 'resolved') {
        _filteredComplaints = _allComplaints
            .where((complaint) => complaint['status'] == 'resolved')
            .toList();
      } else if (filter == 'archived') {
        _filteredComplaints = []; // No archived complaints in mock data
      }
      _applySearchFilter();
    });
  }

  void _applySearchFilter() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      return;
    }

    setState(() {
      _filteredComplaints = _filteredComplaints.where((complaint) {
        final title = (complaint['title'] as String? ?? '').toLowerCase();
        final category = (complaint['category'] as String? ?? '').toLowerCase();
        final location = (complaint['location'] as String? ?? '').toLowerCase();
        final description =
        (complaint['description'] as String? ?? '').toLowerCase();

        return title.contains(query) ||
            category.contains(query) ||
            location.contains(query) ||
            description.contains(query);
      }).toList();
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
      if (_isSearchVisible) {
        _searchAnimationController.forward();
      } else {
        _searchAnimationController.reverse();
        _searchController.clear();
        _filterComplaints(_selectedFilter);
      }
    });
  }

  Future<void> _refreshComplaints() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Provide haptic feedback
    HapticFeedback.lightImpact();

    setState(() {
      _isRefreshing = false;
      // In a real app, this would fetch fresh data from the server
      _filterComplaints(_selectedFilter);
    });
  }

  void _showAnalyticsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AnalyticsBottomSheetWidget(
        analyticsData: _analyticsData,
      ),
    );
  }

  Map<String, int> _getFilterCounts() {
    return {
      'all': _allComplaints.length,
      'active': _allComplaints
          .where((c) =>
      c['status'] == 'in_progress' ||
          c['status'] == 'under_review' ||
          c['status'] == 'pending')
          .length,
      'resolved': _allComplaints.where((c) => c['status'] == 'resolved').length,
      'archived': 0, // No archived complaints in mock data
    };
  }

  void _navigateToComplaintDetails(Map<String, dynamic> complaint) {
    Navigator.pushNamed(
      context,
      '/complaint-details-tracking',
      arguments: complaint,
    );
  }

  void _shareComplaint(Map<String, dynamic> complaint) {
    HapticFeedback.selectionClick();
    // In a real app, this would use the share plugin
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing complaint: ${complaint['title']}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _addUpdate(Map<String, dynamic> complaint) {
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Adding update to: ${complaint['title']}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _markResolved(Map<String, dynamic> complaint) {
    HapticFeedback.selectionClick();
    setState(() {
      complaint['status'] = 'resolved';
      complaint['progress'] = 1.0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Marked as resolved: ${complaint['title']}'),
        duration: const Duration(seconds: 2),
        backgroundColor: Theme.of(context).colorScheme.tertiary, // Use theme for success/tertiary color
      ),
    );
  }

  void _archiveComplaint(Map<String, dynamic> complaint) {
    HapticFeedback.selectionClick();
    setState(() {
      _allComplaints.remove(complaint);
      _filterComplaints(_selectedFilter);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Archived: ${complaint['title']}'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _allComplaints.add(complaint);
              _filterComplaints(_selectedFilter);
            });
          },
        ),
      ),
    );
  }

  void _reportFirstIssue() {
    Navigator.pushNamed(context, '/report-issue-flow');
  }

  @override
  Widget build(BuildContext context) {
    // Access theme properties dynamically
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final appBarTheme = Theme.of(context).appBarTheme;

    return Scaffold(
      backgroundColor: colorScheme.background, // Use theme color
      appBar: AppBar(
        title: _isSearchVisible
            ? _buildSearchField(context)
            : Text(
          'My Issues',
          style: appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            onPressed: _toggleSearch,
            icon: CustomIconWidget(
              iconName: _isSearchVisible ? 'close' : 'search',
              color: appBarTheme.iconTheme?.color ??
                  colorScheme.onSurface, // Use theme color
              size: 24,
            ),
          ),
          IconButton(
            onPressed: _showAnalyticsBottomSheet,
            icon: CustomIconWidget(
              iconName: 'analytics',
              color: appBarTheme.iconTheme?.color ??
                  colorScheme.onSurface, // Use theme color
              size: 24,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          FilterChipsWidget(
            selectedFilter: _selectedFilter,
            onFilterChanged: _filterComplaints,
            filterCounts: _getFilterCounts(),
          ),
          // Main content
          Expanded(
            child: _filteredComplaints.isEmpty
                ? EmptyStateWidget(onReportFirstIssue: _reportFirstIssue)
                : RefreshIndicator(
              onRefresh: _refreshComplaints,
              color: colorScheme.primary, // Use theme color
              child: ListView.builder(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: _filteredComplaints.length,
                itemBuilder: (context, index) {
                  final complaint = _filteredComplaints[index];
                  return ComplaintCardWidget(
                    complaint: complaint,
                    onTap: () => _navigateToComplaintDetails(complaint),
                    onShare: () => _shareComplaint(complaint),
                    onAddUpdate: () => _addUpdate(complaint),
                    onMarkResolved: () => _markResolved(complaint),
                    onArchive: () => _archiveComplaint(complaint),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      // --- REMOVED THE bottomNavigationBar PROPERTY ---
      // This screen is nested within MainNavigationShell, which provides the bottom bar.
    );
  }

  Widget _buildSearchField(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AnimatedBuilder(
      animation: _searchAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _searchAnimation.value,
          child: TextField(
            controller: _searchController,
            autofocus: true,
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onPrimary, // Text color in AppBar
            ),
            decoration: InputDecoration(
              hintText: 'Search complaints...',
              hintStyle: textTheme.titleMedium?.copyWith(
                color: colorScheme.onPrimary.withOpacity(0.7), // Use theme color
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: (value) => _applySearchFilter(),
          ),
        );
      },
    );
  }
}
