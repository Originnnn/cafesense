import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:cafesense/core/theme/app_colors.dart";
import "package:cafesense/core/routes/app_routes.dart";
import "package:cafesense/core/widgets/survey_widgets.dart";

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Logo
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(child: Text("?", style: TextStyle(fontSize: 36))),
              ),
              const SizedBox(height: 24),
              Text(
                "Chào mừng đến với",
                textAlign: TextAlign.center,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 16, color: AppColors.textSecondary, fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "CafeSense",
                textAlign: TextAlign.center,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Hãy để chúng tôi hiểu bạn hơn",
                style: GoogleFonts.beVietnamPro(fontSize: 14, color: AppColors.textHint),
              ),
              const SizedBox(height: 40),
              _buildStep(
                icon: Icons.person_outline_rounded,
                title: "Hồ sơ cá nhân",
                subtitle: "Tên, tuổi, nghề nghiệp",
              ),
              const SizedBox(height: 12),
              _buildStep(
                icon: Icons.favorite_outline_rounded,
                title: "Mục đích & sở thích",
                subtitle: "Bạn thích làm gì ở cafe",
                iconColor: AppColors.error,
              ),
              const SizedBox(height: 12),
              _buildStep(
                icon: Icons.schedule_rounded,
                title: "Thói quen",
                subtitle: "Đi khi nào, hay đi đâu",
                iconColor: AppColors.warning,
              ),
              const Spacer(),
              PrimaryButton(
                label: "Bắt đầu",
                onPressed: () => Navigator.pushNamed(context, AppRoutes.avatarPicker),
                trailing: const Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.white),
              ),
              const SizedBox(height: 24),
              Container(
                height: 6,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: AppColors.progressBg,
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: AppColors.progressFill,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text("0%", style: GoogleFonts.beVietnamPro(fontSize: 11, color: AppColors.textHint)),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep({
    required IconData icon,
    required String title,
    required String subtitle,
    Color iconColor = AppColors.primary,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.beVietnamPro(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textHint),
        ],
      ),
    );
  }
}

