import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cafesense/core/providers/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cafesense/features/auth/presentation/login_page.dart';

class MainSettingsScreen extends ConsumerWidget {
  const MainSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;
    final primaryColor = isDarkMode ? const Color(0xFFC69C6D) : const Color(0xFF5D4037);
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    // Show current language name
    final langCode = context.locale.languageCode;
    final langName = langCode == 'vi'
        ? 'Tiếng Việt'
        : langCode == 'en'
            ? 'English'
            : langCode == 'ja'
                ? '日本語'
                : langCode == 'fr'
                    ? 'Français'
                    : 'Tiếng Việt';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: primaryColor),
        title: Text(tr('settings'), style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
        actions: [Icon(Icons.search, color: primaryColor), const SizedBox(width: 15)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserHeader(textColor),
            const SizedBox(height: 30),
            _buildSectionTitle(tr('general_settings'), primaryColor),
            _buildContainer(cardColor, [
              _buildListTile(
                Icons.notifications_none,
                tr('notifications'),
                primaryColor,
                textColor,
                trailing: Switch(value: true, onChanged: (v) {}, activeThumbColor: primaryColor),
              ),
              _buildListTile(
                Icons.dark_mode_outlined,
                tr('dark_mode'),
                primaryColor,
                textColor,
                trailing: Switch(
                  value: isDarkMode,
                  onChanged: (val) {
                    ref.read(themeProvider.notifier).toggleTheme(val);
                  },
                  activeThumbColor: primaryColor,
                ),
              ),
            ]),
            _buildSectionTitle(tr('system'), primaryColor),
            _buildContainer(cardColor, [
              _buildListTile(
                Icons.translate,
                tr('language'),
                primaryColor,
                textColor,
                subtitle: langName,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LanguageScreen())),
              ),
              _buildListTile(Icons.shield_outlined, tr('privacy'), primaryColor, textColor, onTap: () {}),
            ]),
            _buildSectionTitle(tr('support'), primaryColor),
            _buildContainer(cardColor, [
              _buildListTile(Icons.help_outline, tr('help_center'), primaryColor, textColor, onTap: () {}),
            ]),
            const SizedBox(height: 40),
            _buildLogoutButton(context, primaryColor),
            const SizedBox(height: 50),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(primaryColor),
    );
  }

  Widget _buildUserHeader(Color textColor) {
    final user = FirebaseAuth.instance.currentUser;
    String userName = user?.displayName ?? '';
    if (userName.trim().isEmpty) {
      userName = user?.email?.split('@').first ?? 'Người dùng';
    }
    final String userEmail = user?.email ?? 'Chưa cập nhật email';
    final String initial = userName.isNotEmpty ? userName[0].toUpperCase() : 'U';

    return Row(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: textColor.withValues(alpha: 0.1),
          child: Text(
            initial,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor)),
              Text(userEmail, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(top: 25, bottom: 10, left: 5),
      child: Text(
        title,
        style: TextStyle(color: color.withValues(alpha: 0.7), fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.1),
      ),
    );
  }

  Widget _buildContainer(Color bg, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildListTile(
    IconData icon,
    String title,
    Color iconColor,
    Color textColor, {
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context, Color color) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: OutlinedButton.icon(
        onPressed: () => _showLogoutDialog(context, color),
        icon: Icon(Icons.logout, color: color),
        label: Text(tr('logout'), style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color.withValues(alpha: 0.3)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, Color color) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            CircleAvatar(radius: 35, backgroundColor: color.withValues(alpha: 0.1), child: Icon(Icons.logout, color: color, size: 35)),
            const SizedBox(height: 25),
            const Text('Đăng xuất?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)).tr(),
            const SizedBox(height: 15),
            Text(
              tr('logout_desc'),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: Text(tr('confirm_exit'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(tr('cancel'), style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(Color color) {
    return BottomNavigationBar(
      currentIndex: 3,
      selectedItemColor: color,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 10,
      unselectedFontSize: 10,
      items: [
        BottomNavigationBarItem(icon: const Icon(Icons.explore_outlined), label: tr('explore')),
        BottomNavigationBarItem(icon: const Icon(Icons.auto_awesome_outlined), label: tr('match')),
        BottomNavigationBarItem(icon: const Icon(Icons.bookmark_outline), label: tr('favorite')),
        BottomNavigationBarItem(icon: const Icon(Icons.person), label: tr('profile')),
      ],
    );
  }
}

/// Language selection screen with 4 languages: Vietnamese, English, Japanese, French.
class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentCode = context.locale.languageCode;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(tr('language'), style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr('choose_language'),
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, height: 1.2),
            ),
            const SizedBox(height: 15),
            Text(
              tr('choose_language_desc'),
              style: const TextStyle(color: Colors.grey, fontSize: 15),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: ListView(
                children: [
                  GestureDetector(
                    onTap: () => context.setLocale(const Locale('vi', '')),
                    child: _buildLangCard('🇻🇳', 'Tiếng Việt', 'MẶC ĐỊNH HỆ THỐNG', currentCode == 'vi'),
                  ),
                  GestureDetector(
                    onTap: () => context.setLocale(const Locale('en', '')),
                    child: _buildLangCard('🇬🇧', 'English', 'ENGLISH', currentCode == 'en'),
                  ),
                  GestureDetector(
                    onTap: () => context.setLocale(const Locale('ja', '')),
                    child: _buildLangCard('🇯🇵', '日本語', 'JAPANESE', currentCode == 'ja'),
                  ),
                  GestureDetector(
                    onTap: () => context.setLocale(const Locale('fr', '')),
                    child: _buildLangCard('🇫🇷', 'Français', 'FRENCH', currentCode == 'fr'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLangCard(String flag, String title, String sub, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isSelected ? Border.all(color: const Color(0xFF5D4037), width: 2) : null,
      ),
      child: ListTile(
        leading: Text(flag, style: const TextStyle(fontSize: 28)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(sub, style: const TextStyle(fontSize: 12)),
        trailing: isSelected
            ? const Icon(Icons.check_circle, color: Color(0xFF5D4037))
            : const Icon(Icons.circle_outlined, color: Colors.grey),
      ),
    );
  }
}
