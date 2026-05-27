import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:panorama_viewer/panorama_viewer.dart';

class Cafe3dSpaceScreen extends StatefulWidget {
  final String cafeName;
  final String panoramaUrl;

  const Cafe3dSpaceScreen({
    super.key,
    required this.cafeName,
    required this.panoramaUrl,
  });

  @override
  State<Cafe3dSpaceScreen> createState() => _Cafe3dSpaceScreenState();
}

class _Cafe3dSpaceScreenState extends State<Cafe3dSpaceScreen>
    with TickerProviderStateMixin {
  bool _useGyroscope = true;
  double _zoom = 1.0;
  double _longitude = 0.0; // current horizontal angle (0-360)
  bool _isAutoRotating = true;
  bool _showControls = true;
  bool _imageLoaded = false;

  late AnimationController _loadingController;
  late Animation<double> _loadingRotation;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _loadingController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _loadingRotation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _loadingController, curve: Curves.linear),
    );

    // Auto-hide controls after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted && _showControls) {
        setState(() => _showControls = false);
      }
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _loadingController.dispose();
    super.dispose();
  }

  void _onTap() {
    setState(() => _showControls = !_showControls);
  }

  void _zoomIn() {
    setState(() => _zoom = (_zoom + 0.2).clamp(0.5, 3.0));
  }

  void _zoomOut() {
    setState(() => _zoom = (_zoom - 0.2).clamp(0.5, 3.0));
  }

  void _toggleGyroscope() {
    setState(() => _useGyroscope = !_useGyroscope);
  }

  void _toggleAutoRotate() {
    setState(() => _isAutoRotating = !_isAutoRotating);
  }

  /// Get compass direction label from longitude
  String _compassLabel(double lon) {
    final angle = lon % 360;
    final normalized = angle < 0 ? angle + 360 : angle;
    if (normalized < 22.5 || normalized >= 337.5) return 'B';
    if (normalized < 67.5) return 'ĐB';
    if (normalized < 112.5) return 'Đ';
    if (normalized < 157.5) return 'ĐN';
    if (normalized < 202.5) return 'N';
    if (normalized < 247.5) return 'TN';
    if (normalized < 292.5) return 'T';
    return 'TB';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _onTap,
        child: Stack(
          children: [
            // ── 3D Panorama View ──────────────────────────────────
            Positioned.fill(
              child: PanoramaViewer(
                zoom: _zoom,
                animSpeed: _isAutoRotating ? 0.3 : 0.0,
                sensorControl:
                    _useGyroscope ? SensorControl.orientation : SensorControl.none,
                onViewChanged: (lon, lat, tilt) {
                  if (mounted) {
                    setState(() => _longitude = lon);
                  }
                },
                child: Image.network(
                  widget.panoramaUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted && !_imageLoaded) {
                          setState(() => _imageLoaded = true);
                        }
                      });
                      return child;
                    }
                    return const SizedBox.shrink();
                  },
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFF1A0A00),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.broken_image_rounded,
                              color: Colors.white38, size: 64),
                          const SizedBox(height: 16),
                          Text(
                            'Không thể tải ảnh không gian',
                            style: GoogleFonts.beVietnamPro(
                                color: Colors.white54, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── Loading Overlay ───────────────────────────────────
            if (!_imageLoaded)
              Positioned.fill(
                child: Container(
                  color: Colors.black87,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedBuilder(
                          animation: _loadingRotation,
                          builder: (_, __) => Transform.rotate(
                            angle: _loadingRotation.value,
                            child: Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFE2A884),
                                  width: 3,
                                ),
                              ),
                              child: const Icon(
                                Icons.threed_rotation,
                                color: Color(0xFFE2A884),
                                size: 32,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Đang tải không gian 360°...',
                          style: GoogleFonts.beVietnamPro(
                            color: Colors.white70,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.cafeName,
                          style: GoogleFonts.beVietnamPro(
                            color: const Color(0xFFE2A884),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // ── Top Bar ───────────────────────────────────────────
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              left: 16,
              right: 16,
              child: AnimatedOpacity(
                opacity: _showControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 400),
                child: Row(
                  children: [
                    // Back button
                    _glassButton(
                      child: const Icon(Icons.arrow_back_rounded,
                          color: Colors.white, size: 22),
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 12),
                    // Cafe name pill
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.35),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.15)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.threed_rotation,
                                    color: Color(0xFFE2A884), size: 16),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    widget.cafeName,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.beVietnamPro(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Compass
                    _compassWidget(_longitude),
                  ],
                ),
              ),
            ),

            // ── Drag hint (shown briefly) ─────────────────────────
            if (_imageLoaded)
              Positioned(
                left: 0,
                right: 0,
                bottom: 130,
                child: IgnorePointer(
                  child: AnimatedOpacity(
                    opacity: _showControls ? 0.0 : 0.8,
                    duration: const Duration(milliseconds: 300),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter:
                              ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 8),
                            color: Colors.black45,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.swipe_rounded,
                                    color: Colors.white60, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  'Vuốt để xoay · Chạm để hiện menu',
                                  style: GoogleFonts.beVietnamPro(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // ── Bottom Control Bar ─────────────────────────────────
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 24,
              left: 24,
              right: 24,
              child: AnimatedOpacity(
                opacity: _showControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 400),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.12),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Auto-rotate toggle
                          _controlButton(
                            icon: _isAutoRotating
                                ? Icons.pause_circle_outline_rounded
                                : Icons.rotate_right_rounded,
                            label: _isAutoRotating ? 'Dừng' : 'Xoay',
                            active: _isAutoRotating,
                            onTap: _toggleAutoRotate,
                          ),
                          _divider(),
                          // Gyroscope toggle
                          _controlButton(
                            icon: _useGyroscope
                                ? Icons.screen_rotation_alt_rounded
                                : Icons.screen_lock_rotation_rounded,
                            label: 'Gyro',
                            active: _useGyroscope,
                            onTap: _toggleGyroscope,
                          ),
                          _divider(),
                          // Zoom out
                          _controlButton(
                            icon: Icons.zoom_out_rounded,
                            label: '',
                            active: false,
                            onTap: _zoom > 0.5 ? _zoomOut : null,
                          ),
                          // Zoom indicator
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${_zoom.toStringAsFixed(1)}×',
                              style: GoogleFonts.beVietnamPro(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          // Zoom in
                          _controlButton(
                            icon: Icons.zoom_in_rounded,
                            label: '',
                            active: false,
                            onTap: _zoom < 3.0 ? _zoomIn : null,
                          ),
                        ],
                      ),
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

  Widget _glassButton(
      {required Widget child, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.35),
              shape: BoxShape.circle,
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.15), width: 1),
            ),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }

  Widget _compassWidget(double lon) {
    final angle = (lon % 360) * math.pi / 180;
    final label = _compassLabel(lon);
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.4),
            shape: BoxShape.circle,
            border: Border.all(
                color: const Color(0xFFE2A884).withValues(alpha: 0.4)),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.rotate(
                angle: -angle,
                child: const Icon(
                  Icons.navigation_rounded,
                  color: Color(0xFFE2A884),
                  size: 20,
                ),
              ),
              Positioned(
                bottom: 4,
                child: Text(
                  label,
                  style: GoogleFonts.beVietnamPro(
                    color: Colors.white,
                    fontSize: 7,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _controlButton({
    required IconData icon,
    required String label,
    required bool active,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: onTap == null
                ? Colors.white24
                : active
                    ? const Color(0xFFE2A884)
                    : Colors.white70,
            size: 26,
          ),
          if (label.isNotEmpty) ...[
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.beVietnamPro(
                color: active ? const Color(0xFFE2A884) : Colors.white54,
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 28,
      color: Colors.white12,
    );
  }
}
