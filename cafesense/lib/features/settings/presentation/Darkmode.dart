import 'package:flutter/material.dart';

// --- 1. MÀN HÌNH CHÍNH SÁCH BẢO MẬT ---
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  final Color primaryBrown = const Color(0xFF5D4037);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: primaryBrown),
        title: Text('Chính sách riêng tư', style: TextStyle(color: primaryBrown, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tại CafeSense, chúng tôi coi trọng sự tin tưởng của bạn...',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 30),
            _buildPolicySection(
              '1. Thu thập dữ liệu',
              'Chúng tôi thu thập thông tin bạn cung cấp trực tiếp... bao gồm tên, địa chỉ email và sở thích hương vị cà phê.',
              Icons.vibration, // Icon mô phỏng
            ),
            _buildPolicySection(
              '2. Sử dụng thông tin',
              'Thông tin của bạn được sử dụng để cá nhân hóa danh sách "Sensory Edit" dành riêng cho bạn.',
              Icons.article_outlined,
            ),
            _buildPolicySection(
              '3. Bảo mật',
              'Chúng tôi áp dụng các biện pháp bảo mật kỹ thuật để bảo vệ dữ liệu cá nhân của bạn.',
              Icons.verified_user_outlined,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(left: BorderSide(color: Colors.orange.shade100, width: 4)),
              ),
              child: const Text(
                '"Sự minh bạch là thành phần quan trọng nhất trong công thức niềm tin của chúng tôi."',
                style: TextStyle(fontStyle: FontStyle.italic, color: Color(0xFF8D6E63)),
              ),
            ),
            const SizedBox(height: 30),
            _buildContactInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicySection(String title, String content, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFFEFEBE9), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, size: 20, color: primaryBrown),
              ),
              const SizedBox(width: 15),
              Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryBrown)),
            ],
          ),
          const SizedBox(height: 12),
          Text(content, style: const TextStyle(fontSize: 14, height: 1.6, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return Row(
      children: [
        Icon(Icons.help_outline, color: primaryBrown),
        const SizedBox(width: 15),
        const Expanded(
          child: Text(
            'Liên hệ: trungn.22it@vku.udn.vn', // Theo thông tin trong ảnh
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

// --- 2. MÀN HÌNH TRẠNG THÁI TRỐNG (LỊCH SỬ/YÊU THÍCH) ---
class EmptyStateScreen extends StatelessWidget {
  const EmptyStateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: const Icon(Icons.arrow_back, color: Color(0xFF5D4037)),
        title: const Text('Lịch sử xem', style: TextStyle(color: Color(0xFF5D4037))),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Hình minh họa cốc cà phê và kính lúp
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6D4C41),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Icon(Icons.local_cafe, size: 80, color: Colors.white),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.search, size: 30, color: Colors.black),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 40),
              const Text(
                'Lịch sử còn trống',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Text(
                'Bạn chưa xem quán nào gần đây. Hãy bắt đầu khám phá nhé!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5D4037),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text('Khám phá ngay', style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}