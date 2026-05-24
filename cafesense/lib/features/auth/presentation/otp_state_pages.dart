import 'package:flutter/material.dart';

import 'package:cafesense/core/theme/app_colors.dart';
import 'package:cafesense/features/auth/presentation/auth_shared_widgets.dart';
import 'set_password_page.dart';

class OtpResentSuccessPage extends StatelessWidget {
  const OtpResentSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const OtpStatePage(
      bannerColor: Color(0xFFEAF2DD),
      bannerIconBg: AppColors.tertiaryContainer,
      bannerText: 'Mã mới đã được gửi thành công!',
      errorText: null,
    );
  }
}

class OtpInvalidPage extends StatelessWidget {
  const OtpInvalidPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const OtpStatePage(
      bannerColor: Colors.transparent,
      bannerIconBg: Colors.transparent,
      bannerText: '',
      errorText: 'Mã xác minh không đúng. Vui lòng nhập lại.',
    );
  }
}

class OtpStatePage extends StatelessWidget {
  const OtpStatePage({
    super.key,
    required this.bannerColor,
    required this.bannerIconBg,
    required this.bannerText,
    required this.errorText,
  });

  final Color bannerColor;
  final Color bannerIconBg;
  final String bannerText;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Xác thực tài khoản',
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 8),
            if (bannerText.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: bannerColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(color: bannerIconBg, shape: BoxShape.circle),
                      child: const Icon(Icons.check, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        bannerText,
                        style: const TextStyle(
                          color: AppColors.tertiaryContainer,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            const Text(
              'Xác thực tài khoản',
              style: TextStyle(
                fontFamily: 'Epilogue',
                color: AppColors.primary,
                fontSize: 27,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Mã xác thực mới đã được gửi tới email của bạn. Vui lòng kiểm tra lại.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 17, height: 1.55),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List<Widget>.generate(6, (int index) {
                return OtpBox(active: errorText != null);
              }),
            ),
            const SizedBox(height: 14),
            if (errorText != null)
              Text(
                errorText!,
                style: const TextStyle(color: Color(0xFFD43A2F), fontSize: 16, fontWeight: FontWeight.w600),
              ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.schedule, color: AppColors.primary, size: 22),
                  SizedBox(width: 10),
                  Text('03:00', style: TextStyle(color: AppColors.primary, fontSize: 22, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              label: 'Xác nhận',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const SetPasswordPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 14),
            Text(
              errorText != null ? 'Gửi lại mã' : 'Không nhận được mã?\nGửi lại mã',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: errorText != null ? AppColors.primary : AppColors.outline,
                fontWeight: FontWeight.w700,
                fontSize: 18,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 16),
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Image.asset(
                    'assets/figma_images/x_c_th_c_otp_cafe_sense_1.png',
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
                Positioned(
                  right: -8,
                  top: -8,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.tertiaryContainer,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Icon(Icons.coffee, color: Colors.white70, size: 30),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
