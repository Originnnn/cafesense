import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:google_fonts/google_fonts.dart";
import "package:cafesense/core/theme/app_colors.dart";
import "package:cafesense/core/routes/app_routes.dart";
import "package:cafesense/core/widgets/survey_widgets.dart";
import "package:cafesense/features/onboarding/presentation/onboarding_notifier.dart";

class AvatarPickerScreen extends ConsumerStatefulWidget {
  const AvatarPickerScreen({super.key});
  @override
  ConsumerState<AvatarPickerScreen> createState() => _AvatarPickerScreenState();
}

class _AvatarPickerScreenState extends ConsumerState<AvatarPickerScreen> {
  int _selectedIndex = -1;

  final List<Map<String, dynamic>> _avatars = [
    {"emoji": "🟠", "color": const Color(0xFFFFD4A3)},
    {"emoji": "🤎", "color": const Color(0xFFE8D5C4)},
    {"emoji": "🔵", "color": const Color(0xFFB3D9F2)},
    {"emoji": "🟢", "color": const Color(0xFFB8E6B8)},
    {"emoji": "🧡", "color": const Color(0xFFFFD4A3)},
    {"emoji": "🌷", "color": const Color(0xFFFFC0CB)},
    {"emoji": "💜", "color": const Color(0xFFD4B8E6)},
    {"emoji": "🤍", "color": const Color(0xFFF5ECD8)},
    {"emoji": "💛", "color": const Color(0xFFFFF3A3)},
    {"emoji": "☕", "color": const Color(0xFFFFD4A3)},
    {"emoji": "🎧", "color": const Color(0xFFFFD4A3)},
    {"emoji": "💗", "color": const Color(0xFFFFC0CB)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const SurveyAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Text(
                      "Chọn avatar",
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Đại diện cho phong cách của bạn tại cafe",
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 1,
                      ),
                      itemCount: _avatars.length,
                      itemBuilder: (context, index) {
                        final avatar = _avatars[index];
                        final isSelected = _selectedIndex == index;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedIndex = index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: avatar["color"] as Color,
                              shape: BoxShape.circle,
                              border: isSelected
                                  ? Border.all(
                                      color: AppColors.primary, width: 3)
                                  : null,
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primary
                                            .withValues(alpha: 0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      )
                                    ]
                                  : [],
                            ),
                            child: Center(
                              child: Text(
                                avatar["emoji"] as String,
                                style: const TextStyle(fontSize: 30),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 28),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            "Hoặc",
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 13,
                              color: AppColors.textHint,
                            ),
                          ),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: () => setState(() => _selectedIndex = -2),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 24),
                              decoration: BoxDecoration(
                                color: _selectedIndex == -2
                                    ? AppColors.primary.withValues(alpha: 0.08)
                                    : AppColors.surface,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: _selectedIndex == -2
                                      ? AppColors.primary
                                      : AppColors.unselectedBorder,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.camera_alt_outlined,
                                      size: 20, color: AppColors.textSecondary),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Nhận ảnh từ thư viện",
                                    style: GoogleFonts.beVietnamPro(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SurveyProgressBar(progress: 0.15),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    label: "Tiếp theo",
                    onPressed: _selectedIndex != -1
                        ? () {
                            final String avatarVal = _selectedIndex == -2
                                ? "custom_gallery_photo"
                                : _avatars[_selectedIndex]["emoji"] as String;
                            ref
                                .read(onboardingProvider.notifier)
                                .updateAvatar(avatarVal);
                            Navigator.pushNamed(context, AppRoutes.occupation);
                          }
                        : null,
                    isEnabled: _selectedIndex != -1,
                    trailing: const Icon(Icons.arrow_forward_rounded,
                        size: 18, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
