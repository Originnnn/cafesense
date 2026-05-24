import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:cafesense/core/theme/app_colors.dart";
import "package:cafesense/core/routes/app_routes.dart";
import "package:cafesense/core/widgets/survey_widgets.dart";

class SavedProfileScreen extends StatefulWidget {
  const SavedProfileScreen({super.key});
  @override
  State<SavedProfileScreen> createState() => _SavedProfileScreenState();
}

class _SavedProfileScreenState extends State<SavedProfileScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),
              ScaleTransition(
                scale: _scale,
                child: Column(
                  children: [
                    Container(
                      width: 90, height: 90,
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(child: Text("?", style: TextStyle(fontSize: 44))),
                    ),
                    const SizedBox(height: 20),
                    Text("ï¿½? lï¿½u thay ï¿½?i!",
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary,
                      )),
                    const SizedBox(height: 10),
                    Text(
                      "K?t n?i b? l?i.\nChï¿½ng tï¿½i s? c? g?ng ï¿½? gi?i quy?t l?i nï¿½y cho b?n. H?y th? l?i ï¿½?ng nh?t khi khï¿½ng k?t n?i thï¿½?ng xuyï¿½n.",
                      style: GoogleFonts.beVietnamPro(fontSize: 14, color: AppColors.textSecondary, height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    PrimaryButton(
                      label: "Quay l?i h? sï¿½",
                      onPressed: () => Navigator.popUntil(context, ModalRoute.withName(AppRoutes.mainApp)),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("V? trang ch?",
                        style: GoogleFonts.beVietnamPro(fontSize: 14, color: AppColors.textSecondary)),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

