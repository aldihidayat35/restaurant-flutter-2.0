import 'package:restaurant_flutter/domain/repositories/favorite_repository.dart';

class IsFavoriteRestaurant {
  final FavoriteRepository repository;

  IsFavoriteRestaurant(this.repository);

  Future<bool> execute(String id) async {
    return await repository.isFavorite(id);
  }
}
