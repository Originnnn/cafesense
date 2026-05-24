import 'package:flutter/material.dart';

import 'package:cafesense/core/theme/app_colors.dart';
import 'package:cafesense/features/auth/presentation/auth_shared_widgets.dart';
import 'set_password_page.dart';

class OtpMobilePage extends StatefulWidget {
  const OtpMobilePage({super.key});

  @override
  State<OtpMobilePage> createState() => _OtpMobilePageState();
}

class _OtpMobilePageState extends State<OtpMobilePage> {
  final List<TextEditingController> _controllers = List<TextEditingController>.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List<FocusNode>.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final TextEditingController controller in _controllers) {
      controller.dispose();
    }
    for (final FocusNode node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < _focusNodes.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  void _onConfirmOtp() {
    final String otp = _controllers.map((TextEditingController c) => c.text).join();
    final bool validOtp = RegExp(r'^\d{6}$').hasMatch(otp);

    if (!validOtp) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP phải gồm đúng 6 chữ số.')),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const SetPasswordPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Xác minh OTP',
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 156,
                    height: 156,
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(Icons.shield, color: AppColors.primary, size: 66),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Xác minh tài khoản',
                    style: TextStyle(fontFamily: 'Epilogue', fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Chúng tôi đã gửi mã xác minh gồm 6 chữ số tới số điện thoại/email của bạn.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.secondary, fontSize: 17, height: 1.55),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List<Widget>.generate(6, (int index) {
                      return OtpDigitInput(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        onChanged: (String value) => _onOtpChanged(index, value),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.schedule, size: 18, color: AppColors.secondary),
                        SizedBox(width: 8),
                        Text(
                          'Gửi lại mã sau 60s',
                          style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  PrimaryButton(label: 'Xác nhận', onPressed: _onConfirmOtp),
                  const SizedBox(height: 22),
                  const Text(
                    'Gặp khó khăn? Liên hệ hỗ trợ',
                    style: TextStyle(color: AppColors.secondary, fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                NavItem(icon: Icons.home, label: 'Trang chủ'),
                NavItem(icon: Icons.restaurant_menu, label: 'Thực đơn'),
                NavItem(icon: Icons.receipt_long, label: 'Đơn hàng'),
                NavItem(icon: Icons.person, label: 'Cá nhân', active: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
