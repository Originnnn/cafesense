import 'package:flutter/material.dart';
import 'package:cafesense/features/cafe/data/models/cafe.dart';
import 'write_review_screen.dart';

class ReviewsTab extends StatelessWidget {
  final List<Review> reviews;
  final String cafeId;
  final String cafeName;

  const ReviewsTab({
    super.key,
    required this.reviews,
    required this.cafeId,
    required this.cafeName,
  });

  @override
  Widget build(BuildContext context) {
    double averageRating = 5.0;
    if (reviews.isNotEmpty) {
      double sum = reviews.fold(0.0, (prev, element) => prev + element.rating);
      averageRating = sum / reviews.length;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 24, bottom: 100, left: 24, right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRatingCard(averageRating),
          const SizedBox(height: 48),
          const Text(
            'Nhật ký khách hàng',
            style: TextStyle(
              color: Color(0xFF553722),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          if (reviews.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Text(
                  'Chưa có đánh giá nào cho quán này. Hãy là người đầu tiên chia sẻ cảm nhận!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF6D5B4F), fontSize: 16),
                ),
              ),
            )
          else
            ...reviews.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Column(
                  children: [
                    _buildReviewerInfoRow(
                      name: item.userName,
                      title:
                          'KHÁCH HÀNG THÂN THIẾT • ${item.dateTime.day}/${item.dateTime.month}/${item.dateTime.year}',
                      userAvatar: item.userAvatar,
                      rating: item.rating.round(),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Text(
                        item.comment,
                        style: const TextStyle(
                          color: Color(0xFF553722),
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF553722),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WriteReviewScreen(
                      cafeId: cafeId,
                      cafeName: cafeName,
                    ),
                  ),
                );
              },
              child: const Text('Chia sẻ cảm nhận',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingCard(double rating) {
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
            'Cảm nhận khách\nhàng',
            style: TextStyle(
              color: Color(0xFF553722),
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Dựa trên ${reviews.length} trải nghiệm được chọn lọc',
            style: const TextStyle(color: Color(0xFF6D5B4F), fontSize: 14),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                rating.toStringAsFixed(1),
                style: const TextStyle(
                  color: Color(0xFF553722),
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      if (index < rating.floor()) {
                        return const Icon(Icons.star,
                            color: Color(0xFF553722), size: 20);
                      } else if (index < rating && rating % 1 != 0) {
                        return const Icon(Icons.star_half,
                            color: Color(0xFF553722), size: 20);
                      } else {
                        return const Icon(Icons.star_border,
                            color: Color(0xFF553722), size: 20);
                      }
                    }),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildWhiteChip('KHÔNG GIAN YÊN TĨNH'),
              _buildWhiteChip('HẠT RANG THỦ CÔNG'),
              _buildWhiteChip('HƯƠNG GỖ SỒI'),
              _buildWhiteChip('BARISTA CHUYÊN NGHIỆP'),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildWhiteChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF553722),
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildReviewerInfoRow({
    required String name,
    required String title,
    required String userAvatar,
    required int rating,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: const Color(0xFFEAE8E5),
          child: Text(
            userAvatar.isNotEmpty ? userAvatar : '🧑',
            style: const TextStyle(fontSize: 20),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Color(0xFF553722),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                    color: Color(0xFF6D5B4F),
                    fontSize: 10,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Row(
          children: List.generate(
              5,
              (index) => Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: const Color(0xFFC4B8AD),
                    size: 14,
                  )),
        ),
      ],
    );
  }
}
