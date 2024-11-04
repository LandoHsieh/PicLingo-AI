import 'package:flutter/material.dart';
import 'package:pic_lingo/components/camera_upload/camera_button.dart';
import 'package:pic_lingo/components/camera_upload/photo_preview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  XFile? _imageFile;
  CameraController? _controller;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeCamera();
    });
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('找不到相機')),
        );
        return;
      }
      
      _controller = CameraController(
        cameras[0],
        ResolutionPreset.medium,
      );

      await _controller!.initialize();
      if (!mounted) return;

      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('相機初始化錯誤: $e')),
      );
    }
  }

  Future<void> _takePicture() async {
    try {
      if (_controller == null || !_controller!.value.isInitialized) return;
      
      final image = await _controller!.takePicture();
      setState(() {
        _imageFile = image;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('拍照時發生錯誤: $e')),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('拍照'),
        actions: [
          if (_imageFile != null)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/photo-preview',
                  arguments: _imageFile,
                );
              },
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _imageFile != null
                  ? PhotoPreview(imageFile: _imageFile!)
                  : _isCameraInitialized
                      ? CameraPreview(_controller!)
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
            ),
            const SizedBox(height: 20),
            CameraButton(onPressed: _takePicture),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
} 