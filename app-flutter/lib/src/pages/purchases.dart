import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../models/model.dart' as model;
import '../components/components.dart';
import '../gql/gql.dart' as queries;

class PurchasesPage extends StatefulWidget {
  const PurchasesPage([Key? key]) : super(key: key);

  @override
  State createState() => _PurchasesPageState();
}

class _PurchasesPageState extends State<PurchasesPage> {
  Refetch? _refetch;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shilingi')),
      body: VisibilityDetector(
        key: const Key('on-index-page'),
        onVisibilityChanged: (visibilityInfo) {
          if (visibilityInfo.visibleFraction == 1.0 && _refetch != null) {
            _refetch!();
          }
        },
        child: Query(
          options: QueryOptions(document: queries.purchasesQuery),
          builder: (QueryResult result,
              {Refetch? refetch, FetchMore? fetchMore}) {
            _refetch = refetch;
            if (result.isLoading && result.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (result.data != null) {
              var p = model.Purchases.fromJson(result.data!);
              return RefreshIndicator(
                onRefresh: () {
                  if (_refetch != null) {
                    return _refetch!();
                  }
                  return Future.value();
                },
                child: ListView(children: [
                  const SizedBox(height: 12.0),
                  for (var purchase in p.purchases) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: WPurchase(purchase),
                    ),
                    const SizedBox(height: 12.0),
                  ],
                ]),
              );
            }
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      'unable to load your purchases ${result.exception?.graphqlErrors.toString()} ${result.exception?.toString()}'),
                  const SizedBox(height: 20),
                  if (_refetch != null)
                    TextButton(
                        onPressed: () {
                          if (_refetch != null) {
                            _refetch!();
                          }
                        },
                        child: const Text('Refresh'))
                ],
              ),
            );
          },
        ),
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
