import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter/presentation/pages/main_page.dart';
import 'package:restaurant_flutter/presentation/providers/main_index_provider.dart';
import 'package:restaurant_flutter/presentation/providers/favorite_provider.dart';
import 'package:restaurant_flutter/presentation/providers/restaurant_list_provider.dart';
import 'package:restaurant_flutter/presentation/providers/theme_provider.dart';
import 'package:restaurant_flutter/presentation/providers/reminder_provider.dart';
import 'package:restaurant_flutter/domain/entities/restaurant.dart';
import 'package:restaurant_flutter/domain/usecases/get_restaurant_list.dart';
import 'package:restaurant_flutter/domain/usecases/get_favorite_restaurants.dart';
import 'package:restaurant_flutter/domain/usecases/add_favorite_restaurant.dart';
import 'package:restaurant_flutter/domain/usecases/remove_favorite_restaurant.dart';
import 'package:restaurant_flutter/domain/usecases/is_favorite_restaurant.dart';
import 'package:restaurant_flutter/domain/repositories/restaurant_repository.dart';
import 'package:restaurant_flutter/domain/repositories/favorite_repository.dart';
import 'package:restaurant_flutter/domain/entities/restaurant_detail.dart';
import 'package:restaurant_flutter/presentation/pages/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Fake ReminderProvider that doesn't depend on NotificationHelper/AlarmManager
class FakeReminderProvider extends ReminderProvider {
  bool _fakeValue = false;

  @override
  bool get isDailyReminderOn => _fakeValue;

  @override
  Future<void> toggleDailyReminder(bool value) async {
    _fakeValue = value;
    notifyListeners();
  }
}

// Fake implementations for testing
class FakeRestaurantRepository implements RestaurantRepository {
  @override
  Future<List<Restaurant>> getRestaurantList() async {
    return [
      const Restaurant(
        id: '1',
        name: 'Test Restaurant',
        description: 'Test Description',
        pictureId: '14',
        city: 'Jakarta',
        rating: 4.5,
      ),
    ];
  }

  @override
  Future<RestaurantDetail> getRestaurantDetail(String id) async {
    throw UnimplementedError();
  }
}

class FakeFavoriteRepository implements FavoriteRepository {
  @override
  Future<List<Restaurant>> getFavorites() async => [];
  @override
  Future<void> addFavorite(Restaurant restaurant) async {}
  @override
  Future<void> removeFavorite(String id) async {}
  @override
  Future<bool> isFavorite(String id) async => false;
}

Widget createTestApp() {
  final fakeRestaurantRepo = FakeRestaurantRepository();
  final fakeFavoriteRepo = FakeFavoriteRepository();

  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => MainIndexProvider()),
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider<ReminderProvider>(
        create: (_) => FakeReminderProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => RestaurantListProvider(
          getRestaurantList: GetRestaurantList(fakeRestaurantRepo),
        ),
      ),
      ChangeNotifierProvider(
        create: (_) => FavoriteProvider(
          getFavoriteRestaurants: GetFavoriteRestaurants(fakeFavoriteRepo),
          addFavoriteRestaurant: AddFavoriteRestaurant(fakeFavoriteRepo),
          removeFavoriteRestaurant: RemoveFavoriteRestaurant(fakeFavoriteRepo),
          isFavoriteRestaurant: IsFavoriteRestaurant(fakeFavoriteRepo),
        ),
      ),
    ],
    child: const MaterialApp(home: MainPage()),
  );
}

Widget createSettingsTestApp({FakeReminderProvider? reminderProvider}) {
  final fakeReminder = reminderProvider ?? FakeReminderProvider();

  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider<ReminderProvider>(create: (_) => fakeReminder),
    ],
    child: const MaterialApp(home: SettingsPage()),
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('MainPage should display bottom navigation with 3 tabs', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createTestApp());
    await tester.pumpAndSettle();

    // Verify NavigationBar with 3 destinations exists
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationDestination), findsNWidgets(3));
    expect(find.text('Favorites'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('Tapping Favorites tab should switch to favorites page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createTestApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Favorites'));
    await tester.pumpAndSettle();

    expect(find.text('Your favorite restaurants'), findsOneWidget);
  });

  testWidgets('Tapping Settings tab should show settings page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createTestApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Dark Theme'), findsOneWidget);
    expect(find.text('Daily Reminder'), findsOneWidget);
  });

  group('Daily Reminder (Push Notification) in Settings', () {
    testWidgets('Daily Reminder switch should be off by default', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createSettingsTestApp());
      await tester.pumpAndSettle();

      // Verify the reminder switch exists and is off
      expect(find.text('Daily Reminder'), findsOneWidget);
      expect(find.text('Reminder is off'), findsOneWidget);

      // The Switch widget should be in off state
      final switchFinder = find.byType(Switch);
      // There are 2 switches (theme + reminder), check the second one
      final reminderSwitch = tester.widget<Switch>(switchFinder.at(1));
      expect(reminderSwitch.value, isFalse);
    });

    testWidgets(
      'Tapping Daily Reminder switch should toggle it on and update subtitle',
      (WidgetTester tester) async {
        await tester.pumpWidget(createSettingsTestApp());
        await tester.pumpAndSettle();

        // Initially off
        expect(find.text('Reminder is off'), findsOneWidget);

        // Tap the reminder switch (second Switch in the page)
        final switchFinder = find.byType(Switch);
        await tester.tap(switchFinder.at(1));
        await tester.pumpAndSettle();

        // Should now be on with updated subtitle
        expect(find.text('Reminder at 11:00 AM is on'), findsOneWidget);

        final reminderSwitch = tester.widget<Switch>(switchFinder.at(1));
        expect(reminderSwitch.value, isTrue);
      },
    );

    testWidgets(
      'Toggling Daily Reminder on then off should return to off state',
      (WidgetTester tester) async {
        await tester.pumpWidget(createSettingsTestApp());
        await tester.pumpAndSettle();

        final switchFinder = find.byType(Switch);

        // Toggle ON
        await tester.tap(switchFinder.at(1));
        await tester.pumpAndSettle();
        expect(find.text('Reminder at 11:00 AM is on'), findsOneWidget);

        // Toggle OFF
        await tester.tap(switchFinder.at(1));
        await tester.pumpAndSettle();
        expect(find.text('Reminder is off'), findsOneWidget);

        final reminderSwitch = tester.widget<Switch>(switchFinder.at(1));
        expect(reminderSwitch.value, isFalse);
      },
    );
  });
}
