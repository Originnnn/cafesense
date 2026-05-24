import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:google_fonts/google_fonts.dart";
import "package:cafesense/core/theme/app_colors.dart";
import "package:cafesense/core/routes/app_routes.dart";
import "package:cafesense/core/widgets/survey_widgets.dart";
import "package:cafesense/features/onboarding/presentation/onboarding_notifier.dart";

class WifiNoiseScreen extends ConsumerStatefulWidget {
  const WifiNoiseScreen({super.key});
  @override
  ConsumerState<WifiNoiseScreen> createState() => _WifiNoiseScreenState();
}

class _WifiNoiseScreenState extends ConsumerState<WifiNoiseScreen> {
  String? _noiseLevel;
  String? _wifiNeed;
  String? _plugNeed;

  final List<Map<String, String>> _noise = [
    {"emoji": "🤫", "title": "Yên tĩnh", "sub": "Tập trung cao"},
    {"emoji": "🙂", "title": "Vừa phải", "sub": "Tiếng nền nhẹ"},
    {"emoji": "🎉", "title": "Sôi động", "sub": "Nhộn nhịp, vui vẻ"},
  ];

  @override
  Widget build(BuildContext context) {
    return SurveyScaffold(
      categoryEmoji: "📶",
      categoryLabel: "Wifi & tiếng ồn",
      title: "Yêu cầu không gian?",
      subtitle: "Không gian lý tưởng giúp bạn làm việc hiệu quả nhất",
      progress: 0.50,
      canProceed: _noiseLevel != null,
      onNext: () {
        if (_noiseLevel != null) {
          ref.read(onboardingProvider.notifier).updateWifiNoise(
                wifiNeed: _wifiNeed ?? 'wifiNo',
                noiseLevel: _noiseLevel!,
              );
          Navigator.pushNamed(context, AppRoutes.amenities);
        }
      },

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Mức độ tiếng ồn:",
            style: GoogleFonts.beVietnamPro(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: _noise.map((n) {
              final sel = _noiseLevel == n["title"];
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _noiseLevel = n["title"]),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: sel ? AppColors.primary : AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: sel ? AppColors.primary : AppColors.unselectedBorder,
                          width: sel ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(n["emoji"]!, style: const TextStyle(fontSize: 24)),
                          const SizedBox(height: 6),
                          Text(
                            n["title"]!,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: sel ? Colors.white : AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            n["sub"]!,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 10,
                              color: sel ? Colors.white70 : AppColors.textSecondary,
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
          const SizedBox(height: 24),
          Text("Wifi & ổ cắm:",
            style: GoogleFonts.beVietnamPro(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _buildOptionRow("📶 Wifi miễn phí tốt", "wifiYes", _wifiNeed,
            (v) => setState(() => _wifiNeed = v)),
          const SizedBox(height: 8),
          _buildOptionRow("🔌 Có ổ cắm điện", "plugYes", _plugNeed,
            (v) => setState(() => _plugNeed = v)),
          const SizedBox(height: 24),
          Text("Bổ sung thêm:",
            style: GoogleFonts.beVietnamPro(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _buildOptionRow("🚗 Có chỗ đỗ xe", "park", null, (_) {}),
          const SizedBox(height: 8),
          _buildOptionRow("🚉 Gần ga/trạm xe", "transport", null, (_) {}),
        ],
      ),
    );
  }

  Widget _buildOptionRow(String label, String key, String? current, Function(String) onSelect) {
    final isSel = current == key;
    return GestureDetector(
      onTap: () => onSelect(key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
            Expanded(
              child: Text(label, style: GoogleFonts.beVietnamPro(fontSize: 13, color: AppColors.textPrimary)),
            ),
            if (isSel) const Icon(Icons.check_circle, color: AppColors.primary, size: 18),
          ],
        ),
      ),
    );
  }
}

