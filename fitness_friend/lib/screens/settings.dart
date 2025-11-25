import 'package:flutter/material.dart';
import '../tables/database.dart';

class settings extends StatefulWidget {
  const settings({super.key});

  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {
  final calorieCtrl = TextEditingController();
  final proteinCtrl = TextEditingController();
  final carbCtrl = TextEditingController();
  final fatCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadCurrentGoals();
  }

  Future<void> loadCurrentGoals() async {
    final goals = await AppDatabase().getGoals();
    setState(() {
      calorieCtrl.text = goals["calorieGoal"].toString();
      proteinCtrl.text = goals["proteinGoal"].toString();
      carbCtrl.text = goals["carbGoal"].toString();
      fatCtrl.text = goals["fatGoal"].toString();
    });
  }

  Future<void> updateGoals() async {
    final db = await AppDatabase.getDatabase();
    await db.update(
      "goals",
      {
        "calorieGoal": int.tryParse(calorieCtrl.text) ?? 2000,
        "proteinGoal": int.tryParse(proteinCtrl.text) ?? 150,
        "carbGoal": int.tryParse(carbCtrl.text) ?? 250,
        "fatGoal": int.tryParse(fatCtrl.text) ?? 70,
        "updatedAt": DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [1],
    );
    
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Goals updated")));
      
  } 

  Future<void> clearAllData() async {
    final db = await AppDatabase.getDatabase();
    await db.delete("loggedMeals");
    await db.delete("savedMeals");
    
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Data cleared")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text("Daily Goals", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          TextField(controller: calorieCtrl, decoration: const InputDecoration(labelText: "Calorie Goal"), keyboardType: TextInputType.number),
          TextField(controller: proteinCtrl, decoration: const InputDecoration(labelText: "Protein Goal (g)"), keyboardType: TextInputType.number),
          TextField(controller: carbCtrl, decoration: const InputDecoration(labelText: "Carb Goal (g)"), keyboardType: TextInputType.number),
          TextField(controller: fatCtrl, decoration: const InputDecoration(labelText: "Fat Goal (g)"), keyboardType: TextInputType.number),
          ElevatedButton(onPressed: updateGoals, child: const Text("Update Goals")),
          
          const SizedBox(height: 30),
          
          const Text("Data Management", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: clearAllData,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Clear All Data", style: TextStyle(color: Colors.white)),
          ),

        ],
      ),
    );
  }
}
