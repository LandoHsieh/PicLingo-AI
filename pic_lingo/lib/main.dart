import 'package:flutter/material.dart';
import 'package:pic_lingo/components/camera_upload/photo_preview.dart';
import 'package:pic_lingo/pages/analysis/analysis_result_page.dart';
import 'package:pic_lingo/pages/auth/login_page.dart';
import 'package:pic_lingo/pages/auth/signup_page.dart';
import 'package:pic_lingo/pages/camera_upload/camera_page.dart';
import 'package:pic_lingo/pages/camera_upload/upload_page.dart';
import 'package:pic_lingo/pages/home/home_page.dart';
import 'package:pic_lingo/pages/camera_upload/photo_preview_page.dart';
import 'package:pic_lingo/pages/profile/profile_page.dart';
import 'package:pic_lingo/theme/app_theme.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PicLingo',
      theme: AppTheme.lightTheme,
      // 關閉 debug 標籤
      debugShowCheckedModeBanner: true,
      // 設定初始路由為登入頁面
      home: const LoginPage(),
      // home: const HomePage(),
      // 設定路由
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/home': (context) => const HomePage(),
        '/camera': (context) => const CameraPage(),
        '/upload': (context) => const UploadPage(),
        '/photo-preview': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as XFile;
          return PhotoPreviewPage(imageFile: args);
        },
        '/analysis': (context) => const AnalysisResultPage(
            imageUrl:
                "https://wallpapers.com/images/hd/cat-desktop-1920-x-1200-wallpaper-8uggswykdt2hzvxi.jpg"),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}
