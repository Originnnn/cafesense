import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cafesense/features/cafe/presentation/cafe_detail_screen.dart';
import 'package:cafesense/features/cafe/presentation/filter_screen.dart';
import 'package:cafesense/features/explore/presentation/explore_map_screen.dart';
import 'package:cafesense/features/cafe/data/repositories/cafe_repository.dart';
import 'package:cafesense/features/cafe/data/models/cafe.dart';
import 'package:cafesense/core/providers/favorites_provider.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  late Future<List<Cafe>> _cafesFuture;
  double? _userLatitude;
  double? _userLongitude;

  @override
  void initState() {
    super.initState();
    _cafesFuture = _fetchCafesWithLocation();
  }

  Future<List<Cafe>> _fetchCafesWithLocation() async {
    double? lat;
    double? lng;
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }
        if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
          Position position = await Geolocator.getCurrentPosition();
          lat = position.latitude;
          lng = position.longitude;
          if (mounted) {
            setState(() {
              _userLatitude = lat;
              _userLongitude = lng;
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
    return ref.read(cafeRepositoryProvider).getCafes(lat: lat, lng: lng);
  }

  String _getDistanceText(Cafe cafe) {
    if (_userLatitude != null && _userLongitude != null) {
      final double distance = Geolocator.distanceBetween(
        _userLatitude!,
        _userLongitude!,
        cafe.latitude,
        cafe.longitude,
      );
      if (distance >= 1000) {
        return "${(distance / 1000).toStringAsFixed(1)} km";
      } else {
        return "${distance.toStringAsFixed(0)} m";
      }
    }
    return "0.5 km";
  }

  void _refreshCafes() {
    setState(() {
      _cafesFuture = _fetchCafesWithLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double topInset = MediaQuery.of(context).padding.top;
    final double overlayBarHeight = topInset + 68;

    return FutureBuilder<List<Cafe>>(
      future: _cafesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF553722)),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Đã xảy ra lỗi: ${snapshot.error.toString().replaceAll('Exception: ', '')}',
                    textAlign: TextAlign.center,
                    style:
                        const TextStyle(color: Color(0xFF553722), fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refreshCafes,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF553722)),
                    child: const Text('Thử lại',
                        style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            ),
          );
        }

        final List<Cafe> cafes = snapshot.data ?? [];
        if (cafes.isEmpty) {
          return const Center(
            child: Text('Không tìm thấy dữ liệu quán cà phê nào.'),
          );
        }

        final Cafe heroCafe = cafes[0];
        final Cafe? standardCafe = cafes.length > 1 ? cafes[1] : null;
        final Cafe? compactCafe = cafes.length > 2 ? cafes[2] : null;
        final Cafe? darkCafe = cafes.length > 3 ? cafes[3] : null;

        return Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding:
                    EdgeInsets.only(top: overlayBarHeight + 20, bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Tìm kiếm\nquán cafe hợp\ngu bạn',
                        style: TextStyle(
                          color: Color(0xFF553722),
                          fontSize: 40,
                          fontFamily: 'Noto Serif',
                          height: 1.2,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Khám phá thủ công',
                            style: TextStyle(
                              color: Color(0xFF553722),
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const ExploreMapScreen()),
                              );
                            },
                            child: const Icon(Icons.location_on,
                                color: Color(0xFF553722)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CafeDetailScreen(cafe: heroCafe)));
                            },
                            child: _buildHeroCard(heroCafe),
                          ),
                          const SizedBox(height: 24),
                          if (standardCafe != null) ...[
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CafeDetailScreen(cafe: standardCafe)),
                                );
                              },
                              child: _buildStandardCard(standardCafe),
                            ),
                            const SizedBox(height: 24),
                          ],
                          GestureDetector(
                            onTap: () {
                              // visual promo banner, route to hero for visual consistency
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CafeDetailScreen(cafe: heroCafe)));
                            },
                            child: _buildPromoBanner(),
                          ),
                          const SizedBox(height: 24),
                          if (compactCafe != null) ...[
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CafeDetailScreen(cafe: compactCafe)),
                                );
                              },
                              child: _buildCompactCard(compactCafe),
                            ),
                            const SizedBox(height: 24),
                          ],
                          if (darkCafe != null) ...[
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CafeDetailScreen(cafe: darkCafe)),
                                );
                              },
                              child: _buildDarkBanner(darkCafe),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Translucent Floating Top Bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Container(
                    height: overlayBarHeight,
                    padding: EdgeInsets.only(
                      top: topInset + 10,
                      left: 24,
                      right: 24,
                      bottom: 10,
                    ),
                    color: const Color(0xFFFCF9F6).withValues(alpha: 0.8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const FilterScreen()),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                            child: const Icon(Icons.tune,
                                color: Color(0xFF553722)),
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            'CafeSense',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF553722),
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const CircleAvatar(
                          radius: 16,
                          backgroundColor: Color(0xFFEAE8E5),
                          backgroundImage: NetworkImage(
                              'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&q=80'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeroCard(Cafe cafe) {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        color: const Color(0xFFF6F3F0),
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: NetworkImage(cafe.imageUrl.isNotEmpty
              ? cafe.imageUrl
              : 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=500&q=80'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    const Color(0xFF553722).withValues(alpha: 0.8),
                    const Color(0xFF553722).withValues(alpha: 0.0),
                  ],
                  stops: const [0.0, 0.5],
                ),
              ),
            ),
          ),
          Positioned(
            left: 24,
            bottom: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (cafe.spaceStyle.isNotEmpty)
                      _buildGlassChip(cafe.spaceStyle.first.toUpperCase()),
                    const SizedBox(width: 12),
                    _buildGlassChip('SPECIALTY'),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  cafe.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  cafe.description,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassChip(String text) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          color: Colors.white.withValues(alpha: 0.2),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStandardCard(Cafe cafe) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F3F0),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A1C1C1A),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              cafe.imageUrl.isNotEmpty
                  ? cafe.imageUrl
                  : 'https://images.unsplash.com/photo-1497935586351-b67a49e012bf?w=500&q=80',
              cacheWidth: 500,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            cafe.name,
            style: const TextStyle(
              color: Color(0xFF553722),
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: cafe.spaceStyle
                .take(2)
                .map((chip) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3C5A63).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          chip,
                          style: const TextStyle(
                            color: Color(0xFF2D4B54),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF553722),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Icon(Icons.auto_awesome, color: Colors.white, size: 30),
          const SizedBox(height: 16),
          const Text(
            'Điểm đến mới',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Đậu cà phê thương mại trực tiếp từ Huila, Colombia vừa cập bến khu vực của bạn.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.only(bottom: 4),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white30)),
            ),
            child: const Text(
              'KHÁM PHÁ NGAY',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactCard(Cafe cafe) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F3F0),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              cafe.imageUrl.isNotEmpty
                  ? cafe.imageUrl
                  : 'https://images.unsplash.com/photo-1559525839-b184a4d698c7?w=500&q=80',
              cacheWidth: 500,
              height: 192,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cafe.name,
                    style: const TextStyle(
                      color: Color(0xFF553722),
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${cafe.priceLabel} • ${cafe.spaceStyle.join(", ").toUpperCase()}',
                    style: const TextStyle(
                      color: Color(0xFF6D5B4F),
                      fontSize: 12,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  ref.read(favoritesProvider.notifier).toggleFavorite(cafe.id);
                },
                child: Icon(
                  ref.watch(favoritesProvider).contains(cafe.id)
                      ? Icons.bookmark
                      : Icons.bookmark_border,
                  color: const Color(0xFF6F4E37),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDarkBanner(Cafe cafe) {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: const Color(0xFF1C1917),
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: NetworkImage(cafe.imageUrl.isNotEmpty
              ? cafe.imageUrl
              : 'https://images.unsplash.com/photo-1511920170033-f8396924c348?w=500&q=80'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.4),
            BlendMode.darken,
          ),
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xCC553722),
                  Color(0x00553722),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  cafe.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  cafe.tagline,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
