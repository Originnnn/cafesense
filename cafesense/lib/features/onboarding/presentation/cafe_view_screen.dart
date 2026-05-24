import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:google_fonts/google_fonts.dart";
import "package:cafesense/core/theme/app_colors.dart";
import "package:cafesense/core/routes/app_routes.dart";
import "package:cafesense/core/widgets/survey_widgets.dart";
import "package:cafesense/features/onboarding/presentation/onboarding_notifier.dart";

class CafeViewScreen extends ConsumerStatefulWidget {
  const CafeViewScreen({super.key});
  @override
  ConsumerState<CafeViewScreen> createState() => _CafeViewScreenState();
}

class _CafeViewScreenState extends ConsumerState<CafeViewScreen> {
  String? _selected;

  final List<Map<String, dynamic>> _views = [
    {
      "emoji": "🌊",
      "title": "Biển / Sông",
      "sub": "Mặt nước thư giãn",
      "color": const Color(0xFFB3D9F2),
    },
    {
      "emoji": "🏙️",
      "title": "Phố xá",
      "sub": "Nhộn nhịp đường phố",
      "color": const Color(0xFFE0E8F0),
    },
    {
      "emoji": "🌳",
      "title": "Thiên nhiên",
      "sub": "Cây xanh, núi, đồng",
      "color": const Color(0xFFB8E6B8),
    },
    {
      "emoji": "🚫",
      "title": "Không cần",
      "sub": "View không quan trọng",
      "color": const Color(0xFFF0E6D3),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SurveyScaffold(
      categoryEmoji: "🖼️",
      categoryLabel: "Không gian yêu thích",
      title: "View bạn thích?",
      subtitle: "Chọn view cảnh bạn muốn ngắm khi ngồi cafe",
      progress: 0.90,
      canProceed: _selected != null,
      onNext: () {
        if (_selected != null) {
          ref.read(onboardingProvider.notifier).updateCafeView(_selected!);
          Navigator.pushNamed(context, AppRoutes.concept);
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
              childAspectRatio: 1.1,
            ),
            itemCount: _views.length,
            itemBuilder: (context, index) {
              final v = _views[index];
              final isSel = _selected == v["title"];
              return GestureDetector(
                onTap: () => setState(() => _selected = v["title"]),
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
                                color: v["color"] as Color,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(v["emoji"]!,
                                    style: const TextStyle(fontSize: 30)),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              v["title"]!,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: isSel
                                    ? AppColors.primary
                                    : AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              v["sub"]!,
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
                  const Text("👀", style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Ngắm mặt nước giúp thư giãn tâm trí tuyệt vời",
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 13,
                        color: AppColors.primaryLight,
                      ),
                      softWrap: true,
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
