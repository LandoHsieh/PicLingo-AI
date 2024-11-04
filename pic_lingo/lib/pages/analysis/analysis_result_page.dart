import 'package:flutter/material.dart';
import 'package:pic_lingo/components/analysis/word_label.dart';
// import 'package:pic_lingo/components/analysis/pronunciation_feedback.dart';
import 'package:pic_lingo/components/analysis/generated_sentence.dart';

class AnalysisResultPage extends StatelessWidget {
  final String imageUrl; // 暫時使用 String，之後可能會改為 File 或 XFile

  const AnalysisResultPage({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    // 模擬的分析結果數據
    final mockLabels = [
      {'word': 'cat', 'phonetic': '/kæt/', 'confidence': 0.95},
      {'word': 'pet', 'phonetic': '/pɛt/', 'confidence': 0.88},
      {'word': 'animal', 'phonetic': '/ˈænɪməl/', 'confidence': 0.82},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('分析結果'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // 重新分析功能
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // 刪除功能
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 照片預覽
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            
            // 標籤列表
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '辨識結果',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...mockLabels.map((label) => WordLabel(
                    word: label['word'] as String,
                    phonetic: label['phonetic'] as String,
                    confidence: label['confidence'] as double,
                  )).toList(),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 生成的句子
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: GeneratedSentence(
                sentence: "The cat is a lovely pet animal.",
                translation: "這隻貓是一個可愛的寵物動物。",
              ),
            ),
          ],
        ),
      ),
    );
  }
} 