import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:cafesense/core/theme/app_colors.dart";
import "package:cafesense/features/settings/presentation/HistoryEmpty.dart";

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool _showRecent = true;
  bool _isSelectionMode = false;

  final List<_HistoryItem> _items = [
    _HistoryItem(
      name: "The Workshop",
      address: "Lý Tự Trọng, Quận 1",
      badge: "YÊN TĨNH",
      badgeBg: const Color(0xFFE6F0CF),
      badgeText: const Color(0xFF627A32),
      time: "Hôm nay, 08:30",
      imageUrl: "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=300&q=80",
      selected: false,
    ),
    _HistoryItem(
      name: "Bosgaurus Coffee",
      address: "Nguyễn Hữu Cảnh, Bình Thạnh",
      badge: "PREMIUM",
      badgeBg: const Color(0xFFF3E4C7),
      badgeText: const Color(0xFF7A5A2A),
      time: "Hôm qua, 15:45",
      imageUrl: "https://images.unsplash.com/photo-1442512595331-e89e73853f31?w=300&q=80",
      selected: false,
    ),
  ];

  int get _selectedCount => _items.where((item) => item.selected).length;

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) {
      return const EmptyHistoryScreen();
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
          "Lịch sử xem",
          style: GoogleFonts.beVietnamPro(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => setState(() {
              _isSelectionMode = !_isSelectionMode;
              if (!_isSelectionMode) {
                for (final item in _items) {
                  item.selected = false;
                }
              }
            }),
            child: Text(
              _isSelectionMode ? "Xong" : "Chọn",
              style: GoogleFonts.beVietnamPro(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
              child: Column(
                children: [
                  Row(
                    children: [
                      _timeChip(label: "Gần đây", selected: _showRecent, onTap: () => setState(() => _showRecent = true)),
                      const SizedBox(width: 10),
                      _timeChip(label: "Tuần này", selected: !_showRecent, onTap: () => setState(() => _showRecent = false)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      itemCount: _items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) => _historyCard(_items[index]),
                    ),
                  ),
                ],
              ),
            ),
            if (_isSelectionMode && _selectedCount > 0)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _items.removeWhere((item) => item.selected);
                        _isSelectionMode = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 16),
                    label: Text(
                      "Xóa $_selectedCount mục",
                      style: GoogleFonts.beVietnamPro(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _timeChip({required String label, required bool selected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? AppColors.primary : AppColors.unselectedBorder),
        ),
        child: Text(
          label,
          style: GoogleFonts.beVietnamPro(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _historyCard(_HistoryItem item) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          if (_isSelectionMode)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Checkbox(
                value: item.selected,
                onChanged: (value) => setState(() => item.selected = value ?? false),
                activeColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
            ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              item.imageUrl,
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
                  item.name,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.address,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: item.badgeBg,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        item.badge,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: item.badgeText,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      item.time,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 9,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryItem {
  _HistoryItem({
    required this.name,
    required this.address,
    required this.badge,
    required this.badgeBg,
    required this.badgeText,
    required this.time,
    required this.imageUrl,
    required this.selected,
  });

  final String name;
  final String address;
  final String badge;
  final Color badgeBg;
  final Color badgeText;
  final String time;
  final String imageUrl;
  bool selected;
}
