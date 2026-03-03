import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:restaurant_flutter/domain/entities/restaurant.dart';

class FavoriteLocalDataSource {
  static const String _tableName = 'favorites';
  static const String _dbName = 'restaurant_favorites.db';
  static const int _dbVersion = 1;

  Database? _database;
  Completer<Database>? _completer;

  Future<Database> get database async {
    if (_database != null) return _database!;

    if (_completer != null) return _completer!.future;

    _completer = Completer<Database>();
    try {
      _database = await _initDatabase();
      _completer!.complete(_database!);
    } catch (e) {
      _completer!.completeError(e);
      _completer = null;
      rethrow;
    }
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            description TEXT NOT NULL,
            pictureId TEXT NOT NULL,
            city TEXT NOT NULL,
            rating REAL NOT NULL
          )
        ''');
      },
    );
  }

  Future<List<Restaurant>> getFavorites() async {
    final db = await database;
    final results = await db.query(_tableName);
    return results.map((map) => _fromMap(map)).toList();
  }

  Future<void> addFavorite(Restaurant restaurant) async {
    final db = await database;
    await db.insert(
      _tableName,
      _toMap(restaurant),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(String id) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> isFavorite(String id) async {
    final db = await database;
    final results = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty;
  }

  Map<String, dynamic> _toMap(Restaurant restaurant) {
    return {
      'id': restaurant.id,
      'name': restaurant.name,
      'description': restaurant.description,
      'pictureId': restaurant.pictureId,
      'city': restaurant.city,
      'rating': restaurant.rating,
    };
  }

  Restaurant _fromMap(Map<String, dynamic> map) {
    return Restaurant(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      pictureId: map['pictureId'] as String,
      city: map['city'] as String,
      rating: (map['rating'] as num).toDouble(),
    );
  }
}
