import 'package:flutter/material.dart';
import 'package:cafesense/features/cafe/data/models/cafe.dart';

class MenuTab extends StatelessWidget {
  final List<MenuItem> menu;

  const MenuTab({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 24, bottom: 80, left: 24, right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroHeader(),
          const SizedBox(height: 32),
          if (menu.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Text(
                  'Chưa có thực đơn cho quán này.',
                  style: TextStyle(color: Color(0xFF6D5B4F), fontSize: 16),
                ),
              ),
            )
          else
            ...menu.map((item) {
              Color chipColor = const Color(0xFFD4E9E2);
              if (item.category.toLowerCase() == 'cake') {
                chipColor = const Color(0xFFF2DDD1);
              } else if (item.category.toLowerCase() == 'tea') {
                chipColor = const Color(0xFFEAE8E5);
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: _buildMenuItem(
                  title: item.name,
                  price: '${item.price.toStringAsFixed(0)}đ',
                  description: 'Sản phẩm chất lượng cao phục vụ tại quán.',
                  chips: [item.category.toUpperCase()],
                  chipColor: chipColor,
                  imageUrl:
                      'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=500&q=80',
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildHeroHeader() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFF553722),
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: NetworkImage(
              'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=500&q=80'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  const Color(0xFF553722).withValues(alpha: 0.9),
                  const Color(0xFF553722).withValues(alpha: 0.1),
                ],
              ),
            ),
          ),
          Positioned(
            left: 24,
            bottom: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B565A),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('LỰA CHỌN ĐẶC SẮC',
                      style: TextStyle(
                          color: Colors.white, fontSize: 10, letterSpacing: 1)),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Nghi Thức Thủ Công',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required String price,
    required String description,
    required List<String> chips,
    required Color chipColor,
    required String imageUrl,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Image.network(
            imageUrl,
            height: 300,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF553722),
                  fontSize: 24,
                  fontFamily: 'Noto Serif',
                ),
              ),
            ),
            Text(
              price,
              style: const TextStyle(
                color: Color(0xFF6D5B4F),
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          description,
          style: TextStyle(
            color: const Color(0xFF553722).withValues(alpha: 0.8),
            fontSize: 14,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: chips
              .map((chip) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: chipColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        chip,
                        style: const TextStyle(
                          color: Color(0xFF2D4B54),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
