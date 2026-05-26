import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cafesense/core/network/api_client.dart';
import 'package:cafesense/features/cafe/data/models/cafe.dart';
import 'package:cafesense/features/profile/data/models/user_profile.dart';
import 'package:cafesense/features/cafe/data/cafe_seed_data.dart';

class CafeRepository {
  final ApiClient _apiClient;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CafeRepository(this._apiClient);

  Future<List<Cafe>> getCafes({double? lat, double? lng}) async {
    try {
      // Seed first if database is empty
      await seedCafesIfNeeded();

      final snapshot = await _firestore.collection('cafes').get();
      if (snapshot.docs.isEmpty) {
        return _getMockCafes(lat: lat, lng: lng);
      }
      return snapshot.docs.map((doc) => Cafe.fromJson(doc.data())).toList();
    } catch (e) {
      debugPrint('Error getting cafes from Firestore: $e');
      return _getMockCafes(lat: lat, lng: lng);
    }
  }

  Future<void> seedCafesIfNeeded() async {
    try {
      final snapshot = await _firestore.collection('cafes').limit(1).get();
      if (snapshot.docs.isEmpty) {
        debugPrint('Seeding cafes data to Firestore...');
        final batch = _firestore.batch();
        for (final data in cafeSeedData) {
          final docRef = _firestore.collection('cafes').doc(data['id']);
          batch.set(docRef, data);
        }
        await batch.commit();
        debugPrint('✅ Seeded 10 cafes to Firestore successfully!');
      }
    } catch (e) {
      debugPrint('❌ Error seeding cafes to Firestore: $e');
    }
  }

  List<Cafe> _getMockCafes({double? lat, double? lng}) {
    final double centerLat = lat ?? 10.774;
    final double centerLng = lng ?? 106.702;

    return [
      Cafe(
        id: 'sora_coffee',
        name: 'Sora Coffee',
        fullName: 'Sora Coffee -Ngã Ba, Nam Kỳ Khởi Nghĩa Huỳnh Lắm, Ngũ Hành Sơn',
        description: 'Quán nằm ở vị trí đắc địa ngã ba, không gian xanh mát mẻ, đồ uống đa dạng thích hợp cho các buổi hẹn hò hoặc thư giãn cùng bạn bè.',
        imageUrl: 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=500&q=80',
        latitude: centerLat,
        longitude: centerLng,
        priceLabel: '\$\$\$',
        tagline: 'Không gian xanh ngập tràn ánh sáng',
        spaceStyle: const ['Thiên nhiên', 'Ấm cúng'],
        amenities: const ['Máy lạnh', 'Không hút thuốc', 'Wifi mạnh', 'Chỗ để xe'],
        menu: const [
          MenuItem(name: 'Cà phê sữa đá', price: 29000, category: 'Coffee'),
          MenuItem(name: 'Trà đào cam sả', price: 35000, category: 'Tea'),
        ],
        reviews: const [],
        matchPercent: 95,
      ),
    ];
  }

  Future<List<Cafe>> getMatchedCafes({UserProfile? profile}) async {
    try {
      // Try to fetch profile from Firestore if not provided
      UserProfile? userProfile = profile;
      if (userProfile == null) {
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          final doc = await _firestore.collection('users').doc(currentUser.uid).get();
          if (doc.exists && doc.data() != null) {
            userProfile = UserProfile.fromJson(doc.data()!);
          }
        }
      }

      // Fetch all cafes
      final cafes = await getCafes();

      // Calculate match percentage client-side
      final matchedCafes = cafes.map((cafe) {
        final matchPercent = _calculateMatchPercent(userProfile, cafe);
        return Cafe(
          id: cafe.id,
          name: cafe.name,
          fullName: cafe.fullName,
          description: cafe.description,
          imageUrl: cafe.imageUrl,
          latitude: cafe.latitude,
          longitude: cafe.longitude,
          priceLabel: cafe.priceLabel,
          tagline: cafe.tagline,
          spaceStyle: cafe.spaceStyle,
          amenities: cafe.amenities,
          menu: cafe.menu,
          reviews: cafe.reviews,
          matchPercent: matchPercent,
          roastLevel: cafe.roastLevel,
          acidity: cafe.acidity,
          body: cafe.body,
          sweetness: cafe.sweetness,
          process: cafe.process,
        );
      }).toList();

      // Sort by match percentage descending
      matchedCafes.sort((a, b) => (b.matchPercent ?? 0).compareTo(a.matchPercent ?? 0));
      return matchedCafes;
    } catch (e) {
      debugPrint('Error calculating matched cafes: $e');
      throw Exception('Đã xảy ra lỗi khi tính toán so khớp: $e');
    }
  }

  Future<List<Cafe>> getAiMatchedCafes({
    required List<String> filters,
    required RangeValues priceRange,
  }) async {
    try {
      // 1. Fetch all cafes
      final cafes = await getCafes();

      // 2. Parse filter arguments
      final String priceTier = filters.isNotEmpty ? filters[0] : "Tầm trung";
      final String distance = filters.length > 1 ? filters[1] : "1 - 3 km";
      final String space = filters.length > 2 ? filters[2] : "Hiện đại";
      final List<String> amenities = filters.length > 3 ? filters.sublist(3) : const [];

      // 3. Define weights configuration
      final Map<String, Map<String, double>> weights = {
        "hoc tap": {
          "wifi": 0.30,
          "khong_gian": 0.25,
          "o_cam": 0.25,
          "gia_ca": 0.05,
          "ngon": 0.10,
          "view": 0.05
        },
        "lam viec": {
          "wifi": 0.30,
          "o_cam": 0.25,
          "khong_gian": 0.20,
          "gia_ca": 0.10,
          "ngon": 0.10,
          "view": 0.05
        },
        "thu gian": {
          "view": 0.30,
          "khong_gian": 0.25,
          "ngon": 0.20,
          "wifi": 0.10,
          "gia_ca": 0.10,
          "o_cam": 0.05
        },
        "gap ban be": {
          "khong_gian": 0.25,
          "ngon": 0.25,
          "view": 0.20,
          "wifi": 0.10,
          "gia_ca": 0.10,
          "o_cam": 0.10
        },
        "hen ho": {
          "view": 0.35,
          "khong_gian": 0.30,
          "ngon": 0.15,
          "gia_ca": 0.10,
          "wifi": 0.05,
          "o_cam": 0.05
        },
        "khac": {
          "wifi": 0.20,
          "khong_gian": 0.20,
          "o_cam": 0.15,
          "gia_ca": 0.15,
          "ngon": 0.15,
          "view": 0.15
        }
      };

      // 4. Map selected space style to weights purpose
      String purpose = "khac";
      if (space == "Yên tĩnh") {
        purpose = "lam viec";
      } else if (space == "Cổ điển") {
        purpose = "thu gian";
      } else if (space == "Sân vườn") {
        purpose = "thu gian";
      } else if (space == "Hiện đại") {
        purpose = "khac";
      }

      // 5. Construct user preference rating vector (1.0 to 5.0)
      final Map<String, double> userInput = {
        "wifi": amenities.contains("Wifi mạnh") ? 5.0 : 3.0,
        "khong_gian": space == "Yên tĩnh" ? 4.5 : 4.0,
        "o_cam": amenities.contains("Ổ cắm điện") ? 5.0 : 2.0,
        "gia_ca": priceTier == "Bình dân" ? 2.0 : (priceTier == "Cao cấp" ? 4.5 : 3.0),
        "ngon": 4.0,
        "view": space == "Sân vườn" ? 4.5 : (space == "Cổ điển" ? 4.0 : (space == "Hiện đại" ? 3.0 : 2.5)),
      };

      // Adjust space quality based on other features selected
      if (amenities.contains("Máy lạnh")) {
        userInput["khong_gian"] = (userInput["khong_gian"] ?? 4.0) + 0.25;
      }
      if (amenities.contains("Không hút thuốc")) {
        userInput["khong_gian"] = (userInput["khong_gian"] ?? 4.0) + 0.25;
      }
      userInput["khong_gian"] = userInput["khong_gian"]!.clamp(1.0, 5.0);

      final w = weights[purpose] ?? weights["khac"]!;
      final featuresList = ["wifi", "khong_gian", "o_cam", "gia_ca", "ngon", "view"];

      // 6. Calculate match score and filter cafes
      final List<Cafe> matchedResults = [];

      for (final cafe in cafes) {
        // Price filtering: only filter out cafes where the cheapest drink is more than the maximum budget
        if (cafe.menu.isNotEmpty) {
          final menuPricesK = cafe.menu.map((e) => e.price / 1000.0).toList();
          final double minMenuPrice = menuPricesK.reduce((a, b) => a < b ? a : b);

          if (minMenuPrice > priceRange.end) {
            continue;
          }
        } else {
          double minPrice = 15;
          if (cafe.priceLabel == '\$\$') {
            minPrice = 25;
          } else if (cafe.priceLabel == '\$\$\$') {
            minPrice = 45;
          }
          if (minPrice > priceRange.end) {
            continue;
          }
        }

        // Distance filtering (calculate from cafes cluster center: 15.9770, 108.2653)
        final double dLat = cafe.latitude - 15.9770;
        final double dLon = cafe.longitude - 108.2653;
        final double dist = math.sqrt(dLat * dLat + dLon * dLon) * 111.0;

        if (distance == "1 km" && dist > 1.5) {
          continue;
        } else if (distance == "1 - 3 km" && dist > 3.5) {
          continue;
        } else if (distance == "3 - 5 km" && dist > 5.5) {
          continue;
        }

        // Space Style filtering
        bool matchesSpace = false;
        if (space == "Hiện đại") {
          matchesSpace = cafe.spaceStyle.any((s) => s.toLowerCase().contains("hiện đại"));
        } else if (space == "Cổ điển") {
          matchesSpace = cafe.spaceStyle.any((s) => s.toLowerCase().contains("cổ điển"));
        } else if (space == "Sân vườn") {
          matchesSpace = cafe.spaceStyle.any((s) => s.toLowerCase().contains("sân vườn") || s.toLowerCase().contains("thiên nhiên"));
        } else if (space == "Yên tĩnh") {
          final desc = cafe.description.toLowerCase();
          final tag = cafe.tagline.toLowerCase();
          matchesSpace = desc.contains("yên tĩnh") ||
              tag.contains("yên tĩnh") ||
              cafe.spaceStyle.any((s) => s.toLowerCase().contains("yên tĩnh")) ||
              cafe.id == "sh_flow" ||
              cafe.id == "zone_six" ||
              cafe.id == "leo_coffee" ||
              cafe.id == "xeko_coffee";
        } else {
          matchesSpace = true;
        }
        if (!matchesSpace) {
          continue;
        }

        // Amenities filtering: must have ALL selected amenities
        if (amenities.isNotEmpty) {
          final bool hasAll = amenities.every((filter) {
            final String normFilter = filter.toLowerCase().trim();
            return cafe.amenities.any((a) => a.toLowerCase().contains(normFilter));
          });
          if (!hasAll) {
            continue;
          }
        }

        // Calculate Weighted Manhattan Distance
        double scoreSum = 0;
        double maxScoreSum = 0;

        final Map<String, double> cafeVector = {
          "wifi": cafe.wifiRating,
          "khong_gian": cafe.spaceRating,
          "o_cam": cafe.outletRating,
          "gia_ca": cafe.priceRating,
          "ngon": cafe.tasteRating,
          "view": cafe.viewRating,
        };

        for (final f in featuresList) {
          final double userVal = userInput[f] ?? 3.0;
          final double cafeVal = cafeVector[f] ?? 3.0;
          final double diff = (userVal - cafeVal).abs();
          final double weightVal = w[f] ?? 0.15;

          scoreSum += weightVal * diff;
          maxScoreSum += weightVal * 4.0;
        }

        final double matchScore = maxScoreSum > 0 ? (1.0 - (scoreSum / maxScoreSum)) : 0.0;
        final int matchPercent = (matchScore * 100).round().clamp(0, 100);

        matchedResults.add(
          Cafe(
            id: cafe.id,
            name: cafe.name,
            fullName: cafe.fullName,
            description: cafe.description,
            imageUrl: cafe.imageUrl,
            latitude: cafe.latitude,
            longitude: cafe.longitude,
            priceLabel: cafe.priceLabel,
            tagline: cafe.tagline,
            spaceStyle: cafe.spaceStyle,
            amenities: cafe.amenities,
            menu: cafe.menu,
            reviews: cafe.reviews,
            matchPercent: matchPercent,
            roastLevel: cafe.roastLevel,
            acidity: cafe.acidity,
            body: cafe.body,
            sweetness: cafe.sweetness,
            process: cafe.process,
            wifiRating: cafe.wifiRating,
            spaceRating: cafe.spaceRating,
            outletRating: cafe.outletRating,
            priceRating: cafe.priceRating,
            tasteRating: cafe.tasteRating,
            viewRating: cafe.viewRating,
          ),
        );
      }

      // Sort descending by matchPercent
      matchedResults.sort((a, b) => (b.matchPercent ?? 0).compareTo(a.matchPercent ?? 0));
      return matchedResults;
    } catch (e) {
      debugPrint('Error calculating matched cafes: $e');
      throw Exception('Đã xảy ra lỗi khi tìm kiếm bằng AI: $e');
    }
  }

  int _calculateMatchPercent(UserProfile? userProfile, Cafe cafe) {
    if (userProfile == null) return 100;

    double totalWeight = 0;
    double matchedWeight = 0;

    // 1. Space Styles Match (Weight = 3)
    if (userProfile.spaceStyle.isNotEmpty) {
      totalWeight += 3;
      final cafeStyles = cafe.spaceStyle.map((s) => s.trim().toLowerCase()).toList();
      final userStyles = userProfile.spaceStyle.map((s) => s.trim().toLowerCase()).toList();
      final overlaps = userStyles.where((s) => cafeStyles.contains(s)).toList();

      final styleScore = overlaps.length / userStyles.length;
      matchedWeight += styleScore * 3;
    }

    // 2. Amenities Match (Weight = 3)
    if (userProfile.amenities.isNotEmpty) {
      totalWeight += 3;
      final cafeAmenities = cafe.amenities.map((a) => a.trim().toLowerCase()).toList();
      final userAmenities = userProfile.amenities.map((a) => a.trim().toLowerCase()).toList();
      final overlaps = userAmenities.where((a) => cafeAmenities.contains(a)).toList();

      final amenityScore = overlaps.length / userAmenities.length;
      matchedWeight += amenityScore * 3;
    }

    // 3. Flavor Preference Match (Weight = 4)
    final fp = userProfile.flavorPreference;
    int flavorTotal = 0;
    int flavorMatched = 0;

    if (fp.roastLevel.trim().isNotEmpty) {
      flavorTotal++;
      if (fp.roastLevel.trim().toLowerCase() == cafe.roastLevel.trim().toLowerCase()) {
        flavorMatched++;
      }
    }
    if (fp.acidity.trim().isNotEmpty) {
      flavorTotal++;
      if (fp.acidity.trim().toLowerCase() == cafe.acidity.trim().toLowerCase()) {
        flavorMatched++;
      }
    }
    if (fp.body.trim().isNotEmpty) {
      flavorTotal++;
      if (fp.body.trim().toLowerCase() == cafe.body.trim().toLowerCase()) {
        flavorMatched++;
      }
    }
    if (fp.sweetness.trim().isNotEmpty) {
      flavorTotal++;
      if (fp.sweetness.trim().toLowerCase() == cafe.sweetness.trim().toLowerCase()) {
        flavorMatched++;
      }
    }
    if (fp.process.trim().isNotEmpty) {
      flavorTotal++;
      if (fp.process.trim().toLowerCase() == cafe.process.trim().toLowerCase()) {
        flavorMatched++;
      }
    }

    if (flavorTotal > 0) {
      totalWeight += 4;
      matchedWeight += (flavorMatched / flavorTotal) * 4;
    }

    // 4. Purpose Match (Weight = 2)
    if (userProfile.mainPurpose.trim().isNotEmpty) {
      totalWeight += 2;
      final purpose = userProfile.mainPurpose.toLowerCase();
      final tagline = cafe.tagline.toLowerCase();
      final description = cafe.description.toLowerCase();

      double purposeScore = 0.5;
      if (purpose.contains('học') || purpose.contains('làm việc') || purpose.contains('work')) {
        if (tagline.contains('work') || tagline.contains('focus') || description.contains('việc') || description.contains('tập trung')) {
          purposeScore = 1.0;
        } else {
          purposeScore = 0.4;
        }
      } else if (purpose.contains('thư giãn') || purpose.contains('đọc sách') || purpose.contains('relax')) {
        if (tagline.contains('focus') || description.contains('đọc sách') || description.contains('thư giãn') || description.contains('yên tĩnh')) {
          purposeScore = 1.0;
        } else {
          purposeScore = 0.5;
        }
      }
      matchedWeight += purposeScore * 2;
    }

    if (totalWeight == 0) return 90;

    final matchPercent = ((matchedWeight / totalWeight) * 100).round();
    return matchPercent.clamp(0, 100);
  }

  Future<Review> postReview(String cafeId, double rating, String comment) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      final String userName = currentUser?.displayName ?? currentUser?.email?.split('@').first ?? 'Bạn';
      final String userAvatar = '👤';

      final review = Review(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userName: userName,
        userAvatar: userAvatar,
        rating: rating,
        comment: comment,
        dateTime: DateTime.now(),
      );

      final docRef = _firestore.collection('cafes').doc(cafeId);
      await _firestore.runTransaction((transaction) async {
        final doc = await transaction.get(docRef);
        if (doc.exists) {
          final data = doc.data()!;
          final List<dynamic> oldReviews = data['reviews'] as List<dynamic>? ?? [];
          final newReviews = [review.toJson(), ...oldReviews];
          transaction.update(docRef, {'reviews': newReviews});
        }
      });

      return review;
    } catch (e) {
      debugPrint('Error posting review to Firestore: $e');
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
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await _firestore.collection('users').doc(currentUser.uid).set(profile.toJson());
        debugPrint('✅ Saved user profile to Firestore successfully!');
      } else {
        throw Exception('Người dùng chưa đăng nhập.');
      }
    } catch (e) {
      debugPrint('Error saving user profile to Firestore: $e');
      throw Exception('Đã xảy ra lỗi khi cập nhật hồ sơ: $e');
    }
  }
}

final cafeRepositoryProvider = Provider<CafeRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CafeRepository(apiClient);
});
