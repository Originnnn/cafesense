import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cafesense/features/profile/data/models/user_profile.dart';

class OnboardingNotifier extends StateNotifier<UserProfile> {
  OnboardingNotifier()
      : super(const UserProfile(
          avatar: '',
          occupation: '',
          mainPurpose: '',
          companion: '',
          noiseLevel: '',
          wifiNeed: '',
          amenities: [],
          spaceStyle: [],
          flavorPreference: FlavorPreference.empty(),
          valuePriorities: [],
          preferredLight: '',
          preferredMusic: '',
          preferredCafeSize: '',
          preferredCafeView: '',
          preferredConcepts: [],
        ));

  void updateAvatar(String avatar) {
    state = state.copyWith(avatar: avatar);
  }

  void updateOccupation(String occupation) {
    state = state.copyWith(occupation: occupation);
  }

  void updateMainPurpose(String mainPurpose) {
    state = state.copyWith(mainPurpose: mainPurpose);
  }

  void updateCompanion(String companion) {
    state = state.copyWith(companion: companion);
  }

  void updateWifiNoise({required String wifiNeed, required String noiseLevel}) {
    state = state.copyWith(wifiNeed: wifiNeed, noiseLevel: noiseLevel);
  }

  void updateAmenities(List<String> amenities) {
    state = state.copyWith(amenities: amenities);
  }

  void updateSpaceStyle(List<String> spaceStyle) {
    state = state.copyWith(spaceStyle: spaceStyle);
  }

  void updateFlavorPreference(FlavorPreference flavor) {
    state = state.copyWith(flavorPreference: flavor);
  }

  void updateValuePriorities(List<String> priorities) {
    state = state.copyWith(valuePriorities: priorities);
  }

  void updateLightMusic({required String light, required String music}) {
    state = state.copyWith(preferredLight: light, preferredMusic: music);
  }

  void updateCafeSize(String size) {
    state = state.copyWith(preferredCafeSize: size);
  }

  void updateCafeView(String view) {
    state = state.copyWith(preferredCafeView: view);
  }

  void updatePreferredConcepts(List<String> concepts) {
    state = state.copyWith(preferredConcepts: concepts);
  }

  void reset() {
    state = const UserProfile(
      avatar: '',
      occupation: '',
      mainPurpose: '',
      companion: '',
      noiseLevel: '',
      wifiNeed: '',
      amenities: [],
      spaceStyle: [],
      flavorPreference: FlavorPreference.empty(),
      valuePriorities: [],
      preferredLight: '',
      preferredMusic: '',
      preferredCafeSize: '',
      preferredCafeView: '',
      preferredConcepts: [],
    );
  }
}

final onboardingProvider = StateNotifierProvider<OnboardingNotifier, UserProfile>((ref) {
  return OnboardingNotifier();
});
