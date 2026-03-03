import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter/common/notification_helper.dart';
import 'package:restaurant_flutter/common/theme.dart';
import 'package:restaurant_flutter/data/datasources/favorite_local_datasource.dart';
import 'package:restaurant_flutter/data/datasources/restaurant_remote_datasource.dart';
import 'package:restaurant_flutter/data/repositories/favorite_repository_impl.dart';
import 'package:restaurant_flutter/data/repositories/restaurant_repository_impl.dart';
import 'package:restaurant_flutter/domain/usecases/add_favorite_restaurant.dart';
import 'package:restaurant_flutter/domain/usecases/get_favorite_restaurants.dart';
import 'package:restaurant_flutter/domain/usecases/get_restaurant_list.dart';
import 'package:restaurant_flutter/domain/usecases/is_favorite_restaurant.dart';
import 'package:restaurant_flutter/domain/usecases/remove_favorite_restaurant.dart';
import 'package:restaurant_flutter/presentation/pages/main_page.dart';
import 'package:restaurant_flutter/presentation/providers/favorite_provider.dart';
import 'package:restaurant_flutter/presentation/providers/reminder_provider.dart';
import 'package:restaurant_flutter/presentation/providers/restaurant_list_provider.dart';
import 'package:restaurant_flutter/presentation/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationHelper.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Setup dependency injection
    final remoteDataSource = RestaurantRemoteDataSource();
    final repository =
        RestaurantRepositoryImpl(remoteDataSource: remoteDataSource);
    final getRestaurantList = GetRestaurantList(repository);

    final favoriteLocalDataSource = FavoriteLocalDataSource();
    final favoriteRepository =
        FavoriteRepositoryImpl(localDataSource: favoriteLocalDataSource);
    final getFavoriteRestaurants = GetFavoriteRestaurants(favoriteRepository);
    final addFavoriteRestaurant = AddFavoriteRestaurant(favoriteRepository);
    final removeFavoriteRestaurant =
        RemoveFavoriteRestaurant(favoriteRepository);
    final isFavoriteRestaurant = IsFavoriteRestaurant(favoriteRepository);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => RestaurantListProvider(
            getRestaurantList: getRestaurantList,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoriteProvider(
            getFavoriteRestaurants: getFavoriteRestaurants,
            addFavoriteRestaurant: addFavoriteRestaurant,
            removeFavoriteRestaurant: removeFavoriteRestaurant,
            isFavoriteRestaurant: isFavoriteRestaurant,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ReminderProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Restaurant App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const MainPage(),
          );
        },
      ),
    );
  }
}
