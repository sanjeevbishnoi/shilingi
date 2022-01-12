import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import './src/pages/pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shilingi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.rubikTextTheme(),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const PurchasesPage(),
        '/new-purchase': (context) => const NewPurchasePage()
      },
    );
  }
}
