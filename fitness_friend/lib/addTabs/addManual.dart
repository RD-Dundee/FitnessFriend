import 'package:flutter/material.dart';
import '../tables/database.dart';

class addManual extends StatefulWidget {
  const addManual({super.key});

  @override
  State<addManual> createState() => _addManual();
}

class _addManual extends State<addManual> {
  final nameCtrl = TextEditingController();
  final caloriesCtrl = TextEditingController();
  final proteinCtrl = TextEditingController();
  final carbsCtrl = TextEditingController();
  final fatCtrl = TextEditingController();

  Future<void> saveMeal() async {
  final now = DateTime.now();
  final date = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

  final db = await AppDatabase.getDatabase();

  final data = {
    "savedMealId": null,
    "name": nameCtrl.text,
    "calories": int.tryParse(caloriesCtrl.text) ?? 0,
    "protein": int.tryParse(proteinCtrl.text) ?? 0,
    "carbs": int.tryParse(carbsCtrl.text) ?? 0,
    "fat": int.tryParse(fatCtrl.text) ?? 0,
    "weight": null,
    "timestamp": now.millisecondsSinceEpoch,
    "date": date
  };

  try {
    await db.insert("loggedMeals", data);
    print("Innsert success");
  } catch (e) {
    print("Insert failed..... Damn : $e");
  }

  ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(content: Text("Food added")));

  nameCtrl.clear();
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
        TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Add Food")),
        TextField(controller: caloriesCtrl, decoration: const InputDecoration(labelText: "Calories"), keyboardType: TextInputType.number),
        TextField(controller: proteinCtrl, decoration: const InputDecoration(labelText: "Protein (g)"), keyboardType: TextInputType.number),
        TextField(controller: carbsCtrl, decoration: const InputDecoration(labelText: "Carbs (g)"), keyboardType: TextInputType.number),
        TextField(controller: fatCtrl, decoration: const InputDecoration(labelText: "Fat (g)"), keyboardType: TextInputType.number),
        const SizedBox(height: 20),
        ElevatedButton(onPressed: saveMeal, child: const Text("Add Food")),
      ],
    );
  }
}
