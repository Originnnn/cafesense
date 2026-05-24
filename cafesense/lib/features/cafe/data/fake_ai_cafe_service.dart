import "package:flutter/material.dart";

class CafeSearchResult {
  const CafeSearchResult({
    required this.name,
    required this.description,
    required this.priceLabel,
    required this.distanceLabel,
    required this.matchPercent,
    required this.imageUrl,
    required this.tagline,
    required this.amenities,
  });

  final String name;
  final String description;
  final String priceLabel;
  final String distanceLabel;
  final int matchPercent;
  final String imageUrl;
  final String tagline;
  final List<String> amenities;
}

class FakeAiCafeService {
  static int previewResultCount({
    required List<String> filters,
    required RangeValues priceRange,
  }) {
    return _shouldReturnEmpty(filters: filters, priceRange: priceRange)
        ? 0
        : _mockResults.length;
  }

  static Future<List<CafeSearchResult>> searchCafes({
    required List<String> filters,
    required RangeValues priceRange,
  }) async {
    await Future.delayed(const Duration(milliseconds: 2200));

    if (_shouldReturnEmpty(filters: filters, priceRange: priceRange)) {
      return const <CafeSearchResult>[];
    }

    return _mockResults;
  }

  static bool _shouldReturnEmpty({
    required List<String> filters,
    required RangeValues priceRange,
  }) {
    final int span = (priceRange.end - priceRange.start).round();
    return filters.length >= 5 && span < 25;
  }

  static const List<CafeSearchResult> _mockResults = <CafeSearchResult>[
    CafeSearchResult(
        name: "The Gilded Bean",
        description: "Một nơi trú ẩn cho công việc tập trung với cà phê rang tại nhà và khu vực yên tĩnh.",
        priceLabel: "\$\$",
        distanceLabel: "0.6 miles away",
        matchPercent: 98,
        imageUrl: "https://images.unsplash.com/photo-1497935586351-b67a49e012bf?w=1000&q=80",
        tagline: "Best for: Deep Work",
        amenities: <String>["wifi", "silent", "plug"],
      ),
    CafeSearchResult(
        name: "Velvet Roast",
        description: "Không gian mềm ánh sáng, hợp cho đọc sách và trò chuyện nhẹ.",
        priceLabel: "\$\$",
        distanceLabel: "0.4 miles away",
        matchPercent: 94,
        imageUrl: "https://images.unsplash.com/photo-1541167760496-1628856ab772?w=1000&q=80",
        tagline: "Best for: Soft Focus",
        amenities: <String>["wifi", "plug", "coffee"],
      ),
    CafeSearchResult(
        name: "Obsidian Brew",
        description: "Concept tối giản, roast đậm, có nhiều bàn nhỏ cho làm việc 1-1.",
        priceLabel: "\$\$\$",
        distanceLabel: "1.2 miles away",
        matchPercent: 91,
        imageUrl: "https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=1000&q=80",
        tagline: "Best for: Espresso Lovers",
        amenities: <String>["silent", "non_smoke", "power"],
      ),
    CafeSearchResult(
        name: "Flora & Foam",
        description: "Nhiều cây xanh, ánh sáng tự nhiên, hợp brainstorming sáng tạo.",
        priceLabel: "\$\$",
        distanceLabel: "1.8 miles away",
        matchPercent: 89,
        imageUrl: "https://images.unsplash.com/photo-1525648199074-cee30ba79a4a?w=1000&q=80",
        tagline: "Best for: Creative Brainstorming",
        amenities: <String>["wifi", "garden", "coffee"],
      ),
  ];
}
