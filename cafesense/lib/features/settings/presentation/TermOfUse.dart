import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:cafesense/core/theme/app_colors.dart";

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

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
          "Điều khoản sử dụng",
          style: GoogleFonts.beVietnamPro(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Chào mừng bạn đến với CafeSense. Bằng việc truy cập ứng dụng, bạn đồng ý tuân thủ các điều khoản dưới đây để bảo vệ cộng đồng yêu cafe.",
              style: GoogleFonts.beVietnamPro(
                fontSize: 12.5,
                color: AppColors.textSecondary,
                height: 1.55,
              ),
            ),
            const SizedBox(height: 24),
            _section(
              number: "01",
              title: "Chấp nhận điều khoản",
              body:
                  "Khi tạo tài khoản hoặc sử dụng dịch vụ, bạn xác nhận đã đọc, hiểu và đồng ý bị ràng buộc bởi các điều khoản này.",
            ),
            _section(
              number: "02",
              title: "Quyền sở hữu trí tuệ",
              body:
                  "Tất cả nội dung, hình ảnh, thiết kế và dữ liệu thuộc quyền sở hữu của CafeSense hoặc đối tác liên kết. Không sao chép hay sử dụng cho mục đích thương mại khi chưa được chấp thuận.",
            ),
            _section(
              number: "03",
              title: "Hành vi người dùng",
              body:
                  "Không đăng nội dung thù ghét hoặc xúc phạm. Không can thiệp hệ thống kỹ thuật của ứng dụng. Chỉ đăng đánh giá trung thực và mang tính xây dựng.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _section({required String number, required String title, required String body}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Stack(
        children: [
          Positioned(
            top: -4,
            left: 0,
            child: Text(
              number,
              style: GoogleFonts.beVietnamPro(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: AppColors.surfaceWarm,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 44),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
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
          ),
        ],
      ),
    );
  }
}
