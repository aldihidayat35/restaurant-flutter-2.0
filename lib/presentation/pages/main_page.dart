import 'package:flutter/material.dart';
import 'package:restaurant_flutter/presentation/pages/favorite_page.dart';
import 'package:restaurant_flutter/presentation/pages/restaurant_list_page.dart';
import 'package:restaurant_flutter/presentation/pages/settings_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    RestaurantListPage(),
    FavoritePage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: theme.cardColor,
        indicatorColor: theme.colorScheme.primary.withValues(alpha: 0.15),
        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.restaurant_rounded,
              color: _currentIndex == 0
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            label: 'Restaurant',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.favorite_rounded,
              color: _currentIndex == 1
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.settings_rounded,
              color: _currentIndex == 2
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
