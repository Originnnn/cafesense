import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:cafesense/core/theme/app_colors.dart";
import "package:cafesense/features/settings/presentation/DeleteAccount.dart";
import "package:cafesense/features/settings/presentation/TermOfUse.dart";

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool _shareLocation = true;
  bool _personalized = true;
  bool _analytics = false;

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
          "Quyền riêng tư",
          style: GoogleFonts.beVietnamPro(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            children: [
              _card(
                children: [
                  _switchRow(
                    icon: Icons.location_on_outlined,
                    title: "Chia sẻ vị trí",
                    subtitle: "Giúp đề xuất quán gần bạn hơn",
                    value: _shareLocation,
                    onChanged: (v) => setState(() => _shareLocation = v),
                  ),
                  _divider(),
                  _switchRow(
                    icon: Icons.psychology_alt_outlined,
                    title: "Thông báo cá nhân hóa",
                    subtitle: "Nhận gợi ý theo sở thích của bạn",
                    value: _personalized,
                    onChanged: (v) => setState(() => _personalized = v),
                  ),
                  _divider(),
                  _switchRow(
                    icon: Icons.bar_chart_outlined,
                    title: "Phân tích dữ liệu",
                    subtitle: "Giúp cải thiện trải nghiệm ứng dụng",
                    value: _analytics,
                    onChanged: (v) => setState(() => _analytics = v),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _card(
                children: [
                  _navRow(
                    icon: Icons.key_outlined,
                    title: "Chỉnh sửa khóa bảo mật",
                    onTap: () {},
                  ),
                  _divider(),
                  _navRow(
                    icon: Icons.description_outlined,
                    title: "Điều khoản sử dụng",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TermsOfServiceScreen()),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DeleteAccountConfirmScreen()),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFFD9D9)),
                    color: const Color(0xFFFFFBFB),
                  ),
                  child: Center(
                    child: Text(
                      "Xóa tài khoản của tôi",
                      style: GoogleFonts.beVietnamPro(
                        color: const Color(0xFFD14D4D),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
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

  Widget _card({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(children: children),
    );
  }

  Widget _divider() {
    return const Divider(height: 1, indent: 50, endIndent: 12, color: AppColors.borderLight);
  }

  Widget _switchRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: _iconBox(icon),
      title: Text(
        title,
        style: GoogleFonts.beVietnamPro(fontSize: 12.5, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.beVietnamPro(fontSize: 10, color: AppColors.textSecondary),
      ),
      trailing: Switch(value: value, onChanged: onChanged, activeThumbColor: AppColors.primary),
    );
  }

  Widget _navRow({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: _iconBox(icon),
      title: Text(
        title,
        style: GoogleFonts.beVietnamPro(fontSize: 12.5, fontWeight: FontWeight.w600),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
    );
  }

  Widget _iconBox(IconData icon) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: AppColors.surfaceWarm,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 16, color: AppColors.primary),
    );
  }
}
