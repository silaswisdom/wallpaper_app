import 'package:flutter/material.dart';

class Wallpaper {
  final String id;
  final String name;
  final String category;
  final String imagePath;
  final List<String> tags;
  final String description;
  final bool isFavorite;

  Wallpaper({
    required this.id,
    required this.name,
    required this.category,
    required this.imagePath,
    required this.tags,
    required this.description,
    this.isFavorite = false,
  });

  Wallpaper copyWith({bool? isFavorite}) {
    return Wallpaper(
      id: id,
      name: name,
      category: category,
      imagePath: imagePath,
      tags: tags,
      description: description,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class Category {
  final String name;
  final List<String> imagePaths; 
  final String subtitle;
  final int count;

  Category({
    required this.name,
    List<String>? imagePaths,
    this.subtitle = '',
    this.count = 0,
  }) : imagePaths = imagePaths ?? [];

  String get imagePath => imagePaths.isNotEmpty ? imagePaths.first : '';
}


final List<Category> mockCategories = [
  Category(
    name: 'Nature',
    imagePaths: [
      'assets/nature.png'
      'assets/nature1.png',
      'assets/nature2.png',
      'assets/nature3.png',
      'assets/nature4.png',
      'assets/nature5.png',
      'assets/nature6.png',
    ],
    subtitle: 'Mountains, Forest and Landscapes',
    count: 6,
  ),
  Category(
    name: 'Abstract',
    imagePaths: [
      'assets/abstract.png',
    ],
    subtitle: 'Modern Geometric and artistic designs',
    count: 4,
  ),
  Category(
    name: 'Urban',
    imagePaths: [
      'assets/urban.png',
    ],
    subtitle: 'Cities, architecture and street',
    count: 6,
  ),
  Category(
    name: 'Space',
    imagePaths: [
      'assets/space.png',
    ],
    subtitle: 'Cosmos, planets, and galaxies',
    count: 3,
  ),
  Category(
    name: 'Minimalist',
    imagePaths: [
      'assets/minimalist.png',
    ],
    subtitle: 'Clean, simple, and elegant',
    count: 6,
  ),
  Category(
    name: 'Animals',
    imagePaths: [
      'assets/animals.png',
    ],
    subtitle: 'Wildlife and nature photography',
    count: 4,
  ),
];

class WallpaperItem {
  final String id;
  final String name;
  final String imagePath;
  final List<String> tags;
  WallpaperItem({
    required this.id,
    required this.name,
    this.imagePath = '',
    this.tags = const [],
  });
}
