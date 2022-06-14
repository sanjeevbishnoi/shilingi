import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class ClassicBottomNavigation extends StatelessWidget {
  const ClassicBottomNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '/';
    var currentIndex = 0;
    switch (currentRoute) {
      case '/':
        currentIndex = 0;
        break;
      case '/catalogue':
        currentIndex = 1;
        break;
      case '/shopping-list':
        currentIndex = 2;
        break;
    }

    return BottomNavigationBar(
      currentIndex: currentIndex,
      unselectedItemColor: Colors.black54,
      selectedItemColor: Colors.lightGreen,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_rounded), label: 'Purchases'),
        BottomNavigationBarItem(
            icon: Icon(Icons.amp_stories), label: 'Catalogue'),
        BottomNavigationBarItem(
            icon: Icon(Icons.checklist), label: 'Shopping lists'),
        BottomNavigationBarItem(
            icon: Icon(FeatherIcons.logOut), label: 'Logout'),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.of(context).pushReplacementNamed('/');
            break;
          case 1:
            Navigator.of(context).pushReplacementNamed('/catalogue');
            break;
          case 2:
            Navigator.of(context).pushReplacementNamed('/shopping-list');
            break;
          case 3:
            FirebaseAuth.instance.signOut();
            break;
        }
      },
    );
  }
}
