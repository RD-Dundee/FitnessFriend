import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static Database? _db;

  static Future<Database> getDatabase() async {
    if (_db != null) return _db!;

    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, "fitnessFriend.db");

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE savedMeals(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            totalWeight INTEGER,
            calories INTEGER NOT NULL,
            protein INTEGER,
            carbs INTEGER,
            fat INTEGER,
            created_at INTEGER
          );
        ''');

        await db.execute('''
          CREATE TABLE loggedMeals(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              savedMealId INTEGER,
              name TEXT,
              calories INTEGER NOT NULL,
              protein INTEGER,
              carbs INTEGER,
              fat INTEGER,
              weight INTEGER,
              timestamp INTEGER NOT NULL,
              date TEXT NOT NULL,
              FOREIGN KEY (savedMealId) REFERENCES savedMeals(id)
            );
        ''');
        await db.execute('''
          CREATE TABLE goals(
            id INTEGER PRIMARY KEY,
            calorieGoal INTEGER,
            proteinGoal INTEGER,
            carbGoal INTEGER,
            fatGoal INTEGER,
            updatedAt INTEGER
          );
        ''');
    
      }
    );

    return  _db!;
  }
}  