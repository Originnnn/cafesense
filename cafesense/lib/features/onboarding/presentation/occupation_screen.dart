import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:cafesense/core/routes/app_routes.dart";
import "package:cafesense/core/widgets/survey_widgets.dart";
import "package:cafesense/features/onboarding/presentation/onboarding_notifier.dart";

class OccupationScreen extends ConsumerStatefulWidget {
  const OccupationScreen({super.key});
  @override
  ConsumerState<OccupationScreen> createState() => _OccupationScreenState();
}

class _OccupationScreenState extends ConsumerState<OccupationScreen> {
  String? _selected;
  final List<Map<String, String>> _jobs = [
    {"emoji": "💼", "title": "Văn phòng", "sub": "Nhân viên & quản lý"},
    {"emoji": "🎨", "title": "Sáng tạo", "sub": "Thiết kế, nghệ thuật"},
    {"emoji": "👨‍💻", "title": "Lập trình", "sub": "Developer & kỹ sư"},
    {"emoji": "📚", "title": "Học sinh/SV", "sub": "Đang đi học"},
    {"emoji": "🛍️", "title": "Kinh doanh", "sub": "Tự kinh doanh"},
    {"emoji": "✍️", "title": "Freelancer", "sub": "Làm việc tự do"},
  ];

  @override
  Widget build(BuildContext context) {
    return SurveyScaffold(
      categoryEmoji: "👷",
      categoryLabel: "Công việc của bạn",
      title: "Nghề nghiệp của bạn?",
      subtitle: "Giúp chúng tôi kết nối bạn với những người cùng lĩnh vực",
      progress: 0.21,
      canProceed: _selected != null,
      onNext: () {
        if (_selected != null) {
          ref.read(onboardingProvider.notifier).updateOccupation(_selected!);
          Navigator.pushNamed(context, AppRoutes.mainPurpose);
        }
      },
      body: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.4,
        ),
        itemCount: _jobs.length,
        itemBuilder: (context, index) {
          final job = _jobs[index];
          return SelectableCard(
            emoji: job["emoji"]!,
            title: job["title"]!,
            subtitle: job["sub"]!,
            isSelected: _selected == job["title"],
            onTap: () => setState(() => _selected = job["title"]),
          );
        },
      ),
    );
  }
}

