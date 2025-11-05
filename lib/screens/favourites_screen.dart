import 'package:flutter/material.dart';
import '../services/favorites_service.dart';
import '../widgets/local_image.dart';
import '../models/data_models.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 6),
      Text('Saved Wallpapers', style: TextStyle(fontSize: 60, fontWeight: FontWeight.w500, color: const Color(0xFFFD8C4E))),
      SizedBox(height: 8),
      Text('Your saved wallpapers collection', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, color: Color(0xFF575757)),),
      const SizedBox(height: 8),
      Expanded(
        child: ValueListenableBuilder<Set<String>>(
          valueListenable: FavoritesService.instance.favorites,
          builder: (context, favs, _) {
            if (favs.isEmpty) {
              return Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.photo_library_outlined, size: 84, color: Colors.grey),
                  const SizedBox(height: 50),
                  const Text('No Saved Wallpapers', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24, color: Color(0xFF575757))),
                  SizedBox(height: 20),
                  Text('Start saving your favorite wallpapers to see them here', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF575757)),),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => Navigator.of(context).pushReplacementNamed('/browse'),
                    child: const Text('Browse Wallpapers', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    style: TextButton.styleFrom(backgroundColor: const Color(0xFFFD8C4E), foregroundColor: Colors.white),
                  )
                ]),
              );
            }

            final list = favs.toList();
            return GridView.builder(
              padding: const EdgeInsets.only(top: 8),
              itemCount: list.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.9),
              itemBuilder: (context, i) {
                final path = list[i];
                return Stack(children: [
                  ClipRRect(borderRadius: BorderRadius.circular(12), child: LocalImage(path: path, fit: BoxFit.cover)),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: GestureDetector(
                      onTap: () => FavoritesService.instance.toggle(path),
                      child: const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.favorite, color: Color(0xFFFBB03B))),
                    ),
                  ),
                ]);
              },
            );
          },
        ),
      )
    ]);
  }
}