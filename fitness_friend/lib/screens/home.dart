import 'package:flutter/material.dart';
import '../navigation/appHeader.dart';

class homeScreen extends StatelessWidget {
  const homeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: appHeader(),
      body: Center(
        child: Text(
          "Home page",
        )
      )
    );
  }
}