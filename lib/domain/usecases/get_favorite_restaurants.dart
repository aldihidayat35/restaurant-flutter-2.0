import 'package:restaurant_flutter/domain/entities/restaurant.dart';
import 'package:restaurant_flutter/domain/repositories/favorite_repository.dart';

class GetFavoriteRestaurants {
  final FavoriteRepository repository;

  GetFavoriteRestaurants(this.repository);

  Future<List<Restaurant>> execute() async {
    return await repository.getFavorites();
  }
}
