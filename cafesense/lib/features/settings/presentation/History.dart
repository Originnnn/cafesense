import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cafesense/core/theme/app_colors.dart';
import 'package:cafesense/core/providers/history_provider.dart';
import 'package:cafesense/features/cafe/data/repositories/cafe_repository.dart';
import 'package:cafesense/features/cafe/presentation/cafe_detail_screen.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  bool _isSelectionMode = false;
  final Set<String> _selectedIds = {};

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inHours < 1) return '${diff.inMinutes} phút trước';
    if (diff.inDays < 1) {
      final hour = dt.hour.toString().padLeft(2, '0');
      final min = dt.minute.toString().padLeft(2, '0');
      return 'Hôm nay, $hour:$min';
    }
    if (diff.inDays == 1) {
      final hour = dt.hour.toString().padLeft(2, '0');
      final min = dt.minute.toString().padLeft(2, '0');
      return 'Hôm qua, $hour:$min';
    }
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(historyProvider);

    if (history.isEmpty) {
      return _buildEmptyState();
    }

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
          'Lịch sử xem',
          style: GoogleFonts.beVietnamPro(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          if (_isSelectionMode && _selectedIds.isNotEmpty)
            TextButton(
              onPressed: () {
                ref.read(historyProvider.notifier).removeEntries(_selectedIds.toList());
                setState(() {
                  _isSelectionMode = false;
                  _selectedIds.clear();
                });
              },
              child: Text(
                'Xóa (${_selectedIds.length})',
                style: GoogleFonts.beVietnamPro(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFE05555),
                ),
              ),
            ),
          TextButton(
            onPressed: () => setState(() {
              _isSelectionMode = !_isSelectionMode;
              _selectedIds.clear();
            }),
            child: Text(
              _isSelectionMode ? 'Xong' : 'Chọn',
              style: GoogleFonts.beVietnamPro(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          if (!_isSelectionMode)
            IconButton(
              onPressed: () => _showClearAllDialog(),
              icon: const Icon(Icons.delete_sweep_outlined, color: AppColors.textSecondary, size: 20),
            ),
          const SizedBox(width: 4),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${history.length} quán đã xem',
              style: GoogleFonts.beVietnamPro(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: history.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) => _historyCard(context, history[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _historyCard(BuildContext context, HistoryEntry entry) {
    final isSelected = _selectedIds.contains(entry.cafeId);

    return GestureDetector(
      onTap: () async {
        if (_isSelectionMode) {
          setState(() {
            if (isSelected) {
              _selectedIds.remove(entry.cafeId);
            } else {
              _selectedIds.add(entry.cafeId);
            }
          });
          return;
        }
        // Navigate to cafe detail - need to load the full cafe
        final repo = ref.read(cafeRepositoryProvider);
        try {
          final cafes = await repo.getCafes();
          final cafe = cafes.firstWhere(
            (c) => c.id == entry.cafeId,
            orElse: () => throw Exception('Not found'),
          );
          if (!context.mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CafeDetailScreen(cafe: cafe)),
          );
        } catch (_) {
          // If not found in the list, show a snack
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Không thể mở quán này')),
          );
        }
      },
      onLongPress: () {
        setState(() {
          _isSelectionMode = true;
          _selectedIds.add(entry.cafeId);
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.08) : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: isSelected ? Border.all(color: AppColors.primary, width: 1.5) : null,
        ),
        child: Row(
          children: [
            if (_isSelectionMode)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Checkbox(
                  value: isSelected,
                  onChanged: (value) => setState(() {
                    if (value == true) {
                      _selectedIds.add(entry.cafeId);
                    } else {
                      _selectedIds.remove(entry.cafeId);
                    }
                  }),
                  activeColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
              ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                entry.imageUrl,
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
                  Text(
                    entry.cafeName,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    entry.priceLabel,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (entry.spaceStyle.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6F0CF),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            entry.spaceStyle.first.toUpperCase(),
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF627A32),
                            ),
                          ),
                        ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(Icons.access_time_rounded, size: 10, color: AppColors.textHint),
                          const SizedBox(width: 3),
                          Text(
                            _formatTime(entry.viewedAt),
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 9,
                              color: AppColors.textHint,
                            ),
                          ),
                        ],
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

  Widget _buildEmptyState() {
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
          'Lịch sử xem',
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 124,
              height: 124,
              decoration: BoxDecoration(
                color: AppColors.surfaceWarm,
                borderRadius: BorderRadius.circular(26),
              ),
              child: const Icon(Icons.history_rounded, size: 52, color: AppColors.textHint),
            ),
            const SizedBox(height: 20),
            Text(
              'Chưa có lịch sử xem',
              style: GoogleFonts.beVietnamPro(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Mỗi quán bạn bấm vào xem\nsẽ được ghi lại ở đây.',
              textAlign: TextAlign.center,
              style: GoogleFonts.beVietnamPro(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearAllDialog() {
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
                child: const Icon(Icons.delete_forever_outlined, color: Color(0xFFE08A8A)),
              ),
              const SizedBox(height: 14),
              Text(
                'Xóa toàn bộ lịch sử?',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Lịch sử xem của bạn sẽ bị xóa vĩnh viễn.',
                textAlign: TextAlign.center,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(historyProvider.notifier).clearAll();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE05555),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    'Xóa tất cả',
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
