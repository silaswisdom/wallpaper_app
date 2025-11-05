import 'package:flutter/material.dart';
import '../models/data_models.dart';
import '../widgets/category_card.dart';
import '../widgets/active_banner.dart';
import 'category_detail_screen.dart';
import '../services/active_wallpaper_service.dart';

const double kTabletBreakpoint = 720;
const double kDesktopBreakpoint = 1000;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final List<Category> categories;

  @override
  void initState() {
    super.initState();
    categories = [
      Category(
        name: 'Nature',
        imagePaths: ['assets/nature.png',
        'assets/nature 1.png',
        'assets/nature 2.png',
        'assets/nature 3.png',],
        subtitle: 'Mountains, Forest and landscapes',
        count: 6),
      Category(name: 'Abstract', imagePaths: ['assets/abstract.png'], subtitle: 'Modern geometric and artistic designs', count: 4),
      Category(name: 'Urban', imagePaths: ['assets/urban.png'], subtitle: 'Cities, architecture and street', count: 6),
      Category(name: 'Space', imagePaths: ['assets/space.png'], subtitle: 'Cosmos, planets, and galaxies', count: 3),
      Category(name: 'Minimalist', imagePaths: ['assets/minimalist.png'], subtitle: 'Clean, simple, and elegant', count: 6),
      Category(name: 'Animals', imagePaths: ['assets/animals.png'], subtitle: 'Wildlife and nature photography', count: 4),
    ];
  }

  void navigateToCategory(Category category) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => CategoryDetailScreen(category: category)));
  }

  String _activeSelectionLabel(String path) {
    final parts = path.split(RegExp(r'[\\/]+'));
    final name = parts.isNotEmpty ? parts.last : path;
    return name.replaceAll(RegExp(r'\.[^\.]+$'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( backgroundColor: Color(0xFFF8F8F8),
      body: LayoutBuilder(builder: (context, constraints) {
        final isWide = constraints.maxWidth >= kDesktopBreakpoint;
        final gridCross = isWide ? 3 : (constraints.maxWidth >= kTabletBreakpoint ? 2 : 1);
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            ValueListenableBuilder<ActiveWallpaper?>(
              valueListenable: ActiveWallpaperService.instance.active,
              builder: (context, active, _) {
                if (active != null) {
                  return Column(children: [
                    ActiveWallpaperBanner(
                      title: 'Your Active Wallpaper', 
                      subtitle: 'Category - ${active.category}\n Selection - ${_activeSelectionLabel(active.imagePath)}',
                      imagePath: active.imagePath,
                    ),
                    const SizedBox(height: 24),
                  ]);
                }

                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(height: 6),
                  Text('Discover Beautiful Wallpapers',
                      style: TextStyle(fontSize: 60, fontWeight: FontWeight.w500, color: const Color(0xFFFD8C4E))),
                  const SizedBox(height: 8),
                  Text(
                    'Discover curated collections of stunning wallpapers. Browse by\ncategory, preview in full-screen, and set your favorites.',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, color: Color(0xFF575757)),
                  ),
                  const SizedBox(height: 24),
                ]);
              },
            ),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Categories', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 32)),
              TextButton(onPressed: () {}, child: const Text('See All', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, color: Color(0xFF808080)),)),
            ]),
            const SizedBox(height: 16),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: categories.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridCross,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: isWide ? 2.3 : (gridCross == 1 ? 2.7 : 1.6),
              ),
              itemBuilder: (context, i) {
                final cat = categories[i];
                return CategoryCard(category: cat, onTap: () => navigateToCategory(cat));
              },
            ),
          ]),
        );
      }),
    );
  }
}

class CategoryDetailScreen extends StatelessWidget {
  final Category category;
  const CategoryDetailScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category.name)),
      body: Center(
        child: Text('Selected category: ${category.name}'),
      ),
    );
  }
}
