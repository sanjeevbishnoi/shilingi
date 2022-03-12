import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

var statFormat = NumberFormat('#,##0.00', 'en_US');

class StatCard extends StatelessWidget {
  final String title;
  final double value;
  final Widget? goTo;
  final dynamic settings;

  const StatCard(
      {Key? key,
      required this.title,
      required this.value,
      this.goTo,
      this.settings})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Material(
        elevation: 2,
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(6.0),
          splashColor: Colors.black38,
          onTap: goTo != null
              ? () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => goTo!,
                        settings: RouteSettings(arguments: settings)),
                  );
                }
              : null,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        statFormat.format(value),
                        style: const TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        title,
                        style: const TextStyle(fontSize: 12.0),
                      ),
                    ],
                  ),
                ),
                if (goTo != null)
                  const Center(child: Icon(Icons.chevron_right)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
