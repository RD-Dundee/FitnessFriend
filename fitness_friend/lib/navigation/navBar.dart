import 'package:flutter/material.dart';
import '../screens/home.dart';
import '../screens/add.dart';
import '../screens/loggedMeals.dart';

class navBar extends StatefulWidget {
  const navBar({super.key});

  @override
  State<navBar> createState() => _navBarState();
}

class _navBarState extends State<navBar> {
  int _currentIndex = 0;

  final List<Widget> pages = [
    homeScreen(),
    addScreen(),
    loggedMeals(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(

        currentIndex: _currentIndex,

        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home'
            ),

          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add'
            ),

          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Logged'
            ),
        ],
        
        ),
    );
  }
}