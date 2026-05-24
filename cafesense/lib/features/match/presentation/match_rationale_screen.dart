import 'dart:math' as math;
import 'package:flutter/material.dart';
import "package:cafesense/core/widgets/custom_bottom_nav.dart";
import 'package:cafesense/features/cafe/data/models/cafe.dart';
import 'package:cafesense/features/cafe/presentation/cafe_detail_screen.dart';

class MatchRationaleScreen extends StatelessWidget {
  final Cafe cafe;

  const MatchRationaleScreen({super.key, required this.cafe});

  @override
  Widget build(BuildContext context) {
    final int matchPercent = cafe.matchPercent ?? 100;

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
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 100),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: const Color(0xFF553722), width: 4),
                  ),
                ),
                Column(
                  children: [
                    Text('$matchPercent%',
                        style: const TextStyle(
                            color: Color(0xFF553722),
                            fontSize: 40,
                            fontWeight: FontWeight.bold)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF553722),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text('ĐIỂM TƯƠNG\nTHÍCH',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              letterSpacing: 1,
                              height: 1.2)),
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              cafe.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF553722),
                fontSize: 32,
                fontFamily: 'Noto Serif',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Trí tuệ nhân tạo của chúng tôi đã tính toán sự phù hợp này dựa trên gu pha chế cá nhân của bạn.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF6D5B4F),
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF553722),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CafeDetailScreen(cafe: cafe)),
                  );
                },
                child: const Text('Khám phá quán ngay',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 48),
            _buildSpaceMatchCard(),
            const SizedBox(height: 24),
            _buildFlavorMatchCard(),
            const SizedBox(height: 24),
            _buildUtilityMatchCard(),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNav(currentIndex: 1, onTap: (index) {}),
    );
  }

  Widget _buildSpaceMatchCard() {
    final int score = math.min(100, (cafe.matchPercent ?? 90) + 2);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F3F0),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.auto_awesome, color: Color(0xFF553722), size: 24),
                  SizedBox(width: 8),
                  Text('Sự phù hợp không\ngian',
                      style: TextStyle(
                          color: Color(0xFF553722),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 1.2)),
                ],
              ),
              Text('$score%',
                  style: const TextStyle(
                      color: Color(0xFF553722),
                      fontSize: 28,
                      fontFamily: 'Noto Serif')),
            ],
          ),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                  color: Color(0xFF6D5B4F), fontSize: 14, height: 1.5),
              children: [
                const TextSpan(text: 'Đồng bộ phong cách thiết kế: '),
                TextSpan(
                    text: cafe.spaceStyle.join(', '),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFF553722))),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('MỨC ĐỘ PHÙ HỢP',
                  style: TextStyle(
                      color: Color(0xFF6D5B4F),
                      fontSize: 10,
                      letterSpacing: 1)),
              Text('RẤT CAO',
                  style: TextStyle(
                      color: Color(0xFF553722),
                      fontSize: 10,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFD4C3BA).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 9,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF553722),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const Expanded(flex: 1, child: SizedBox()),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Địa điểm này sở hữu thiết kế theo phong cách ${cafe.spaceStyle.join(" và ")} cực kỳ ấn tượng, mang lại cảm giác thoải mái và truyền cảm hứng làm việc cũng như thư giãn tối đa.',
            style: const TextStyle(
              color: Color(0xFF6D5B4F),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlavorMatchCard() {
    final int score = math.max(60, (cafe.matchPercent ?? 90) - 5);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F3F0),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.coffee, color: Color(0xFF553722), size: 24),
                  SizedBox(width: 8),
                  Text('Đồng bộ hương vị',
                      style: TextStyle(
                          color: Color(0xFF553722),
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              Text('$score%',
                  style: const TextStyle(
                      color: Color(0xFF553722),
                      fontSize: 28,
                      fontFamily: 'Noto Serif')),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Bản đồ vị giác tối ưu cho gu thưởng thức hạt specialty tinh tuyển.',
            style:
                TextStyle(color: Color(0xFF6D5B4F), fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 32),
          Center(
            child: Container(
              width: 240,
              height: 240,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _buildBubble('High', 'ĐỘ CHUA', -60, -40),
                  _buildBubble('Heavy', 'THỂ CHẤT', 50, -30),
                  _buildBubble('Honey', 'ĐỘ NGỌT', -50, 60),
                  _buildBubble('Washed', 'SƠ CHẾ', 60, 50),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        color: const Color(0xFFEAE8E5).withValues(alpha: 0.5),
                        shape: BoxShape.circle),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Thực đơn cà phê tại ${cafe.name} sử dụng các dòng hạt chất lượng cao sơ chế cẩn thận, đáp ứng hoàn hảo các yêu cầu khắt khe của bạn về chất lượng tách cà phê nguyên bản.',
            style: const TextStyle(
              color: Color(0xFF6D5B4F),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(
      String title, String subtitle, double offsetX, double offsetY) {
    return Transform.translate(
      offset: Offset(offsetX, offsetY),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(subtitle,
              style: const TextStyle(
                  color: Color(0xFF6D5B4F), fontSize: 8, letterSpacing: 1)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFEAE8E5)),
            ),
            child: Text(title,
                style: const TextStyle(
                    color: Color(0xFF553722),
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildUtilityMatchCard() {
    final int score = math.min(100, (cafe.matchPercent ?? 90) + 1);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F3F0),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.dashboard_customize_outlined,
                      color: Color(0xFF553722), size: 24),
                  SizedBox(width: 8),
                  Text('Điểm tiện ích',
                      style: TextStyle(
                          color: Color(0xFF553722),
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              Text('$score%',
                  style: const TextStyle(
                      color: Color(0xFF553722),
                      fontSize: 28,
                      fontFamily: 'Noto Serif')),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Các tiện ích lý tưởng hỗ trợ trải nghiệm tối đa.',
            style: TextStyle(
              color: Color(0xFF6D5B4F),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: cafe.amenities.isEmpty
                ? [const SizedBox.shrink()]
                : cafe.amenities
                    .map((a) => _buildUtilityChip(
                        Icons.check_circle_outline, a.toUpperCase()))
                    .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildUtilityChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEAE8E5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF553722)),
          const SizedBox(width: 8),
          Text(label,
              style: const TextStyle(
                  color: Color(0xFF553722),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1)),
        ],
      ),
    );
  }
}
