import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cafesense/core/network/api_client.dart';
import 'package:cafesense/features/cafe/data/models/cafe.dart';
import 'package:cafesense/features/profile/data/models/user_profile.dart';

class CafeRepository {
  final ApiClient _apiClient;

  CafeRepository(this._apiClient);

  Future<List<Cafe>> getCafes({double? lat, double? lng}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (lat != null && lng != null) {
        queryParams['lat'] = lat;
        queryParams['lng'] = lng;
      }
      final response = await _apiClient.dio.get(
        '/cafes',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );
      final List<dynamic> list = response.data as List<dynamic>;
      return list.map((e) => Cafe.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      // Fallback to mock data when API fails or is not available
      return _getMockCafes(lat: lat, lng: lng);
    }
  }

  List<Cafe> _getMockCafes({double? lat, double? lng}) {
    // Tọa độ trung tâm (mặc định nếu không có GPS)
    final double centerLat = lat ?? 10.774;
    final double centerLng = lng ?? 106.702;

    return [
      Cafe(
        id: '1',
        name: 'The Workshop Coffee',
        description: 'Quán cafe specialty yên tĩnh, thích hợp làm việc và gặp gỡ.',
        imageUrl: 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=500&q=80',
        latitude: centerLat,
        longitude: centerLng,
        priceLabel: '\$\$',
        tagline: 'Specialty Coffee & Roastery',
        spaceStyle: ['Minimalist', 'Quiet', 'Workspace'],
        amenities: ['Wifi', 'Parking', 'Air Conditioning'],
        menu: const [
          MenuItem(name: 'Pour Over', price: 65000, category: 'Coffee'),
          MenuItem(name: 'Latte Art', price: 60000, category: 'Coffee'),
          MenuItem(name: 'Matcha Cake', price: 45000, category: 'Cake'),
          MenuItem(name: 'Peach Tea', price: 55000, category: 'Tea'),
        ],
        reviews: [
          Review(
            id: 'r1',
            userName: 'Hoang Nam',
            userAvatar: '👨',
            rating: 5.0,
            comment: 'Quán cafe yên tĩnh, cà phê Pour Over rất tuyệt vời!',
            dateTime: DateTime.now().subtract(const Duration(days: 2)),
          ),
          Review(
            id: 'r2',
            userName: 'Thu Ha',
            userAvatar: '👩',
            rating: 4.0,
            comment: 'Không gian đẹp nhưng cuối tuần hơi đông.',
            dateTime: DateTime.now().subtract(const Duration(days: 5)),
          ),
        ],
        matchPercent: 95,
      ),
      Cafe(
        id: '2',
        name: 'Okkio Caffe',
        description: 'Không không gian ấm cúng mang phong cách retro giữa lòng thành phố.',
        imageUrl: 'https://images.unsplash.com/photo-1497935586351-b67a49e012bf?w=500&q=80',
        latitude: centerLat + 0.01,
        longitude: centerLng + 0.01,
        priceLabel: '\$\$',
        tagline: 'Retro Vibe & Cold Brew',
        spaceStyle: ['Retro', 'Cozy', 'Vintage'],
        amenities: ['Wifi', 'Air Conditioning'],
        menu: const [],
        reviews: const [],
        matchPercent: 88,
      ),
      Cafe(
        id: '3',
        name: 'Rang Rang Coffee',
        description: 'Quán rộng rãi, thiết kế hiện đại, phù hợp đi nhóm.',
        imageUrl: 'https://images.unsplash.com/photo-1559525839-b184a4d698c7?w=500&q=80',
        latitude: centerLat - 0.01,
        longitude: centerLng + 0.02,
        priceLabel: '\$',
        tagline: 'Modern & Social',
        spaceStyle: ['Modern', 'Spacious', 'Social'],
        amenities: ['Wifi', 'Parking', 'Air Conditioning', 'Smoking Area'],
        menu: const [],
        reviews: const [],
        matchPercent: 80,
      ),
      Cafe(
        id: '4',
        name: 'Bosgaurus Coffee',
        description: 'Trải nghiệm cà phê nghệ thuật với tầm nhìn đẹp.',
        imageUrl: 'https://images.unsplash.com/photo-1511920170033-f8396924c348?w=500&q=80',
        latitude: centerLat + 0.02,
        longitude: centerLng - 0.01,
        priceLabel: '\$\$\$',
        tagline: 'Artisan Coffee Roasters',
        spaceStyle: ['Elegant', 'Scenic', 'Artisan'],
        amenities: ['Wifi', 'Parking', 'Air Conditioning'],
        menu: const [],
        reviews: const [],
        matchPercent: 75,
      ),
    ];
  }

  Future<List<Cafe>> getMatchedCafes({UserProfile? profile}) async {
    try {
      final response = await _apiClient.dio.post(
        '/match',
        data: profile?.toJson(),
      );
      final List<dynamic> list = response.data as List<dynamic>;
      return list.map((e) => Cafe.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      final dynamic errorMessage = e.response?.data?['error'] ?? 'Đã xảy ra lỗi khi tính toán so khớp';
      throw Exception(errorMessage.toString());
    }
  }

  Future<Review> postReview(String cafeId, double rating, String comment) async {
    try {
      final response = await _apiClient.dio.post(
        '/cafes/$cafeId/reviews',
        data: {
          'rating': rating,
          'comment': comment,
        },
      );
      return Review.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      // Fake successful response
      await Future.delayed(const Duration(milliseconds: 500));
      return Review(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userName: 'Bạn',
        userAvatar: '👤',
        rating: rating,
        comment: comment,
        dateTime: DateTime.now(),
      );
    }
  }

  Future<void> saveUserProfile(UserProfile profile) async {
    try {
      await _apiClient.dio.post(
        '/profile',
        data: profile.toJson(),
      );
    } on DioException catch (e) {
      final dynamic errorMessage = e.response?.data?['error'] ?? 'Đã xảy ra lỗi khi cập nhật hồ sơ';
      throw Exception(errorMessage.toString());
    }
  }
}

final cafeRepositoryProvider = Provider<CafeRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CafeRepository(apiClient);
});
