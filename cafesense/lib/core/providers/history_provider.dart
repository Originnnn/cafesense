import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cafesense/features/cafe/data/models/cafe.dart';

const _kHistoryKey = 'view_history_v1';
const _kMaxHistory = 50;

/// A lightweight record of a cafe that was viewed.
class HistoryEntry {
  final String cafeId;
  final String cafeName;
  final String imageUrl;
  final List<String> spaceStyle;
  final String priceLabel;
  final DateTime viewedAt;

  const HistoryEntry({
    required this.cafeId,
    required this.cafeName,
    required this.imageUrl,
    required this.spaceStyle,
    required this.priceLabel,
    required this.viewedAt,
  });

  factory HistoryEntry.fromCafe(Cafe cafe) => HistoryEntry(
        cafeId: cafe.id,
        cafeName: cafe.name,
        imageUrl: cafe.imageUrl,
        spaceStyle: cafe.spaceStyle,
        priceLabel: cafe.priceLabel,
        viewedAt: DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        'cafeId': cafeId,
        'cafeName': cafeName,
        'imageUrl': imageUrl,
        'spaceStyle': spaceStyle,
        'priceLabel': priceLabel,
        'viewedAt': viewedAt.toIso8601String(),
      };

  factory HistoryEntry.fromJson(Map<String, dynamic> json) => HistoryEntry(
        cafeId: json['cafeId'] as String? ?? '',
        cafeName: json['cafeName'] as String? ?? '',
        imageUrl: json['imageUrl'] as String? ?? '',
        spaceStyle: (json['spaceStyle'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
        priceLabel: json['priceLabel'] as String? ?? '',
        viewedAt: json['viewedAt'] != null
            ? DateTime.parse(json['viewedAt'] as String)
            : DateTime.now(),
      );
}

class HistoryNotifier extends StateNotifier<List<HistoryEntry>> {
  HistoryNotifier() : super([]) {
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_kHistoryKey);
      if (raw != null) {
        final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
        state = decoded
            .map((e) => HistoryEntry.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('HistoryNotifier: failed to load: $e');
    }
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(state.map((e) => e.toJson()).toList());
      await prefs.setString(_kHistoryKey, encoded);
    } catch (e) {
      debugPrint('HistoryNotifier: failed to save: $e');
    }
  }

  /// Add a viewed cafe to history (most recent first, no duplicates).
  void addEntry(Cafe cafe) {
    final entry = HistoryEntry.fromCafe(cafe);
    // Remove existing entry for same cafe (will be re-added at top)
    final updated = state.where((e) => e.cafeId != cafe.id).toList();
    updated.insert(0, entry);
    // Trim to max size
    state = updated.take(_kMaxHistory).toList();
    _save();
  }

  /// Remove specific entries by cafeId.
  void removeEntries(List<String> cafeIds) {
    state = state.where((e) => !cafeIds.contains(e.cafeId)).toList();
    _save();
  }

  /// Clear all history.
  void clearAll() {
    state = [];
    _save();
  }
}

final historyProvider = StateNotifierProvider<HistoryNotifier, List<HistoryEntry>>((ref) {
  return HistoryNotifier();
});
