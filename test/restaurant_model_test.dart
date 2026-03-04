import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_flutter/data/models/restaurant_model.dart';

void main() {
  group('RestaurantModel', () {
    test('should correctly parse from JSON', () {
      // arrange
      final json = {
        'id': 'rqdv5juczeskfw1e867',
        'name': 'Melting Pot',
        'description': 'Lorem ipsum dolor sit amet',
        'pictureId': '14',
        'city': 'Medan',
        'rating': 4.2,
      };

      // act
      final model = RestaurantModel.fromJson(json);

      // assert
      expect(model.id, 'rqdv5juczeskfw1e867');
      expect(model.name, 'Melting Pot');
      expect(model.description, 'Lorem ipsum dolor sit amet');
      expect(model.pictureId, '14');
      expect(model.city, 'Medan');
      expect(model.rating, 4.2);
    });

    test('should handle missing/null JSON fields with defaults', () {
      // arrange
      final json = <String, dynamic>{};

      // act
      final model = RestaurantModel.fromJson(json);

      // assert
      expect(model.id, '');
      expect(model.name, '');
      expect(model.description, '');
      expect(model.pictureId, '');
      expect(model.city, '');
      expect(model.rating, 0.0);
    });

    test('should convert to Restaurant entity correctly', () {
      // arrange
      final model = RestaurantModel(
        id: 'abc123',
        name: 'Test Restaurant',
        description: 'A test description',
        pictureId: '25',
        city: 'Jakarta',
        rating: 4.5,
      );

      // act
      final entity = model.toEntity();

      // assert
      expect(entity.id, 'abc123');
      expect(entity.name, 'Test Restaurant');
      expect(entity.description, 'A test description');
      expect(entity.pictureId, '25');
      expect(entity.city, 'Jakarta');
      expect(entity.rating, 4.5);
    });

    test('Restaurant entity should generate correct image URLs', () {
      // arrange
      final model = RestaurantModel(
        id: 'abc123',
        name: 'Test',
        description: 'Desc',
        pictureId: '25',
        city: 'Jakarta',
        rating: 4.0,
      );

      // act
      final entity = model.toEntity();

      // assert
      expect(
        entity.smallImageUrl,
        'https://restaurant-api.dicoding.dev/images/small/25',
      );
      expect(
        entity.mediumImageUrl,
        'https://restaurant-api.dicoding.dev/images/medium/25',
      );
      expect(
        entity.largeImageUrl,
        'https://restaurant-api.dicoding.dev/images/large/25',
      );
    });
  });
}
