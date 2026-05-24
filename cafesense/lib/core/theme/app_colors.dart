import 'package:flutter/material.dart';

/// Unified color palette for CafeSense app
/// Combines cafesense_app comprehensive colors with lib_part1 Material3 standard colors
abstract final class AppColors {
  // ============ PRIMARY COLORS (from cafesense_app) ============
  static const Color primary = Color(0xFF4E2A0E);
  static const Color primaryLight = Color(0xFF7B4F2E);

  // ============ ACCENT & SECONDARY (from cafesense_app) ============
  static const Color accent = Color(0xFFD4A96A);
  static const Color accentLight = Color(0xFFE8C99A);

  // ============ BACKGROUNDS & SURFACES (merged) ============
  static const Color background = Color(0xFFF5EFE6);
  static const Color backgroundLight = Color(0xFFFAF7F2);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceWarm = Color(0xFFF2EAD9);

  // ============ MATERIAL3 SURFACE CONTAINERS (from lib_part1) ============
  static const Color surfaceVariant = Color(0xFFE5E2DF);
  static const Color surfaceContainerLowest = Colors.white;
  static const Color surfaceContainerLow = Color(0xFFF6F3F0);
  static const Color surfaceContainer = Color(0xFFF0EDEA);
  static const Color surfaceContainerHigh = Color(0xFFEAE8E5);
  static const Color surfaceContainerHighest = Color(0xFFE5E2DF);

  // ============ TAGS & SELECTION (from cafesense_app) ============
  static const Color tagBg = Color(0xFFF0E6D3);
  static const Color tagText = Color(0xFF6B4C2A);
  static const Color tagSelected = Color(0xFF4E2A0E);
  static const Color tagSelectedText = Color(0xFFFFFFFF);
  static const Color selectedBorder = Color(0xFF4E2A0E);
  static const Color unselectedBorder = Color(0xFFE0D0BC);

  // ============ TEXT COLORS (from cafesense_app) ============
  static const Color textPrimary = Color(0xFF2C1810);
  static const Color textSecondary = Color(0xFF8B6A4E);
  static const Color textHint = Color(0xFFB8956A);
  static const Color textLight = Color(0xFFD4B896);

  // ============ MATERIAL3 TEXT COLORS (from lib_part1) ============
  static const Color onPrimary = Colors.white;
  static const Color onSurface = Color(0xFF1C1C1A);
  static const Color onSurfaceVariant = Color(0xFF50453E);
  static const Color onBackground = Color(0xFF1C1C1A);

  // ============ PROGRESS & STATUS (from cafesense_app) ============
  static const Color progressBg = Color(0xFFE8D5B8);
  static const Color progressFill = Color(0xFF4E2A0E);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA500);
  static const Color error = Color(0xFFE53935);

  // ============ BUTTON COLORS (from cafesense_app) ============
  static const Color buttonPrimary = Color(0xFF4E2A0E);
  static const Color buttonText = Color(0xFFFFFFFF);
  static const Color buttonDisabled = Color(0xFFCCBBA8);

  // ============ AVATAR COLORS (from cafesense_app) ============
  static const Color avatarPink = Color(0xFFFFC0CB);
  static const Color avatarBlue = Color(0xFFB3D9F2);
  static const Color avatarGreen = Color(0xFFB8E6B8);
  static const Color avatarYellow = Color(0xFFFFF3A3);
  static const Color avatarPurple = Color(0xFFD4B8E6);
  static const Color avatarOrange = Color(0xFFFFD4A3);
  static const Color avatarBeige = Color(0xFFE8D5C4);
  static const Color avatarMint = Color(0xFFB8E6D4);

  // ============ DARK MODE COLORS (from cafesense_app) ============
  static const Color darkBg = Color(0xFF1A0F05);
  static const Color darkSurface = Color(0xFF2C1A0A);
  static const Color darkCard = Color(0xFF3D2610);

  // ============ ADDITIONAL (from cafesense_app) ============
  static const Color cardBeige = Color(0xFFF5ECD8);
  static const Color borderLight = Color(0xFFE8D5B8);

  // ============ ALIASES FOR MATERIAL3 COMPONENTS (from lib_part1) ============
  // These are mapping from lib_part1's Material3 colors for compatibility
  static const Color primaryContainer = Color(0xFF6F4E37);
  static const Color primaryFixed = Color(0xFFFFDCC6);
  static const Color primaryFixedDim = Color(0xFFEABDA0);
  static const Color secondary = Color(0xFF695D46);
  static const Color secondaryContainer = Color(0xFFEFDEC0);
  static const Color tertiary = Color(0xFF364224);
  static const Color tertiaryFixed = Color(0xFFDAE8BE);
  static const Color tertiaryContainer = Color(0xFF4D5A39);
  static const Color outline = Color(0xFF82746D);
  static const Color outlineVariant = Color(0xFFD4C3BA);
  static const Color onPrimaryContainer = Color(0xFFEEC1A4);

  // ============ SPLASH SCREEN COLORS (from lib_part1) ============
  static const Color splashTop = primaryContainer;
  static const Color splashBottom = primary;
  static const Color splashText = onPrimary;
}
