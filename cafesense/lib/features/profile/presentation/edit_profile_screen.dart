import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:cafesense/core/theme/app_colors.dart";
import "package:cafesense/core/routes/app_routes.dart";
import "package:cafesense/core/widgets/survey_widgets.dart";

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController(text: "Minh Anh");
  final _emailController = TextEditingController(text: "minhcafemail.com.vn");
  final _phoneController = TextEditingController(text: "+84 813 123 4567");

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Ch?nh s?a h? s�",
          style: GoogleFonts.beVietnamPro(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    // Avatar
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 90, height: 90,
                          decoration: BoxDecoration(
                            color: AppColors.avatarOrange,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primary, width: 2.5),
                          ),
                          child: const Center(child: Text("??", style: TextStyle(fontSize: 42))),
                        ),
                        Positioned(
                          bottom: 0, right: 0,
                          child: Container(
                            width: 28, height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(Icons.edit, color: Colors.white, size: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text("T?m th?i Anh",
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
                      )),
                    const SizedBox(height: 28),
                    _buildField("Nguy�n Minh Anh", _nameController, "H? v� t�n"),
                    const SizedBox(height: 14),
                    _buildField("Email", _emailController, "Email"),
                    const SizedBox(height: 14),
                    _buildField("�i?n tho?i", _phoneController, "S? �i?n tho?i"),
                    const SizedBox(height: 24),
                    _buildSectionTitle("Nh?n th�ng b�o qua mail"),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Column(
                        children: [
                          _buildToggleRow("Cho ph�p th�ng b�o t? �?ng", true),
                          const Divider(height: 16, color: AppColors.borderLight),
                          _buildToggleRow("Ch� ? t?i qu�n l?", false),
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
              child: PrimaryButton(
                label: "L�u thay �?i",
                onPressed: () => Navigator.pushNamed(context, AppRoutes.savedProfile),
                trailing: null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.beVietnamPro(
          fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          style: GoogleFonts.beVietnamPro(fontSize: 14, color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.unselectedBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.unselectedBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(title, style: GoogleFonts.beVietnamPro(
        fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
    );
  }

  Widget _buildToggleRow(String label, bool value) {
    return Row(
      children: [
        Expanded(child: Text(label, style: GoogleFonts.beVietnamPro(fontSize: 13, color: AppColors.textPrimary))),
        Switch(value: value, onChanged: (v) {}, activeThumbColor: AppColors.primary),
      ],
    );
  }
}
