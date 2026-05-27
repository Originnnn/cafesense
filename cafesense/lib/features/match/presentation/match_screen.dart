import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cafesense/features/match/presentation/match_animation_screen.dart';
import 'package:cafesense/features/cafe/presentation/cafe_detail_screen.dart';
import 'package:cafesense/features/cafe/presentation/filter_screen.dart';
import 'package:cafesense/features/cafe/data/repositories/cafe_repository.dart';
import 'package:cafesense/features/cafe/data/models/cafe.dart';

class MatchScreen extends ConsumerStatefulWidget {
  const MatchScreen({super.key});

  @override
  ConsumerState<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends ConsumerState<MatchScreen> {
  late Future<List<Cafe>> _matchedCafesFuture;

  @override
  void initState() {
    super.initState();
    _matchedCafesFuture = ref.read(cafeRepositoryProvider).getMatchedCafes();
  }

  void _refreshMatches() {
    setState(() {
      _matchedCafesFuture = ref.read(cafeRepositoryProvider).getMatchedCafes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder<List<Cafe>>(
          future: _matchedCafesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF553722)),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        'Đã xảy ra lỗi: ${snapshot.error.toString().replaceAll('Exception: ', '')}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Color(0xFF553722), fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _refreshMatches,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF553722)),
                        child: const Text('Thử lại',
                            style: TextStyle(color: Colors.white)),
                      )
                    ],
                  ),
                ),
              );
            }

            final List<Cafe> cafes = snapshot.data ?? [];
            if (cafes.isEmpty) {
              return const Center(
                child: Text(
                    'Không tìm thấy gợi ý nào. Hãy thử cập nhật hồ sơ khảo sát!'),
              );
            }

            final Cafe topMatch = cafes[0];
            final Cafe? secondMatch = cafes.length > 1 ? cafes[1] : null;
            final List<Cafe> similarCafes = cafes.skip(2).toList();

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 88, bottom: 120, left: 24, right: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'LỰA CHỌN TINH TUYỂN',
                      style: TextStyle(
                        color: Color(0xFF6D5B4F),
                        fontSize: 12,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Gợi ý mỗi\nngày',
                      style: TextStyle(
                        color: Color(0xFF553722),
                        fontSize: 48,
                        fontFamily: 'Noto Serif',
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'AI của chúng tôi đã phân tích khẩu vị của bạn để tìm ra những điểm đến lý tưởng nhất.',
                      style: TextStyle(
                        color: const Color(0xFF6D5B4F).withValues(alpha: 0.8),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Top Match Card
                    _buildTopMatchCard(context, topMatch),
                    const SizedBox(height: 24),

                    // Second Match Card
                    if (secondMatch != null) ...[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CafeDetailScreen(cafe: secondMatch)),
                          );
                        },
                        child: _buildSecondMatchCard(secondMatch),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Update profile prompt card
                    GestureDetector(
                      onTap: () {
                        // Navigate to onboarding to reset/update survey
                        // But since we want to just prompt, we keep it visual
                      },
                      child: _buildUpdateProfileCard(),
                    ),
                    const SizedBox(height: 48),

                    // Similar places section
                    if (similarCafes.isNotEmpty) ...[
                      const Text(
                        'Khám phá các\nquán tương tự',
                        style: TextStyle(
                          color: Color(0xFF553722),
                          fontSize: 32,
                          fontFamily: 'Noto Serif',
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ...similarCafes.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CafeDetailScreen(cafe: item)),
                              );
                            },
                            child: _buildSimilarCard(
                              title: item.name,
                              subtitle:
                                  '${item.spaceStyle.first.toUpperCase()} • ${item.priceLabel} • 0.5 KM',
                              matchScore: '${item.matchPercent ?? 80}%',
                              imageUrl: item.imageUrl,
                            ),
                          ),
                        );
                      }),
                    ]
                  ],
                ),
              ),
            );
          },
        ),

        // Translucent App Bar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                height: 68 + MediaQuery.of(context).padding.top,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 10,
                  left: 24,
                  right: 24,
                  bottom: 10,
                ),
                color: const Color(0xFFFCF9F6).withValues(alpha: 0.8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FilterScreen()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: const Icon(Icons.tune, color: Color(0xFF553722)),
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'CafeSense',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF553722),
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const CircleAvatar(
                      radius: 16,
                      backgroundColor: Color(0xFFEAE8E5),
                      backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&q=80'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopMatchCard(BuildContext context, Cafe cafe) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MatchAnimationScreen(cafe: cafe),
          ),
        );
      },
      child: Container(
        height: 280,
        decoration: BoxDecoration(
          color: const Color(0xFF553722),
          borderRadius: BorderRadius.circular(24),
          image: DecorationImage(
            image: NetworkImage(cafe.imageUrl.isNotEmpty
                ? cafe.imageUrl
                : 'https://images.unsplash.com/photo-1511920170033-f8396924c348?w=500&q=80'),
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
                    const Color(0xFF553722).withValues(alpha: 0.2),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B2414),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${cafe.matchPercent ?? 100}% Phù hợp',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Text(
                        'LỰA CHỌN CỦA BTV',
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                            letterSpacing: 1),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (cafe.spaceStyle.isNotEmpty)
                            _buildGlassChip(
                                cafe.spaceStyle.first.toUpperCase()),
                          const SizedBox(width: 8),
                          if (cafe.spaceStyle.length > 1)
                            _buildGlassChip(cafe.spaceStyle[1].toUpperCase()),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (cafe.amenities.isNotEmpty)
                        _buildGlassChip(cafe.amenities.first.toUpperCase()),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassChip(String text) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          color: Colors.white.withValues(alpha: 0.2),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondMatchCard(Cafe cafe) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFEBE6DF),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${cafe.matchPercent ?? 90}%',
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF553722)),
              ),
              const Icon(Icons.auto_awesome, color: Color(0xFF553722)),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            cafe.name,
            style: const TextStyle(
              fontSize: 24,
              color: Color(0xFF553722),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            cafe.description,
            style: TextStyle(
              color: const Color(0xFF553722).withValues(alpha: 0.8),
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              cafe.imageUrl.isNotEmpty
                  ? cafe.imageUrl
                  : 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=500&q=80',
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateProfileCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF2DDD1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFF553722),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.coffee, color: Colors.white, size: 20),
          ),
          const SizedBox(height: 16),
          const Text(
            'Phát hiện hương vị mới',
            style: TextStyle(
              color: Color(0xFF553722),
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'CẬP NHẬT HỒ SƠ ĐỂ NHẬN GỢI Ý TỐT HƠN',
            style: TextStyle(
              color: Color(0xFF6D5B4F),
              fontSize: 10,
              letterSpacing: 1,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarCard({
    required String title,
    required String subtitle,
    required String matchScore,
    required String imageUrl,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(
                  imageUrl.isNotEmpty
                      ? imageUrl
                      : 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=500&q=80',
                  height: 280,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    matchScore,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF553722),
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF6D5B4F),
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
