import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:google_fonts/google_fonts.dart";
import "package:cafesense/core/theme/app_colors.dart";
import "package:cafesense/core/routes/app_routes.dart";
import "package:cafesense/core/widgets/survey_widgets.dart";
import "package:cafesense/features/onboarding/presentation/onboarding_notifier.dart";

class ConceptScreen extends ConsumerStatefulWidget {
  const ConceptScreen({super.key});
  @override
  ConsumerState<ConceptScreen> createState() => _ConceptScreenState();
}

class _ConceptScreenState extends ConsumerState<ConceptScreen> {
  final Set<String> _selected = {};

  final List<Map<String, String>> _concepts = [
    {"emoji": "📚", "label": "Sách & thư viện"},
    {"emoji": "🎭", "label": "Nghệ thuật / Gallery"},
    {"emoji": "🎮", "label": "Gaming cafe"},
    {"emoji": "🐾", "label": "Pet cafe"},
    {"emoji": "🌇", "label": "Rooftop"},
    {"emoji": "🏭", "label": "Industrial"},
    {"emoji": "🌸", "label": "Flower cafe"},
    {"emoji": "✨", "label": "Minimalist"},
  ];

  @override
  Widget build(BuildContext context) {
    return SurveyScaffold(
      categoryEmoji: "🎨",
      categoryLabel: "Không gian yêu thích",
      title: "Concept đặc biệt nào bạn thích?",
      subtitle: "Chọn những concept thu hút bạn nhất",
      progress: 0.96,
      canProceed: _selected.isNotEmpty,
      onNext: () {
        if (_selected.isNotEmpty) {
          ref.read(onboardingProvider.notifier).updatePreferredConcepts(_selected.toList());
          Navigator.pushNamed(context, AppRoutes.success);
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
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 3.2,
            ),
            itemCount: _concepts.length,
            itemBuilder: (context, index) {
              final c = _concepts[index];
              final isSel = _selected.contains(c["label"]);
              return GestureDetector(
                onTap: () => setState(() {
                  if (isSel) {
                    _selected.remove(c["label"]);
                  } else {
                    _selected.add(c["label"]!);
                  }
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSel ? AppColors.primary.withValues(alpha: 0.08) : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSel ? AppColors.primary : AppColors.unselectedBorder,
                      width: isSel ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(c["emoji"]!, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          c["label"]!,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isSel ? AppColors.primary : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (isSel)
                        const Icon(Icons.check_circle, color: AppColors.primary, size: 16),
                    ],
                  ),
                ),
              );
            },
          ),
          if (_selected.isNotEmpty) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceWarm,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("CONCEPT ĐÃ CHỌN",
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textHint,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: _selected.map((label) {
                      final concept = _concepts.firstWhere((c) => c["label"] == label);
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(concept["emoji"]!, style: const TextStyle(fontSize: 14)),
                            const SizedBox(width: 4),
                            Text(label,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 12,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, size: 14, color: AppColors.success),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            "Gần xong! Đây là frame cuối của nhóm Không gian yêu thích",
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 11,
                              color: AppColors.success,
                            ),
                          ),
                        ),
                      ],
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

