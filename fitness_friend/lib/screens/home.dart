import 'package:flutter/material.dart';
import '../navigation/appHeader.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../tables/database.dart';

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
  int calorieGoal = 1;
  int carbGoal = 1;
  int proteinGoal = 1;
  int fatGoal = 1;

  @override
  void initState() {
    super.initState();
    loadProgress();
  }

  Future<void> loadProgress() async {
    final totals = await AppDatabase().getTodayTotals();
    final goals = await AppDatabase().getGoals();

    setState(() {
      calories = totals["calories"] as int;
      carbs = totals["carbs"] as int;
      protein = totals["protein"] as int;
      fat = totals["fat"] as int;

      calorieGoal = goals["calorieGoal"] as int;
      carbGoal = goals["carbGoal"] as int;
      proteinGoal = goals["proteinGoal"] as int;
      fatGoal = goals["fatGoal"] as int;
    });
  }

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      appBar: appHeader(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

          const SizedBox(height: 40), 

          Center(
            child: CircularPercentIndicator(
              radius: 110,
              lineWidth: 18,
              percent: calorieGoal > 0 ? (calories / calorieGoal).clamp(0.0, 1.0) : 0.0,
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
          ),

          const SizedBox(height: 30),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  CircularPercentIndicator(
                    radius: 55,
                    lineWidth: 10,
                    percent: carbGoal > 0 ? (carbs / carbGoal).clamp(0.0, 1.0) : 0.0,
                    animation: true,
                    circularStrokeCap: CircularStrokeCap.butt,
                    progressColor: Colors.blue,
                    backgroundColor: Colors.grey,
                    center: Text(
                      carbGoal > 0 ? "${((carbs / carbGoal) * 100).round()}%" : "0%",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text("$carbs / $carbGoal g"),
                  const Text("Carbs"),
                ],
              ),

              Column(
                children: [
                  CircularPercentIndicator(
                    radius: 55,
                    lineWidth: 10,
                    percent: proteinGoal > 0 ? (protein / proteinGoal).clamp(0.0, 1.0) : 0.0,
                    animation: true,
                    circularStrokeCap: CircularStrokeCap.butt,
                    progressColor: Colors.red,
                    backgroundColor: Colors.grey,
                    center: Text(
                      proteinGoal > 0 ? "${((protein / proteinGoal) * 100).round()}%" : "0%",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text("$protein / $proteinGoal g"),
                  const Text("Protein"),
                ],
              ),

              Column(
                children: [
                  CircularPercentIndicator(
                    radius: 55,
                    lineWidth: 10,
                    percent: fatGoal > 0 ? (fat / fatGoal).clamp(0.0, 1.0) : 0.0,
                    animation: true,
                    circularStrokeCap: CircularStrokeCap.butt,
                    progressColor: Colors.purple,
                    backgroundColor: Colors.grey,
                    center: Text(
                      fatGoal > 0 ? "${((fat / fatGoal) * 100).round()}%" : "0%",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text("$fat / $fatGoal g"),
                  const Text("Fat"),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          Container(
            height: 3,
            width: double.infinity,
            color: Colors.grey.shade400,
          ),

          const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}