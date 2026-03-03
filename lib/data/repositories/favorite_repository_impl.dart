import 'package:restaurant_flutter/data/datasources/favorite_local_datasource.dart';
import 'package:restaurant_flutter/domain/entities/restaurant.dart';
import 'package:restaurant_flutter/domain/repositories/favorite_repository.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteLocalDataSource localDataSource;

  FavoriteRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Restaurant>> getFavorites() async {
    return await localDataSource.getFavorites();
  }

  @override
  Future<void> addFavorite(Restaurant restaurant) async {
    await localDataSource.addFavorite(restaurant);
  }

  @override
  Future<void> removeFavorite(String id) async {
    await localDataSource.removeFavorite(id);
  }

  @override
  Future<bool> isFavorite(String id) async {
    return await localDataSource.isFavorite(id);
  }
}
