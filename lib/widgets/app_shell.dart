import 'package:flutter/material.dart';

enum AppTab { home, browse, favourites, settings }

class AppShell extends StatelessWidget {
  final Widget child;
  final AppTab currentTab;
  const AppShell({super.key, required this.child, required this.currentTab});

  static const double kTabletBreakpoint = 720;
  static const double kDesktopBreakpoint = 1000;

  void _navigate(BuildContext context, AppTab tab) {
    final route = {
      AppTab.home: '/',
      AppTab.browse: '/browse',
      AppTab.favourites: '/favourites',
      AppTab.settings: '/settings',
    }[tab]!;
    if (ModalRoute.of(context)?.settings.name != route) {
      Navigator.of(context).pushReplacementNamed(route);
    }
  }

  Widget _navButton(BuildContext ctx, AppTab tab, IconData icon, String label) {
    final isActive = tab == currentTab;
    return TextButton.icon(
      onPressed: () => _navigate(ctx, tab),
      icon: Icon(icon, color: isActive ? Theme.of(ctx).colorScheme.primary : Colors.grey[700]),
      label: Text(label, style: TextStyle(color: isActive ? Theme.of(ctx).colorScheme.primary : Colors.grey[700])),
      style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final horizontalPadding = width >= kDesktopBreakpoint ? 48.0 : (width >= kTabletBreakpoint ? 28.0 : 16.0);
    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/icon.png',
              width: 28,
              height: 28,
              errorBuilder: (_, __, ___) => Icon(Icons.photo, size: 28, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(width: 10),
            Text('Wallpaper Studio', style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).textTheme.titleMedium?.color)),
          ],
        ),
        actions: [
          _navButton(context, AppTab.home, Icons.home_outlined, 'Home'),
          _navButton(context, AppTab.browse, Icons.grid_view, 'Browse'),
          _navButton(context, AppTab.favourites, Icons.favorite_border, 'Favourites'),
          _navButton(context, AppTab.settings, Icons.settings_outlined, 'Settings'),
          const SizedBox(width: 8),
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        final maxWidth = constraints.maxWidth >= kDesktopBreakpoint ? 1200.0 : double.infinity;
        return Center(
          child: Container(
            width: maxWidth,
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 20),
            child: child,
          ),
        );
      }),
    );
  }
}