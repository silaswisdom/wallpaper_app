import 'package:flutter/material.dart';
import '../models/data_models.dart';
import '../widgets/category_card.dart';
import '../widgets/local_image.dart';
import 'category_detail_screen.dart';

const double kTabletBreakpoint = 720;
const double kDesktopBreakpoint = 1000;

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  bool isGrid = true; // toggle between grid and list

  final List<Category> categories = [
    Category(
      name: 'Nature',
      imagePaths: [
        'assets/nature.png',
        'assets/nature 1.png',
        'assets/nature 2.png',
        'assets/nature 3.png',
        'assets/nature 4.png',
        'assets/nature 5.png',
        'assets/nature 6.png',
      ],
      subtitle: 'Mountains, Forest and landscapes',
      count: 6,
    ),
    Category(
      name: 'Abstract',
      imagePaths: ['assets/abstract.png'],
      subtitle: 'Modern geometric and artistic designs',
      count: 4,
    ),
    Category(
      name: 'Urban',
      imagePaths: ['assets/urban.png'],
      subtitle: 'Cities, architecture and street',
      count: 6,
    ),
    Category(
      name: 'Space',
      imagePaths: ['assets/space.png'],
      subtitle: 'Cosmos, planets, and galaxies',
      count: 3,
    ),
    Category(
      name: 'Minimalist',
      imagePaths: ['assets/minimalist.png'],
      subtitle: 'Clean, simple, and elegant',
      count: 6,
    ),
    Category(
      name: 'Animals',
      imagePaths: ['assets/animals.png'],
      subtitle: 'Wildlife and nature photography',
      count: 4,
    ),
  ];

  void _openCategory(Category cat) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => CategoryDetailScreen(category: cat)));
  }

  Widget _modeButton({
    required bool active,
    required VoidCallback onTap,
    required String assetPath,
    required IconData fallbackIcon,
    required String tooltip,
  }) {
    const activeColor = Color(0xFFFFA821);
    const inactiveColor = Color(0xFF000000);
    final iconColor = active ? activeColor : inactiveColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: active ? activeColor.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Image.asset(
          assetPath,
          width: 28,
          height: 28,
          color: iconColor,
          errorBuilder: (_, __, ___) => Icon(fallbackIcon, color: iconColor, size: 24),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= kDesktopBreakpoint;
    final cross = isWide ? 3 : (width >= kTabletBreakpoint ? 2 : 1);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 6),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Browse Categories',
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFFD8C4E),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Explore our curated collections of stunning wallpapers',
                style: TextStyle(
                  fontSize: isWide ? 16 : 14,
                  color: Colors.grey[700],
                ),
              ),
            ]),
          ),
          Row(
            children: [
              Tooltip(
                message: 'Grid view',
                child: _modeButton(
                  active: isGrid,
                  onTap: () => setState(() => isGrid = true),
                  assetPath: 'assets/icon_grid.png',
                  fallbackIcon: Icons.grid_view,
                  tooltip: 'Grid view',
                ),
              ),
              const SizedBox(width: 8),
              Tooltip(
                message: 'List view',
                child: _modeButton(
                  active: !isGrid,
                  onTap: () => setState(() => isGrid = false),
                  assetPath: 'assets/icon_list.png',
                  fallbackIcon: Icons.view_list,
                  tooltip: 'List view',
                ),
              ),
            ],
          ),
        ],
      ),
      const SizedBox(height: 50),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: isGrid
              ? GridView.builder(
                  itemCount: categories.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cross,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: isWide ? 1.7 : (cross == 1 ? 3.0 : 1.6),
                  ),
                  itemBuilder: (context, i) {
                    final cat = categories[i];
                    return GestureDetector(
                      onTap: () => _openCategory(cat),
                      child: CategoryCard(category: cat),
                    );
                  },
                )
              : ListView.separated(
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const Divider(height: 16, thickness: 1),
                  itemBuilder: (context, i) {
                    final cat = categories[i];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(width: 120, height: 72, child: LocalImage(path: cat.imagePath, fit: BoxFit.cover)),
                      ),
                      title: Text(cat.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(cat.subtitle),
                      trailing: Text('${cat.count} wallpapers', style: const TextStyle(color: Colors.grey)),
                      onTap: () => _openCategory(cat),
                    );
                  },
                ),
        ),
      ),
    ]);
  }
}