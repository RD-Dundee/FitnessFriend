import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../security/encrypt.dart';

class AppDatabase {
  static Database? _db;
  static AppDatabase? _instance;

  AppDatabase._internal();    
  
  factory AppDatabase() {
    _instance ??= AppDatabase._internal();
    return _instance!;
  }

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
        
        await db.insert("goals", {
          "id": 1,
          "calorieGoal": 2000,
          "proteinGoal": 150,
          "carbGoal": 250,
          "fatGoal": 70,
          "updatedAt": DateTime.now().millisecondsSinceEpoch,
        });
      }
    );

    return _db!;
  }

  Future<Map<String, dynamic>> getGoals() async {
    try {
      final db = await getDatabase();
      final result = await db.query("goals", limit: 1);

      return result.isNotEmpty ? result.first : {
        "calorieGoal": 2000,
        "carbGoal": 250,
        "proteinGoal": 150,
        "fatGoal": 70,
      };
    } catch (e) {
      print("Error getting goals: $e");
      return {
        "calorieGoal": 2000,
        "carbGoal": 250,
        "proteinGoal": 150,
        "fatGoal": 70,
      };
    }
  }

  Future<Map<String, dynamic>> getTodayTotals() async {
    try {
      final db = await getDatabase();
      final today = DateTime.now();
      final dateString = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

      final result = await db.rawQuery('''
        SELECT 
          SUM(calories) AS totalCalories,
          SUM(carbs) AS totalCarbs,
          SUM(protein) AS totalProtein,
          SUM(fat) AS totalFat
        FROM loggedMeals
        WHERE date = ?
      ''', [dateString]);

      return {
        "calories": result.first["totalCalories"] ?? 0,
        "carbs": result.first["totalCarbs"] ?? 0,
        "protein": result.first["totalProtein"] ?? 0,
        "fat": result.first["totalFat"] ?? 0,
      };
    } catch (e) {
      print("Error getting today totals: $e");
      return {
        "calories": 0,
        "carbs": 0,
        "protein": 0,
        "fat": 0,
      };
    }
  }

  Future<void> insertSavedMeal(Map<String, dynamic> data) async {
    final db = await getDatabase();
    
    final encryptedData = Map<String, dynamic>.from(data);
    if (data["name"] != null) {
      encryptedData["name"] = securityHelper.encrypt(data["name"]);
    }
    
    await db.insert("savedMeals", encryptedData);
  }

  Future<void> insertLoggedMeal(Map<String, dynamic> data) async {
    final db = await getDatabase();
    
    final encryptedData = Map<String, dynamic>.from(data);
    if (data["name"] != null) {
      encryptedData["name"] = securityHelper.encrypt(data["name"]);
    }
    
    await db.insert("loggedMeals", encryptedData);
  }


  Future<List<Map<String, dynamic>>> getTodayLoggedMeals() async {
    final db = await getDatabase();
    final now = DateTime.now();
    final dateString = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    final results = await db.query(
      "loggedMeals",
      where: "date = ?",
      whereArgs: [dateString],
      orderBy: "timestamp ASC",
    );

    return results.map((meal) {
      final name = meal["name"];
      if (name != null && name is String) {
        meal["name"] = securityHelper.decrypt(name);
      }
      return meal;
    }).toList();
  }


  Future<void> logPortionMeal(Map<String, dynamic> data) async {
    final db = await getDatabase();
    
    final encryptedData = Map<String, dynamic>.from(data);
    if (data["name"] != null) {
      encryptedData["name"] = securityHelper.encrypt(data["name"]);
    }
    
    await db.insert("loggedMeals", encryptedData);
  }


  Future<List<Map<String, dynamic>>> getSavedMeals() async {
    final db = await getDatabase();
    final results = await db.query("savedMeals", orderBy: "created_at DESC");
    
    return results.map((meal) {
      if (meal["name"] != null) {
        meal["name"] = securityHelper.decrypt(meal["name"] as String); 
      }
      return meal;
    }).toList();
  }


}