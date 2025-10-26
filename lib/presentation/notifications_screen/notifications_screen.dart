import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/empty_notifications_widget.dart';
import './widgets/notification_card_widget.dart';
import './widgets/notification_filter_widget.dart';
import './widgets/notification_search_widget.dart';
import './widgets/notification_settings_widget.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  String _selectedFilter = 'All';
  String _searchQuery = '';
  bool _isSearchVisible = false;
  List<String> _recentSearches = ['complaint update', 'community', 'resolved'];

  late AnimationController _refreshController;
  late Animation<double> _refreshAnimation;

  final List<String> _filters = [
    'All',
    'My Complaints',
    'Community Updates',
    'System Messages'
  ];

  final Map<String, bool> _notificationSettings = {
    'pushNotifications': true,
    'complaintUpdates': true,
    'communityUpdates': true,
    'systemMessages': true,
    'emergencyAlerts': true,
    'quietHours': false,
    'notificationSound': true,
    'vibration': true,
  };

  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 1,
      'type': 'emergency',
      'title': 'Emergency: Water Main Break',
      'message':
      'Water service disruption on Main Street. Crews are working to restore service. Expected completion: 6 PM today.',
      'timestamp': DateTime.now().subtract(Duration(minutes: 15)),
      'isRead': false,
      'relatedScreen': '/interactive-map-screen',
    },
    {
      'id': 2,
      'type': 'complaint_update',
      'title': 'Complaint #CM2024-001 Updated',
      'message':
      'Your pothole complaint has been assigned to the Public Works Department. Work is scheduled to begin next week.',
      'timestamp': DateTime.now().subtract(Duration(hours: 2)),
      'isRead': false,
      'relatedScreen': '/complaint-details-screen',
    },
    {
      'id': 3,
      'type': 'community_achievement',
      'title': 'Community Milestone Reached!',
      'message':
      'Great news! Our neighborhood has resolved 50 complaints this month. Thank you for your active participation in making our community better.',
      'timestamp': DateTime.now().subtract(Duration(hours: 4)),
      'isRead': true,
      'relatedScreen': '/interactive-map-screen',
    },
    {
      'id': 4,
      'type': 'authority_response',
      'title': 'Response from Parks Department',
      'message':
      'Thank you for reporting the broken playground equipment. Our maintenance team will inspect and repair the swing set by Friday.',
      'timestamp': DateTime.now().subtract(Duration(hours: 8)),
      'isRead': true,
      'relatedScreen': '/complaint-tracking-screen',
    },
    {
      'id': 5,
      'type': 'system_message',
      'title': 'App Update Available',
      'message':
      'CivicConnect v2.1 is now available with improved map features and faster complaint submission. Update now for the best experience.',
      'timestamp': DateTime.now().subtract(Duration(days: 1)),
      'isRead': false,
      'relatedScreen': '/user-profile-screen',
    },
    {
      'id': 6,
      'type': 'complaint_update',
      'title': 'Complaint #CM2024-002 Resolved',
      'message':
      'Your street lighting complaint has been resolved. The new LED streetlight has been installed and is now operational.',
      'timestamp': DateTime.now().subtract(Duration(days: 2)),
      'isRead': true,
      'relatedScreen': '/complaint-details-screen',
    },
    {
      'id': 7,
      'type': 'community_achievement',
      'title': 'You Earned a Badge!',
      'message':
      'Congratulations! You\'ve earned the "Community Champion" badge for submitting 5 helpful complaints. Keep making a difference!',
      'timestamp': DateTime.now().subtract(Duration(days: 3)),
      'isRead': true,
      'relatedScreen': '/user-profile-screen',
    },
    {
      'id': 8,
      'type': 'authority_response',
      'title': 'Traffic Department Update',
      'message':
      'Your traffic signal timing complaint is under review. We\'re conducting a traffic study and will implement changes within 30 days.',
      'timestamp': DateTime.now().subtract(Duration(days: 5)),
      'isRead': true,
      'relatedScreen': '/complaint-tracking-screen',
    },
  ];

  @override
  void initState() {
    super.initState();
    _refreshController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    _refreshAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _refreshController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredNotifications {
    List<Map<String, dynamic>> filtered = _notifications;

    // Apply filter
    if (_selectedFilter != 'All') {
      filtered = filtered.where((notification) {
        switch (_selectedFilter) {
          case 'My Complaints':
            return notification['type'] == 'complaint_update';
          case 'Community Updates':
            return notification['type'] == 'community_achievement';
          case 'System Messages':
            return notification['type'] == 'system_message';
          default:
            return true;
        }
      }).toList();
    }

    // Apply search
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((notification) {
        final title = (notification['title'] as String).toLowerCase();
        final message = (notification['message'] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();
        return title.contains(query) || message.contains(query);
      }).toList();
    }

    return filtered;
  }

  int get _unreadCount {
    return _notifications
        .where((notification) => !(notification['isRead'] as bool))
        .length;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredNotifications = _filteredNotifications;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Notifications',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (_unreadCount > 0) ...[
              SizedBox(width: 2.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.error,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _unreadCount.toString(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onError,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isSearchVisible = !_isSearchVisible;
              });
            },
            icon: CustomIconWidget(
              iconName: _isSearchVisible ? 'search_off' : 'search',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
            tooltip: _isSearchVisible ? 'Hide search' : 'Search notifications',
          ),
          IconButton(
            onPressed: _showSettingsBottomSheet,
            icon: CustomIconWidget(
              iconName: 'settings',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
            tooltip: 'Notification settings',
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'mark_all_read',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'mark_email_read',
                      color: theme.colorScheme.onSurface,
                      size: 20,
                    ),
                    SizedBox(width: 3.w),
                    Text('Mark All Read'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'clear_all',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'clear_all',
                      color: theme.colorScheme.error,
                      size: 20,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Clear All',
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ],
                ),
              ),
            ],
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'more_vert',
                color: theme.colorScheme.onSurface,
                size: 24,
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: Column(
          children: [
            if (_isSearchVisible)
              NotificationSearchWidget(
                onSearchChanged: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                  if (query.isNotEmpty && !_recentSearches.contains(query)) {
                    setState(() {
                      _recentSearches.insert(0, query);
                      if (_recentSearches.length > 5) {
                        _recentSearches = _recentSearches.take(5).toList();
                      }
                    });
                  }
                },
                recentSearches: _recentSearches,
                onClearRecentSearches: () {
                  setState(() {
                    _recentSearches.clear();
                  });
                },
              ),
            NotificationFilterWidget(
              filters: _filters,
              selectedFilter: _selectedFilter,
              onFilterChanged: (filter) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
            ),
            Expanded(
              child: filteredNotifications.isEmpty
                  ? _searchQuery.isNotEmpty || _selectedFilter != 'All'
                  ? _buildNoResultsWidget(theme)
                  : EmptyNotificationsWidget(
                onEnableNotifications: _handleEnableNotifications,
              )
                  : ListView.builder(
                controller: _scrollController,
                padding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                itemCount: filteredNotifications.length,
                itemBuilder: (context, index) {
                  final notification = filteredNotifications[index];
                  return NotificationCardWidget(
                    notification: notification,
                    onTap: () => _handleNotificationTap(notification),
                    onDismiss: () => _handleNotificationDismiss(
                        notification['id'] as int),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsWidget(ThemeData theme) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'search_off',
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  size: 40,
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'No Results Found',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No notifications match "$_searchQuery"'
                  : 'No notifications in $_selectedFilter category',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                  _selectedFilter = 'All';
                  _isSearchVisible = false;
                });
              },
              child: Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    _refreshController.forward();

    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));

    // Add a new notification to simulate refresh
    if (mounted) {
      setState(() {
        _notifications.insert(0, {
          'id': DateTime.now().millisecondsSinceEpoch,
          'type': 'system_message',
          'title': 'Notifications Updated',
          'message':
          'Your notifications have been refreshed with the latest updates.',
          'timestamp': DateTime.now(),
          'isRead': false,
          'relatedScreen': '/notifications-screen',
        });
      });
    }

    _refreshController.reverse();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Notifications updated'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _handleNotificationTap(Map<String, dynamic> notification) {
    // Mark as read
    setState(() {
      notification['isRead'] = true;
    });

    // Navigate to related screen
    final relatedScreen = notification['relatedScreen'] as String?;
    if (relatedScreen != null && relatedScreen != '/notifications-screen') {
      Navigator.pushNamed(context, relatedScreen);
    }
  }

  void _handleNotificationDismiss(int notificationId) {
    setState(() {
      _notifications
          .removeWhere((notification) => notification['id'] == notificationId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notification dismissed'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // In a real app, you would restore the notification here
          },
        ),
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'mark_all_read':
        setState(() {
          for (var notification in _notifications) {
            notification['isRead'] = true;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('All notifications marked as read')),
        );
        break;
      case 'clear_all':
        _showClearAllDialog();
        break;
    }
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear All Notifications'),
        content: Text(
            'Are you sure you want to clear all notifications? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _notifications.clear();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('All notifications cleared')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _showSettingsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NotificationSettingsWidget(
        settings: _notificationSettings,
        onSettingsChanged: (newSettings) {
          setState(() {
            _notificationSettings.addAll(newSettings);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Notification settings updated')),
          );
        },
      ),
    );
  }

  void _handleEnableNotifications() {
    // In a real app, this would request notification permissions
    setState(() {
      _notificationSettings['pushNotifications'] = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Notifications enabled! You\'ll receive updates about your community.'),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
