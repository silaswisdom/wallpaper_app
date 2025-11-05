import 'package:flutter/foundation.dart';

/// Simple in-memory favorites store identified by imagePath.
/// Use FavoritesService.instance.toggle(path) to add/remove.
class FavoritesService {
  FavoritesService._();
  static final FavoritesService instance = FavoritesService._();

  final ValueNotifier<Set<String>> favorites = ValueNotifier<Set<String>>({});

  bool isFavorite(String path) => favorites.value.contains(path);

  void toggle(String path) {
    final set = Set<String>.from(favorites.value);
    if (set.contains(path)) set.remove(path); else set.add(path);
    favorites.value = set;
  }

  List<String> list() => favorites.value.toList(growable: false);
}