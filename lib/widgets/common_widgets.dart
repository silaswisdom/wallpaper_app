import 'package:flutter/material.dart';
import '../models/data_models.dart';
import 'local_image.dart';

enum AppView { home, categoryDetails, favourites, settings }

const double kDesktopBreakpoint = 1000.0;
const double kTabletBreakpoint = 600.0;

bool isDesktop(BuildContext context) =>
    MediaQuery.of(context).size.width >= kDesktopBreakpoint;

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppView currentView;
  final void Function(AppView) onNavigate;

  const CustomAppBar({
    super.key,
    required this.currentView,
    required this.onNavigate,
  });

  @override
  Size get preferredSize => const Size.fromHeight(72.0);

  Widget _navItem(BuildContext ctx, IconData icon, String label, AppView view, bool desktop) {
    final isSelected = currentView == view;
    final color = isSelected ? Theme.of(ctx).colorScheme.primary : Colors.grey[700];

    if (!desktop) {
      return IconButton(
        onPressed: () => onNavigate(view),
        icon: Icon(icon, color: color),
        tooltip: label,
      );
    }

    return TextButton.icon(
      onPressed: () => onNavigate(view),
      icon: Icon(icon, color: color, size: 18),
      label: Text(label, style: TextStyle(color: color)),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final desktop = isDesktop(context);
    final double horizontalPadding = desktop ? 40.0 : 20.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      color: Colors.white, 
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: preferredSize.height,
          child: Row(
            children: [
              const Text('Wallpaper Studio', style: TextStyle(fontWeight: FontWeight.w600)),
              const Spacer(),
              _navItem(context, Icons.home_outlined, 'Home', AppView.home, desktop),
              const SizedBox(width: 8),
              _navItem(context, Icons.grid_view, 'Browse', AppView.categoryDetails, desktop),
              const SizedBox(width: 8),
              _navItem(context, Icons.favorite_border, 'Favourites', AppView.favourites, desktop),
              const SizedBox(width: 8),
              _navItem(context, Icons.settings_outlined, 'Settings', AppView.settings, desktop),
            ],
          ),
        ),
      ),
    );
  }
}

class CommonCategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;

  const CommonCategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            LocalImage(path: category.imagePath, fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.45), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(category.subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(10)),
                    child: Text('${category.count} wallpapers', style: const TextStyle(color: Colors.white70, fontSize: 11)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WallpaperThumbnail extends StatelessWidget {
  final WallpaperItem wallpaper;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const WallpaperThumbnail({
    super.key,
    required this.wallpaper,
    required this.isSelected,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            LocalImage(path: wallpaper.imagePath, fit: BoxFit.cover),
            if (isSelected)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.primary, width: 3),
                ),
              ),
            Positioned(
              right: 8,
              top: 8,
              child: GestureDetector(
                onTap: onFavoriteToggle,
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.favorite_border, size: 16, color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PhoneMockup extends StatelessWidget {
  final String imagePath;

  const PhoneMockup({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final desktop = isDesktop(context);
    final double width = desktop ? 220 : 160;
    final double height = desktop ? 440 : 300;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12)],
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: LocalImage(path: imagePath, fit: BoxFit.cover),
      ),
    );
  }
}

class WallpaperPreview extends StatelessWidget {
  final WallpaperItem wallpaper;
  final VoidCallback onSet;
  final VoidCallback onSave;

  const WallpaperPreview({
    super.key,
    required this.wallpaper,
    required this.onSet,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Preview', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: [
                Expanded(child: LocalImage(path: wallpaper.imagePath, fit: BoxFit.cover)),
                const SizedBox(height: 12),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(wallpaper.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Row(children: [
                    IconButton(onPressed: onSave, icon: const Icon(Icons.favorite_border)),
                    ElevatedButton(onPressed: onSet, child: const Text('Set to Wallpaper')),
                  ]),
                ]),
              ]),
            ),
          ),
        ),
      ],
    );
  }
}
