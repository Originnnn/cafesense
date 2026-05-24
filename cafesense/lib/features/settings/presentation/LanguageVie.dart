import 'package:flutter/material.dart';

class EmptyStateScreen extends StatelessWidget {
  const EmptyStateScreen({super.key});

  final Color primaryBrown = const Color(0xFF5D4037);
  final Color buttonBrown = const Color(0xFF634A3A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryBrown),
          onPressed: () {},
        ),
        title: Text(
          'Yêu thích',
          style: TextStyle(color: primaryBrown, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Phan minh hoa do hoa trung tam
            _buildIllustration(),
            
            const SizedBox(height: 40),

            // Tieu de thong bao
            Text(
              'Chưa có quán yêu thích',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: primaryBrown,
                height: 1.2,
              ),
            ),
            
            const SizedBox(height: 15),

            // Doan van mo ta
            Text(
              'Góc cafe quen thuộc của bạn đang trống trải. Hãy cùng tìm kiếm một không gian mới nhé!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),

            const SizedBox(height: 60),

            // Nut Kham pha ngay
            SizedBox(
              width: double.infinity,
              height: 65,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.explore_outlined, color: Colors.white),
                label: const Text(
                  'Khám phá ngay',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonBrown,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 5,
                  shadowColor: buttonBrown.withValues(alpha: 0.4),
                ),
              ),
            ),

            const SizedBox(height: 40),
            
            // Text nho footer (Version info)
            Text(
              'COLLECTION EMPTY STATE V1.0',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[400],
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // Ham xay dung phan hinh anh minh hoa
  Widget _buildIllustration() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Khung nen bo goc mo phia sau
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: const Color(0xFFE0D9D1).withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        // Icon mat buon va lan khoi
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.air, color: Colors.grey[400], size: 30),
            const SizedBox(height: 10),
            Icon(
              Icons.sentiment_dissatisfied_outlined,
              size: 100,
              color: Colors.grey[300],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: primaryBrown,
      unselectedItemColor: Colors.grey[400],
      currentIndex: 2, // Dang o tab Yeu thich
      selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontSize: 10),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: 'KHÁM PHÁ'),
        BottomNavigationBarItem(icon: Icon(Icons.auto_awesome_outlined), label: 'PHÙ HỢP'),
        BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'YÊU THÍCH'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'CÁ NHÂN'),
      ],
    );
  }
}
