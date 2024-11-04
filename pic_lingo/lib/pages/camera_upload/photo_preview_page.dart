import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pic_lingo/components/camera_upload/photo_preview.dart';

class PhotoPreviewPage extends StatelessWidget {
  final XFile imageFile;

  const PhotoPreviewPage({
    super.key,
    required this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('照片預覽'),
        actions: [
          TextButton.icon(
            onPressed: () {
              // TODO: 實作分析功能
              Navigator.pushNamed(context, '/analysis');
            },
            icon: const Icon(Icons.auto_awesome),
            label: const Text('開始分析'),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PhotoPreview(imageFile: imageFile),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '點擊「開始分析」按鈕進行 AI 分析',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 