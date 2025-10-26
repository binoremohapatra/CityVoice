import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationSelectionWidget extends StatefulWidget {
  final ValueChanged<LatLng> onLocationSelected;

  const LocationSelectionWidget({super.key, required this.onLocationSelected});

  @override
  State<LocationSelectionWidget> createState() => _LocationSelectionWidgetState();
}

class _LocationSelectionWidgetState extends State<LocationSelectionWidget> {
  final MapController _mapController = MapController();
  static const LatLng _initialCenter = LatLng(28.6139, 77.2090);
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Set initial location
    widget.onLocationSelected(_initialCenter);
  }

  Future<void> _getCurrentLocation() async {
    // ... (Location fetching logic is the same) ...
    final position = await Geolocator.getCurrentPosition();
    final currentLocation = LatLng(position.latitude, position.longitude);
    widget.onLocationSelected(currentLocation);
    _mapController.move(currentLocation, 16.0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Step 2: Pinpoint the Location', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 24),
          SizedBox(
            height: 400,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _initialCenter,
                      initialZoom: 12.0,
                      onPositionChanged: (position, hasGesture) {
                        if (hasGesture) {
                          widget.onLocationSelected(position.center!);
                        }
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.civicconnect',
                      ),
                    ],
                  ),
                  const Icon(Icons.location_pin, color: Colors.red, size: 50),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _getCurrentLocation,
              icon: _isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.my_location),
              label: const Text('Use My Current Location'),
            ),
          ),
        ],
      ),
    );
  }
}