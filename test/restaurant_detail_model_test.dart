import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_flutter/data/models/restaurant_detail_model.dart';

void main() {
  group('RestaurantDetailModel', () {
    test('should correctly parse full JSON with all nested data', () {
      // arrange
      final json = {
        'id': 'rqdv5juczeskfw1e867',
        'name': 'Melting Pot',
        'description': 'Lorem ipsum',
        'pictureId': '14',
        'city': 'Medan',
        'address': 'Jln. Pandeglang no 19',
        'rating': 4.2,
        'categories': [
          {'name': 'Italia'},
          {'name': 'Modern'},
        ],
        'menus': {
          'foods': [
            {'name': 'Paket rosemary'},
            {'name': 'Toastie salmon'},
          ],
          'drinks': [
            {'name': 'Es teh'},
            {'name': 'Jus apel'},
          ],
        },
        'customerReviews': [
          {
            'name': 'Ahmad',
            'review': 'Makanannya enak!',
            'date': '13 November 2019',
          },
        ],
      };

      // act
      final model = RestaurantDetailModel.fromJson(json);

      // assert
      expect(model.id, 'rqdv5juczeskfw1e867');
      expect(model.name, 'Melting Pot');
      expect(model.address, 'Jln. Pandeglang no 19');
      expect(model.categories.length, 2);
      expect(model.categories[0].name, 'Italia');
      expect(model.menus.foods.length, 2);
      expect(model.menus.drinks.length, 2);
      expect(model.menus.foods[0].name, 'Paket rosemary');
      expect(model.customerReviews.length, 1);
      expect(model.customerReviews[0].name, 'Ahmad');
    });

    test('should handle empty/null nested fields gracefully', () {
      // arrange
      final json = {
        'id': 'test',
        'name': 'Test',
        'description': '',
        'pictureId': '',
        'city': '',
        'address': '',
        'rating': 0,
        'categories': null,
        'menus': <String, dynamic>{},
        'customerReviews': null,
      };

      // act
      final model = RestaurantDetailModel.fromJson(json);

      // assert
      expect(model.categories, isEmpty);
      expect(model.menus.foods, isEmpty);
      expect(model.menus.drinks, isEmpty);
      expect(model.customerReviews, isEmpty);
    });

    test('should convert to RestaurantDetail entity correctly', () {
      // arrange
      final model = RestaurantDetailModel(
        id: 'abc',
        name: 'Test',
        description: 'Desc',
        pictureId: '14',
        city: 'Jakarta',
        address: 'Jl. Test',
        rating: 4.0,
        categories: const [CategoryModel(name: 'Italia')],
        menus: const MenusModel(
          foods: [MenuItemModel(name: 'Nasi Goreng')],
          drinks: [MenuItemModel(name: 'Es Teh')],
        ),
        customerReviews: const [
          CustomerReviewModel(
            name: 'User',
            review: 'Good',
            date: '2024-01-01',
          ),
        ],
      );

      // act
      final entity = model.toEntity();

      // assert
      expect(entity.id, 'abc');
      expect(entity.name, 'Test');
      expect(entity.categories.length, 1);
      expect(entity.categories[0].name, 'Italia');
      expect(entity.menus.foods.length, 1);
      expect(entity.menus.foods[0].name, 'Nasi Goreng');
      expect(entity.menus.drinks.length, 1);
      expect(entity.customerReviews.length, 1);
      expect(entity.customerReviews[0].review, 'Good');
    });
  });
}
