import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:google_fonts/google_fonts.dart";
import "package:cafesense/core/theme/app_colors.dart";
import "package:cafesense/core/routes/app_routes.dart";
import "package:cafesense/core/widgets/survey_widgets.dart";
import "package:cafesense/features/onboarding/presentation/onboarding_notifier.dart";

class MainPurposeScreen extends ConsumerStatefulWidget {
  const MainPurposeScreen({super.key});
  @override
  ConsumerState<MainPurposeScreen> createState() => _MainPurposeScreenState();
}

class _MainPurposeScreenState extends ConsumerState<MainPurposeScreen> {
  final Set<String> _selected = {};
  final List<Map<String, String>> _purposes = [
    {"emoji": "💻", "title": "Làm việc", "sub": "Remote work"},
    {"emoji": "📚", "title": "Học tập", "sub": "Ôn thi, bài tập"},
    {"emoji": "🤝", "title": "Gặp gỡ", "sub": "Bạn bè, đồng nghiệp"},
    {"emoji": "😌", "title": "Nghỉ ngơi", "sub": "Relax, thư giãn"},
    {"emoji": "📖", "title": "Đọc sách", "sub": "Đọc sách, tài liệu"},
    {"emoji": "🎨", "title": "Sáng tạo", "sub": "Ý tưởng, vẽ vời"},
    {"emoji": "🧪", "title": "Trải nghiệm", "sub": "Thử đồ uống mới"},
    {"emoji": "🔄", "title": "Thay đổi", "sub": "Phụ thuộc vào ngày"},
  ];

  @override
  Widget build(BuildContext context) {
    return SurveyScaffold(
      categoryEmoji: "🎯",
      categoryLabel: "Mục đích",
      title: "Bạn hay đến cafe để làm gì?",
      subtitle: "Chọn tất cả những gì phù hợp với bạn",
      progress: 0.30,
      canProceed: _selected.isNotEmpty,
      onNext: () {
        if (_selected.isNotEmpty) {
          ref.read(onboardingProvider.notifier).updateMainPurpose(_selected.join(", "));
          Navigator.pushNamed(context, AppRoutes.companion);
        }
      },

      body: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.4,
            ),
            itemCount: _purposes.length,
            itemBuilder: (context, index) {
              final p = _purposes[index];
              return SelectableCard(
                emoji: p["emoji"]!,
                title: p["title"]!,
                subtitle: p["sub"]!,
                isSelected: _selected.contains(p["title"]),
                onTap: () => setState(() {
                  if (_selected.contains(p["title"])) {
                    _selected.remove(p["title"]);
                  } else {
                    _selected.add(p["title"]!);
                  }
                }),
              );
            },
          ),
          if (_selected.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Text("✅", style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Đã chọn: ${_selected.join(", ")}",
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w500,
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

