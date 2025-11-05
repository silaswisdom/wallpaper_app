import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';

import '../models/data_models.dart';
import '../services/active_wallpaper_service.dart';
import '../services/favorites_service.dart';
import '../widgets/local_image.dart';

typedef _SPI = Int32 Function(Uint32 uiAction, Uint32 uiParam, Pointer<Utf16> pvParam, Uint32 fWinIni);
typedef _SpiDart = int Function(int uiAction, int uiParam, Pointer<Utf16> pvParam, int fWinIni);

class CategoryDetailScreen extends StatefulWidget {
  final Category category;
  const CategoryDetailScreen({super.key, required this.category});

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  late final List<WallpaperItem> items;
  late WallpaperItem selected;

  bool thumbnailsAsGrid = true;

  _SpiDart? _systemParametersInfo;

  @override
  void initState() {
    super.initState();

    if (widget.category.imagePaths.isNotEmpty) {
      items = List.generate(widget.category.imagePaths.length, (i) {
        return WallpaperItem(
          id: 'w$i',
          name: '${widget.category.name} ${i + 1}',
          imagePath: widget.category.imagePaths[i],
          tags: [widget.category.name.toLowerCase(), 'ambience', 'flowers'],
        );
      });
    } else {
      items = List.generate(6, (i) {
        return WallpaperItem(
          id: 'w$i',
          name: '${widget.category.name} ${i + 1}',
          imagePath: '',
          tags: [widget.category.name.toLowerCase()],
        );
      });
    }
    selected = items.first;

    if (Platform.isWindows) {
      try {
        final user32 = DynamicLibrary.open('user32.dll');
        _systemParametersInfo = user32.lookupFunction<_SPI, _SpiDart>('SystemParametersInfoW');
      } catch (_) {
        _systemParametersInfo = null;
      }
    }
  }

  Future<void> _setWallpaper(String path, {String displayMode = 'Fit'}) async {
    if (path.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No image selected to set as wallpaper.')));
      return;
    }

    if (Platform.isWindows && _systemParametersInfo != null) {
      final ptr = path.toNativeUtf16();
      const SPI_SETDESKWALLPAPER = 0x0014;
      const SPIF_UPDATEINIFILE = 0x01;
      const SPIF_SENDWININICHANGE = 0x02;
      final res = _systemParametersInfo!(SPI_SETDESKWALLPAPER, 0, ptr, SPIF_UPDATEINIFILE | SPIF_SENDWININICHANGE);
      calloc.free(ptr);
      if (res == 0) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to set wallpaper (Windows API).')));
        return;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wallpaper set successfully.')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Set wallpaper not supported on this platform.')));
    }

    ActiveWallpaperService.instance.setActive(widget.category.name, path);
  }

  void _toggleFavorite(String path) {
    if (path.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No image path to save as favorite.')));
      return;
    }
    FavoritesService.instance.toggle(path);
  }

  void _shareImage(String path) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Share action not implemented.')));
  }

  void _downloadImage(String path) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Download action not implemented.')));
  }

  Future<void> _openSettings() async {
    final result = await showDialog<WallpaperSettingsResult>(
      context: context,
      builder: (_) => WallpaperSettingsDialog(),
    );

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Settings saved — display: ${result.displayMode}, auto-rotate: ${result.autoRotate ? "on" : "off"}'),
      ));
    }
  }

  Widget _modeToggle() {
    const activeColor = Color(0xFFFFA821);
    const inactiveColor = Color(0xFF000000);

    return Row(
      children: [
        GestureDetector(
          onTap: () => setState(() => thumbnailsAsGrid = true),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: thumbnailsAsGrid ? activeColor.withOpacity(0.12) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.grid_view, color: thumbnailsAsGrid ? activeColor : inactiveColor),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => setState(() => thumbnailsAsGrid = false),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: !thumbnailsAsGrid ? activeColor.withOpacity(0.12) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.view_list, color: !thumbnailsAsGrid ? activeColor : inactiveColor),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        label: const Text('Back to Categories', style: TextStyle(color: Color(0xFF979797))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(widget.category.name, style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w400)),
                      const SizedBox(width: 12), Spacer(),
                      _modeToggle(),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: thumbnailsAsGrid
                        ? GridView.count(
                            crossAxisCount: 3,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            padding: const EdgeInsets.only(top: 4),
                            children: items.map((w) {
                              final isSelected = selected.id == w.id;
                              return GestureDetector(
                                onTap: () => setState(() => selected = w),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      LocalImage(path: w.imagePath, fit: BoxFit.cover),
                                      if (isSelected)
                                        Container(decoration: BoxDecoration(border: Border.all(color: Theme.of(context).colorScheme.primary, width: 3))),
                                      Positioned(
                                        right: 8,
                                        top: 8,
                                        child: ValueListenableBuilder<Set<String>>(
                                          valueListenable: FavoritesService.instance.favorites,
                                          builder: (ctx, favs, _) {
                                            final fav = favs.contains(w.imagePath);
                                            return GestureDetector(
                                              onTap: () => _toggleFavorite(w.imagePath),
                                              child: CircleAvatar(
                                                radius: 14,
                                                backgroundColor: Colors.white,
                                                child: Icon(fav ? Icons.favorite : Icons.favorite_border, size: 16, color: fav ? Color(0xFFFBB03B) : Colors.grey),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Positioned(
                                        left: 10,
                                        bottom: 10,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                          decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(8)),
                                          child: Text(w.name, style: const TextStyle(color: Colors.white, fontSize: 12)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.only(top: 4),
                            itemCount: items.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 10),
                            itemBuilder: (context, i) {
                              final w = items[i];
                              return GestureDetector(
                                onTap: () => setState(() => selected = w),
                                child: SizedBox(
                                  height: 78,
                                  child: Row(
                                    children: [
                                      ClipRRect(borderRadius: BorderRadius.circular(8), child: SizedBox(width: 120, height: 78, child: LocalImage(path: w.imagePath, fit: BoxFit.cover))),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(w.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                            const SizedBox(height: 4),
                                            Text(widget.category.name, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                          ],
                                        ),
                                      ),
                                      ValueListenableBuilder<Set<String>>(
                                        valueListenable: FavoritesService.instance.favorites,
                                        builder: (ctx, favs, _) {
                                          final fav = favs.contains(w.imagePath);
                                          return IconButton(
                                            onPressed: () => _toggleFavorite(w.imagePath),
                                            icon: Icon(fav ? Icons.favorite : Icons.favorite_border, color: fav ? Color(0xFFFFA821) : null),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 20),
            Expanded(
              flex: 3,
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(children: [
                    Expanded(
                      flex: 6,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('Preview', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 20),
                        const Text('Name', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: Color(0xFF808080))),
                        Text(selected.name, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 24)),
                        const SizedBox(height: 18),
                        const Text('Tags', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF808080))),
                        const SizedBox(height: 6),
                        Wrap(spacing: 12, children: selected.tags.map((t) => Chip(label: Text(t))).toList()),
                        const SizedBox(height: 18),
                        const Text('Description', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: Color(0xFF808080))),
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          child: Text(
                            'Discover the pure beauty of "${selected.name}\nEssence" - your gateway to authentic,\nnature-inspired experiences. Let this\nunique collection elevate your senses\nand connect you with the unrefined el...',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[700], height: 1.4),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            IconButton(onPressed: () => _shareImage(selected.imagePath), icon: const Icon(Icons.share_outlined)),
                            IconButton(onPressed: () => _downloadImage(selected.imagePath), icon: const Icon(Icons.download_outlined)),
                            IconButton(onPressed: _openSettings, icon: const Icon(Icons.settings_outlined)),
                          ],
                        ),
                      ]),
                    ),

                    const SizedBox(width: 12),
                    SizedBox(
                      width: 300,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: AspectRatio(
                              aspectRatio: 4 / 7,
                              child: LocalImage(path: selected.imagePath, fit: BoxFit.cover),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: ValueListenableBuilder<Set<String>>(
                                    valueListenable: FavoritesService.instance.favorites,
                                    builder: (ctx, favs, _) {
                                      final isFav = favs.contains(selected.imagePath);
                                      return OutlinedButton.icon(
                                        onPressed: () => _toggleFavorite(selected.imagePath),
                                        icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Color(0xFFFBB03B) : null),
                                        label: Text(isFav ? 'Saved' : 'Save to Favorites', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFBB03B)),
                                    onPressed: () => _setWallpaper(selected.imagePath),
                                    icon: const Icon(Icons.wallpaper),
                                    label: const Text('Set to Wallpaper', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),), 
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WallpaperSettingsResult {
  final String displayMode;
  final bool autoRotate;
  final bool lockWallpaper;
  final bool syncAcrossDevices;
  final bool activated;

  WallpaperSettingsResult({
    required this.displayMode,
    required this.autoRotate,
    required this.lockWallpaper,
    required this.syncAcrossDevices,
    required this.activated,
  });
}

class WallpaperSettingsDialog extends StatefulWidget {
  @override
  State<WallpaperSettingsDialog> createState() => _WallpaperSettingsDialogState();
}

class _WallpaperSettingsDialogState extends State<WallpaperSettingsDialog> {
  bool activated = true;
  String displayMode = 'Fit';
  bool autoRotate = false;
  bool lockWallpaper = false;
  bool syncAcrossDevices = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Wallpaper Setup',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),),
          SizedBox(height: 6),
          Text('Configure your wallpaper settings and enable auto-rotation',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),)
        ],
      ),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Activate Wallpaper', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                subtitle: const Text('Set the selected wallpaper as your\ndesktop background', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF9C9C9C)),),
                trailing: Switch(value: activated, onChanged: (v) => setState(() => activated = v), activeColor: Color(0xFFFFA821),), 
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Display mode', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20)),
                  RadioListTile<String>(
                    activeColor: Color(0xFFFFA821),
                    title: const Text('Fit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                    subtitle: Text('Scale to fit without cropping', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400,color:Color(0xFF9C9C9C)),),
                    value: 'Fit', groupValue: displayMode, onChanged: (v) => setState(() => displayMode = v!)), 
                  RadioListTile<String>(
                    activeColor: Color(0xFFFFA821),
                    title: const Text('Fill', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                    subtitle: Text('Scale to fill the entire screen', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF9C9C9C)),),
                    value: 'Fill', groupValue: displayMode, onChanged: (v) => setState(() => displayMode = v!)), 
                  RadioListTile<String>(
                    activeColor: Color(0xFFFFA821),
                    title: const Text('Stretch', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                    subtitle: Text('Stretch to fill the screen', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF9C9C9C)),),
                    value: 'Stretch', groupValue: displayMode, onChanged: (v) => setState(() => displayMode = v!)),
                  RadioListTile<String>(
                    activeColor: Color(0xFFFFA821),
                    title: const Text('Tile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                    subtitle: Text('Repeat the image to fill the screen', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF9C9C9C)),),
                    value: 'Tile', groupValue: displayMode, onChanged: (v) => setState(() => displayMode = v!)),
                ]),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                title: const Text('Auto - Rotation', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                subtitle: const Text('Automatically change your wallpaper at regular intervals', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF9C9C9C)),),
                value: autoRotate,
                onChanged: (v) => setState(() => autoRotate = v), activeColor: Color(0xFFFFA821),
              ),
              const SizedBox(height: 8),
              const Text('Advanced Settings', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20)),
              CheckboxListTile(
                title: const Text('Lock Wallpaper', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                subtitle: const Text('Prevent accidental changes', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF9C9C9C)),),
                value: lockWallpaper,
                onChanged: (v) => setState(() => lockWallpaper = v ?? false),
              ),
              CheckboxListTile(
                title: const Text('Sync Across Devices', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                subtitle: const Text('Keep wallpaper consistent on all devices', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF9C9C9C)),),
                value: syncAcrossDevices,
                onChanged: (v) => setState(() => syncAcrossDevices = v ?? false), activeColor: Color(0xFFFFA821),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancel',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),)),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(WallpaperSettingsResult(
              displayMode: displayMode,
              autoRotate: autoRotate,
              lockWallpaper: lockWallpaper,
              syncAcrossDevices: syncAcrossDevices,
              activated: activated,
            )); 
          }, 
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFBB03B)),
          child: const Text('Save Settings',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),),
        ),
      ],
    );
  }
}