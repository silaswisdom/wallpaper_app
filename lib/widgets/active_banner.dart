import 'package:flutter/material.dart';
import 'local_image.dart';

class ActiveWallpaperBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath; 
  const ActiveWallpaperBanner({super.key, required this.title, required this.subtitle, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Card(color: Colors.white,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(43),
              child: SizedBox(width: 117, height: 210, child: LocalImage(path: imagePath, fit: BoxFit.cover)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Your Active Wallpaper', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500, color: Color(0xFFFD8C4E))),
                SizedBox(height: 12,),
                Text('This wallpaper is currently set as your active background', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Color(0xFF808080)),),
                const SizedBox(height: 20),
                Text(subtitle, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ]),
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.ios_share, color: Color(0xFFE5E5E5))),
            IconButton(onPressed: () {}, icon: Icon(Icons.settings, color: Color(0xFFE5E5E5))),
          ],
        ),
      ),
    );
  }
}