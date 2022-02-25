import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

var statFormat = NumberFormat('#,##0.00', 'en_US');

class StatCard extends StatelessWidget {
  final String title;
  final double value;

  const StatCard({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(6.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              statFormat.format(value),
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 12.0),
            ),
          ],
        ),
      ),
    );
  }
}
