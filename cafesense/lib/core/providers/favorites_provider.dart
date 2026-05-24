import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super({});

  void toggleFavorite(String cafeId) {
    if (state.contains(cafeId)) {
      state = {...state}..remove(cafeId);
    } else {
      state = {...state}..add(cafeId);
    }
  }

  bool isFavorite(String cafeId) {
    return state.contains(cafeId);
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  return FavoritesNotifier();
});
