import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:cafesense/core/theme/app_colors.dart";
import "package:cafesense/core/routes/app_routes.dart";
import "package:cafesense/features/settings/presentation/Favorite.dart";
import "package:cafesense/features/settings/presentation/History.dart";
import "package:cafesense/features/settings/presentation/Policy.dart";
import "package:cafesense/features/settings/presentation/Privacy.dart";
import "package:cafesense/features/settings/presentation/TermOfUse.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cafesense/core/providers/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cafesense/features/auth/presentation/login_page.dart';
import 'package:cafesense/features/settings/presentation/LogOut.dart'
    as settings;

class MainAppScreen extends ConsumerStatefulWidget {
  const MainAppScreen({super.key});

  @override
  ConsumerState<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends ConsumerState<MainAppScreen> {
  bool _notifyEnabled = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    _darkMode = ref.watch(themeProvider) == ThemeMode.dark;
    final isDarkMode = _darkMode;
    final Color pageBg =
        isDarkMode ? AppColors.darkBg : AppColors.backgroundLight;
    final Color surface =
        isDarkMode ? AppColors.darkSurface : AppColors.surface;
    final Color title = isDarkMode ? Colors.white : AppColors.textPrimary;
    final Color subtitle =
        isDarkMode ? Colors.white70 : AppColors.textSecondary;

    return Scaffold(
      backgroundColor: pageBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.arrow_back_ios_new_rounded,
                        color: title, size: 18),
                  ),
                  Expanded(
                    child: Text(
                      "Cài đặt",
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: title,
                      ),
                    ),
                  ),
                  Icon(Icons.search_rounded, color: title, size: 20),
                ],
              ),
              const SizedBox(height: 8),
              _buildUserHeader(title, subtitle),
              const SizedBox(height: 24),
              _sectionLabel("CÀI ĐẶT CHUNG", subtitle),
              _card(
                surface,
                [
                  _switchTile(
                    icon: Icons.notifications_none_rounded,
                    iconColor: AppColors.accent,
                    title: "Thông báo",
                    subtitle: null,
                    value: _notifyEnabled,
                    onChanged: (value) =>
                        setState(() => _notifyEnabled = value),
                    titleColor: title,
                    subtitleColor: subtitle,
                  ),
                  _divider(_darkMode),
                  _switchTile(
                    icon: Icons.dark_mode_outlined,
                    iconColor: AppColors.accent,
                    title: tr('dark_mode'),
                    subtitle: null,
                    value: isDarkMode,
                    onChanged: (value) {
                      ref.read(themeProvider.notifier).toggleTheme(value);
                    },
                    titleColor: title,
                    subtitleColor: subtitle,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _sectionLabel("HỆ THỐNG", subtitle),
              _card(
                surface,
                [
                  _navTile(
                    icon: Icons.translate_rounded,
                    iconColor: AppColors.accent,
                    title: tr('language'),
                    subtitle: () {
                      final code = context.locale.languageCode;
                      if (code == 'vi') return 'Tiếng Việt';
                      if (code == 'en') return 'English';
                      if (code == 'ja') return '日本語';
                      if (code == 'fr') return 'Français';
                      return 'Tiếng Việt';
                    }(),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const settings.LanguageScreen()),
                    ),
                    titleColor: title,
                    subtitleColor: subtitle,
                  ),
                  _divider(_darkMode),
                  _navTile(
                    icon: Icons.shield_outlined,
                    iconColor: AppColors.accent,
                    title: "Quyền riêng tư",
                    subtitle: null,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const PrivacySettingsScreen()),
                    ),
                    titleColor: title,
                    subtitleColor: subtitle,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _sectionLabel("DỮ LIỆU", subtitle),
              _card(
                surface,
                [
                  _navTile(
                    icon: Icons.history_rounded,
                    iconColor: AppColors.accent,
                    title: "Lịch sử xem",
                    subtitle: "Quản lý các quán đã xem",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HistoryScreen()),
                    ),
                    titleColor: title,
                    subtitleColor: subtitle,
                  ),
                  _divider(_darkMode),
                  _navTile(
                    icon: Icons.bookmark_border_rounded,
                    iconColor: AppColors.accent,
                    title: "Yêu thích",
                    subtitle: "Danh sách quán đã lưu",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const FavoriteListScreen()),
                    ),
                    titleColor: title,
                    subtitleColor: subtitle,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _sectionLabel("HỖ TRỢ", subtitle),
              _card(
                surface,
                [
                  _navTile(
                    icon: Icons.description_outlined,
                    iconColor: AppColors.accent,
                    title: "Điều khoản sử dụng",
                    subtitle: null,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const TermsOfServiceScreen()),
                    ),
                    titleColor: title,
                    subtitleColor: subtitle,
                  ),
                  _divider(_darkMode),
                  _navTile(
                    icon: Icons.policy_outlined,
                    iconColor: AppColors.accent,
                    title: "Chính sách riêng tư",
                    subtitle: null,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const PrivacyPolicyScreen()),
                    ),
                    titleColor: title,
                    subtitleColor: subtitle,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _showLogoutDialog,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFF2CBCB)),
                    backgroundColor: isDarkMode
                        ? const Color(0xFF2E2118)
                        : const Color(0xFFFFFBFA),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: const Icon(Icons.logout_rounded,
                      color: Color(0xFFE64A4A), size: 18),
                  label: Text(
                    tr('logout'),
                    style: GoogleFonts.beVietnamPro(
                      color: const Color(0xFFE64A4A),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserHeader(Color title, Color subtitle) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _darkMode ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.surfaceWarm,
            child: Text(
              "N",
              style: GoogleFonts.beVietnamPro(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nguyễn Minh Anh",
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: title,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "minhanh.nguyen@gmail.com",
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 11,
                    color: subtitle,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.editProfile),
            icon: Icon(Icons.chevron_right_rounded, color: subtitle),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 2, bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.beVietnamPro(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: color,
        ),
      ),
    );
  }

  Widget _card(Color bg, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: _darkMode ? 0.18 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _divider(bool dark) {
    return Divider(
      height: 1,
      indent: 52,
      endIndent: 12,
      color: dark ? Colors.white12 : AppColors.borderLight,
    );
  }

  Widget _switchTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color titleColor,
    required Color subtitleColor,
  }) {
    return ListTile(
      leading: _leadingIcon(icon, iconColor),
      title: Text(
        title,
        style: GoogleFonts.beVietnamPro(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: titleColor,
        ),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle,
              style:
                  GoogleFonts.beVietnamPro(fontSize: 11, color: subtitleColor),
            ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.primary,
      ),
    );
  }

  Widget _navTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String? subtitle,
    required VoidCallback onTap,
    required Color titleColor,
    required Color subtitleColor,
  }) {
    return ListTile(
      onTap: onTap,
      leading: _leadingIcon(icon, iconColor),
      title: Text(
        title,
        style: GoogleFonts.beVietnamPro(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: titleColor,
        ),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle,
              style:
                  GoogleFonts.beVietnamPro(fontSize: 11, color: subtitleColor),
            ),
      trailing: Icon(Icons.chevron_right_rounded, color: subtitleColor),
    );
  }

  Widget _leadingIcon(IconData icon, Color iconColor) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: AppColors.surfaceWarm.withValues(alpha: _darkMode ? 0.25 : 0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 17, color: iconColor),
    );
  }

  void _showLogoutDialog() {
    showDialog<void>(
      context: context,
      builder: (_) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWarm,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.logout_rounded,
                      color: AppColors.primary),
                ),
                const SizedBox(height: 14),
                Text(
                  "Đăng xuất?",
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Bạn có chắc chắn muốn kết thúc phiên làm việc hiện tại không?",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove('token');
                      if (!context.mounted) return;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      tr('confirm_exit'),
                      style: GoogleFonts.beVietnamPro(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      tr('cancel'),
                      style: GoogleFonts.beVietnamPro(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
