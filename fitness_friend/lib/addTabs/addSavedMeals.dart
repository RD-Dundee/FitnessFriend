import 'package:flutter/material.dart';
import '../tables/database.dart';

class addSavedMeal extends StatefulWidget {
  const addSavedMeal({super.key});

  @override
  State<addSavedMeal> createState() => _addSavedMeal();
}

class _addSavedMeal extends State<addSavedMeal> {
  final nameCtrl = TextEditingController();
  final weightCtrl = TextEditingController();
  final caloriesCtrl = TextEditingController();
  final proteinCtrl = TextEditingController();
  final carbsCtrl = TextEditingController();
  final fatCtrl = TextEditingController();

  Future<void> addMeal() async {
    final db = await AppDatabase.getDatabase();

    final data = {
      "name": nameCtrl.text,
      "totalWeight": int.tryParse(weightCtrl.text) ?? 0,
      "calories": int.tryParse(caloriesCtrl.text) ?? 0,
      "protein": int.tryParse(proteinCtrl.text) ?? 0,
      "carbs": int.tryParse(carbsCtrl.text) ?? 0,
      "fat": int.tryParse(fatCtrl.text) ?? 0,
      "created_at": DateTime.now().millisecondsSinceEpoch
    };

    await db.insert("savedMeals", data);

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Saved meal added")));

    nameCtrl.clear();
    weightCtrl.clear();
    caloriesCtrl.clear();
    proteinCtrl.clear();
    carbsCtrl.clear();
    fatCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Meal Name")),
        TextField(controller: weightCtrl, decoration: const InputDecoration(labelText: "Weight (g)"), keyboardType: TextInputType.number),
        TextField(controller: caloriesCtrl, decoration: const InputDecoration(labelText: "Calories"), keyboardType: TextInputType.number),
        TextField(controller: proteinCtrl, decoration: const InputDecoration(labelText: "Protein (g)"), keyboardType: TextInputType.number),
        TextField(controller: carbsCtrl, decoration: const InputDecoration(labelText: "Carbs (g)"), keyboardType: TextInputType.number),
        TextField(controller: fatCtrl, decoration: const InputDecoration(labelText: "Fat (g)"), keyboardType: TextInputType.number),
        const SizedBox(height: 20),
        ElevatedButton(onPressed: addMeal, child: const Text("Save Meal")),
      ],
    );
  }
}
