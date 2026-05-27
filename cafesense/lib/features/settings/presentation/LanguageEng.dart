import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:google_fonts/google_fonts.dart";
import "package:cafesense/core/theme/app_colors.dart";
import "package:cafesense/core/providers/locale_provider.dart";

class LanguageScreen extends ConsumerStatefulWidget {
  const LanguageScreen({super.key});

  @override
  ConsumerState<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends ConsumerState<LanguageScreen> {
  late String _selected;

  final List<_LangItem> _languages = const [
    _LangItem(name: "Tiếng Việt", code: "vi", subtitle: "VIETNAMESE", flag: "🇻🇳"),
    _LangItem(name: "English", code: "en", subtitle: "ENGLISH", flag: "🇬🇧"),
    _LangItem(name: "Français", code: "fr", subtitle: "FRENCH", flag: "🇫🇷"),
    _LangItem(name: "日本語", code: "ja", subtitle: "JAPANESE", flag: "🇯🇵"),
  ];

  @override
  void initState() {
    super.initState();
    final currentLocale = ref.read(localeProvider);
    _selected = _getLanguageName(currentLocale.languageCode);
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'vi':
        return "Tiếng Việt";
      case 'en':
        return "English";
      case 'fr':
        return "Français";
      case 'ja':
        return "日本語";
      default:
        return "Tiếng Việt";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.textPrimary),
        ),
        title: Text(
          "Ngôn ngữ",
          style: GoogleFonts.beVietnamPro(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Chọn ngôn ngữ\ncủa bạn",
              style: GoogleFonts.beVietnamPro(
                fontSize: 34,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                height: 1.05,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Cá nhân hóa trải nghiệm khám phá cafe với ngôn ngữ bạn cảm thấy thoải mái nhất.",
              style: GoogleFonts.beVietnamPro(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: _languages.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, index) {
                  final item = _languages[index];
                  final bool selected = _selected == item.name;
                  return InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () async {
                      setState(() => _selected = item.name);
                      await ref.read(localeProvider.notifier).changeLocale(item.code);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: selected ? AppColors.primary : AppColors.unselectedBorder,
                          width: selected ? 1.4 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceWarm,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(item.flag, style: const TextStyle(fontSize: 22)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  item.subtitle,
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 9,
                                    color: AppColors.textHint,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: selected ? AppColors.primary : AppColors.unselectedBorder),
                              color: selected ? AppColors.primary : Colors.transparent,
                            ),
                            child: selected
                                ? const Icon(Icons.check_rounded, color: Colors.white, size: 12)
                                : null,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LangItem {
  const _LangItem({required this.name, required this.code, required this.subtitle, required this.flag});

  final String name;
  final String code;
  final String subtitle;
  final String flag;
}
