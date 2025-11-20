import 'package:flutter/material.dart';
import '../navigation/appHeader.dart';
import 'package:percent_indicator/percent_indicator.dart';


class homeScreen extends StatelessWidget {
  const homeScreen({super.key});
  //temp details will be from table
  final int calories = 850;
  final int calorieGoal = 2200;

  final int carbs = 120;
  final int carbGoal = 250;

  final int protein = 40;
  final int proteinGoal = 150;

  final int fat = 30;
  final int fatGoal = 70;


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
              percent: calories / calorieGoal,
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
                    percent: carbs / carbGoal,
                    animation: true,
                    circularStrokeCap: CircularStrokeCap.butt,
                    progressColor: Colors.blue,
                    backgroundColor: Colors.grey,
                    center: Text(
                      "${((carbs / carbGoal) * 100).round()}%",
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
                    percent: protein / proteinGoal,
                    animation: true,
                    circularStrokeCap: CircularStrokeCap.butt,
                    progressColor: Colors.red,
                    backgroundColor: Colors.grey,
                    center: Text(
                      "${((protein / proteinGoal) * 100).round()}%",
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
                    percent: fat / fatGoal,
                    animation: true,
                    circularStrokeCap: CircularStrokeCap.butt,
                    progressColor: Colors.purple,
                    backgroundColor: Colors.grey,
                    center: Text(
                      "${((fat / fatGoal) * 100).round()}%",
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