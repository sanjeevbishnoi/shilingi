import 'package:flutter/material.dart';

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
      ),
      home: const SafeArea(child: Main()),
    );
  }
}

class Main extends StatelessWidget {
  const Main([Key? key]) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shilingi')),
      body: const PurchasesPage(),
      backgroundColor: const Color(0xFFF8F8F8),
    );
  }
}
