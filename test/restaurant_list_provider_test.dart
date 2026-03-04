import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_flutter/common/result_state.dart';
import 'package:restaurant_flutter/domain/entities/restaurant.dart';
import 'package:restaurant_flutter/domain/entities/restaurant_detail.dart';
import 'package:restaurant_flutter/domain/repositories/restaurant_repository.dart';
import 'package:restaurant_flutter/domain/usecases/get_restaurant_list.dart';
import 'package:restaurant_flutter/presentation/providers/restaurant_list_provider.dart';

// ---------- Fake repository implementations ----------

class FakeSuccessRestaurantRepository implements RestaurantRepository {
  @override
  Future<List<Restaurant>> getRestaurantList() async {
    return const [
      Restaurant(
        id: '1',
        name: 'Resto A',
        description: 'Deskripsi A',
        pictureId: 'pic1',
        city: 'Jakarta',
        rating: 4.5,
      ),
      Restaurant(
        id: '2',
        name: 'Resto B',
        description: 'Deskripsi B',
        pictureId: 'pic2',
        city: 'Bandung',
        rating: 4.0,
      ),
    ];
  }

  @override
  Future<RestaurantDetail> getRestaurantDetail(String id) async =>
      throw UnimplementedError();
}

class FakeErrorRestaurantRepository implements RestaurantRepository {
  @override
  Future<List<Restaurant>> getRestaurantList() async {
    throw Exception('Gagal mengambil data restoran');
  }

  @override
  Future<RestaurantDetail> getRestaurantDetail(String id) async =>
      throw UnimplementedError();
}

class FakeEmptyRestaurantRepository implements RestaurantRepository {
  @override
  Future<List<Restaurant>> getRestaurantList() async {
    return [];
  }

  @override
  Future<RestaurantDetail> getRestaurantDetail(String id) async =>
      throw UnimplementedError();
}

// ---------- Tests ----------

void main() {
  group('RestaurantListProvider', () {
    test('state awal provider harus ResultLoading', () {
      // Arrange — buat provider (constructor langsung panggil fetchRestaurantList)
      final useCase = GetRestaurantList(FakeSuccessRestaurantRepository());
      final provider = RestaurantListProvider(getRestaurantList: useCase);

      // Assert — sebelum future selesai, state masih Loading
      expect(provider.state, isA<ResultLoading>());
    });

    test(
      'harus mengembalikan daftar restoran ketika pengambilan data API berhasil',
      () async {
        // Arrange
        final useCase = GetRestaurantList(FakeSuccessRestaurantRepository());
        final provider = RestaurantListProvider(getRestaurantList: useCase);

        // Act — tunggu fetchRestaurantList selesai
        await provider.fetchRestaurantList();

        // Assert
        expect(provider.state, isA<ResultLoaded<List<Restaurant>>>());

        final loaded = provider.state as ResultLoaded<List<Restaurant>>;
        expect(loaded.data.length, 2);
        expect(loaded.data.first.name, 'Resto A');
        expect(loaded.data.last.city, 'Bandung');
      },
    );

    test(
      'harus mengembalikan kesalahan ketika pengambilan data API gagal',
      () async {
        // Arrange
        final useCase = GetRestaurantList(FakeErrorRestaurantRepository());
        final provider = RestaurantListProvider(getRestaurantList: useCase);

        // Act
        await provider.fetchRestaurantList();

        // Assert
        expect(provider.state, isA<ResultError<List<Restaurant>>>());

        final error = provider.state as ResultError<List<Restaurant>>;
        expect(error.message, contains('Gagal mengambil data restoran'));
      },
    );

    test(
      'harus mengembalikan list kosong ketika API berhasil tapi tidak ada data',
      () async {
        // Arrange
        final useCase = GetRestaurantList(FakeEmptyRestaurantRepository());
        final provider = RestaurantListProvider(getRestaurantList: useCase);

        // Act
        await provider.fetchRestaurantList();

        // Assert
        expect(provider.state, isA<ResultLoaded<List<Restaurant>>>());

        final loaded = provider.state as ResultLoaded<List<Restaurant>>;
        expect(loaded.data, isEmpty);
      },
    );
  });
}
