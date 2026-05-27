import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cafesense/core/theme/app_colors.dart';
import 'package:cafesense/core/providers/favorites_provider.dart';
import 'package:cafesense/features/cafe/data/models/cafe.dart';
import 'package:cafesense/features/cafe/presentation/cafe_detail_screen.dart';

class SavedScreen extends ConsumerWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favCafesAsync = ref.watch(favoriteCafesProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
          child: favCafesAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
            error: (e, _) => Center(
              child: Text(
                'Không thể tải danh sách yêu thích.',
                style: GoogleFonts.beVietnamPro(color: AppColors.textSecondary),
              ),
            ),
            data: (cafes) => cafes.isEmpty ? _emptyState(context) : _listState(context, ref, cafes),
          ),
        ),
      ),
    );
  }

  Widget _listState(BuildContext context, WidgetRef ref, List<Cafe> cafes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Danh sách yêu thích',
          style: GoogleFonts.beVietnamPro(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '${cafes.length} quán đã lưu',
          style: GoogleFonts.beVietnamPro(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 14),
        Expanded(
          child: ListView.separated(
            itemCount: cafes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) => _savedCard(context, ref, cafes[index]),
          ),
        ),
      ],
    );
  }

  Widget _savedCard(BuildContext context, WidgetRef ref, Cafe cafe) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CafeDetailScreen(cafe: cafe)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                cafe.imageUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 70,
                  height: 70,
                  color: AppColors.surfaceWarm,
                  child: const Icon(Icons.local_cafe_outlined, color: AppColors.textHint),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          cafe.name,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => _showRemoveDialog(context, ref, cafe),
                        borderRadius: BorderRadius.circular(20),
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(Icons.favorite_rounded, size: 18, color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    cafe.fullName.contains(' -') ? cafe.fullName.split(' -').last.trim() : cafe.fullName,
                    style: GoogleFonts.beVietnamPro(fontSize: 10, color: AppColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (cafe.spaceStyle.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6F0CF),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            cafe.spaceStyle.first.toUpperCase(),
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF627A32),
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),
                      Text(
                        cafe.priceLabel,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Container(
          width: 124,
          height: 124,
          decoration: BoxDecoration(
            color: AppColors.surfaceWarm,
            borderRadius: BorderRadius.circular(26),
          ),
          child: const Icon(Icons.favorite_border_rounded, size: 52, color: AppColors.textHint),
        ),
        const SizedBox(height: 20),
        Text(
          'Chưa có quán yêu thích',
          style: GoogleFonts.beVietnamPro(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Bấm vào icon ❤️ trên bất kỳ quán nào\nđể thêm vào danh sách yêu thích của bạn!',
          textAlign: TextAlign.center,
          style: GoogleFonts.beVietnamPro(
            fontSize: 13,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
        const Spacer(),
      ],
    );
  }

  void _showRemoveDialog(BuildContext context, WidgetRef ref, Cafe cafe) {
    showDialog<void>(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: AppColors.surfaceWarm,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.heart_broken_outlined, color: Color(0xFFE08A8A)),
              ),
              const SizedBox(height: 14),
              Text(
                'Bỏ yêu thích?',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Bạn có chắc muốn xóa ${cafe.name} khỏi danh sách yêu thích không?',
                textAlign: TextAlign.center,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(favoritesProvider.notifier).toggleFavorite(cafe.id);
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    'Xác nhận xóa',
                    style: GoogleFonts.beVietnamPro(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Hủy',
                  style: GoogleFonts.beVietnamPro(color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
