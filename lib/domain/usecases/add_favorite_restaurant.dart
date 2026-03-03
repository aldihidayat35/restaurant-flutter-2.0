import 'package:restaurant_flutter/domain/entities/restaurant.dart';
import 'package:restaurant_flutter/domain/repositories/favorite_repository.dart';

class AddFavoriteRestaurant {
  final FavoriteRepository repository;

  AddFavoriteRestaurant(this.repository);

  Future<void> execute(Restaurant restaurant) async {
    await repository.addFavorite(restaurant);
  }
}
