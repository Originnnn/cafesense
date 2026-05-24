import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:cafesense/core/theme/app_colors.dart";

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  final List<_SavedItem> _savedItems = [
    _SavedItem(
      name: "Copper Portafilter",
      address: "543 Trần Đại Nghĩa, Ngũ Hành Sơn",
      tag: "YÊN TĨNH",
      rating: "4.8",
      imageUrl: "https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=300&q=80",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: _savedItems.isEmpty ? _emptyState() : _listState(),
      ),
    );
  }

  Widget _listState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Danh sách đã lưu",
          style: GoogleFonts.beVietnamPro(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 14),
        ..._savedItems.map(_savedCard),
      ],
    );
  }

  Widget _savedCard(_SavedItem item) {
    return Container(
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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => _showDeleteDialog(item),
                      child: const Icon(Icons.bookmark_rounded, size: 18, color: AppColors.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  item.address,
                  style: GoogleFonts.beVietnamPro(fontSize: 10, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6F0CF),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        item.tag,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF627A32),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.star_rounded, size: 12, color: Color(0xFFE8A140)),
                    const SizedBox(width: 3),
                    Text(
                      item.rating,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
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

  Widget _emptyState() {
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
          child: const Icon(Icons.bookmark_border_rounded, size: 52, color: AppColors.textHint),
        ),
        const SizedBox(height: 20),
        Text(
          "Chưa có quán được lưu",
          style: GoogleFonts.beVietnamPro(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Những quán cafe bạn muốn lưu sẽ\nxuất hiện ở đây.\nHãy khám phá ngay thôi!",
          textAlign: TextAlign.center,
          style: GoogleFonts.beVietnamPro(
            fontSize: 13,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: Text(
              "Khám phá ngay",
              style: GoogleFonts.beVietnamPro(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(_SavedItem item) {
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
                child: const Icon(Icons.bookmark_outline, color: Color(0xFFE08A8A)),
              ),
              const SizedBox(height: 14),
              Text(
                "Bỏ lưu?",
                style: GoogleFonts.beVietnamPro(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Bạn có chắc chắn muốn xóa quán này khỏi danh sách đã lưu không?",
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
                    setState(() => _savedItems.remove(item));
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    "Xác nhận xóa",
                    style: GoogleFonts.beVietnamPro(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  "Hủy",
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

class _SavedItem {
  _SavedItem({
    required this.name,
    required this.address,
    required this.tag,
    required this.rating,
    required this.imageUrl,
  });

  final String name;
  final String address;
  final String tag;
  final String rating;
  final String imageUrl;
}
