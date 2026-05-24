import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:cafesense/core/theme/app_colors.dart";

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.textPrimary),
        ),
        title: Text(
          "Chính sách riêng tư",
          style: GoogleFonts.beVietnamPro(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tại CafeSense, chúng tôi coi trọng sự tin tưởng của bạn. Tài liệu này mô tả cách dữ liệu cá nhân được thu thập, sử dụng và bảo vệ.",
              style: GoogleFonts.beVietnamPro(
                fontSize: 12.5,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            _policySection(
              icon: Icons.storage_outlined,
              title: "1. Thu thập dữ liệu",
              body: "Chúng tôi thu thập thông tin bạn cung cấp trực tiếp như tên, email và sở thích cá nhân để cá nhân hóa trải nghiệm.",
            ),
            _policySection(
              icon: Icons.settings_suggest_outlined,
              title: "2. Sử dụng thông tin",
              body: "Thông tin được sử dụng để gợi ý quán phù hợp, cải thiện thuật toán và nâng cao chất lượng sản phẩm.",
            ),
            _policySection(
              icon: Icons.verified_user_outlined,
              title: "3. Bảo mật",
              body: "Dữ liệu được mã hóa và lưu trữ an toàn theo tiêu chuẩn kỹ thuật phù hợp. Chúng tôi không bán dữ liệu cá nhân cho bên thứ ba.",
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
              decoration: const BoxDecoration(
                border: Border(left: BorderSide(color: Color(0xFFFFDCC0), width: 4)),
              ),
              child: Text(
                "Sự minh bạch là thành phần quan trọng nhất trong công thức niềm tin của chúng tôi.",
                style: GoogleFonts.beVietnamPro(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: AppColors.primaryLight,
                ),
              ),
            ),
            const SizedBox(height: 22),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.help_outline_rounded, size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Liên hệ: trungn.22it@vku.udn.vn",
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _policySection({required IconData icon, required String title, required String body}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.surfaceWarm,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: AppColors.primary),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: GoogleFonts.beVietnamPro(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
