import 'package:flutter/material.dart';
import '../navigation/appHeader.dart';

class loggedMeals extends StatelessWidget {
  const loggedMeals({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: appHeader(),
      body: Center(
        child: Text(
          "logged meals",
        )
      )
    );
  }
}