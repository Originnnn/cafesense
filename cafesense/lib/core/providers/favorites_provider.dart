import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cafesense/features/cafe/data/repositories/cafe_repository.dart';
import 'package:cafesense/features/cafe/data/models/cafe.dart';

const _kFavKey = 'favorites_v1';

class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super({}) {
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getStringList(_kFavKey) ?? [];
      state = raw.toSet();
    } catch (e) {
      debugPrint('FavoritesNotifier: failed to load: $e');
    }
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_kFavKey, state.toList());
    } catch (e) {
      debugPrint('FavoritesNotifier: failed to save: $e');
    }
  }

  void toggleFavorite(String cafeId) {
    if (state.contains(cafeId)) {
      state = {...state}..remove(cafeId);
    } else {
      state = {...state}..add(cafeId);
    }
    _save();
  }

  bool isFavorite(String cafeId) => state.contains(cafeId);
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  return FavoritesNotifier();
});

/// Derived provider: list of full Cafe objects that are favorited
final favoriteCafesProvider = FutureProvider<List<Cafe>>((ref) async {
  final favoriteIds = ref.watch(favoritesProvider);
  if (favoriteIds.isEmpty) return [];
  try {
    final repo = ref.read(cafeRepositoryProvider);
    final allCafes = await repo.getCafes();
    return allCafes.where((c) => favoriteIds.contains(c.id)).toList();
  } catch (e) {
    debugPrint('favoriteCafesProvider: error $e');
    return [];
  }
});
