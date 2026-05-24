import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:google_fonts/google_fonts.dart";
import "package:cafesense/core/theme/app_colors.dart";
import "package:cafesense/core/routes/app_routes.dart";
import "package:cafesense/core/widgets/survey_widgets.dart";
import "package:cafesense/features/onboarding/presentation/onboarding_notifier.dart";

class CompanionScreen extends ConsumerStatefulWidget {
  const CompanionScreen({super.key});
  @override
  ConsumerState<CompanionScreen> createState() => _CompanionScreenState();
}

class _CompanionScreenState extends ConsumerState<CompanionScreen> {
  String? _selected;
  String? _note;

  final List<Map<String, String>> _companions = [
    {"emoji": "🙋", "title": "Một mình"},
    {"emoji": "🧑‍🤝‍🧑", "title": "Bạn bè"},
    {"emoji": "👥", "title": "Đồng nghiệp"},
    {"emoji": "💑", "title": "Người yêu"},
    {"emoji": "👨‍👩‍👧‍👦", "title": "Gia đình"},
    {"emoji": "🔄", "title": "Tùy ngày"},
  ];

  final List<String> _notes = [
    "📶 Wifi tốt & có sạc pin",
    "☕ Cà phê ngon & bánh",
    "🪑 Không gian nhiều chỗ",
    "🎵 Nhạc nhẹ, ít ồn",
  ];

  @override
  Widget build(BuildContext context) {
    return SurveyScaffold(
      categoryEmoji: "👥",
      categoryLabel: "Bạn đồng hành",
      title: "Bạn thường đi với ai?",
      subtitle: "Sẽ ảnh hưởng đến lựa chọn không gian cho bạn",
      progress: 0.40,
      canProceed: _selected != null,
      onNext: () {
        if (_selected != null) {
          ref.read(onboardingProvider.notifier).updateCompanion(_selected!);
          Navigator.pushNamed(context, AppRoutes.wifiNoise);
        }
      },

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.5,
            ),
            itemCount: _companions.length,
            itemBuilder: (context, index) {
              final c = _companions[index];
              final isSelected = _selected == c["title"];
              return GestureDetector(
                onTap: () => setState(() => _selected = c["title"]),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary.withValues(alpha: 0.08) : AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.unselectedBorder,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(c["emoji"]!, style: const TextStyle(fontSize: 24)),
                      const SizedBox(height: 4),
                      Text(
                        c["title"]!,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected ? AppColors.primary : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            "Khi đi cùng, bạn thường ưu tiên:",
            style: GoogleFonts.beVietnamPro(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ..._notes.map((n) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GestureDetector(
              onTap: () => setState(() => _note = n),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: _note == n ? AppColors.primary.withValues(alpha: 0.08) : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _note == n ? AppColors.primary : AppColors.unselectedBorder,
                    width: _note == n ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        n,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 13,
                          color: _note == n ? AppColors.primary : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (_note == n)
                      const Icon(Icons.check_circle, color: AppColors.primary, size: 18),
                  ],
                ),
              ),
            ),
          )),
          const SizedBox(height: 8),
          Text(
            "Tùy trường hợp có thể thay đổi",
            style: GoogleFonts.beVietnamPro(fontSize: 11, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}

