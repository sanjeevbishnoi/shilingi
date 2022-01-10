import 'package:flutter/material.dart';

import '../models/model.dart' as model;
import '../components/components.dart';

class PurchasesPage extends StatefulWidget {
  const PurchasesPage([Key? key]) : super(key: key);

  @override
  State createState() => _PurchasesPageState();
}

class _PurchasesPageState extends State<PurchasesPage> {
  final List<model.Purchase> purchases = [
    model.Purchase(
      market: "Quickmart",
      date: DateTime.now().subtract(const Duration(days: 1)),
      items: [],
    ),
    model.Purchase(
      market: "Ruiru Market",
      date: DateTime.now().subtract(const Duration(days: 2)),
      items: [],
    ),
    model.Purchase(
      market: "Carrefour",
      date: DateTime.now().subtract(const Duration(days: 5)),
      items: [],
    ),
    model.Purchase(
      market: "Naivas",
      date: DateTime.now().subtract(const Duration(days: 10)),
      items: [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shilingi')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView(children: [
          for (var purchase in purchases) ...[
            WPurchase(purchase),
            const SizedBox(height: 12.0)
          ],
        ]),
      ),
      backgroundColor: const Color(0xFFF8F8F8),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, '/new-purchase');
          }),
    );
  }
}
