import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:google_fonts/google_fonts.dart";
import "package:cafesense/core/theme/app_colors.dart";
import "package:cafesense/core/routes/app_routes.dart";
import "package:cafesense/core/widgets/survey_widgets.dart";
import "package:cafesense/features/onboarding/presentation/onboarding_notifier.dart";

class CafeSizeScreen extends ConsumerStatefulWidget {
  const CafeSizeScreen({super.key});
  @override
  ConsumerState<CafeSizeScreen> createState() => _CafeSizeScreenState();
}

class _CafeSizeScreenState extends ConsumerState<CafeSizeScreen> {
  String? _selected;

  final List<Map<String, dynamic>> _sizes = [
    {
      "emoji": "🏠",
      "title": "Nhỏ nhắn",
      "sub": "Ấm cúng, ít người",
      "extra": "< 25 chỗ",
      "desc": "Quán nhỏ tạo cảm giác gần gũi, riêng tư và ấm cúng nhất",
      "color": const Color(0xFFF5E6C8),
    },
    {
      "emoji": "🏢",
      "title": "Vừa phải",
      "sub": "30-50 chỗ ngồi",
      "extra": null,
      "desc": "Cân bằng giữa không gian và sự thoải mái",
      "color": const Color(0xFFE8F0F8),
    },
    {
      "emoji": "🏬",
      "title": "Rộng lớn",
      "sub": "Nhiều khu vực",
      "extra": null,
      "desc": "Không gian rộng rãi, nhiều lựa chọn ngồi",
      "color": const Color(0xFFE0F0E0),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SurveyScaffold(
      categoryEmoji: "🪑",
      categoryLabel: "Không gian yêu thích",
      title: "Quy mô quán bạn thích?",
      subtitle: "Chọn quy mô không gian bạn cảm thấy thoải mái nhất",
      progress: 0.85,
      canProceed: _selected != null,
      onNext: () {
        if (_selected != null) {
          ref.read(onboardingProvider.notifier).updateCafeSize(_selected!);
          Navigator.pushNamed(context, AppRoutes.cafeView);
        }
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: _sizes.map((s) {
              final isSel = _selected == s["title"];
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () => setState(() => _selected = s["title"]),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(12),
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
                          Column(
                            children: [
                              Container(
                                height: 64,
                                decoration: BoxDecoration(
                                  color: s["color"] as Color,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(s["emoji"]!,
                                      style: const TextStyle(fontSize: 28)),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                s["title"]!,
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: isSel
                                      ? AppColors.primary
                                      : AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                s["sub"]!,
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 10,
                                  color: AppColors.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              if (s["extra"] != null)
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.accent.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    s["extra"]!,
                                    style: GoogleFonts.beVietnamPro(
                                      fontSize: 10,
                                      color: AppColors.primaryLight,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          if (isSel)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check,
                                    color: Colors.white, size: 13),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
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
                  const Text("📐", style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _sizes
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
