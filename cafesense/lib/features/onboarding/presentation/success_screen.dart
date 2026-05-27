import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:cafesense/core/theme/app_colors.dart";
import "package:cafesense/core/routes/app_routes.dart";
import "package:cafesense/core/widgets/survey_widgets.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:cafesense/features/onboarding/presentation/onboarding_notifier.dart";
import "package:cafesense/features/cafe/data/repositories/cafe_repository.dart";
import "package:firebase_auth/firebase_auth.dart";

class SuccessScreen extends ConsumerStatefulWidget {
  const SuccessScreen({super.key});
  @override
  ConsumerState<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends ConsumerState<SuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _scaleAnim = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const SurveyAppBar(title: "Khảo sát"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),
              FadeTransition(
                opacity: _fadeAnim,
                child: Column(
                  children: [
                    ScaleTransition(
                      scale: _scaleAnim,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.success.withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.check_rounded,
                            color: Colors.white, size: 52),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Hồ sơ đã sẵn sàng! 🎉",
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getUserName(),
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryLight,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildStat("Lần đến", "12", "cafe"),
                        _buildDivider(),
                        _buildStat("Số giờ", "8", "tuần"),
                        _buildDivider(),
                        _buildStat("Yêu thích", "5", "quán"),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceWarm,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Column(
                        children: [
                          _buildReviewRow("Quán gợi ý yêu thích", "Matching"),
                          const Divider(
                              height: 16, color: AppColors.borderLight),
                          _buildReviewRow("Thanh Rustic Table", "Matching"),
                          const Divider(
                              height: 16, color: AppColors.borderLight),
                          _buildReviewRow("Sharp & Brew", "Matching"),
                          const Divider(
                              height: 16, color: AppColors.borderLight),
                          _buildReviewRow("Garden Esprit", "Matching"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const SurveyProgressBar(progress: 1.0),
              const SizedBox(height: 16),
              PrimaryButton(
                label: "Khám phá ngay",
                onPressed: () async {
                  try {
                    // Send onboarding answers to API
                    final profile = ref.read(onboardingProvider);
                    await ref
                        .read(cafeRepositoryProvider)
                        .saveUserProfile(profile);

                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setBool('isOnboardingCompleted', true);

                    if (context.mounted) {
                      Navigator.pushNamed(context, AppRoutes.mainApp);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Lưu thông tin thất bại: ${e.toString().replaceAll('Exception: ', '')}')),
                      );
                    }
                  }
                },
                trailing: const Icon(Icons.explore_rounded,
                    size: 18, color: Colors.white),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, String unit) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.beVietnamPro(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
        Text(
          "$label / $unit",
          style: GoogleFonts.beVietnamPro(
              fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 36,
      color: AppColors.borderLight,
      margin: const EdgeInsets.symmetric(horizontal: 20),
    );
  }

  Widget _buildReviewRow(String name, String tag) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.tagBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(child: Text("☕", style: TextStyle(fontSize: 18))),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            name,
            style: GoogleFonts.beVietnamPro(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            tag,
            style: GoogleFonts.beVietnamPro(
                fontSize: 11,
                color: AppColors.success,
                fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  String _getUserName() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (user.displayName != null && user.displayName!.trim().isNotEmpty) {
        return user.displayName!;
      }
      if (user.email != null && user.email!.contains('@')) {
        return user.email!.split('@').first;
      }
    }
    return "Bạn";
  }
}
