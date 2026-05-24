import 'package:flutter/material.dart';
import "package:cafesense/core/widgets/custom_bottom_nav.dart";
import 'package:cafesense/features/cafe/data/models/cafe.dart';
import 'match_rationale_screen.dart';

class MatchAnimationScreen extends StatefulWidget {
  final Cafe cafe;

  const MatchAnimationScreen({super.key, required this.cafe});

  @override
  State<MatchAnimationScreen> createState() => _MatchAnimationScreenState();
}

class _MatchAnimationScreenState extends State<MatchAnimationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(() {
        setState(() {});
      });

    _controller.forward().then((_) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MatchRationaleScreen(cafe: widget.cafe)),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int matchPercent = widget.cafe.matchPercent ?? 100;

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
        title: const Text(
          'CafeSense',
          style: TextStyle(
            color: Color(0xFF553722),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 24),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&q=80'),
            ),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: CircularProgressIndicator(
                          value: _controller.value,
                          strokeWidth: 4,
                          backgroundColor:
                              const Color(0xFFD4C3BA).withValues(alpha: 0.3),
                          color: const Color(0xFF553722),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.local_cafe,
                              size: 40, color: Color(0xFF553722)),
                          const SizedBox(height: 8),
                          Text(
                            '${(_controller.value * matchPercent).toInt()}%',
                            style: const TextStyle(
                              color: Color(0xFF553722),
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                const Text(
                  'Đang giải mã hương vị...',
                  style: TextStyle(
                    color: Color(0xFF553722),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Phân tích hồ sơ vị giác cá nhân và kết nối với ${widget.cafe.name} - quán cà phê phù hợp nhất.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF6D5B4F),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 48),
                LinearProgressIndicator(
                  value: _controller.value,
                  backgroundColor:
                      const Color(0xFFD4C3BA).withValues(alpha: 0.3),
                  color: const Color(0xFF553722),
                ),
                const SizedBox(height: 48),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: [
                    if (widget.cafe.spaceStyle.isNotEmpty)
                      _buildFloatingTag(
                          widget.cafe.spaceStyle.first.toUpperCase()),
                    if (widget.cafe.amenities.isNotEmpty)
                      _buildTextTag(widget.cafe.amenities.first.toUpperCase()),
                    if (widget.cafe.spaceStyle.length > 1)
                      _buildFloatingTag(
                          widget.cafe.spaceStyle[1].toUpperCase()),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomBottomNav(currentIndex: 1, onTap: (index) {}),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF3B565A).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1)),
    );
  }

  Widget _buildTextTag(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(label,
          style: const TextStyle(
              color: Color(0xFF6D5B4F),
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1)),
    );
  }
}
