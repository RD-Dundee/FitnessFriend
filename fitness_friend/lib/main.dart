import 'package:flutter/material.dart';
import 'navigation/navBar.dart';

void main() {
  runApp(const MyApp());
} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF2E5A88),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF2E5A88),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const navBar(),
    );
  }
}
