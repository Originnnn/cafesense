import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cafesense/core/widgets/custom_bottom_nav.dart';
import 'package:cafesense/features/cafe/data/repositories/cafe_repository.dart';

class WriteReviewScreen extends ConsumerStatefulWidget {
  final String cafeId;
  final String cafeName;

  const WriteReviewScreen({
    super.key,
    required this.cafeId,
    required this.cafeName,
  });

  @override
  ConsumerState<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends ConsumerState<WriteReviewScreen> {
  int _rating = 4;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chia sẻ cảm nhận',
              style: TextStyle(
                color: Color(0xFF553722),
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                    color: Color(0xFF6D5B4F), fontSize: 16, height: 1.5),
                children: [
                  const TextSpan(
                      text:
                          'Mỗi tách cà phê là một câu chuyện. Trải nghiệm của bạn với '),
                  TextSpan(
                      text: widget.cafeName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF553722))),
                  const TextSpan(text: ' thế nào?'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(
                  'https://images.unsplash.com/photo-1497935586351-b67a49e012bf?w=500&q=80',
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF6F3F0),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'PHA CHẾ TẠI',
                    style: TextStyle(
                      color: Color(0xFF6D5B4F),
                      fontSize: 12,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.cafeName,
                    style: const TextStyle(
                      color: Color(0xFF553722),
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Đánh giá trải nghiệm của bạn',
                    style: TextStyle(
                      color: Color(0xFF553722),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _rating = index + 1;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Icon(
                            index < _rating ? Icons.star : Icons.star_border,
                            color: const Color(0xFF553722),
                            size: 32,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Suy nghĩ của bạn',
              style: TextStyle(
                color: Color(0xFF553722),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 150,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFEBEBEB),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                controller: _reviewController,
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText:
                      'Mô tả hương vị, không gian hoặc cảm nhận của bạn...',
                  hintStyle: TextStyle(
                    color: const Color(0xFF6D5B4F).withValues(alpha: 0.5),
                    fontSize: 16,
                  ),
                ),
                style: const TextStyle(
                  color: Color(0xFF553722),
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildTagChip('Kết cấu mượt'),
                _buildTagChip('Hương hoa'),
                _buildTagChip('Phục vụ nhanh'),
              ],
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF553722),
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () async {
              final comment = _reviewController.text.trim();
              if (comment.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Vui lòng nhập nội dung đánh giá.')),
                );
                return;
              }

              try {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Đang gửi đánh giá...'),
                      duration: Duration(seconds: 1)),
                );

                final review = await ref.read(cafeRepositoryProvider).postReview(
                      widget.cafeId,
                      _rating.toDouble(),
                      comment,
                    );

                if (!mounted) return;

                Navigator.pop(context, review);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('Đánh giá của bạn đã được gửi thành công!')),
                );
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Gửi đánh giá thất bại: ${e.toString().replaceAll('Exception: ', '')}')),
                );
              }
            },
            icon: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
            label: const Text('Gửi đánh giá',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(currentIndex: 0, onTap: (index) {}),
    );
  }

  Widget _buildTagChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEFECE9),
        borderRadius: BorderRadius.circular(24),
        border:
            Border.all(color: const Color(0xFFD4C3BA).withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF553722),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
