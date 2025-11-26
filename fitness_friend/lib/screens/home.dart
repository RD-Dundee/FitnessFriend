import 'package:flutter/material.dart';
import '../navigation/appHeader.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../tables/database.dart';
import 'package:sqflite/sqflite.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => homeScreenState();
}

class homeScreenState extends State<homeScreen> {
  int calories = 0;
  int carbs = 0;
  int protein = 0;
  int fat = 0;
  int calorieGoal = 0;
  int carbGoal = 0;
  int proteinGoal = 0;
  int fatGoal = 0;

  List<Map<String, dynamic>> savedMeals = [];
  final weightCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProgress();
    loadSavedMeals();
    insertExampleMeal();
  }

  Future<void> loadProgress() async {
    final totals = await AppDatabase().getTodayTotals();
    final goals = await AppDatabase().getGoals();

    setState(() {
      calories = totals["calories"];
      carbs = totals["carbs"];
      protein = totals["protein"];
      fat = totals["fat"];

      calorieGoal = goals["calorieGoal"];
      carbGoal = goals["carbGoal"];
      proteinGoal = goals["proteinGoal"];
      fatGoal = goals["fatGoal"];
    });
  }

  Future<void> loadSavedMeals() async {
    final db = await AppDatabase.getDatabase();
    final result = await db.query("savedMeals", orderBy: "created_at DESC");
    setState(() => savedMeals = result);
  }

  Future<void> insertExampleMeal() async {
    final db = await AppDatabase.getDatabase();
    final count = Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM savedMeals"));

    if (count == 0) {
      await db.insert("savedMeals", {
        "name": "Chicken & Rice",
        "totalWeight": 300,
        "calories": 450,
        "protein": 40,
        "carbs": 55,
        "fat": 8,
        "created_at": DateTime.now().millisecondsSinceEpoch
      });
      await loadSavedMeals();
    }
  }

  Future<void> logPortion(Map<String, dynamic> meal, TextEditingController weightCtrl) async {
    final enteredWeight = int.tryParse(weightCtrl.text) ?? 0;
    if (enteredWeight == 0) return;

    final scale = enteredWeight / (meal["totalWeight"] ?? 1);

    final now = DateTime.now();
    final date = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    final db = await AppDatabase.getDatabase();
    await db.insert("loggedMeals", {
      "savedMealId": meal["id"],
      "name": meal["name"],
      "calories": (meal["calories"] * scale).round(),
      "protein": (meal["protein"] * scale).round(),
      "carbs": (meal["carbs"] * scale).round(),
      "fat": (meal["fat"] * scale).round(),
      "weight": enteredWeight,
      "timestamp": now.millisecondsSinceEpoch,
      "date": date
    });

    weightCtrl.clear();
    await loadProgress();
    
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Meal logged successfully!")));
  }

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      appBar: appHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [

            Card(
              margin: EdgeInsets.all(16),
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircularPercentIndicator(
                      radius: 110,
                      lineWidth: 18,
                      percent: calorieGoal == 0 ? 0 : (calories / calorieGoal).clamp(0.0, 1.0),
                      animation: true,
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: Colors.orange,
                      backgroundColor: Colors.grey.shade300,
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "$calories",
                            style: const TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "/ $calorieGoal kcal",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          macroWheel(carbs, carbGoal, "Carbs", Colors.blue),
                          macroWheel(protein, proteinGoal, "Protein", Colors.red),
                          macroWheel(fat, fatGoal, "Fat", Colors.purple),
                        ],
                      ),
                    ),
                  ],
                ),
              
              ),
            ),

            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade400,
                    width: 3,
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  "Saved Meals",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            for (final meal in savedMeals) buildSavedMealCard(meal),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget macroWheel(int value, int goal, String label, Color color) {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 45,
          lineWidth: 10,
          percent: goal == 0 ? 0 : (value / goal).clamp(0.0, 1.0),
          animation: true,
          circularStrokeCap: CircularStrokeCap.butt,
          progressColor: color,
          backgroundColor: Colors.grey,
          center: Text(
            goal == 0 ? "0%" : "${((value / goal) * 100).round()}%",
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(height: 8),
        Text("$value / $goal g"),
        Text(label),
      ],
    );
  }

  Widget buildSavedMealCard(Map<String, dynamic> meal) {
    final localWeightCtrl = TextEditingController();
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12), 
        color: Colors.grey.shade100,
        border: Border.all(
          color: Colors.grey.shade400,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(meal["name"],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 5),
          Text("${meal["totalWeight"]}g • ${meal["calories"]} kcal • ${meal["protein"]}P • ${meal["carbs"]}C • ${meal["fat"]}F"),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: localWeightCtrl,
                  decoration: const InputDecoration(labelText: "Weight used (g)"),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => logPortion(meal, localWeightCtrl),
                child: const Text("Add"),
              ),
            ],
          )
        ],
      ),
    );
  }

}
