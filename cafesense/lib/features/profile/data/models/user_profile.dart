class UserProfile {
  final String avatar;
  final String occupation;
  final String mainPurpose;
  final String companion;
  final String noiseLevel;
  final String wifiNeed;
  final List<String> amenities;
  final List<String> spaceStyle;
  final FlavorPreference flavorPreference;
  final List<String> valuePriorities;
  final String preferredLight;
  final String preferredMusic;
  final String preferredCafeSize;
  final String preferredCafeView;
  final List<String> preferredConcepts;

  const UserProfile({
    required this.avatar,
    required this.occupation,
    required this.mainPurpose,
    required this.companion,
    required this.noiseLevel,
    required this.wifiNeed,
    required this.amenities,
    required this.spaceStyle,
    required this.flavorPreference,
    required this.valuePriorities,
    required this.preferredLight,
    required this.preferredMusic,
    required this.preferredCafeSize,
    required this.preferredCafeView,
    required this.preferredConcepts,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      avatar: json['avatar'] as String? ?? '',
      occupation: json['occupation'] as String? ?? '',
      mainPurpose: json['mainPurpose'] as String? ?? '',
      companion: json['companion'] as String? ?? '',
      noiseLevel: json['noiseLevel'] as String? ?? '',
      wifiNeed: json['wifiNeed'] as String? ?? '',
      amenities: (json['amenities'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      spaceStyle: (json['spaceStyle'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      flavorPreference: json['flavorPreference'] != null
          ? FlavorPreference.fromJson(json['flavorPreference'] as Map<String, dynamic>)
          : const FlavorPreference.empty(),
      valuePriorities: (json['valuePriorities'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      preferredLight: json['preferredLight'] as String? ?? '',
      preferredMusic: json['preferredMusic'] as String? ?? '',
      preferredCafeSize: json['preferredCafeSize'] as String? ?? '',
      preferredCafeView: json['preferredCafeView'] as String? ?? '',
      preferredConcepts: (json['preferredConcepts'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'avatar': avatar,
      'occupation': occupation,
      'mainPurpose': mainPurpose,
      'companion': companion,
      'noiseLevel': noiseLevel,
      'wifiNeed': wifiNeed,
      'amenities': amenities,
      'spaceStyle': spaceStyle,
      'flavorPreference': flavorPreference.toJson(),
      'valuePriorities': valuePriorities,
      'preferredLight': preferredLight,
      'preferredMusic': preferredMusic,
      'preferredCafeSize': preferredCafeSize,
      'preferredCafeView': preferredCafeView,
      'preferredConcepts': preferredConcepts,
    };
  }

  UserProfile copyWith({
    String? avatar,
    String? occupation,
    String? mainPurpose,
    String? companion,
    String? noiseLevel,
    String? wifiNeed,
    List<String>? amenities,
    List<String>? spaceStyle,
    FlavorPreference? flavorPreference,
    List<String>? valuePriorities,
    String? preferredLight,
    String? preferredMusic,
    String? preferredCafeSize,
    String? preferredCafeView,
    List<String>? preferredConcepts,
  }) {
    return UserProfile(
      avatar: avatar ?? this.avatar,
      occupation: occupation ?? this.occupation,
      mainPurpose: mainPurpose ?? this.mainPurpose,
      companion: companion ?? this.companion,
      noiseLevel: noiseLevel ?? this.noiseLevel,
      wifiNeed: wifiNeed ?? this.wifiNeed,
      amenities: amenities ?? this.amenities,
      spaceStyle: spaceStyle ?? this.spaceStyle,
      flavorPreference: flavorPreference ?? this.flavorPreference,
      valuePriorities: valuePriorities ?? this.valuePriorities,
      preferredLight: preferredLight ?? this.preferredLight,
      preferredMusic: preferredMusic ?? this.preferredMusic,
      preferredCafeSize: preferredCafeSize ?? this.preferredCafeSize,
      preferredCafeView: preferredCafeView ?? this.preferredCafeView,
      preferredConcepts: preferredConcepts ?? this.preferredConcepts,
    );
  }
}

class FlavorPreference {
  final String roastLevel;
  final String acidity;
  final String body;
  final String sweetness;
  final String process;

  const FlavorPreference({
    required this.roastLevel,
    required this.acidity,
    required this.body,
    required this.sweetness,
    required this.process,
  });

  const FlavorPreference.empty()
      : roastLevel = '',
        acidity = '',
        body = '',
        sweetness = '',
        process = '';

  factory FlavorPreference.fromJson(Map<String, dynamic> json) {
    return FlavorPreference(
      roastLevel: json['roastLevel'] as String? ?? '',
      acidity: json['acidity'] as String? ?? '',
      body: json['body'] as String? ?? '',
      sweetness: json['sweetness'] as String? ?? '',
      process: json['process'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roastLevel': roastLevel,
      'acidity': acidity,
      'body': body,
      'sweetness': sweetness,
      'process': process,
    };
  }
}
