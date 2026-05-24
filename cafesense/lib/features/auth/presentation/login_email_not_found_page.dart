import 'package:flutter/material.dart';

import 'package:cafesense/core/theme/app_colors.dart';
import 'package:cafesense/features/auth/presentation/auth_shared_widgets.dart';
import 'signup_email_step_page.dart';

class LoginEmailNotFoundPage extends StatelessWidget {
  const LoginEmailNotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          child: Column(
            children: [
              Container(
                height: 280,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: AssetImage('assets/figma_images/l_i_kh_ng_t_m_th_y_email.png'),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: -36),
                padding: const EdgeInsets.fromLTRB(18, 24, 18, 20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Color(0x15553722), blurRadius: 24, offset: Offset(0, 10)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Chào mừng trở lại',
                      style: TextStyle(fontFamily: 'Epilogue', fontSize: 23, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Vui lòng nhập email để tiếp tục hành trình trải nghiệm hương vị cà phê của bạn.',
                      style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 17, height: 1.5),
                    ),
                    const SizedBox(height: 16),
                    const SectionLabel('EMAIL ĐĂNG NHẬP'),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFCC1F1F), width: 2),
                      ),
                      child: const InputTile(
                        hint: 'customer@cafe-sense.vn',
                        icon: Icons.mail,
                        suffix: Icons.warning,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Email này chưa được đăng ký. Vui lòng kiểm tra lại.',
                      style: TextStyle(color: Color(0xFFCC1F1F), fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 18),
                    PrimaryButton(
                      label: 'Thử lại',
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                    const SizedBox(height: 22),
                    Divider(color: AppColors.outlineVariant.withValues(alpha: 0.35)),
                    const SizedBox(height: 18),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => const SignupEmailStepPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Bạn chưa có tài khoản? Đăng ký ngay',
                          style: TextStyle(color: AppColors.secondary, fontSize: 17, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
