import 'package:flutter/material.dart';

import 'package:cafesense/core/theme/app_colors.dart';
import 'login_page.dart';
import 'package:cafesense/features/auth/presentation/auth_shared_widgets.dart';

class SetPasswordPage extends StatefulWidget {
  const SetPasswordPage({super.key});

  @override
  State<SetPasswordPage> createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends State<SetPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _onContinue() {
    final String password = _passwordController.text;
    final bool hasMinLength = password.length >= 8;
    final bool hasLetter = RegExp(r'[A-Za-z]').hasMatch(password);
    final bool hasDigit = RegExp(r'\d').hasMatch(password);

    if (!hasMinLength || !hasLetter || !hasDigit) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu cần >= 8 ký tự, gồm chữ và số.')),
      );
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (BuildContext context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Đặt mật khẩu',
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SmallBar(false),
                SmallBar(false),
                SmallBar(true),
              ],
            ),
            const SizedBox(height: 18),
            Center(
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Icon(Icons.lock, color: AppColors.primary, size: 44),
              ),
            ),
            const SizedBox(height: 18),
            const Center(
              child: Text(
                'Đặt mật khẩu',
                style: TextStyle(
                  fontFamily: 'Epilogue',
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  fontSize: 23,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'Hãy tạo một mật khẩu mạnh để bảo vệ tài khoản và những trải nghiệm hương vị của bạn.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.secondary, fontSize: 17, height: 1.5),
              ),
            ),
            const SizedBox(height: 24),
            const SectionLabel('MẬT KHẨU MỚI'),
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
                  const Icon(Icons.lock_outline, color: AppColors.outline, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: const InputDecoration(
                        hintText: 'Nhập ít nhất 8 ký tự',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: AppColors.outline, fontSize: 18),
                      ),
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.outline,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Text('ĐỘ MẠNH: ', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.secondary)),
                Text('TRUNG BÌNH', style: TextStyle(color: Color(0xFFE0A700), fontWeight: FontWeight.w800)),
                Spacer(),
                Text('60%', style: TextStyle(color: AppColors.outline, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                Expanded(child: StrengthSegment(color: Color(0xFFE74C3C), active: true)),
                SizedBox(width: 6),
                Expanded(child: StrengthSegment(color: Color(0xFFE0A700), active: true)),
                SizedBox(width: 6),
                Expanded(child: StrengthSegment(color: AppColors.outlineVariant, active: false)),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                children: [
                  RuleItem('Ít nhất 8 ký tự', true),
                  SizedBox(height: 10),
                  RuleItem('Chữ thường', true),
                  SizedBox(height: 10),
                  RuleItem('Chữ hoa', false),
                  SizedBox(height: 10),
                  RuleItem('Chữ số (0-9)', false),
                ],
              ),
            ),
            const SizedBox(height: 18),
            PrimaryButton(label: 'Tiếp tục', onPressed: _onContinue),
          ],
        ),
      ),
    );
  }
}
