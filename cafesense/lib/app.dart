import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'core/providers/theme_provider.dart';

import 'core/routes/app_routes.dart';
import 'features/home/presentation/home_page.dart';
import 'features/onboarding/presentation/amenities_screen.dart';
import 'features/onboarding/presentation/avatar_picker_screen.dart';
import 'features/onboarding/presentation/cafe_size_screen.dart';
import 'features/onboarding/presentation/cafe_view_screen.dart';
import 'features/onboarding/presentation/companion_screen.dart';
import 'features/onboarding/presentation/concept_screen.dart';
import 'features/onboarding/presentation/light_music_screen.dart';
import 'features/onboarding/presentation/main_purpose_screen.dart';
import 'features/onboarding/presentation/occupation_screen.dart';
import 'features/onboarding/presentation/space_style_screen.dart';
import 'features/onboarding/presentation/success_screen.dart';
import 'features/onboarding/presentation/value_priority_screen.dart';
import 'features/onboarding/presentation/wifi_noise_screen.dart';
import 'features/splash/presentation/cafe_sense_splash_page.dart';
import 'features/profile/presentation/edit_profile_screen.dart';
import 'core/theme/app_theme.dart';

class CafeSenseApp extends ConsumerWidget {
  const CafeSenseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'CafeSense',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const CafeSenseSplashPage(),
      routes: {
        AppRoutes.avatarPicker: (BuildContext context) => const AvatarPickerScreen(),
        AppRoutes.occupation: (BuildContext context) => const OccupationScreen(),
        AppRoutes.mainPurpose: (BuildContext context) => const MainPurposeScreen(),
        AppRoutes.companion: (BuildContext context) => const CompanionScreen(),
        AppRoutes.wifiNoise: (BuildContext context) => const WifiNoiseScreen(),
        AppRoutes.amenities: (BuildContext context) => const AmenitiesScreen(),
        AppRoutes.valuePriority: (BuildContext context) => const ValuePriorityScreen(),
        AppRoutes.spaceStyle: (BuildContext context) => const SpaceStyleScreen(),
        AppRoutes.lightMusic: (BuildContext context) => const LightMusicScreen(),
        AppRoutes.cafeSize: (BuildContext context) => const CafeSizeScreen(),
        AppRoutes.cafeView: (BuildContext context) => const CafeViewScreen(),
        AppRoutes.concept: (BuildContext context) => const ConceptScreen(),
        AppRoutes.success: (BuildContext context) => const SuccessScreen(),
        AppRoutes.mainApp: (BuildContext context) => const HomePage(),
        AppRoutes.editProfile: (BuildContext context) => const EditProfileScreen(),
      },
    );
  }
}
