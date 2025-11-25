import 'package:flutter/material.dart';
import '../tables/database.dart';

class loggedMeals extends StatefulWidget {
  const loggedMeals({super.key});

  @override
  State<loggedMeals> createState() => _loggedMealsState();
}

class _loggedMealsState extends State<loggedMeals> {
  List<String> hours = [];
  Map<String, List<Map<String, dynamic>>> mealsByHour = {};

  @override
  void initState() {
    super.initState();
    generateHours();
    loadMeals();
  }

  void generateHours() {
    hours = List.generate(
      24,
      (i) => "${i.toString().padLeft(2, '0')}:00",
    );
  }

  Future<void> loadMeals() async {
    final db = await AppDatabase.getDatabase();

    final today = DateTime.now();
    final dateString =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    final data = await db.query(
      "loggedMeals",
      where: "date = ?",
      whereArgs: [dateString],
      orderBy: "timestamp ASC",
    );

    Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var meal in data) {
      //fix
      final rawTs = meal["timestamp"];
      final ts = DateTime.fromMillisecondsSinceEpoch(
        (rawTs is int) ? rawTs : int.tryParse(rawTs.toString()) ?? 0
      );
      //this part
      final hourKey = "${ts.hour.toString().padLeft(2, '0')}:00";

      grouped.putIfAbsent(hourKey, () => []);
      grouped[hourKey]!.add(meal);
    }

    setState(() {
      mealsByHour = grouped;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Logged Meals")),
      body: ListView.builder(
        itemCount: hours.length,
        itemBuilder: (context, index) {
          final hour = hours[index];
          final meals = mealsByHour[hour] ?? [];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hour,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                if (meals.isEmpty)
                  Container(
                    height: 1,
                    color: Colors.grey.shade300,
                    margin: const EdgeInsets.only(bottom: 10),
                  )
                else
                  Column(
                    children: meals.map((meal) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  meal["name"] ?? "Unnamed Meal",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  "${meal["carbs"]}C  •  ${meal["protein"]}P  •  ${meal["fat"]}F",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "${meal["calories"]} kcal",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                const Divider(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}