import 'package:flutter/material.dart';

class NewPurchasePage extends StatefulWidget {
  const NewPurchasePage([Key? key]) : super(key: key);

  @override
  State createState() => _NewPurchasePageState();
}

class _NewPurchasePageState extends State<NewPurchasePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('New purchase')),
        backgroundColor: const Color(0xFFF8F8F8),
        body: const Center(child: Text('New purchase')));
  }
}
