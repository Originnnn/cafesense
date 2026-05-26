import 'dart:ui';
import 'package:flutter/material.dart';
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

class _Cafe3dSpaceScreenState extends State<Cafe3dSpaceScreen> {
  bool _useGyroscope = true;
  double _zoom = 1.0;

  void _zoomIn() {
    setState(() {
      _zoom = (_zoom + 0.25).clamp(1.0, 3.0);
    });
  }

  void _zoomOut() {
    setState(() {
      _zoom = (_zoom - 0.25).clamp(1.0, 3.0);
    });
  }

  void _toggleGyroscope() {
    setState(() {
      _useGyroscope = !_useGyroscope;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 3D Panorama View
          Positioned.fill(
            child: PanoramaViewer(
              zoom: _zoom,
              sensorControl: _useGyroscope ? SensorControl.orientation : SensorControl.none,
              child: Image.network(
                widget.panoramaUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Đang tải không gian 3D...',
                          style: GoogleFonts.beVietnamPro(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          color: Colors.redAccent,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Không thể tải ảnh không gian 3D',
                          style: GoogleFonts.beVietnamPro(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // Glassmorphic Top Bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back Button
                ClipOval(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.3),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                ),

                // Cafe Name Indicator
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                          color: Colors.black.withValues(alpha: 0.3),
                          child: Text(
                            widget.cafeName,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.beVietnamPro(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 48), // Spacer to balance layout
              ],
            ),
          ),

          // Instruction Text Overlay (Fades out quickly)
          Positioned(
            left: 24,
            right: 24,
            bottom: 120,
            child: IgnorePointer(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: Colors.black54,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.swipe_rounded, color: Colors.white70, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Vuốt màn hình để xoay không gian 360°',
                          style: GoogleFonts.beVietnamPro(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Glassmorphic Control Bar at Bottom
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 24,
            left: 32,
            right: 32,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.15),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Gyroscope Control
                      IconButton(
                        icon: Icon(
                          _useGyroscope ? Icons.screen_rotation_rounded : Icons.screen_lock_rotation_rounded,
                          color: _useGyroscope ? const Color(0xFFE2A884) : Colors.white70,
                          size: 28,
                        ),
                        tooltip: 'Chế độ xoay theo thiết bị',
                        onPressed: _toggleGyroscope,
                      ),
                      
                      // Divider
                      Container(
                        width: 1,
                        height: 24,
                        color: Colors.white24,
                      ),

                      // Zoom Out
                      IconButton(
                        icon: const Icon(Icons.zoom_out_rounded, color: Colors.white70, size: 28),
                        onPressed: _zoom > 1.0 ? _zoomOut : null,
                      ),

                      // Zoom Indicator
                      Text(
                        '${_zoom.toStringAsFixed(1)}x',
                        style: GoogleFonts.beVietnamPro(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      // Zoom In
                      IconButton(
                        icon: const Icon(Icons.zoom_in_rounded, color: Colors.white70, size: 28),
                        onPressed: _zoom < 3.0 ? _zoomIn : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
