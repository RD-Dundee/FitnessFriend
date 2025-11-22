import 'package:flutter/material.dart';
import '../navigation/appHeader.dart';     
import '../addTabs/addSavedMeals.dart';
import '../addTabs/addManual.dart';

class addScreen extends StatelessWidget {
  const addScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: appHeader(),
        body: Column(
          children: [
            const TabBar(
              labelColor: Colors.orange,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: "Add Meal"),
                Tab(text: "Add Food"),
              ],
            ),

            Expanded(
              child: const TabBarView(
                children: [
                  addSavedMeal(),
                  addManual(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
