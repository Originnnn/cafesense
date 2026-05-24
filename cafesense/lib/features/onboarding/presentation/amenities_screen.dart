import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:cafesense/core/routes/app_routes.dart";
import "package:cafesense/core/widgets/survey_widgets.dart";
import "package:cafesense/features/onboarding/presentation/onboarding_notifier.dart";

class AmenitiesScreen extends ConsumerStatefulWidget {
  const AmenitiesScreen({super.key});
  @override
  ConsumerState<AmenitiesScreen> createState() => _AmenitiesScreenState();
}

class _AmenitiesScreenState extends ConsumerState<AmenitiesScreen> {
  final Set<String> _selected = {};
  final List<Map<String, String>> _items = [
    {"emoji": "🍪", "title": "Thức ăn nhẹ", "sub": "Bánh, snack"},
    {"emoji": "🥤", "title": "Thức uống đa dạng", "sub": "Nhiều loại"},
    {"emoji": "🚻", "title": "Toilet sạch", "sub": "Vệ sinh tốt"},
    {"emoji": "🪑", "title": "Ghế thoải mái", "sub": "Ngồi lâu"},
    {"emoji": "❄️", "title": "Điều hòa tốt", "sub": "Không khí mát"},
    {"emoji": "🌿", "title": "Không gian mở", "sub": "Thoáng đãng"},
    {"emoji": "🔌", "title": "Sạc điện thoại", "sub": "Cắm được"},
    {"emoji": "🖨️", "title": "In ấn/máy in", "sub": "Dịch vụ in"},
  ];

  @override
  Widget build(BuildContext context) {
    return SurveyScaffold(
      categoryEmoji: "🧰",
      categoryLabel: "Tiện nghi quán",
      title: "Tiện ích nào quan trọng?",
      subtitle: "Chọn những tiện nghi bạn thường cần khi ngồi cafe",
      progress: 0.58,
      canProceed: _selected.isNotEmpty,
      onNext: () {
        if (_selected.isNotEmpty) {
          ref.read(onboardingProvider.notifier).updateAmenities(_selected.toList());
          Navigator.pushNamed(context, AppRoutes.valuePriority);
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
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return SelectableCard(
            emoji: item["emoji"]!,
            title: item["title"]!,
            subtitle: item["sub"]!,
            isSelected: _selected.contains(item["title"]),
            onTap: () => setState(() {
              if (_selected.contains(item["title"])) {
                _selected.remove(item["title"]);
              } else {
                _selected.add(item["title"]!);
              }
            }),
          );
        },
      ),
    );
  }
}
