import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:google_fonts/google_fonts.dart";
import "package:cafesense/core/theme/app_colors.dart";
import "package:cafesense/core/routes/app_routes.dart";
import "package:cafesense/core/widgets/survey_widgets.dart";
import "package:cafesense/features/onboarding/presentation/onboarding_notifier.dart";

class ValuePriorityScreen extends ConsumerStatefulWidget {
  const ValuePriorityScreen({super.key});
  @override
  ConsumerState<ValuePriorityScreen> createState() => _ValuePriorityScreenState();
}

class _ValuePriorityScreenState extends ConsumerState<ValuePriorityScreen> {
  final List<String> _selected = [];
  static const int _maxSelect = 2;

  final List<Map<String, String>> _values = [
    {"emoji": "💸", "label": "Giá cả hợp lý"},
    {"emoji": "☕", "label": "Chất lượng đồ uống"},
    {"emoji": "📍", "label": "Vị trí thuận tiện"},
    {"emoji": "🏡", "label": "Không gian đẹp"},
    {"emoji": "🛎️", "label": "Dịch vụ tốt"},
    {"emoji": "🍰", "label": "Đồ ăn ngon"},
  ];

  @override
  Widget build(BuildContext context) {
    return SurveyScaffold(
      categoryEmoji: "💰",
      categoryLabel: "Ngân sách",
      title: "Khi chi tiêu, bạn ưu tiên điều gì?",
      subtitle: "Chọn những yếu tố quan trọng nhất với bạn khi chọn quán",
      progress: 0.65,
      canProceed: _selected.isNotEmpty,
      onNext: () {
        if (_selected.isNotEmpty) {
          ref.read(onboardingProvider.notifier).updateValuePriorities(_selected);
          Navigator.pushNamed(context, AppRoutes.spaceStyle);
        }
      },

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._values.map((v) {
            final idx = _selected.indexOf(v["label"]!);
            final isSel = idx != -1;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: () => setState(() {
                  if (isSel) {
                    _selected.remove(v["label"]);
                  } else if (_selected.length < _maxSelect) {
                    _selected.add(v["label"]!);
                  }
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isSel ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSel ? AppColors.primary : AppColors.unselectedBorder,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(v["emoji"]!, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          v["label"]!,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isSel ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (isSel)
                        Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              "${idx + 1}",
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceWarm,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ƯU TIÊN CỦA BẠN",
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textHint,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                if (_selected.isEmpty)
                  Text("Chưa chọn ưu tiên nào",
                    style: GoogleFonts.beVietnamPro(fontSize: 13, color: AppColors.textHint),
                  )
                else
                  ..._selected.asMap().entries.map((e) {
                    final v = _values.firstWhere((x) => x["label"] == e.value);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text("${e.key + 1}",
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(v["emoji"]!, style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 4),
                          Text(e.value,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 13,
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                const SizedBox(height: 4),
                Text(
                  "Đã chọn ${_selected.length}/$_maxSelect ưu tiên",
                  style: GoogleFonts.beVietnamPro(fontSize: 11, color: AppColors.textHint),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
