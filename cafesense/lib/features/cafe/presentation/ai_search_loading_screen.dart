import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:google_fonts/google_fonts.dart";
import "package:cafesense/core/widgets/custom_bottom_nav.dart";
import "package:cafesense/features/cafe/data/repositories/cafe_repository.dart";
import "package:cafesense/features/cafe/data/models/cafe.dart";
import "package:cafesense/features/cafe/presentation/filter_results_screen.dart";

class AiSearchLoadingScreen extends ConsumerStatefulWidget {
  const AiSearchLoadingScreen({
    super.key,
    required this.filters,
    required this.priceRange,
  });

  final List<String> filters;
  final RangeValues priceRange;

  @override
  ConsumerState<AiSearchLoadingScreen> createState() => _AiSearchLoadingScreenState();
}

class _AiSearchLoadingScreenState extends ConsumerState<AiSearchLoadingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  int _step = 0;

  static const List<String> _messages = <String>[
    "Đang giải mã hương vị...",
    "Đang học gu không gian của bạn...",
    "Đang kết nối dữ liệu quán phù hợp...",
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _startAiSearch();
  }

  Future<void> _startAiSearch() async {
    Future<void>.delayed(const Duration(milliseconds: 650), () {
      if (mounted) setState(() => _step = 1);
    });
    Future<void>.delayed(const Duration(milliseconds: 1300), () {
      if (mounted) setState(() => _step = 2);
    });

    try {
      final cafeRepo = ref.read(cafeRepositoryProvider);
      
      // Load matched cafes sorted by matching percentage
      final List<Cafe> allMatchedCafes = await cafeRepo.getMatchedCafes();

      // Filter matched cafes on client-side based on widget.filters and widget.priceRange
      final List<Cafe> filteredResults = allMatchedCafes.where((cafe) {
        // Price filtering
        int priceLevel = 1;
        if (cafe.priceLabel == '\$\$') {
          priceLevel = 2;
        } else if (cafe.priceLabel == '\$\$\$') {
          priceLevel = 3;
        }

        final double minPrice = widget.priceRange.start;
        final double maxPrice = widget.priceRange.end;
        if (priceLevel < minPrice || priceLevel > maxPrice) {
          return false;
        }

        // Tag filter (if any are selected, we can check if they overlap with space styles or amenities)
        if (widget.filters.isNotEmpty) {
          bool matchFilter = false;
          for (final filter in widget.filters) {
            final String normFilter = filter.toLowerCase().trim();
            final bool hasAmenity = cafe.amenities.any((a) => a.toLowerCase().contains(normFilter));
            final bool hasStyle = cafe.spaceStyle.any((s) => s.toLowerCase().contains(normFilter));
            
            if (hasAmenity || hasStyle) {
              matchFilter = true;
              break; // OR-based filtering for user friendliness
            }
          }
          if (!matchFilter) {
            return false;
          }
        }

        return true;
      }).toList();

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => FilterResultsScreen(
            results: filteredResults,
            activeFilters: widget.filters,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi tải kết quả: ${e.toString().replaceAll('Exception: ', '')}')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String headline = _messages[_step.clamp(0, _messages.length - 1)];

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCF9F6),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF553722)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "CafeSense",
          style: GoogleFonts.beVietnamPro(
            color: const Color(0xFF553722),
            fontSize: 42,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: const <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(
                "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&q=80",
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 16),
          const Spacer(),
          FadeTransition(
            opacity: CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF553722), width: 3),
                color: Colors.white,
              ),
              child: const Center(
                child: Icon(Icons.local_cafe_rounded, size: 52, color: Color(0xFF6B4A38)),
              ),
            ),
          ),
          const SizedBox(height: 36),
          Text(
            headline,
            style: GoogleFonts.beVietnamPro(
              color: const Color(0xFF553722),
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 38),
            child: Text(
              "Phân tích hồ sơ vị giác cá nhân và kết nối với những hạt cà phê thủ công tinh túy nhất.",
              textAlign: TextAlign.center,
              style: GoogleFonts.beVietnamPro(
                color: const Color(0xFF7E6658),
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 82),
            child: LinearProgressIndicator(
              borderRadius: BorderRadius.circular(20),
              minHeight: 6,
              color: const Color(0xFF553722),
              backgroundColor: const Color(0xFFE8E2DC),
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: widget.filters
                .take(3)
                .map((String filter) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD1DDE0),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        filter.toUpperCase(),
                        style: GoogleFonts.beVietnamPro(
                          color: const Color(0xFF4A5D63),
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ))
                .toList(),
          ),
          const Spacer(),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(currentIndex: 1, onTap: (_) {}),
    );
  }
}
