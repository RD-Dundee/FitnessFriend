import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_friend/tables/database.dart';

void main() {
  // Initialize Flutter binding for database tests
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Database Operation Tests', () {
    test('Get goals returns default values', () async {
      final goals = await AppDatabase().getGoals();
      
      expect(goals['calorieGoal'], 2000);
      expect(goals['proteinGoal'], 150);
      expect(goals['carbGoal'], 250);
      expect(goals['fatGoal'], 70);
    });

    test('Get today totals returns valid structure', () async {
      final totals = await AppDatabase().getTodayTotals();
      
      expect(totals.containsKey('calories'), true);
      expect(totals.containsKey('carbs'), true);
      expect(totals.containsKey('protein'), true);
      expect(totals.containsKey('fat'), true);
      
      expect(totals['calories'] is int, true);
      expect(totals['carbs'] is int, true);
    });
  });
}
