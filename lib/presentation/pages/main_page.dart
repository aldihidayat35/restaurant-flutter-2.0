import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter/presentation/pages/favorite_page.dart';
import 'package:restaurant_flutter/presentation/pages/restaurant_list_page.dart';
import 'package:restaurant_flutter/presentation/pages/settings_page.dart';
import 'package:restaurant_flutter/presentation/providers/main_index_provider.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  static const List<Widget> _pages = [
    RestaurantListPage(),
    FavoritePage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<MainIndexProvider>(
      builder: (context, indexProvider, child) {
        final currentIndex = indexProvider.currentIndex;

        return Scaffold(
          body: IndexedStack(
            index: currentIndex,
            children: _pages,
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: (index) {
              indexProvider.setIndex(index);
            },
            backgroundColor: theme.cardColor,
            indicatorColor:
                theme.colorScheme.primary.withValues(alpha: 0.15),
            destinations: [
              NavigationDestination(
                icon: Icon(
                  Icons.restaurant_rounded,
                  color: currentIndex == 0
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                label: 'Restaurant',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.favorite_rounded,
                  color: currentIndex == 1
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                label: 'Favorites',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.settings_rounded,
                  color: currentIndex == 2
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}
