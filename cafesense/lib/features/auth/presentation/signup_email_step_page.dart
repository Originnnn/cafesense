import 'package:flutter/material.dart';

import 'package:cafesense/core/theme/app_colors.dart';
import 'login_page.dart';
import 'package:cafesense/features/auth/presentation/auth_shared_widgets.dart';
import 'signup_profile_page.dart';

class SignupEmailStepPage extends StatelessWidget {
  const SignupEmailStepPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Cafe Sense',
      trailing: const Text(
        'Bước 1/3',
        style: TextStyle(
          color: AppColors.onSurfaceVariant,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 130,
                  height: 130,
                  decoration: const BoxDecoration(
                    color: AppColors.onSurface,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.branding_watermark, color: Colors.white70, size: 44),
                ),
                Positioned(
                  right: -4,
                  bottom: -4,
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: const BoxDecoration(
                      color: AppColors.tertiaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.auto_awesome, color: Colors.white, size: 24),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            const Text(
              'Tạo tài khoản',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 24,
                fontWeight: FontWeight.w800,
                fontFamily: 'Epilogue',
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Bắt đầu hành trình thưởng thức cà phê cùng chúng tôi',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.secondary,
                fontSize: 18,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Email',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text(
                        'Số điện thoại',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            const SectionLabel('THÔNG TIN ĐĂNG KÝ'),
            const SizedBox(height: 12),
            const InputTile(
              hint: 'example@email.com',
              icon: Icons.mail,
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: 'Tiếp tục',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const SignupProfilePage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Divider(color: AppColors.outlineVariant.withValues(alpha: 0.35)),
            const SizedBox(height: 18),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute<void>(builder: (BuildContext context) => const LoginPage()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text(
                'Đã có tài khoản?  Đăng nhập',
                style: TextStyle(
                  color: AppColors.secondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 26),
            const Text(
              'HOẶC TIẾP TỤC VỚI',
              style: TextStyle(
                color: AppColors.outline,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 3.2,
              ),
            ),
            const SizedBox(height: 18),
            const Row(
              children: [
                Expanded(child: SocialLite(label: 'Google', icon: Icons.g_mobiledata)),
                SizedBox(width: 12),
                Expanded(child: SocialLite(label: 'Facebook', icon: Icons.facebook)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
