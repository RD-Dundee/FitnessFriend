import 'package:flutter/material.dart';
import '../navigation/appHeader.dart';

class addScreen extends StatelessWidget {
  const addScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: appHeader(),
      body: Center(
        child: Text(
          "Add page",
        )
      )
    );
  }
}