import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

import '../gql/gql.dart' as queries;
import '../models/model.dart';
import './settings/settings.dart';
import '../constants/constants.dart';

var numberFormat = NumberFormat('#,##0.00', 'en_US');

class PurchaseDetailsPage extends StatelessWidget {
  const PurchaseDetailsPage({Key? key}) : super(key: key);
  static const String routeName = '/purchase-details';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as PurchaseDetailsRouteSettings;
    return Scaffold(
      appBar: AppBar(title: const Text('Purchase details')),
      body: Query(
        options: QueryOptions(document: queries.purchaseQuery, variables: {
          "id": args.purchaseId,
        }),
        builder: (QueryResult result,
            {Refetch? refetch, FetchMore? fetchMore}) {
          if (result.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (result.hasException) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(30.0),
                child: Text('Unable to retrieve purchase details'),
              ),
            );
          }
          var purchase = Purchase.fromJson(result.data!["node"]!);
          return _PurchaseDetailWidget(purchase: purchase);
        },
      ),
    );
  }
}

class PurchaseDetailsRouteSettings {
  final int purchaseId;

  const PurchaseDetailsRouteSettings({required this.purchaseId});
}

class _PurchaseDetailWidget extends StatelessWidget {
  final Purchase purchase;

  const _PurchaseDetailWidget({required this.purchase});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: ListView(
        children: [
          Row(children: [
            Container(
              width: 20.0,
              height: 20.0,
              decoration: const BoxDecoration(color: Colors.black12),
            ),
            const SizedBox(width: 10.0),
            Text(
              purchase.vendor!.name,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20.0,
              ),
            )
          ]),
          const SizedBox(height: 24.0),
          const Text(
            'Date',
            style: TextStyle(
              color: Colors.black38,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            DateFormat("EEE, MMM d, ''yy'").format(purchase.date.toLocal()),
          ),
          const SizedBox(height: 24.0),
          const Text(
            'Total',
            style: TextStyle(
              color: Colors.black38,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            'Kes ${numberFormat.format(purchase.total)}',
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 24.0),
          const Text(
            'Items',
            style: TextStyle(
              color: Colors.black38,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10.0),
          for (var item in purchase.items!)
            Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: Colors.black38,
                onTap: () {
                  Navigator.of(context).pushNamed(shoppingItemPage,
                      arguments: ShoppingItemRouteSettings(
                          itemId: item.item!.id!, name: item.item!.name));
                },
                child: ListTile(
                  minLeadingWidth: 20,
                  leading: const Icon(Icons.circle_rounded),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(item.item!.name),
                      ),
                      Text(
                          numberFormat.format(item.pricePerUnit * item.units!)),
                    ],
                  ),
                  dense: true,
                  trailing: const Icon(Icons.chevron_right),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
