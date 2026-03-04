import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_flutter/presentation/providers/main_index_provider.dart';

void main() {
  group('MainIndexProvider', () {
    late MainIndexProvider provider;

    setUp(() {
      provider = MainIndexProvider();
    });

    test('initial index should be 0', () {
      expect(provider.currentIndex, 0);
    });

    test('setIndex should update currentIndex', () {
      // act
      provider.setIndex(1);

      // assert
      expect(provider.currentIndex, 1);
    });

    test('setIndex should notify listeners', () {
      // arrange
      bool notified = false;
      provider.addListener(() {
        notified = true;
      });

      // act
      provider.setIndex(2);

      // assert
      expect(notified, true);
      expect(provider.currentIndex, 2);
    });

    test('setIndex to same value should still notify', () {
      // arrange
      provider.setIndex(1);
      bool notified = false;
      provider.addListener(() {
        notified = true;
      });

      // act
      provider.setIndex(1);

      // assert
      expect(notified, true);
    });
  });
}
