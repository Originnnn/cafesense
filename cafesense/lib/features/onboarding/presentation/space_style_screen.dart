import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:google_fonts/google_fonts.dart";
import "package:cafesense/core/theme/app_colors.dart";
import "package:cafesense/core/routes/app_routes.dart";
import "package:cafesense/core/widgets/survey_widgets.dart";
import "package:cafesense/features/onboarding/presentation/onboarding_notifier.dart";

class SpaceStyleScreen extends ConsumerStatefulWidget {
  const SpaceStyleScreen({super.key});
  @override
  ConsumerState<SpaceStyleScreen> createState() => _SpaceStyleScreenState();
}

class _SpaceStyleScreenState extends ConsumerState<SpaceStyleScreen> {
  String? _selected;

  final List<Map<String, dynamic>> _styles = [
    {
      "emoji": "🏡",
      "title": "Ấm cúng",
      "sub": "Gỗ, đèn vàng",
      "desc": "Ấm cúng là một lựa chọn tuyệt vời",
      "color": const Color(0xFFF5E6C8),
    },
    {
      "emoji": "🧩",
      "title": "Hiện đại",
      "sub": "Minimalist",
      "desc": "Sạch sẽ, tối giản, tinh tế",
      "color": const Color(0xFFE8F0F8),
    },
    {
      "emoji": "🌿",
      "title": "Thiên nhiên",
      "sub": "Cây & ánh sáng tự nhiên",
      "desc": "Thư giãn trong không gian xanh mát",
      "color": const Color(0xFFE0F0E0),
    },
    {
      "emoji": "🕰️",
      "title": "Vintage",
      "sub": "Retro, màu nâu",
      "desc": "Phong cách cổ điển đầy cá tính",
      "color": const Color(0xFFF0E8D8),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SurveyScaffold(
      categoryEmoji: "🧭",
      categoryLabel: "Không gian yêu thích",
      title: "Phong cách không gian bạn thích?",
      subtitle: "Chọn một phong cách phù hợp nhất với bạn",
      progress: 0.72,
      canProceed: _selected != null,
      onNext: () {
        if (_selected != null) {
          ref.read(onboardingProvider.notifier).updateSpaceStyle([_selected!]);
          Navigator.pushNamed(context, AppRoutes.lightMusic);
        }
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.05,
            ),
            itemCount: _styles.length,
            itemBuilder: (context, index) {
              final s = _styles[index];
              final isSel = _selected == s["title"];
              return GestureDetector(
                onTap: () => setState(() => _selected = s["title"]),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isSel
                        ? AppColors.primary.withValues(alpha: 0.08)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSel
                          ? AppColors.primary
                          : AppColors.unselectedBorder,
                      width: isSel ? 2 : 1,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 70,
                              decoration: BoxDecoration(
                                color: s["color"] as Color,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(s["emoji"]!,
                                    style: const TextStyle(fontSize: 34)),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              s["title"]!,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: isSel
                                    ? AppColors.primary
                                    : AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              s["sub"]!,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSel)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check,
                                color: Colors.white, size: 14),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          if (_selected != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.accentLight.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Text("🧠", style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _styles
                          .firstWhere((s) => s["title"] == _selected)["desc"]!,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 13,
                        color: AppColors.primaryLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
