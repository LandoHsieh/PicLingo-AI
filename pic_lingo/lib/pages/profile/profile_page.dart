import 'package:flutter/material.dart';
import 'package:pic_lingo/components/profile/profile_edit_form.dart';
import 'package:pic_lingo/components/profile/subscription_status.dart';

class ProfilePage extends StatelessWidget {
  // 模擬用戶數據
  final Map<String, dynamic> mockUser = {
    'username': '測試用戶',
    'email': 'test@example.com',
    'tier': 'free',
    'daily_credit_limit': 10,
    'current_credits': 5,
    'created_at': DateTime.now().subtract(const Duration(days: 30)),
  };

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('個人資料'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 頭像區域
            Container(
              color: Theme.of(context).primaryColor,
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      child: Icon(Icons.person, size: 50),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      mockUser['username'],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // 個人資料表單
            ProfileEditForm(userData: mockUser),
            
            const SizedBox(height: 16),
            
            // 訂閱狀態
            SubscriptionStatus(
              tier: mockUser['tier'],
              creditLimit: mockUser['daily_credit_limit'],
              currentCredits: mockUser['current_credits'],
            ),
          ],
        ),
      ),
    );
  }
} 