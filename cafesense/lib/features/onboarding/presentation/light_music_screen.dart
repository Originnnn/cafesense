import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:google_fonts/google_fonts.dart";
import "package:cafesense/core/theme/app_colors.dart";
import "package:cafesense/core/routes/app_routes.dart";
import "package:cafesense/core/widgets/survey_widgets.dart";
import "package:cafesense/features/onboarding/presentation/onboarding_notifier.dart";

class LightMusicScreen extends ConsumerStatefulWidget {
  const LightMusicScreen({super.key});
  @override
  ConsumerState<LightMusicScreen> createState() => _LightMusicScreenState();
}

class _LightMusicScreenState extends ConsumerState<LightMusicScreen> {
  String? _light;
  String? _music;

  final List<Map<String, String>> _lights = [
    {"emoji": "🌤️", "label": "Ánh tự nhiên"},
    {"emoji": "💡", "label": "Đèn vàng ấm"},
    {"emoji": "🔆", "label": "Đèn trắng sáng"},
    {"emoji": "🌙", "label": "Ánh mờ / dim"},
  ];

  final List<Map<String, String>> _musics = [
    {"emoji": "🎼", "label": "Nhạc nhẹ"},
    {"emoji": "🎷", "label": "Jazz / Lo-fi"},
    {"emoji": "🇻🇳", "label": "Nhạc Việt"},
    {"emoji": "🔇", "label": "Không có nhạc"},
  ];

  @override
  Widget build(BuildContext context) {
    return SurveyScaffold(
      categoryEmoji: "🎵",
      categoryLabel: "Không gian yêu thích",
      title: "Ánh sáng & nhạc nền lý tưởng?",
      subtitle: "Chọn mỗi ô mỗi mục để tạo không gian lý tưởng của bạn",
      progress: 0.79,
      canProceed: _light != null && _music != null,
      onNext: () {
        if (_light != null && _music != null) {
          ref.read(onboardingProvider.notifier).updateLightMusic(
                light: _light!,
                music: _music!,
              );
          Navigator.pushNamed(context, AppRoutes.cafeSize);
        }
      },

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Ánh sáng",
            style: GoogleFonts.beVietnamPro(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 3.0,
            ),
            itemCount: _lights.length,
            itemBuilder: (context, index) {
              final l = _lights[index];
              final isSel = _light == l["label"];
              return GestureDetector(
                onTap: () => setState(() => _light = l["label"]),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSel ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSel ? AppColors.primary : AppColors.unselectedBorder,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(l["emoji"]!, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 6),
                      Text(
                        l["label"]!,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isSel ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Text("🎶 Nhạc nền",
            style: GoogleFonts.beVietnamPro(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 3.0,
            ),
            itemCount: _musics.length,
            itemBuilder: (context, index) {
              final m = _musics[index];
              final isSel = _music == m["label"];
              return GestureDetector(
                onTap: () => setState(() => _music = m["label"]),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSel ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSel ? AppColors.primary : AppColors.unselectedBorder,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(m["emoji"]!, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 6),
                      Text(
                        m["label"]!,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isSel ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          if (_light != null || _music != null) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceWarm,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("KHÔNG GIAN LÝ TƯỞNG CỦA BẠN",
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textHint,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (_light != null) ...[
                        const Text("💡", style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 6),
                        Text(_light!,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                      if (_light != null && _music != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text("•", style: GoogleFonts.beVietnamPro(color: AppColors.textHint)),
                        ),
                      if (_music != null) ...[
                        const Text("🎵", style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 6),
                        Text(_music!,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ],
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
