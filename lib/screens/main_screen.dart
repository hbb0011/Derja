import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favorites_model.dart';
import '../theme/app_colors.dart';
import 'dictionary_screen.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

/// The "frame" of the app: the current page + the bottom navigation bar.
/// It remembers which tab is open (_tab): 0 Home, 1 Dictionary,
/// 2 Favorites, 3 Profile.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _tab = 0;

  void _goTo(int index) => setState(() => _tab = index);

  /// Returns the page that matches the current tab.
  Widget _page() {
    switch (_tab) {
      case 1:
        return const DictionaryScreen();
      case 2:
        return const FavoritesScreen();
      case 3:
        return const ProfileScreen();
      default:
        return HomeScreen(
          onOpenDictionary: () => _goTo(1),
          onOpenProfile: () => _goTo(3),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoritesCount = context.watch<FavoritesModel>().count;

    return Scaffold(
      body: SafeArea(
        bottom: false, // the bottom bar already handles the bottom edge
        // ANIMATION #4: AnimatedSwitcher fades between the old and new page
        // when the tab changes. The ValueKey(_tab) tells it "it's a new page".
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: KeyedSubtree(key: ValueKey(_tab), child: _page()),
        ),
      ),
      bottomNavigationBar: DecoratedBox(
        // Black line above the bar.
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.ink, width: 2)),
        ),
        child: NavigationBar(
          selectedIndex: _tab,
          onDestinationSelected: _goTo,
          backgroundColor: AppColors.paper,
          surfaceTintColor: Colors.transparent,
          indicatorColor: AppColors.green,
          indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: AppColors.ink, width: 2),
          ),
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: Colors.white),
              label: 'Home',
            ),
            const NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(Icons.menu_book, color: Colors.white),
              label: 'Dictionary',
            ),
            NavigationDestination(
              // Badge = small number on the icon (how many favorites).
              icon: Badge(
                isLabelVisible: favoritesCount > 0,
                label: Text('$favoritesCount'),
                child: const Icon(Icons.favorite_border),
              ),
              selectedIcon: Badge(
                isLabelVisible: favoritesCount > 0,
                label: Text('$favoritesCount'),
                child: const Icon(Icons.favorite, color: Colors.white),
              ),
              label: 'Favorites',
            ),
            const NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person, color: Colors.white),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
