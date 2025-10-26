import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart'; // Use this for coordinates
import 'package:permission_handler/permission_handler.dart';

import '../../core/app_export.dart';
import 'widgets/complaint_preview_sheet.dart';
import 'widgets/floating_action_buttons.dart';
import 'widgets/map_filter_panel.dart';
import 'widgets/map_search_bar.dart';
import 'widgets/location_search_delegate.dart';

class InteractiveMapScreen extends StatefulWidget {
  const InteractiveMapScreen({super.key});

  @override
  State<InteractiveMapScreen> createState() => _InteractiveMapScreenState();
}

class _InteractiveMapScreenState extends State<InteractiveMapScreen> {
  final MapController _mapController = MapController();
  bool _isLocationLoading = false;
  List<Marker> _markers = [];

  // Mock data for demonstration
  final List<Map<String, dynamic>> _complaints = [
    {
      'id': 'CMP001', 'title': 'Pothole on Main Street', 'description': 'Large pothole causing issues.',
      'location': {'lat': 28.6315, 'lng': 77.2167}
    },
    {
      'id': 'CMP002', 'title': 'Water Leak in Park', 'description': 'Continuous water leak.',
      'location': {'lat': 28.6139, 'lng': 77.2090}
    },
  ];

  @override
  void initState() {
    super.initState();
    _createMarkers();
  }

  Future<void> _getCurrentLocation() async {
    // ... (Permission and location fetching logic remains the same) ...
    // When location is found:
    final position = await Geolocator.getCurrentPosition();
    _mapController.move(LatLng(position.latitude, position.longitude), 15.0);
  }

  void _createMarkers() {
    var markers = _complaints.map((complaint) {
      final location = complaint['location'] as Map<String, dynamic>;
      return Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(location['lat'], location['lng']),
        child: GestureDetector(
          onTap: () => _showComplaintPreview(complaint),
          child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
        ),
      );
    }).toList();

    setState(() {
      _markers = markers;
    });
  }

  void _showComplaintPreview(Map<String, dynamic> complaint) {
    // ... (This function remains the same) ...
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(28.6139, 77.2090), // Default to Delhi
              initialZoom: 12.0,
            ),
            children: [
              // The actual map background
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.civicconnect',
              ),
              // The layer where markers are drawn
              MarkerLayer(markers: _markers),
            ],
          ),
          // ... (The rest of your UI Stack remains the same) ...
        ],
      ),
    );
  }
}