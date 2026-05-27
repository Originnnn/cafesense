import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// --- MÀN HÌNH CÀI ĐẶT ---
class SettingsScreen extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const SettingsScreen({super.key, required this.isDarkMode, required this.onThemeChanged});

  @override
  Widget build(BuildContext context) {
    final primaryColor = isDarkMode ? const Color(0xFFC69C6D) : const Color(0xFF5D4037);
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Icon(Icons.arrow_back, color: primaryColor),
        title: Text('Cài đặt', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
        actions: [Icon(Icons.search, color: primaryColor), const SizedBox(width: 15)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserHeader(primaryColor),
            const SizedBox(height: 30),
            
            _buildSectionTitle('CÀI ĐẶT CHUNG', primaryColor),
            _buildSettingCard(cardColor, [
              _buildSwitchItem(Icons.notifications_none, 'Thông báo', true, primaryColor),
              const Divider(height: 1, indent: 50, color: Colors.black12),
              _buildSwitchItem(Icons.dark_mode_outlined, 'Chế độ tối', isDarkMode, primaryColor, onChanged: onThemeChanged),
            ]),

            _buildSectionTitle('HỆ THỐNG', primaryColor),
            _buildSettingCard(cardColor, [
              _buildNavigationItem(Icons.translate, 'Ngôn ngữ', primaryColor, subtitle: 'Tiếng Việt (Vietnam)'),
              const Divider(height: 1, indent: 50, color: Colors.black12),
              _buildNavigationItem(Icons.shield_outlined, 'Quyền riêng tư', primaryColor),
            ]),

            const SizedBox(height: 30),
            _buildLogoutButton(primaryColor, cardColor),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(primaryColor, 3),
    );
  }

  // --- WIDGET HỖ TRỢ ---
  Widget _buildUserHeader(Color color) {
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
          backgroundColor: color.withValues(alpha: 0.1),
          child: Text(
            initial,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
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
                      color: color)),
              Text(userEmail, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, Color color) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 15),
    child: Text(title, style: TextStyle(color: color.withValues(alpha: 0.6), fontWeight: FontWeight.bold, fontSize: 12)),
  );

  Widget _buildSettingCard(Color color, List<Widget> children) => Container(
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
    child: Column(children: children),
  );

  Widget _buildSwitchItem(IconData icon, String title, bool val, Color color, {ValueChanged<bool>? onChanged}) => ListTile(
    leading: Icon(icon, color: color),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
    trailing: Switch(value: val, onChanged: onChanged ?? (v){}, activeThumbColor: color),
  );

  Widget _buildNavigationItem(IconData icon, String title, Color color, {String? subtitle}) => ListTile(
    leading: Icon(icon, color: color),
    title: Text(title),
    subtitle: subtitle != null ? Text(subtitle) : null,
    trailing: const Icon(Icons.chevron_right, size: 20),
  );

  Widget _buildLogoutButton(Color color, Color bg) => SizedBox(
    width: double.infinity,
    height: 55,
    child: OutlinedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.logout, color: Colors.red),
      label: const Text('Đăng xuất', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
      style: OutlinedButton.styleFrom(
        backgroundColor: bg,
        side: BorderSide(color: Colors.red.withValues(alpha: 0.1)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    ),
  );

  Widget _buildBottomNav(Color color, int index) => BottomNavigationBar(
    currentIndex: index,
    selectedItemColor: color,
    unselectedItemColor: Colors.grey,
    type: BottomNavigationBarType.fixed,
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: 'KHÁM PHÁ'),
      BottomNavigationBarItem(icon: Icon(Icons.auto_awesome_outlined), label: 'PHÙ HỢP'),
      BottomNavigationBarItem(icon: Icon(Icons.bookmark_outline), label: 'YÊU THÍCH'),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'CÁ NHÂN'),
    ],
  );
}