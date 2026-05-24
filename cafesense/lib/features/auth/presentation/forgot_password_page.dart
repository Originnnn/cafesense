import 'package:flutter/material.dart';

import 'package:cafesense/core/theme/app_colors.dart';
import 'login_page.dart';
import 'package:cafesense/features/auth/presentation/auth_shared_widgets.dart';
import 'otp_mobile_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _contactController = TextEditingController();

  @override
  void dispose() {
    _contactController.dispose();
    super.dispose();
  }

  bool _isValidContact(String value) {
    final String trimmed = value.trim();
    final bool validEmail = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(trimmed);
    final bool validPhone = RegExp(r'^\d{9,11}$').hasMatch(trimmed);
    return validEmail || validPhone;
  }

  void _onSendCode() {
    final String contact = _contactController.text;
    if (!_isValidContact(contact)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập email hoặc số điện thoại hợp lệ.')),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const OtpMobilePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Quên mật khẩu',
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              height: 320,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Center(
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.lock_reset, color: AppColors.primary, size: 72),
                ),
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Quên mật khẩu?',
              style: TextStyle(fontFamily: 'Epilogue', fontWeight: FontWeight.w800, fontSize: 22),
            ),
            const SizedBox(height: 12),
            const Text(
              'Đừng lo lắng! Nhập email hoặc số điện thoại của bạn để nhận mã xác thực thiết lập lại mật khẩu.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.secondary, fontSize: 17, height: 1.55),
            ),
            const SizedBox(height: 22),
            const SectionLabel('EMAIL / SỐ ĐIỆN THOẠI'),
            const SizedBox(height: 10),
            Container(
              height: 72,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.mail, color: AppColors.outline, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _contactController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'example@email.com',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: AppColors.outline, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            PrimaryButton(label: 'Gửi mã xác nhận', onPressed: _onSendCode),
            const SizedBox(height: 18),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute<void>(builder: (BuildContext context) => const LoginPage()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chevron_left, color: AppColors.secondary),
                  Text(
                    'Quay lại Đăng nhập',
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
