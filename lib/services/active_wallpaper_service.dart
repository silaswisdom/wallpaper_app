import 'package:flutter/foundation.dart';

class ActiveWallpaper {
  final String category;
  final String imagePath;
  ActiveWallpaper({required this.category, required this.imagePath});
}

class ActiveWallpaperService {
  ActiveWallpaperService._();
  static final ActiveWallpaperService instance = ActiveWallpaperService._();

  final ValueNotifier<ActiveWallpaper?> active = ValueNotifier<ActiveWallpaper?>(null);

  void setActive(String category, String imagePath) {
    active.value = ActiveWallpaper(category: category, imagePath: imagePath);
  }

  void clear() {
    active.value = null;
  }
}