import "dart:ui" as ui;
import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:geolocator/geolocator.dart";
import "package:google_fonts/google_fonts.dart";
import "package:latlong2/latlong.dart";

import "package:cafesense/core/theme/app_colors.dart";
import "package:cafesense/features/cafe/data/models/cafe.dart";
import "package:cafesense/features/cafe/data/repositories/cafe_repository.dart";
import "package:cafesense/features/cafe/presentation/cafe_detail_screen.dart";

class ExploreMapScreen extends ConsumerStatefulWidget {
  const ExploreMapScreen({super.key});

  @override
  ConsumerState<ExploreMapScreen> createState() => _ExploreMapScreenState();
}

class _ExploreMapScreenState extends ConsumerState<ExploreMapScreen> {
  final MapController _mapController = MapController();
  Position? _currentPosition;
  List<Cafe> _cafes = <Cafe>[];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initLocationAndCafes();
  }

  Future<void> _initLocationAndCafes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 1. Fetch cafes from backend first
      final cafeRepo = ref.read(cafeRepositoryProvider);
      List<Cafe> cafesList;
      try {
        cafesList = await cafeRepo.getMatchedCafes();
      } catch (_) {
        cafesList = await cafeRepo.getCafes();
      }
      setState(() {
        _cafes = cafesList;
      });

      // 2. Determine GPS Location
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _isLoading = false;
      });

      _mapController.move(
        LatLng(position.latitude, position.longitude),
        14.5,
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _showCafeDetails(Cafe cafe) {
    String distanceText = "";
    if (_currentPosition != null) {
      final double distance = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        cafe.latitude,
        cafe.longitude,
      );
      if (distance >= 1000) {
        distanceText = "${(distance / 1000).toStringAsFixed(1)} km";
      } else {
        distanceText = "${distance.toStringAsFixed(0)} m";
      }
    } else {
      distanceText = "Không rõ khoảng cách";
    }

    double avgRating = 5.0;
    if (cafe.reviews.isNotEmpty) {
      avgRating = cafe.reviews.map((r) => r.rating).reduce((a, b) => a + b) /
          cafe.reviews.length;
    }

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textHint.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      cafe.imageUrl.isNotEmpty
                          ? cafe.imageUrl
                          : "https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=500",
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 90,
                        height: 90,
                        color: AppColors.surfaceWarm,
                        child: const Icon(Icons.image_not_supported,
                            color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                cafe.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            if (cafe.matchPercent != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "${cafe.matchPercent}% Match",
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          cafe.tagline,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              avgRating.toStringAsFixed(1),
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Icon(Icons.location_on,
                                color: AppColors.textSecondary, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              distanceText,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
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
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CafeDetailScreen(cafe: cafe),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonPrimary,
                    foregroundColor: AppColors.buttonText,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Xem chi tiết",
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Generate map markers
    final List<Marker> markers = <Marker>[];

    // 1. Add user location marker if available
    if (_currentPosition != null) {
      markers.add(
        Marker(
          point:
              LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          width: 36,
          height: 36,
          child: const _UserLocationDot(),
        ),
      );
    }

    // 2. Add cafes markers
    for (final cafe in _cafes) {
      markers.add(
        Marker(
          point: LatLng(cafe.latitude, cafe.longitude),
          width: 32,
          height: 40,
          child: GestureDetector(
            onTap: () => _showCafeDetails(cafe),
            child: _Pin(),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: <Widget>[
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: LatLng(16.0544, 108.2022),
              initialZoom: 12.4,
              minZoom: 10,
              maxZoom: 18,
            ),
            children: <Widget>[
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: "com.cafesense.app",
              ),
              MarkerLayer(
                markers: markers,
              ),
            ],
          ),

          // Header search/nav bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 18,
            left: 24,
            right: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(16),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: <Widget>[
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back,
                        color: AppColors.primary, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Bản đồ CafeSense",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.beVietnamPro(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 22),
                ],
              ),
            ),
          ),

          // Floating action buttons for gps recenter and reload
          Positioned(
            right: 16,
            bottom: 96,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: "gps_recenter",
                  onPressed: () {
                    if (_currentPosition != null) {
                      _mapController.move(
                        LatLng(_currentPosition!.latitude,
                            _currentPosition!.longitude),
                        15.0,
                      );
                    } else {
                      _initLocationAndCafes();
                    }
                  },
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  mini: true,
                  child: const Icon(Icons.my_location),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: "refresh_map",
                  onPressed: _initLocationAndCafes,
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  mini: true,
                  child: const Icon(Icons.refresh),
                ),
              ],
            ),
          ),

          // Top Loading status bar indicator
          if (_isLoading)
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(
                color: AppColors.primary,
                backgroundColor: Colors.transparent,
              ),
            ),

          // Bottom Bar Status
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: AppColors.backgroundLight,
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Khám phá quanh đây",
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 16,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    _currentPosition != null ? Icons.gps_fixed : Icons.gps_off,
                    color: _currentPosition != null
                        ? AppColors.success
                        : AppColors.textHint,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UserLocationDot extends StatelessWidget {
  const _UserLocationDot();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF2196F3).withValues(alpha: 0.25),
          ),
        ),
        Container(
          width: 16,
          height: 16,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
        Container(
          width: 10,
          height: 10,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF2196F3),
          ),
        ),
      ],
    );
  }
}

class _Pin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PinPainter(),
      size: const Size(32, 40),
    );
  }
}

class _PinPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = AppColors.primary;

    final ui.Path path = ui.Path();
    path.moveTo(size.width / 2, size.height);
    path.quadraticBezierTo(0, size.height * 0.72, 0, size.height * 0.42);
    path.arcToPoint(
      ui.Offset(size.width, size.height * 0.42),
      radius: ui.Radius.circular(size.width / 2),
      clockwise: true,
    );
    path.quadraticBezierTo(
        size.width, size.height * 0.72, size.width / 2, size.height);
    path.close();

    canvas.drawPath(path, paint);

    // Draw inner white dot
    final Paint innerPaint = Paint()..color = Colors.white;
    canvas.drawCircle(
      ui.Offset(size.width / 2, size.height * 0.42),
      4.0,
      innerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
