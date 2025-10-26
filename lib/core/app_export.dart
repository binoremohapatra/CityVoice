// This barrel file is used to export common packages and files
// so they can be imported with a single line in other files.
export 'package:flutter/material.dart';
export 'package:flutter/services.dart';
export 'package:sizer/sizer.dart';
export 'package:latlong2/latlong.dart' hide Path;
export 'package:flutter_map/flutter_map.dart';
export 'package:geolocator/geolocator.dart';
export 'package:camera/camera.dart';

// Exporting your app's foundational files
export '../../routes/app_routes.dart';
export '../../theme/app_theme.dart';
export '../../widgets/custom_icon_widget.dart';
export '../../widgets/custom_image_widget.dart';
export '../../widgets/custom_app_bar.dart';
export '../../widgets/custom_bottom_bar.dart';