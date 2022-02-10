import 'package:flutter/material.dart';

import '../constants/constants.dart';

class MainBottomNavigation extends StatelessWidget {
  const MainBottomNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '/';
    return BottomAppBar(
      child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: currentRoute == purchasesPage
                    ? null
                    : () {
                        Navigator.of(context).pushReplacementNamed('/');
                      },
                icon: const Icon(Icons.calendar_today_rounded)),
            IconButton(
                onPressed: currentRoute == cataloguePage
                    ? null
                    : () {
                        Navigator.of(context)
                            .pushReplacementNamed('/catalogue');
                      },
                icon: const Icon(Icons.amp_stories)),
          ]),
      shape: const CircularNotchedRectangle(),
      notchMargin: 5.0,
    );
  }
}
