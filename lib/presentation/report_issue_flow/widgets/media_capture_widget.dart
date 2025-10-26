import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MediaCaptureWidget extends StatefulWidget {
  final List<XFile> capturedImages;
  final String? audioRecordingPath;
  final String description;
  final Function(List<XFile>) onImagesChanged;
  final Function(String?) onAudioChanged;
  final Function(String) onDescriptionChanged;

  const MediaCaptureWidget({
    Key? key,
    required this.capturedImages,
    this.audioRecordingPath,
    required this.description,
    required this.onImagesChanged,
    required this.onAudioChanged,
    required this.onDescriptionChanged,
  }) : super(key: key);

  @override
  State<MediaCaptureWidget> createState() => _MediaCaptureWidgetState();
}

class _MediaCaptureWidgetState extends State<MediaCaptureWidget> {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isRecording = false;
  final AudioRecorder _audioRecorder = AudioRecorder();
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _descriptionController.text = widget.description;
    _initializeCamera();
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    return (await Permission.camera.request()).isGranted;
  }

  Future<bool> _requestMicrophonePermission() async {
    if (kIsWeb) return true;
    return (await Permission.microphone.request()).isGranted;
  }

  Future<void> _initializeCamera() async {
    try {
      if (!await _requestCameraPermission()) return;

      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;

      final camera = kIsWeb
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
          orElse: () => _cameras.first)
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
          orElse: () => _cameras.first);

      _cameraController = CameraController(
          camera, kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high);

      await _cameraController!.initialize();
      await _applySettings();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    }
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
      if (!kIsWeb) {
        try {
          await _cameraController!.setFlashMode(FlashMode.auto);
        } catch (e) {
          debugPrint('Flash mode not supported: $e');
        }
      }
    } catch (e) {
      debugPrint('Camera settings error: $e');
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final XFile photo = await _cameraController!.takePicture();
      final updatedImages = List<XFile>.from(widget.capturedImages)..add(photo);
      widget.onImagesChanged(updatedImages);
    } catch (e) {
      debugPrint('Photo capture error: $e');
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        final updatedImages = List<XFile>.from(widget.capturedImages)..add(image);
        widget.onImagesChanged(updatedImages);
      }
    } catch (e) {
      debugPrint('Gallery pick error: $e');
    }
  }

  Future<void> _startRecording() async {
    if (!await _requestMicrophonePermission()) return;

    try {
      if (await _audioRecorder.hasPermission()) {
        setState(() {
          _isRecording = true;
        });

        if (kIsWeb) {
          await _audioRecorder.start(
              const RecordConfig(encoder: AudioEncoder.wav),
              path: 'recording.wav');
        } else {
          final dir = await getTemporaryDirectory();
          String path =
              '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
          await _audioRecorder.start(const RecordConfig(), path: path);
        }
      }
    } catch (e) {
      setState(() {
        _isRecording = false;
      });
      debugPrint('Recording start error: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      final String? path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
      });

      if (path != null) {
        widget.onAudioChanged(path);
      }
    } catch (e) {
      setState(() {
        _isRecording = false;
      });
      debugPrint('Recording stop error: $e');
    }
  }

  void _removeImage(int index) {
    final updatedImages = List<XFile>.from(widget.capturedImages);
    updatedImages.removeAt(index);
    widget.onImagesChanged(updatedImages);
  }

  void _removeAudioRecording() {
    widget.onAudioChanged(null);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // FIX: Wrapped in SingleChildScrollView
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Media & Description',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Provide photos, voice notes, or detailed description of the issue',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),

          if (_isCameraInitialized && _cameraController != null)
            Container(
              height: 25.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CameraPreview(_cameraController!),
              ),
            ),

          SizedBox(height: 2.h),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _capturePhoto,
                  icon: CustomIconWidget(
                    iconName: 'camera_alt',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 5.w,
                  ),
                  label: Text(
                    'Take Photo',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickImageFromGallery,
                  icon: CustomIconWidget(
                    iconName: 'photo_library',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 5.w,
                  ),
                  label: Text(
                    'Gallery',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isRecording ? _stopRecording : _startRecording,
              icon: CustomIconWidget(
                iconName: _isRecording ? 'stop' : 'mic',
                color: _isRecording
                    ? Colors.white
                    : AppTheme.lightTheme.colorScheme.onSecondary,
                size: 5.w,
              ),
              label: Text(
                _isRecording ? 'Stop Recording' : 'Record Voice Note',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: _isRecording
                      ? Colors.white
                      : AppTheme.lightTheme.colorScheme.onSecondary,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isRecording
                    ? Colors.red
                    : AppTheme.lightTheme.colorScheme.secondary,
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
              ),
            ),
          ),

          SizedBox(height: 3.h),

          if (widget.capturedImages.isNotEmpty) ...[
            Text(
              'Captured Images (${widget.capturedImages.length})',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 1.h),
            SizedBox(
              height: 15.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.capturedImages.length,
                itemBuilder: (context, index) {
                  final image = widget.capturedImages[index];
                  return Container(
                    margin: EdgeInsets.only(right: 2.w),
                    child: Stack(
                      children: [
                        Container(
                          width: 20.w,
                          height: 15.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.outline,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: kIsWeb
                                ? Image.network(
                              image.path,
                              fit: BoxFit.cover,
                            )
                                : Image.file(
                              File(image.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 1.w,
                          right: 1.w,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Container(
                              padding: EdgeInsets.all(1.w),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: CustomIconWidget(
                                iconName: 'close',
                                color: Colors.white,
                                size: 3.w,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 2.h),
          ],

          if (widget.audioRecordingPath != null) ...[
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.secondary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.secondary,
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'audiotrack',
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    size: 6.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Voice recording captured',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.secondary,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _removeAudioRecording,
                    child: CustomIconWidget(
                      iconName: 'delete',
                      color: Colors.red,
                      size: 5.w,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
          ],

          Text(
            'Description *',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          TextField(
            controller: _descriptionController,
            maxLines: 4,
            maxLength: 500,
            onChanged: widget.onDescriptionChanged,
            decoration: InputDecoration(
              hintText: 'Describe the issue in detail...',
              counterText: '${_descriptionController.text.length}/500',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _audioRecorder.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}