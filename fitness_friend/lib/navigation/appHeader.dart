import 'package:flutter/material.dart';
import '../screens/settings.dart';

class appHeader extends StatelessWidget implements PreferredSizeWidget {
  const appHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("FitnessFriend"),
      actions: [ 
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const settings())
            );
          }, 
          icon: Icon(Icons.settings),
        ),
      ],
    );
  }

  @override 
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}