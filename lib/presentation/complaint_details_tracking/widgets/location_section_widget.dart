import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sizer/sizer.dart';

class LocationSectionWidget extends StatelessWidget {
  final Map<String, dynamic> complaint;

  const LocationSectionWidget({
    super.key,
    required this.complaint,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Safely extract location data with fallback values
    final locationData = complaint['location'] as Map<String, dynamic>? ?? {};
    final lat = locationData['latitude'] as double? ?? 28.6139; // Default to Delhi
    final lng = locationData['longitude'] as double? ?? 77.2090; // Default to Delhi
    final address = locationData['address'] as String? ?? 'Location not specified';
    final complaintLocation = LatLng(lat, lng);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Location',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          // Map Preview using FlutterMap
          Container(
            height: 25.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colorScheme.outline.withOpacity(0.5)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: complaintLocation,
                  initialZoom: 16.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.civicconnect',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: complaintLocation,
                        width: 80,
                        height: 80,
                        child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),
          // Address and Action Button
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, color: theme.colorScheme.primary, size: 20),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        address,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () { /* Add "Open in Maps" logic here */ },
                    icon: const Icon(Icons.open_in_new, size: 18),
                    label: const Text('Open in Maps'),
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