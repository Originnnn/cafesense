import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cafesense/features/cafe/data/models/cafe.dart';
import 'package:cafesense/core/providers/favorites_provider.dart';
import 'package:cafesense/core/providers/history_provider.dart';
import 'cafe_menu_tab.dart';
import 'package:cafesense/features/cafe/presentation/cafe_reviews_tab.dart';
import 'package:cafesense/features/cafe/presentation/cafe_3d_space_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cafesense/core/utils/map_utils.dart';
import 'package:share_plus/share_plus.dart';

class CafeDetailScreen extends ConsumerStatefulWidget {
  final Cafe cafe;

  const CafeDetailScreen({super.key, required this.cafe});

  @override
  ConsumerState<CafeDetailScreen> createState() => _CafeDetailScreenState();
}

class _CafeDetailScreenState extends ConsumerState<CafeDetailScreen> {
  late Cafe _cafe;

  @override
  void initState() {
    super.initState();
    _cafe = widget.cafe;
    // Record this cafe view in history
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(historyProvider.notifier).addEntry(_cafe);
    });
  }

  void _handleReviewAdded(Review review) {
    setState(() {
      final updatedReviews = [review, ..._cafe.reviews];
      _cafe = Cafe(
        id: _cafe.id,
        name: _cafe.name,
        fullName: _cafe.fullName,
        description: _cafe.description,
        imageUrl: _cafe.imageUrl,
        latitude: _cafe.latitude,
        longitude: _cafe.longitude,
        priceLabel: _cafe.priceLabel,
        tagline: _cafe.tagline,
        spaceStyle: _cafe.spaceStyle,
        amenities: _cafe.amenities,
        menu: _cafe.menu,
        reviews: updatedReviews,
        matchPercent: _cafe.matchPercent,
        roastLevel: _cafe.roastLevel,
        acidity: _cafe.acidity,
        body: _cafe.body,
        sweetness: _cafe.sweetness,
        process: _cafe.process,
        wifiRating: _cafe.wifiRating,
        spaceRating: _cafe.spaceRating,
        outletRating: _cafe.outletRating,
        priceRating: _cafe.priceRating,
        tasteRating: _cafe.tasteRating,
        viewRating: _cafe.viewRating,
        panoramaUrl: _cafe.panoramaUrl,
      );
    });
  }

  Cafe get cafe => _cafe;

  @override
  Widget build(BuildContext context) {
    final isFav = ref.watch(favoritesProvider).contains(cafe.id);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFFCF9F6),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 380.0,
                floating: false,
                pinned: true,
                backgroundColor: const Color(0xFFFCF9F6),
                iconTheme: const IconThemeData(color: Color(0xFF553722)),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: isFav ? const Color(0xFFE05555) : const Color(0xFF553722),
                    ),
                    tooltip: isFav ? 'Bỏ yêu thích' : 'Thêm yêu thích',
                    onPressed: () {
                      ref.read(favoritesProvider.notifier).toggleFavorite(cafe.id);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.threed_rotation),
                    tooltip: 'Xem không gian 3D',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Cafe3dSpaceScreen(
                            cafeName: cafe.name,
                            panoramaUrl: cafe.panoramaUrl,
                          ),
                        ),
                      );
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        cafe.imageUrl.isNotEmpty
                            ? cafe.imageUrl
                            : 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=800&q=80',
                        fit: BoxFit.cover,
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              const Color(0xFF553722),
                              const Color(0xFF553722).withValues(alpha: 0.0),
                            ],
                            stops: const [0.0, 0.6],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 24,
                        bottom: 40,
                        right: 24,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cafe.tagline.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              cafe.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(60),
                  child: Container(
                    color: const Color(0xFFFCF9F6),
                    child: const TabBar(
                      indicatorColor: Color(0xFF553722),
                      labelColor: Color(0xFF553722),
                      unselectedLabelColor: Color(0xFF6D5B4F),
                      indicatorWeight: 3,
                      tabs: [
                        Tab(text: 'Tổng quan'),
                        Tab(text: 'Thực đơn'),
                        Tab(text: 'Đánh giá'),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              _OverviewTab(cafe: cafe, isFav: isFav, onFavToggle: () {
                ref.read(favoritesProvider.notifier).toggleFavorite(cafe.id);
              }),
              MenuTab(menu: cafe.menu),
              ReviewsTab(
                reviews: cafe.reviews,
                cafeId: cafe.id,
                cafeName: cafe.name,
                onReviewAdded: _handleReviewAdded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  final Cafe cafe;
  final bool isFav;
  final VoidCallback onFavToggle;

  const _OverviewTab({required this.cafe, required this.isFav, required this.onFavToggle});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 24, bottom: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildActionRow(context),
          const SizedBox(height: 48),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Câu chuyện của\nchúng tôi',
                  style: GoogleFonts.notoSerif(
                    color: const Color(0xFF553722),
                    fontSize: 32,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  cafe.description,
                  style: GoogleFonts.beVietnamPro(
                    color: const Color(0xFF553722),
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          _buildImageCollage(),
          const SizedBox(height: 48),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Triết lý phong cách',
                  style: TextStyle(
                    color: Color(0xFF553722),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Không gian được thiết kế tỉ mỉ để phù hợp nhất với trải nghiệm học tập, làm việc và thư giãn của khách hàng. Chúng tôi trân quý từng nét vẽ kiến trúc và chất lượng dịch vụ.',
                  style: TextStyle(
                    color: const Color(0xFF553722).withValues(alpha: 0.8),
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                _buildDetailsCard(),
                const SizedBox(height: 24),
                _buildFlavorProfileCard(),
                const SizedBox(height: 24),
                _buildMapImage(),
                const SizedBox(height: 48),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TRẢI NGHIỆM',
                            style: TextStyle(
                              color: Color(0xFF6D5B4F),
                              fontSize: 10,
                              letterSpacing: 1.5,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Không gian\n& Tiện ích\nnổi bật',
                            style: TextStyle(
                              color: Color(0xFF553722),
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    Flexible(
                      child: Text(
                        'Xem chi tiết',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Color(0xFF553722),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                _buildAmenitiesList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const Row(
            children: [
              SizedBox(
                width: 60,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&q=80'),
                    ),
                    Positioned(
                      left: 20,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80'),
                      ),
                    ),
                    Positioned(
                      left: 40,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Color(0xFF553722),
                        child: Text('+12',
                            style:
                                TextStyle(color: Colors.white, fontSize: 10)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 32),
              Expanded(
                child: Text(
                  'Được ghé thăm gần đây bởi những\nngười sành sỏi',
                  style: TextStyle(
                    color: Color(0xFF6D5B4F),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: onFavToggle,
                child: _buildActionButton(
                  isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  isFav ? 'Đã lưu' : 'Lưu',
                  iconColor: isFav ? const Color(0xFFE05555) : null,
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () {
                  Share.share('Hãy đến quán ${cafe.name} cùng mình nhé! Không gian siêu đẹp: ${cafe.tagline}');
                },
                child: _buildActionButton(Icons.share, 'Chia sẻ'),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () {
                  MapUtils.navigateTo(cafe.latitude, cafe.longitude);
                },
                child: _buildActionButtonPrimary(Icons.directions, 'Chỉ đường'),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Cafe3dSpaceScreen(
                        cafeName: cafe.name,
                        panoramaUrl: cafe.panoramaUrl,
                      ),
                    ),
                  );
                },
                child: _buildActionButton(Icons.threed_rotation, 'Không gian 3D'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, {Color? iconColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEAE8E5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: iconColor ?? const Color(0xFF553722)),
          const SizedBox(width: 8),
          Text(label,
              style: const TextStyle(
                  color: Color(0xFF553722), fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildActionButtonPrimary(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF553722),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.white),
          const SizedBox(width: 8),
          Text(label,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildImageCollage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                cafe.imageUrl.isNotEmpty
                    ? cafe.imageUrl
                    : 'https://images.unsplash.com/photo-1497935586351-b67a49e012bf?w=500&q=80',
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  'https://images.unsplash.com/photo-1611162617474-5b21e879e113?w=500&q=80',
                  height: 260,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F3F0),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chi tiết liên hệ',
            style: TextStyle(
              color: Color(0xFF553722),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _buildDetailRow(
              Icons.access_time, 'Giờ mở cửa\nHàng ngày: 07:00 - 22:00'),
          const SizedBox(height: 16),
          _buildDetailRow(Icons.location_on_outlined,
              'Tọa độ GPS\nLatitude: ${cafe.latitude}\nLongitude: ${cafe.longitude}'),
          const SizedBox(height: 16),
          _buildDetailRow(Icons.phone_outlined,
              'Liên hệ\nHotline: 1900 CafeSense\nEmail: contact@cafesense.vn'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFF553722)),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF6D5B4F),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFlavorProfileCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF553722),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Phong cách thiết kế',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Đặc trưng về concept không gian của quán',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: cafe.spaceStyle.isEmpty
                ? [const SizedBox.shrink()]
                : cafe.spaceStyle
                    .map((style) => _buildDarkChip(style))
                    .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDarkChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  Widget _buildMapImage() {
    return Container(
      height: 240,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                MapUtils.navigateTo(cafe.latitude, cafe.longitude);
              },
              child: IgnorePointer(
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(cafe.latitude, cafe.longitude),
                    initialZoom: 15.0,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.none,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.cafesense.app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(cafe.latitude, cafe.longitude),
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.location_on,
                            color: Color(0xFF553722),
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: ElevatedButton.icon(
                onPressed: () {
                  MapUtils.navigateTo(cafe.latitude, cafe.longitude);
                },
                icon: const Icon(Icons.directions, size: 20),
                label: const Text('Chỉ đường'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF553722),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmenitiesList() {
    return Column(
      children: cafe.amenities
          .map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F3F0),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline,
                          color: Color(0xFF553722), size: 20),
                      const SizedBox(width: 12),
                      Text(
                        item,
                        style: const TextStyle(
                          color: Color(0xFF553722),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }
}
