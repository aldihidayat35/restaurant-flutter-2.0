import 'package:flutter/material.dart';
import 'package:restaurant_flutter/common/result_state.dart';
import 'package:restaurant_flutter/domain/entities/restaurant.dart';
import 'package:restaurant_flutter/domain/usecases/add_favorite_restaurant.dart';
import 'package:restaurant_flutter/domain/usecases/get_favorite_restaurants.dart';
import 'package:restaurant_flutter/domain/usecases/is_favorite_restaurant.dart';
import 'package:restaurant_flutter/domain/usecases/remove_favorite_restaurant.dart';

class FavoriteProvider extends ChangeNotifier {
  final GetFavoriteRestaurants getFavoriteRestaurants;
  final AddFavoriteRestaurant addFavoriteRestaurant;
  final RemoveFavoriteRestaurant removeFavoriteRestaurant;
  final IsFavoriteRestaurant isFavoriteRestaurant;

  FavoriteProvider({
    required this.getFavoriteRestaurants,
    required this.addFavoriteRestaurant,
    required this.removeFavoriteRestaurant,
    required this.isFavoriteRestaurant,
  }) {
    fetchFavorites();
  }

  ResultState<List<Restaurant>> _state = const ResultLoading();
  ResultState<List<Restaurant>> get state => _state;

  bool _isFavorite = false;
  bool get isFavorite => _isFavorite;

  Future<void> fetchFavorites() async {
    _state = const ResultLoading();
    notifyListeners();

    try {
      final favorites = await getFavoriteRestaurants.execute();
      _state = ResultLoaded(favorites);
    } catch (e) {
      _state = ResultError(e.toString());
    }

    notifyListeners();
  }

  Future<void> addFavorite(Restaurant restaurant) async {
    try {
      await addFavoriteRestaurant.execute(restaurant);
      _isFavorite = true;
      notifyListeners();
      await fetchFavorites();
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> removeFavorite(String id) async {
    try {
      await removeFavoriteRestaurant.execute(id);
      _isFavorite = false;
      notifyListeners();
      await fetchFavorites();
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> checkIsFavorite(String id) async {
    try {
      _isFavorite = await isFavoriteRestaurant.execute(id);
    } catch (e) {
      _isFavorite = false;
    }
    notifyListeners();
  }

  Future<void> toggleFavorite(Restaurant restaurant) async {
    if (_isFavorite) {
      await removeFavorite(restaurant.id);
    } else {
      await addFavorite(restaurant);
    }
  }
}
