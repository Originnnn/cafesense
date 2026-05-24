import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:cafesense/core/widgets/custom_bottom_nav.dart";
import "package:cafesense/features/cafe/presentation/ai_search_loading_screen.dart";

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  RangeValues _priceRange = const RangeValues(60, 120);
  String _selectedPriceTier = "Tầm trung";
  String _selectedDistance = "1 - 3 km";
  final Set<String> _selectedAmenities = <String>{"Ổ cắm điện"};
  String _selectedSpace = "Hiện đại";

  @override
  Widget build(BuildContext context) {
    final int predictedCount = (_selectedFilterTokens().length > 4) ? 1 : 4;

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCF9F6),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF553722)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Bộ lọc",
          style: GoogleFonts.beVietnamPro(
            color: const Color(0xFF553722),
            fontSize: 26,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: _resetFilter,
            child: Text(
              "Reset",
              style: GoogleFonts.beVietnamPro(
                color: const Color(0xFF6D5B4F),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Chọn tiêu chí phù hợp với bạn",
              style: GoogleFonts.beVietnamPro(color: const Color(0xFF6D5B4F), fontSize: 15),
            ),
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 3,
              decoration: BoxDecoration(color: const Color(0xFF553722), borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 32),
            _buildSectionTitle(Icons.payments_outlined, "Giá"),
            const SizedBox(height: 16),
            _buildPriceSection(),
            const SizedBox(height: 32),
            _buildSectionTitle(Icons.send_outlined, "Khoảng cách"),
            const SizedBox(height: 16),
            _buildDistanceGrid(),
            const SizedBox(height: 32),
            _buildSectionTitle(Icons.coffee_maker_outlined, "Tiện ích"),
            const SizedBox(height: 16),
            _buildAmenitiesWrap(),
            const SizedBox(height: 32),
            _buildSectionTitle(Icons.palette_outlined, "Không gian"),
            const SizedBox(height: 16),
            _buildSpaceGrid(),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 10),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF553722),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: _onAiSearch,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Tìm kiếm bằng AI",
                      style: GoogleFonts.beVietnamPro(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "$predictedCount",
                        style: GoogleFonts.beVietnamPro(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          CustomBottomNav(currentIndex: 0, onTap: (_) {}),
        ],
      ),
    );
  }

  void _resetFilter() {
    setState(() {
      _priceRange = const RangeValues(60, 120);
      _selectedPriceTier = "Tầm trung";
      _selectedDistance = "1 - 3 km";
      _selectedAmenities
        ..clear()
        ..add("Ổ cắm điện");
      _selectedSpace = "Hiện đại";
    });
  }

  void _onAiSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AiSearchLoadingScreen(
          filters: _selectedFilterTokens(),
          priceRange: _priceRange,
        ),
      ),
    );
  }

  List<String> _selectedFilterTokens() {
    return <String>[
      _selectedPriceTier,
      _selectedDistance,
      _selectedSpace,
      ..._selectedAmenities,
    ];
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 20, color: const Color(0xFF553722)),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.beVietnamPro(
            color: const Color(0xFF553722),
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: const Color(0xFFF6F3F0), borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("30k", style: GoogleFonts.beVietnamPro(color: const Color(0xFF553722), fontWeight: FontWeight.w700)),
              Text("150k+", style: GoogleFonts.beVietnamPro(color: const Color(0xFF553722), fontWeight: FontWeight.w700)),
            ],
          ),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: const Color(0xFF553722),
              inactiveTrackColor: const Color(0xFFD4C3BA).withValues(alpha: 0.5),
              thumbColor: const Color(0xFF553722),
              trackHeight: 4,
            ),
            child: RangeSlider(
              values: _priceRange,
              min: 30,
              max: 150,
              onChanged: (RangeValues values) => setState(() => _priceRange = values),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(child: _buildPriceButton("Bình dân")),
              const SizedBox(width: 8),
              Expanded(child: _buildPriceButton("Tầm trung")),
              const SizedBox(width: 8),
              Expanded(child: _buildPriceButton("Cao cấp")),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceButton(String label) {
    final bool isSelected = _selectedPriceTier == label;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => setState(() => _selectedPriceTier = label),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF553722) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? null : Border.all(color: const Color(0xFFEAE8E5)),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.beVietnamPro(
            color: isSelected ? Colors.white : const Color(0xFF553722),
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildDistanceGrid() {
    final List<String> options = <String>["1 km", "1 - 3 km", "3 - 5 km", "> 5 km"];
    return GridView.builder(
      itemCount: options.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.2,
      ),
      itemBuilder: (_, int index) {
        final String title = options[index];
        final bool isSelected = _selectedDistance == title;
        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => setState(() => _selectedDistance = title),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF6D5B4F) : const Color(0xFFF6F3F0),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "KHOẢNG",
                  style: GoogleFonts.beVietnamPro(
                    color: isSelected ? Colors.white70 : const Color(0xFF6D5B4F).withValues(alpha: 0.7),
                    fontSize: 10,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: GoogleFonts.beVietnamPro(
                    color: isSelected ? Colors.white : const Color(0xFF553722),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAmenitiesWrap() {
    final List<Map<String, dynamic>> options = <Map<String, dynamic>>[
      <String, dynamic>{"icon": Icons.wifi, "label": "Wifi mạnh"},
      <String, dynamic>{"icon": Icons.power, "label": "Ổ cắm điện"},
      <String, dynamic>{"icon": Icons.directions_car, "label": "Chỗ để xe"},
      <String, dynamic>{"icon": Icons.ac_unit, "label": "Máy lạnh"},
      <String, dynamic>{"icon": Icons.smoke_free, "label": "Không hút thuốc"},
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: options.map((Map<String, dynamic> option) {
        final String label = option["label"] as String;
        final bool isSelected = _selectedAmenities.contains(label);

        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedAmenities.remove(label);
              } else {
                _selectedAmenities.add(label);
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFF2DDD1) : const Color(0xFFF6F3F0),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isSelected ? const Color(0xFF553722).withValues(alpha: 0.35) : Colors.transparent,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(option["icon"] as IconData, size: 16, color: const Color(0xFF553722)),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: GoogleFonts.beVietnamPro(
                    color: const Color(0xFF553722),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSpaceGrid() {
    final List<Map<String, String>> spaces = <Map<String, String>>[
      <String, String>{
        "title": "Yên tĩnh",
        "subtitle": "HỌC TẬP & LÀM VIỆC",
        "image": "https://images.unsplash.com/photo-1541167760496-1628856ab772?w=500&q=80",
      },
      <String, String>{
        "title": "Hiện đại",
        "subtitle": "TỐI GIẢN & TINH TẾ",
        "image": "https://images.unsplash.com/photo-1497935586351-b67a49e012bf?w=500&q=80",
      },
      <String, String>{
        "title": "Cổ điển",
        "subtitle": "HOÀI NIỆM",
        "image": "https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=500&q=80",
      },
      <String, String>{
        "title": "Sân vườn",
        "subtitle": "THOÁNG ĐÃNG",
        "image": "https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=500&q=80",
      },
    ];

    return GridView.builder(
      itemCount: spaces.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (_, int index) {
        final Map<String, String> space = spaces[index];
        final bool isSelected = _selectedSpace == space["title"];

        return InkWell(
          onTap: () => setState(() => _selectedSpace = space["title"]!),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(image: NetworkImage(space["image"]!), fit: BoxFit.cover),
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: <Color>[Colors.black.withValues(alpha: 0.8), Colors.transparent],
                    ),
                  ),
                ),
                if (isSelected)
                  const Positioned(
                    top: 12,
                    right: 12,
                    child: Icon(Icons.check_circle, color: Colors.white, size: 24),
                  ),
                Positioned(
                  left: 16,
                  bottom: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        space["title"]!,
                        style: GoogleFonts.beVietnamPro(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        space["subtitle"]!,
                        style: GoogleFonts.beVietnamPro(
                          color: Colors.white,
                          fontSize: 8,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
