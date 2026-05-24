import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import "package:cafesense/core/theme/app_colors.dart";
import "package:cafesense/features/auth/presentation/success_page.dart";

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final List<TextEditingController> _controllers =
      List<TextEditingController>.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes =
      List<FocusNode>.generate(6, (_) => FocusNode());

  bool _showOtpError = false;
  Timer? _resendToastTimer;

  @override
  void dispose() {
    for (final TextEditingController controller in _controllers) {
      controller.dispose();
    }
    for (final FocusNode node in _focusNodes) {
      node.dispose();
    }
    _resendToastTimer?.cancel();
    super.dispose();
  }

  void _onResendCodePressed() {
    _resendToastTimer?.cancel();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF4D5A39),
        content: const Text('Mã mới đã được gửi thành công!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );

    _resendToastTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    });
  }

  void _onOtpChanged(int index, String value) {
    if (_showOtpError) {
      setState(() {
        _showOtpError = false;
      });
    }

    if (value.isNotEmpty && index < _focusNodes.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  void _onConfirmPressed() {
    final String otp =
        _controllers.map((TextEditingController c) => c.text).join();
    final bool validOtp = RegExp(r'^\d{6}$').hasMatch(otp);

    if (!validOtp) {
      setState(() {
        _showOtpError = true;
      });
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
          builder: (BuildContext context) => const SuccessPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back,
                        color: AppColors.primary, size: 30),
                  ),
                  const Spacer(),
                  Text(
                    'Cafe Sense',
                    style: textTheme.titleLarge?.copyWith(
                      color: AppColors.primary,
                      fontFamily: 'Epilogue',
                      fontSize: 48 / 2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 18),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 146,
                            height: 146,
                            decoration: const BoxDecoration(
                              color: AppColors.secondaryContainer,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.mark_email_unread,
                                color: AppColors.primary, size: 56),
                          ),
                          Positioned(
                            right: -2,
                            top: -2,
                            child: Container(
                              width: 52,
                              height: 52,
                              decoration: const BoxDecoration(
                                color: AppColors.tertiaryFixed,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.lock,
                                  color: AppColors.tertiary, size: 26),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 54),
                      Text(
                        'Xác thực tài khoản',
                        textAlign: TextAlign.center,
                        style: textTheme.headlineLarge?.copyWith(
                          color: AppColors.onSurface,
                          fontFamily: 'Epilogue',
                          fontSize: 62 / 2,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.6,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Text(
                          'Nhập mã xác thực đã được gửi tới email của bạn. Vui lòng kiểm tra hộp thư đến hoặc thư rác.',
                          textAlign: TextAlign.center,
                          style: textTheme.bodyLarge?.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontFamily: 'Inter',
                            fontSize: 19 / 1.2,
                            height: 1.55,
                          ),
                        ),
                      ),
                      const SizedBox(height: 54),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List<Widget>.generate(6, (int index) {
                          return _OtpDigitBox(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            showError: _showOtpError,
                            onChanged: (String value) =>
                                _onOtpChanged(index, value),
                          );
                        }),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        height: _showOtpError ? 28 : 0,
                        margin: EdgeInsets.only(top: _showOtpError ? 18 : 0),
                        child: _showOtpError
                            ? Text(
                                'Mã xác minh không đúng. Vui lòng kiểm tra lại.',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFFE74C3C),
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _onConfirmPressed,
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: AppColors.primaryContainer,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 21),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            textStyle: const TextStyle(
                              fontFamily: 'Epilogue',
                              fontSize: 39 / 2,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          child: const Text('Xác nhận'),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Bạn không nhận được mã?',
                            style: textTheme.bodyLarge?.copyWith(
                              color: AppColors.onSurfaceVariant,
                              fontFamily: 'Inter',
                              fontSize: 18 / 1.2,
                            ),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: _onResendCodePressed,
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Gửi lại mã',
                              style: textTheme.bodyLarge?.copyWith(
                                color: AppColors.primary,
                                fontFamily: 'Inter',
                                fontSize: 20 / 1.2,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 46),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 2),
                              child: Icon(Icons.lightbulb,
                                  color: AppColors.secondary, size: 24),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: AppColors.secondary,
                                    fontFamily: 'Inter',
                                    fontSize: 17 / 1.25,
                                    height: 1.6,
                                  ),
                                  children: const [
                                    TextSpan(text: 'Mã OTP sẽ hết hạn sau '),
                                    TextSpan(
                                      text: '02:59',
                                      style: TextStyle(
                                        color: AppColors.onSurface,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          '. Đừng chia sẻ mã này với bất kỳ ai để bảo vệ tài khoản của bạn.',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 46),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _FooterDot(active: false),
                          SizedBox(width: 14),
                          _FooterDot(active: true),
                          SizedBox(width: 14),
                          _FooterDot(active: false),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'THE SENSORY SOMMELIER EXPERIENCE',
                        style: textTheme.labelLarge?.copyWith(
                          color: AppColors.outline,
                          fontFamily: 'Inter',
                          fontSize: 32 / 3,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OtpDigitBox extends StatelessWidget {
  const _OtpDigitBox({
    required this.controller,
    required this.focusNode,
    required this.showError,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool showError;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 82,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        style: const TextStyle(
          color: Color(0xFF727B8C),
          fontFamily: 'Inter',
          fontSize: 36,
          fontWeight: FontWeight.w700,
        ),
        maxLength: 1,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: onChanged,
        decoration: InputDecoration(
          counterText: '',
          hintText: '•',
          hintStyle: const TextStyle(
            color: Color(0xFF727B8C),
            fontSize: 36,
            fontWeight: FontWeight.w700,
          ),
          filled: true,
          fillColor: AppColors.surfaceContainerHigh,
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: showError ? const Color(0xFFE74C3C) : Colors.transparent,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: showError
                  ? const Color(0xFFE74C3C)
                  : AppColors.primaryContainer,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}

class _FooterDot extends StatelessWidget {
  const _FooterDot({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 9,
      height: 9,
      decoration: BoxDecoration(
        color: active ? AppColors.primaryContainer : AppColors.outlineVariant,
        shape: BoxShape.circle,
      ),
    );
  }
}
