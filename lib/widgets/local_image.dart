import 'dart:io';
import 'package:flutter/material.dart';

class LocalImage extends StatelessWidget {
  final String path;
  final BoxFit fit;
  final double? width;
  final double? height;

  const LocalImage({
    super.key,
    required this.path,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (path.isEmpty) return _fallback();
    try {
      final file = File(path);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: fit,
          width: width,
          height: height,
          errorBuilder: (_, __, ___) => _fallback(),
        );
      }
    } catch (_) {
    }
    return _fallback();
  }

  Widget _fallback() => Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child: const Icon(Icons.image_not_supported, color: Colors.white70),
      );
}