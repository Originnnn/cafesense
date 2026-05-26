import "dart:math" as math;
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:cafesense/core/widgets/custom_bottom_nav.dart";
import "package:cafesense/features/cafe/data/models/cafe.dart";
import "package:cafesense/features/cafe/presentation/cafe_detail_screen.dart";

class FilterResultsScreen extends StatelessWidget {
  const FilterResultsScreen({
    super.key,
    required this.results,
    required this.activeFilters,
  });

  final List<Cafe> results;
  final List<String> activeFilters;

  bool get isEmpty => results.isEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCF9F6),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.tune, color: Color(0xFF553722)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "CafeSense",
          style: GoogleFonts.beVietnamPro(
            color: const Color(0xFF553722),
            fontSize: 32,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: const <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 24),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(
                "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&q=80",
              ),
            ),
          ),
        ],
      ),
      body: isEmpty ? _buildEmptyState(context) : _buildResultsState(context),
      bottomNavigationBar: CustomBottomNav(currentIndex: 1, onTap: (_) {}),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 90),
      child: Column(
        children: <Widget>[
          Container(
            height: 240,
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32)),
            alignment: Alignment.center,
            child: Icon(Icons.search_off, size: 76, color: const Color(0xFFD4C3BA).withValues(alpha: 0.7)),
          ),
          const SizedBox(height: 28),
          Text(
            "AI chưa tìm thấy quán phù hợp",
            textAlign: TextAlign.center,
            style: GoogleFonts.beVietnamPro(
              color: const Color(0xFF553722),
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Bộ lọc hiện tại hơi chặt. Hãy mở rộng mức giá hoặc giảm bớt tiêu chí để nhận thêm kết quả.",
            textAlign: TextAlign.center,
            style: GoogleFonts.beVietnamPro(color: const Color(0xFF6D5B4F), fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 26),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF553722),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Đặt lại bộ lọc",
                style: GoogleFonts.beVietnamPro(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsState(BuildContext context) {
    final Cafe featured = results.first;
    final List<Cafe> compact = results.skip(1).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 90),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                ...activeFilters.take(4).map(_buildActiveFilterChip),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(color: const Color(0xFFEAE8E5), borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    "Đặt lại",
                    style: GoogleFonts.beVietnamPro(color: const Color(0xFF6D5B4F), fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "AI TÌM THẤY ${results.length} ĐỊA ĐIỂM",
                      style: GoogleFonts.beVietnamPro(
                        color: const Color(0xFF6D5B4F),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Your Perfect Brews",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.beVietnamPro(
                        color: const Color(0xFF553722),
                        fontSize: 36,
                        height: 1.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.sort, color: Color(0xFF6D5B4F)),
            ],
          ),
          const SizedBox(height: 24),
          _featuredResultCard(context, featured),
          const SizedBox(height: 24),
          ...compact.map((Cafe item) => Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: _compactResultCard(context, item),
              )),
        ],
      ),
    );
  }

  Widget _buildActiveFilterChip(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(color: const Color(0xFF553722), borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: <Widget>[
            Text(label, style: GoogleFonts.beVietnamPro(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(width: 4),
            const Icon(Icons.close, color: Colors.white, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _featuredResultCard(BuildContext context, Cafe item) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CafeDetailScreen(cafe: item))),
      child: Container(
        decoration: BoxDecoration(color: const Color(0xFFF6F3F0), borderRadius: BorderRadius.circular(24)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
              child: Image.network(item.imageUrl, height: 200, width: double.infinity, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: const Color(0xFFEAE8E5), borderRadius: BorderRadius.circular(16)),
                        child: Text(
                          "${item.matchPercent ?? 100}% Phù hợp",
                          style: GoogleFonts.beVietnamPro(color: const Color(0xFF553722), fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const Icon(Icons.bookmark_border, color: Color(0xFF553722)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    item.name,
                    style: GoogleFonts.beVietnamPro(
                      color: const Color(0xFF553722),
                      fontSize: 38,
                      height: 1.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.description,
                    style: GoogleFonts.beVietnamPro(color: const Color(0xFF6D5B4F), fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: item.amenities.take(3).map((String key) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: _buildIconLabel(_amenityIcon(key), key.toUpperCase()),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF553722),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CafeDetailScreen(cafe: item))),
                      child: Text(
                        "Xem",
                        style: GoogleFonts.beVietnamPro(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconLabel(IconData icon, String label) {
    return Column(
      children: <Widget>[
        Icon(icon, size: 20, color: const Color(0xFF553722)),
        const SizedBox(height: 4),
        Text(label, style: GoogleFonts.beVietnamPro(color: const Color(0xFF6D5B4F), fontSize: 8)),
      ],
    );
  }

  Widget _compactResultCard(BuildContext context, Cafe item) {
    // simple distance calculation from cafes cluster center (15.9770, 108.2653)
    final double dLat = item.latitude - 15.9770;
    final double dLon = item.longitude - 108.2653;
    final double dist = math.sqrt(dLat * dLat + dLon * dLon) * 111.0; // ~111km per degree
    final String distanceLabel = '${dist.toStringAsFixed(1)} km';

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CafeDetailScreen(cafe: item))),
      child: Container(
        decoration: BoxDecoration(color: const Color(0xFFF6F3F0), borderRadius: BorderRadius.circular(24)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                  child: Image.network(item.imageUrl, height: 180, width: double.infinity, fit: BoxFit.cover),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                    child: Text(
                      "${item.matchPercent ?? 100}% Phù hợp",
                      style: GoogleFonts.beVietnamPro(color: const Color(0xFF553722), fontSize: 10, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          item.name,
                          style: GoogleFonts.beVietnamPro(color: const Color(0xFF553722), fontSize: 26, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${item.priceLabel} • $distanceLabel",
                          style: GoogleFonts.beVietnamPro(color: const Color(0xFF6D5B4F), fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: item.amenities.take(3).map((String a) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Icon(_amenityIcon(a), size: 16, color: const Color(0xFF553722)),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.bookmark_border, color: Color(0xFF553722)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _amenityIcon(String key) {
    switch (key.trim().toLowerCase()) {
      case "wifi":
      case "wifi mạnh":
        return Icons.wifi;
      case "silent":
      case "yên tĩnh":
        return Icons.volume_off;
      case "plug":
      case "sạc điện thoại":
      case "ổ cắm điện":
        return Icons.power;
      case "coffee":
      case "thức uống đa dạng":
        return Icons.local_cafe;
      case "garden":
      case "không gian mở":
        return Icons.park;
      case "non_smoke":
      case "không hút thuốc":
        return Icons.smoke_free;
      case "máy lạnh":
        return Icons.ac_unit;
      case "chỗ để xe":
        return Icons.directions_car;
      case "thức ăn nhẹ":
        return Icons.restaurant;
      case "ghế thoải mái":
        return Icons.chair;
      default:
        return Icons.coffee;
    }
  }
}
