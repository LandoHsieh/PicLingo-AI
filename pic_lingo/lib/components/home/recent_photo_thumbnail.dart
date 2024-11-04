import 'package:flutter/material.dart';
import 'package:pic_lingo/models/user_picture.dart';

class RecentPhotoThumbnail extends StatelessWidget {
  const RecentPhotoThumbnail({super.key});

  List<UserPicture> get _mockPictures => [
    UserPicture(
      pictureId: 1,
      userId: 1,
      imageUrl: 'https://picsum.photos/200',
      analyzedText: 'cat, animal, pet',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    UserPicture(
      pictureId: 2,
      userId: 1,
      imageUrl: 'https://picsum.photos/201',
      analyzedText: 'coffee, cup, drink',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    UserPicture(
      pictureId: 3,
      userId: 1,
      imageUrl: 'https://picsum.photos/202',
      analyzedText: 'book, study, education',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final recentPhotos = _mockPictures;

    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recentPhotos.length,
        itemBuilder: (context, index) {
          final photo = recentPhotos[index];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/analysis',
                  arguments: photo.pictureId,
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          photo.imageUrl,
                          width: 140,
                          height: 140,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getTimeAgo(photo.createdAt),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 140,
                    child: Text(
                      photo.analyzedText ?? '',
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inHours < 24) {
      return '${difference.inHours}小時前';
    } else {
      return '${difference.inDays}天前';
    }
  }
} 