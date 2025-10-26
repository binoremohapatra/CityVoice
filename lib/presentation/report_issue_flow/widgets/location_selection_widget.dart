import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/foundation.dart';

import '../../../core/app_export.dart';
import 'location_search_bar.dart';

class LocationSelectionWidget extends StatefulWidget {
  final LatLng? selectedLocation;
  final Function(LatLng) onLocationSelected;

  const LocationSelectionWidget({
    Key? key,
    this.selectedLocation,
    required this.onLocationSelected,
  }) : super(key: key);

  @override
  State<LocationSelectionWidget> createState() =>
      _LocationSelectionWidgetState();
}

class _LocationSelectionWidgetState extends State<LocationSelectionWidget> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  LatLng? _currentLocation;
  bool _isLoadingLocation = false;
  String _locationAccuracy = '';

  static const double _maxZoomLevel = 18.0;

  @override
  void initState() {
    super.initState();
    if (widget.selectedLocation != null) {
      _currentLocation = widget.selectedLocation;
    } else {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLoadingLocation = false;
          _locationAccuracy = 'Location services disabled';
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _isLoadingLocation = false;
            _locationAccuracy = 'Location permission denied';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _isLoadingLocation = false;
          _locationAccuracy = 'Location permission permanently denied';
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final newLocation = LatLng(position.latitude, position.longitude);

      setState(() {
        _currentLocation = newLocation;
        _locationAccuracy = 'Accuracy: ±${position.accuracy.toInt()}m';
        _isLoadingLocation = false;
      });

      _mapController.move(newLocation, _maxZoomLevel);
      widget.onLocationSelected(newLocation);
    } catch (e) {
      setState(() {
        _isLoadingLocation = false;
        _locationAccuracy = 'Unable to get location';
      });
      if (kDebugMode) {
        print('Location error: $e');
      }
    }
  }

  void _onMapTap(TapPosition tapPosition, LatLng location) {
    HapticFeedback.lightImpact();
    setState(() {
      _currentLocation = location;
      _locationAccuracy = 'Pin dropped at this location';
    });
    widget.onLocationSelected(location);
  }

  Future<void> _onSearch() async {
    final query = _searchController.text;
    if (query.isEmpty) return;

    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final LatLng searchResult = LatLng(37.7749, -122.4194);

      setState(() {
        _currentLocation = searchResult;
        _locationAccuracy = 'Location found via search';
        _isLoadingLocation = false;
      });
      _mapController.move(searchResult, 14.0);
      widget.onLocationSelected(searchResult);

    } catch (e) {
      setState(() {
        _isLoadingLocation = false;
        _locationAccuracy = 'Search failed';
      });
      if (kDebugMode) {
        print('Search error: $e');
      }
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLocationSelected = _currentLocation != null;

    return SingleChildScrollView( // FIX: Wrapped the Column in SingleChildScrollView to prevent overflow
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Step 2: Select Location',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Tap on the map or use your current location to pinpoint the issue.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 3.h),
            LocationSearchBar(
              controller: _searchController,
              onSearch: _onSearch,
              onChanged: (value) {},
            ),
            SizedBox(height: 3.h),
            Stack(
              children: [
                Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.colorScheme.outline.withOpacity(0.5),
                      width: isLocationSelected ? 2 : 1,
                    ),
                    boxShadow: isLocationSelected
                        ? [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ]
                        : null,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: _currentLocation ?? LatLng(37.7749, -122.4194),
                        initialZoom: isLocationSelected ? _maxZoomLevel : 12.0,
                        onTap: _onMapTap,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.civicconnect',
                        ),
                        if (_currentLocation != null)
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: _currentLocation!,
                                child: const Icon(Icons.location_pin,
                                    color: Colors.red, size: 40),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 2.h,
                  right: 3.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: theme.shadowColor.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      _locationAccuracy,
                      style: theme.textTheme.labelMedium,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoadingLocation ? null : _getCurrentLocation,
                icon: _isLoadingLocation
                    ? SizedBox(
                  width: 4.w,
                  height: 4.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.onPrimary),
                  ),
                )
                    : const Icon(Icons.my_location),
                label: Text(
                  _isLoadingLocation
                      ? 'Getting Location...'
                      : 'Use Current Location',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 6.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}