class Cafe {
  final String id;
  final String name;
  final String fullName;
  final String description;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final String priceLabel;
  final String tagline;
  final List<String> spaceStyle;
  final List<String> amenities;
  final List<MenuItem> menu;
  final List<Review> reviews;
  final int? matchPercent;
  final String roastLevel;
  final String acidity;
  final String body;
  final String sweetness;
  final String process;
  final String panoramaUrl;

  // Rating fields for AI recommendation
  final double wifiRating;
  final double spaceRating;
  final double outletRating;
  final double priceRating;
  final double tasteRating;
  final double viewRating;

  const Cafe({
    required this.id,
    required this.name,
    this.fullName = '',
    required this.description,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.priceLabel,
    required this.tagline,
    required this.spaceStyle,
    required this.amenities,
    required this.menu,
    required this.reviews,
    this.matchPercent,
    this.roastLevel = '',
    this.acidity = '',
    this.body = '',
    this.sweetness = '',
    this.process = '',
    this.wifiRating = 0.0,
    this.spaceRating = 0.0,
    this.outletRating = 0.0,
    this.priceRating = 0.0,
    this.tasteRating = 0.0,
    this.viewRating = 0.0,
    this.panoramaUrl = '',
  });

  factory Cafe.fromJson(Map<String, dynamic> json) {
    return Cafe(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      fullName: json['fullName'] as String? ?? json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      priceLabel: json['priceLabel'] as String? ?? '',
      tagline: json['tagline'] as String? ?? '',
      spaceStyle: (json['spaceStyle'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      amenities: (json['amenities'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      menu: (json['menu'] as List<dynamic>?)
              ?.map((e) => MenuItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      reviews: (json['reviews'] as List<dynamic>?)
              ?.map((e) => Review.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      matchPercent: json['matchPercent'] as int?,
      roastLevel: json['roastLevel'] as String? ?? '',
      acidity: json['acidity'] as String? ?? '',
      body: json['body'] as String? ?? '',
      sweetness: json['sweetness'] as String? ?? '',
      process: json['process'] as String? ?? '',
      wifiRating: (json['wifiRating'] as num?)?.toDouble() ?? 0.0,
      spaceRating: (json['spaceRating'] as num?)?.toDouble() ?? 0.0,
      outletRating: (json['outletRating'] as num?)?.toDouble() ?? 0.0,
      priceRating: (json['priceRating'] as num?)?.toDouble() ?? 0.0,
      tasteRating: (json['tasteRating'] as num?)?.toDouble() ?? 0.0,
      viewRating: (json['viewRating'] as num?)?.toDouble() ?? 0.0,
      panoramaUrl: json['panoramaUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'fullName': fullName,
      'description': description,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'priceLabel': priceLabel,
      'tagline': tagline,
      'spaceStyle': spaceStyle,
      'amenities': amenities,
      'menu': menu.map((e) => e.toJson()).toList(),
      'reviews': reviews.map((e) => e.toJson()).toList(),
      'matchPercent': matchPercent,
      'roastLevel': roastLevel,
      'acidity': acidity,
      'body': body,
      'sweetness': sweetness,
      'process': process,
      'wifiRating': wifiRating,
      'spaceRating': spaceRating,
      'outletRating': outletRating,
      'priceRating': priceRating,
      'tasteRating': tasteRating,
      'viewRating': viewRating,
      'panoramaUrl': panoramaUrl,
    };
  }
}

class MenuItem {
  final String name;
  final double price;
  final String category;
  final String imageUrl;

  const MenuItem({
    required this.name,
    required this.price,
    required this.category,
    this.imageUrl = '',
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      name: json['name'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
    };
  }
}

class Review {
  final String id;
  final String userName;
  final String userAvatar;
  final double rating;
  final String comment;
  final DateTime dateTime;

  const Review({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.comment,
    required this.dateTime,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      userAvatar: json['userAvatar'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      comment: json['comment'] as String? ?? '',
      dateTime: json['dateTime'] != null
          ? DateTime.parse(json['dateTime'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'userAvatar': userAvatar,
      'rating': rating,
      'comment': comment,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}
