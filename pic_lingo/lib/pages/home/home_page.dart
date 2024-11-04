import 'package:flutter/material.dart';
import 'package:pic_lingo/models/user.dart';
import 'package:pic_lingo/components/home/credit_display.dart';
import 'package:pic_lingo/components/home/recent_photo_thumbnail.dart';
import 'package:pic_lingo/components/home/plan_upgrade_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // 模擬從API獲取的用戶資料
  User get _mockUser => User(
    id: 1,
    username: "測試用戶",
    email: "test@example.com",
    tier: "free",
    dailyCreditLimit: 10,
    currentCredits: 7,
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
    updatedAt: DateTime.now(),
  );

  @override
  Widget build(BuildContext context) {
    final user = _mockUser;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('你好，${user.username}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 信用點數顯示
              const CreditDisplay(
                credits: 10, // 假資料
                usedToday: 5, // 假資料
              ),
              const SizedBox(height: 24),
              
              // 最新照片區域
              Text(
                '最近的學習記錄',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              const RecentPhotoThumbnail(),
              const SizedBox(height: 24),
              
              // 方案升級按鈕
              const PlanUpgradeButton(
                currentPlan: '免費方案', // 假資料
              ),
            ],
          ),
        ),
      ),
      // 底部導航欄
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首頁',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: '拍照',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: '記錄',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/camera');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/history');
          }
        },
      ),
    );
  }
} 