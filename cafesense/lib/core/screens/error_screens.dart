import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:cafesense/core/theme/app_colors.dart";
import "package:cafesense/core/widgets/survey_widgets.dart";

// ===== INTERNET ERROR SCREEN =====
class InternetErrorScreen extends StatelessWidget {
  const InternetErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: const Text("CAFESENSE",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary)),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: const BoxDecoration(
                        color: AppColors.tagBg,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                          child: Text("??", style: TextStyle(fontSize: 52))),
                    ),
                    const SizedBox(height: 28),
                    Text("Lỗi internet",
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        )),
                    const SizedBox(height: 10),
                    Text(
                      "Kết nối bị lỗi.\nĐây thường là lỗi tạm thời, chúng tôi sẽ cố gắng giải quyết lỗi này cho bạn. Hãy thử lại đúng lúc khi mở lại nhiều lần.",
                      style: GoogleFonts.beVietnamPro(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.6),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 36),
                    PrimaryButton(label: "Thử lại ngay", onPressed: () {}),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        side:
                            const BorderSide(color: AppColors.unselectedBorder),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                      ),
                      child: Text("Cài đặt mạng",
                          style: GoogleFonts.beVietnamPro(
                              fontSize: 14, color: AppColors.textSecondary)),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {},
                      child: Text("Thử lại",
                          style: GoogleFonts.beVietnamPro(
                              fontSize: 14, color: AppColors.textHint)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== SERVER ERROR SCREEN =====
class ServerErrorScreen extends StatelessWidget {
  const ServerErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: const Text("CAFESENSE",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary)),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: const BoxDecoration(
                            color: AppColors.tagBg,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text("500",
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary.withValues(alpha: 0.2),
                            )),
                        const Positioned(
                          bottom: 8,
                          right: 8,
                          child: Text("???", style: TextStyle(fontSize: 32)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Text("Lỗi máy chủ",
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        )),
                    const SizedBox(height: 10),
                    Text(
                      "Đây là lỗi của phía chúng tôi, không phải lỗi của bạn!\nChúng tôi đã biết vấn đề và đang cố gắng giải quyết. Hãy thử lại sau hoặc đợi chúng tôi khắc phục.",
                      style: GoogleFonts.beVietnamPro(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.6),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 36),
                    PrimaryButton(label: "Thử lại ngay", onPressed: () {}),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        side:
                            const BorderSide(color: AppColors.unselectedBorder),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                      ),
                      child: Text("Quay lại trang chủ",
                          style: GoogleFonts.beVietnamPro(
                              fontSize: 14, color: AppColors.textSecondary)),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {},
                      child: Text("Thử lại",
                          style: GoogleFonts.beVietnamPro(
                              fontSize: 14, color: AppColors.textHint)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
