import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

import '../models/model.dart' as model;
import '../components/components.dart';
import '../gql/gql.dart' as queries;

class PurchasesPage extends StatefulWidget {
  const PurchasesPage([Key? key]) : super(key: key);

  @override
  State createState() => _PurchasesPageState();
}

class _PurchasesPageState extends State<PurchasesPage> {
  List<model.Purchase> purchases = [
    model.Purchase(
      vendor: const model.Vendor(name: "Quickmart"),
      date: DateTime.now().subtract(const Duration(days: 1)),
      items: [],
    ),
    model.Purchase(
      vendor: const model.Vendor(name: "Ruiru Market"),
      date: DateTime.now().subtract(const Duration(days: 2)),
      items: [],
    ),
    model.Purchase(
      vendor: const model.Vendor(name: "Carrefour"),
      date: DateTime.now().subtract(const Duration(days: 5)),
      items: [],
    ),
    model.Purchase(
      vendor: const model.Vendor(name: "Naivas"),
      date: DateTime.now().subtract(const Duration(days: 10)),
      items: [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shilingi')),
      body: Query(
          options: QueryOptions(document: queries.purchasesQuery),
          builder: (QueryResult result,
              {Refetch? refetch, FetchMore? fetchMore}) {
            if (result.isLoading && result.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (result.data != null) {
              var p = model.Purchases.fromJson(result.data!);
              return ListView(children: [
                const SizedBox(height: 12.0),
                for (var purchase in p.purchases) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: WPurchase(purchase),
                  ),
                  const SizedBox(height: 12.0),
                ],
              ]);
            }
            return const Center(
              child: Text('unable to load your purchases'),
            );
          }),
      backgroundColor: const Color(0xFFF8F8F8),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, '/new-purchase');
          }),
    );
  }
}
