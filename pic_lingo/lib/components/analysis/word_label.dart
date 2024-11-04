import 'package:flutter/material.dart';

class WordLabel extends StatelessWidget {
  final String word;
  final String phonetic;
  final double confidence;

  const WordLabel({
    super.key,
    required this.word,
    required this.phonetic,
    required this.confidence,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Row(
          children: [
            Text(
              word,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              phonetic,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.volume_up),
              onPressed: () {
                // 播放發音功能
              },
            ),
            IconButton(
              icon: const Icon(Icons.mic),
              onPressed: () {
                // 錄音功能
              },
            ),
          ],
        ),
      ),
    );
  }
} 