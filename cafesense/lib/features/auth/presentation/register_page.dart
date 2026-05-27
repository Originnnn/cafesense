import 'package:flutter/material.dart';

import "package:cafesense/core/theme/app_colors.dart";
import "package:cafesense/features/auth/presentation/otp_page.dart";

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cafesense/features/auth/data/repositories/auth_repository.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String value) {
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value);
  }

  Future<void> _handleRegister() async {
    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;
    final String confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập họ và tên.')),
      );
      return;
    }

    if (!_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email không hợp lệ.')),
      );
      return;
    }

    if (password.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu phải có ít nhất 8 ký tự.')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Xác nhận mật khẩu không khớp.')),
      );
      return;
    }

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đang đăng ký tài khoản...'),
          duration: Duration(seconds: 1),
        ),
      );

      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.register(name, email, password);

      if (!mounted) {
        return;
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const OtpPage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String message = 'Đăng ký thất bại.';
      if (e.code == 'weak-password') {
        message = 'Mật khẩu quá yếu.';
      } else if (e.code == 'email-already-in-use') {
        message = 'Email này đã được sử dụng bởi một tài khoản khác.';
      } else if (e.code == 'invalid-email') {
        message = 'Email không hợp lệ.';
      } else {
        message = 'Lỗi: ${e.message}';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng ký thất bại: ${e.toString().replaceAll('Exception: ', '')}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F2),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: Container(
                padding: const EdgeInsets.fromLTRB(18, 26, 18, 26),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F5F2),
                  borderRadius: BorderRadius.circular(36),
                  border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.18)),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1F553722),
                            blurRadius: 16,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.local_cafe, color: Colors.white, size: 40),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Cafe Sense',
                      style: textTheme.headlineLarge?.copyWith(
                        color: AppColors.primary,
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 58 / 2,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Bắt đầu hành trình thưởng thức cafe',
                      style: textTheme.bodyLarge?.copyWith(
                        color: AppColors.secondary,
                        fontSize: 25 / 2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 34),
                    _FieldLabel(text: 'Họ và tên', textTheme: textTheme),
                    const SizedBox(height: 8),
                    _RegisterInput(
                      controller: _nameController,
                      hintText: 'Nguyễn Văn A',
                      prefixIcon: Icons.person,
                    ),
                    const SizedBox(height: 20),
                    _FieldLabel(text: 'Email', textTheme: textTheme),
                    const SizedBox(height: 8),
                    _RegisterInput(
                      controller: _emailController,
                      hintText: 'example@gmail.com',
                      prefixIcon: Icons.mail,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    _FieldLabel(text: 'Mật khẩu', textTheme: textTheme),
                    const SizedBox(height: 8),
                    _RegisterInput(
                      controller: _passwordController,
                      hintText: '••••••••',
                      prefixIcon: Icons.lock,
                      obscureText: _obscurePassword,
                      suffix: IconButton(
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
                    ),
                    const SizedBox(height: 20),
                    _FieldLabel(text: 'Xác nhận mật khẩu', textTheme: textTheme),
                    const SizedBox(height: 8),
                    _RegisterInput(
                      controller: _confirmPasswordController,
                      hintText: '••••••••',
                      prefixIcon: Icons.verified_user,
                      obscureText: _obscureConfirmPassword,
                      suffix: IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                        icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                          color: AppColors.outline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handleRegister,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: AppColors.primaryContainer,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                          textStyle: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 24 / 2,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        child: const Text('Đăng ký'),
                      ),
                    ),
                    const SizedBox(height: 34),
                    Text(
                      'Bạn đã có tài khoản?',
                      style: textTheme.bodyLarge?.copyWith(
                        color: AppColors.secondary,
                        fontSize: 24 / 2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Text(
                        'Đăng nhập ngay',
                        style: textTheme.bodyLarge?.copyWith(
                          color: AppColors.primary,
                          fontSize: 46 / 2,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Bằng việc nhấn Đăng ký, bạn đồng ý với các\nĐiều khoản dịch vụ và Chính sách bảo mật\ncủa Cafe Sense.',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyLarge?.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 15,
                        height: 1.6,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text, required this.textTheme});

  final String text;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: textTheme.bodyLarge?.copyWith(
          color: AppColors.onSurface,
          fontSize: 21 / 2,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _RegisterInput extends StatelessWidget {
  const _RegisterInput({
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.suffix,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final Widget? suffix;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(prefixIcon, color: AppColors.outline),
        suffixIcon: suffix,
        hintText: hintText,
        hintStyle: const TextStyle(
          color: AppColors.outlineVariant,
          fontSize: 20 / 2,
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.38)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.38)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.primaryContainer),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      ),
      style: const TextStyle(
        color: AppColors.onSurface,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
