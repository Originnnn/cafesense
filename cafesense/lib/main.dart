import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:easy_localization/easy_localization.dart';

import 'app.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // File do flutterfire tự tạo ra

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Khởi tạo Firebase và kiểm tra kết nối
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ Kết nối Firebase thành công!');
  } catch (e) {
    debugPrint('❌ Lỗi kết nối Firebase: $e');
  }

  await EasyLocalization.ensureInitialized();
  
  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  
  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const [Locale('vi', ''), Locale('en', ''), Locale('ja', ''), Locale('fr', '')],
        path: 'assets/translations',
        fallbackLocale: const Locale('vi', ''),
        child: const CafeSenseApp(),
      ),
    ),
  );
}

