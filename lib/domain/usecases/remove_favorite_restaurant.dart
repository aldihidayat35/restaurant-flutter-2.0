import 'package:restaurant_flutter/domain/repositories/favorite_repository.dart';

class RemoveFavoriteRestaurant {
  final FavoriteRepository repository;

  RemoveFavoriteRestaurant(this.repository);

  Future<void> execute(String id) async {
    await repository.removeFavorite(id);
  }
}
