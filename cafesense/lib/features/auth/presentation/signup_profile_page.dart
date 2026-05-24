import 'package:flutter/material.dart';

import 'package:cafesense/core/theme/app_colors.dart';
import 'otp_page.dart';
import 'package:cafesense/features/auth/presentation/auth_shared_widgets.dart';

class SignupProfilePage extends StatelessWidget {
  const SignupProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Cafe Sense',
      trailing: const Text(
        'Bước 3/3',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.secondary),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 124,
              height: 124,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(Icons.add_a_photo, color: AppColors.outline, size: 44),
            ),
            const SizedBox(height: 24),
            const Text(
              'Hoàn thành hồ sơ',
              style: TextStyle(
                fontFamily: 'Epilogue',
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
                fontSize: 23,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Hãy cho chúng tôi biết một chút về bạn để có trải nghiệm cá nhân hóa nhất.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.secondary, fontSize: 18, height: 1.5),
            ),
            const SizedBox(height: 24),
            const SectionLabel('Họ và tên'),
            const SizedBox(height: 10),
            const InputTile(hint: 'Nguyễn Văn A', icon: Icons.person),
            const SizedBox(height: 16),
            const SectionLabel('Ngày sinh'),
            const SizedBox(height: 10),
            const InputTile(hint: 'mm/dd/yyyy', icon: Icons.calendar_today, suffix: Icons.calendar_month),
            const SizedBox(height: 16),
            const SectionLabel('Giới tính'),
            const SizedBox(height: 10),
            const InputTile(hint: 'Chọn giới tính', icon: Icons.wc, suffix: Icons.keyboard_arrow_down),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Tạo tài khoản',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const OtpPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Bằng cách nhấn Tạo tài khoản, bạn đồng ý với Điều khoản dịch vụ và Chính sách bảo mật của chúng tôi.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 15, height: 1.45),
            ),
            const SizedBox(height: 18),
            const Row(
              children: [
                Expanded(child: PromoCard(title: 'KHÁM PHÁ', subtitle: 'Hơn 50 quán Specialty')),
                SizedBox(width: 12),
                Expanded(child: PromoCard(title: 'ƯU ĐÃI', subtitle: 'Đặc quyền thành viên')),
              ],
            ),
            const SizedBox(height: 18),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Dot(false),
                SizedBox(width: 8),
                Dot(false),
                SizedBox(width: 8),
                Dot(true),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
