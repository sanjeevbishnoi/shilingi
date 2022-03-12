import 'package:flutter/material.dart';
import 'package:shilingi/src/pages/settings/settings.dart';

import '../constants/constants.dart';

class DateRangeAnalytics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as AnalyticsForSettings;

    return Scaffold(
      backgroundColor: mainScaffoldBg,
      appBar: AppBar(title: const Text('Analytics')),
      body: Center(
          child: Text(
              'Analytics ${args.analyticsFor} ${args.month} ${args.after} ${args.before}')),
    );
  }
}
