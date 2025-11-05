import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/browse_screen.dart';
import 'screens/favourites_screen.dart';
import 'screens/settings_screen.dart';
import 'widgets/app_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wallpaper Studio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFD8C4E)),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const AppShell(child: HomeScreen(), currentTab: AppTab.home),
        '/browse': (_) => const AppShell(child: BrowseScreen(), currentTab: AppTab.browse),
        '/favourites': (_) => const AppShell(child: FavouritesScreen(), currentTab: AppTab.favourites),
        '/settings': (_) => const AppShell(child: SettingsScreen(), currentTab: AppTab.settings),
      },
    );
  }
}
