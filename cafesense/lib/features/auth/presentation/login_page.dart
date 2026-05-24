import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:cafesense/core/theme/app_colors.dart';
import 'package:cafesense/features/auth/presentation/forgot_password_page.dart';
import 'package:cafesense/features/auth/presentation/register_page.dart';
import 'package:cafesense/features/onboarding/presentation/avatar_picker_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cafesense/features/auth/data/repositories/auth_repository.dart';
import 'package:cafesense/features/home/presentation/home_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool _obscurePassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String value) {
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value);
  }

  Future<void> _handleLogin() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    if (!_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Email không hợp lệ. Vui lòng kiểm tra lại.')),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu phải có ít nhất 6 ký tự.')),
      );
      return;
    }

    try {
      // Show loading SnackBar or visual indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đang đăng nhập...'),
          duration: Duration(seconds: 1),
        ),
      );

      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.login(email, password);

      if (!mounted) {
        return;
      }

      // Đi thẳng vào HomePage, bỏ qua onboarding
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const HomePage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String message = 'Đăng nhập thất bại.';
      if (e.code == 'user-not-found') {
        message = 'Không tìm thấy tài khoản với email này.';
      } else if (e.code == 'wrong-password') {
        message = 'Sai mật khẩu, vui lòng thử lại.';
      } else if (e.code == 'invalid-credential') {
        message = 'Email hoặc mật khẩu không chính xác.';
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
        SnackBar(
            content: Text(
                'Đăng nhập thất bại: ${e.toString().replaceAll('Exception: ', '')}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F2),
      body: Stack(
        children: [
          const Positioned(
            top: -120,
            right: -90,
            child: _BlurOrb(size: 220, color: Color(0x33553722)),
          ),
          const Positioned(
            bottom: -140,
            left: -110,
            child: _BlurOrb(size: 280, color: Color(0x22364224)),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      _BrandHeader(textTheme: textTheme),
                      const SizedBox(height: 24),
                      _LoginCard(
                        obscurePassword: _obscurePassword,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        onTogglePassword: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        onForgotPassword: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  const ForgotPasswordPage(),
                            ),
                          );
                        },
                        onLogin: () {
                          _handleLogin();
                        },
                      ),
                      const SizedBox(height: 24),
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            'Chưa có tài khoản? ',
                            style: textTheme.bodyLarge?.copyWith(
                              color: AppColors.onSurface,
                              fontSize: 34 / 2,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      const RegisterPage(),
                                ),
                              );
                            },
                            child: Text(
                              'Tạo ngay',
                              style: textTheme.bodyLarge?.copyWith(
                                color: AppColors.primary,
                                fontSize: 34 / 2,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _FooterLink(text: 'ĐIỀU KHOẢN', textTheme: textTheme),
                          const SizedBox(width: 14),
                          Container(
                              width: 4,
                              height: 4,
                              decoration: const BoxDecoration(
                                  color: AppColors.outlineVariant,
                                  shape: BoxShape.circle)),
                          const SizedBox(width: 14),
                          _FooterLink(text: 'BẢO MẬT', textTheme: textTheme),
                          const SizedBox(width: 14),
                          Container(
                              width: 4,
                              height: 4,
                              decoration: const BoxDecoration(
                                  color: AppColors.outlineVariant,
                                  shape: BoxShape.circle)),
                          const SizedBox(width: 14),
                          _FooterLink(text: 'HỖ TRỢ', textTheme: textTheme),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader({required this.textTheme});

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Transform.rotate(
          angle: 0.05,
          child: Container(
            width: 80,
            height: 80,
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
            child: const Icon(Icons.local_cafe, color: Colors.white, size: 42),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Cafe Sense',
          style: textTheme.headlineLarge?.copyWith(
            color: AppColors.primary,
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 56 / 2,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Hương vị tinh tế trong từng giọt cà phê',
          style: textTheme.bodyLarge?.copyWith(
            color: AppColors.secondary,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard({
    required this.obscurePassword,
    required this.emailController,
    required this.passwordController,
    required this.onTogglePassword,
    required this.onForgotPassword,
    required this.onLogin,
  });

  final bool obscurePassword;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onTogglePassword;
  final VoidCallback onForgotPassword;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border:
            Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.18)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14553722),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chào mừng quay lại',
            style: textTheme.headlineLarge?.copyWith(
              color: AppColors.onSurface,
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 46 / 2,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'Email',
            style: textTheme.bodyLarge?.copyWith(
              color: AppColors.secondary,
              fontSize: 34 / 2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          _InputBox(
            controller: emailController,
            hintText: 'example@cafe.com',
            prefixIcon: Icons.mail,
            suffix: null,
            obscureText: false,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Text(
                'Mật khẩu',
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColors.secondary,
                  fontSize: 34 / 2,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onForgotPassword,
                child: Text(
                  'Quên mật khẩu?',
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.primary,
                    fontSize: 32 / 2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _InputBox(
            controller: passwordController,
            hintText: '••••••••',
            prefixIcon: Icons.lock,
            obscureText: obscurePassword,
            suffix: IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: onTogglePassword,
              icon: Icon(
                obscurePassword ? Icons.visibility : Icons.visibility_off,
                color: AppColors.outline,
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryContainer,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                textStyle: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              icon: const Text('Đăng nhập'),
              label: const Icon(Icons.arrow_forward, size: 20),
            ),
          ),
          const SizedBox(height: 22),
          Divider(color: AppColors.outlineVariant.withValues(alpha: 0.24)),
          const SizedBox(height: 18),
          Center(
            child: Text(
              'Hoặc đăng nhập với',
              style: textTheme.bodyLarge?.copyWith(
                color: AppColors.secondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Row(
            children: [
              Expanded(
                child: _SocialButton(
                  icon: Icons.g_mobiledata,
                  label: 'Google',
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _SocialButton(
                  icon: Icons.thumb_up_alt,
                  label: 'Facebook',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InputBox extends StatelessWidget {
  const _InputBox({
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    required this.obscureText,
    required this.suffix,
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
      style: const TextStyle(
          color: AppColors.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.surfaceContainerLow,
        prefixIcon: Icon(prefixIcon, color: AppColors.outline),
        suffixIcon: suffix,
        hintText: hintText,
        hintStyle: const TextStyle(
            color: AppColors.outlineVariant,
            fontSize: 16,
            fontWeight: FontWeight.w500),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(14),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.onSurface, size: 24),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({required this.text, required this.textTheme});

  final String text;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: textTheme.labelLarge?.copyWith(
        color: AppColors.outlineVariant,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.1,
      ),
    );
  }
}

class _BlurOrb extends StatelessWidget {
  const _BlurOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 42, sigmaY: 42),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
