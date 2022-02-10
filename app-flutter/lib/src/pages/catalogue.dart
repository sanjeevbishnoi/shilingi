import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

import '../constants/constants.dart';
import '../components/components.dart';
import '../gql/gql.dart';
import '../models/model.dart';

class CataloguePage extends StatelessWidget {
  static const routeName = '/catalogue';

  const CataloguePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainScaffoldBg,
      appBar: AppBar(title: const Text('Catalogue')),
      body: Query(
        options: QueryOptions(document: vendorAndItemsNames),
        builder: (QueryResult result,
            {FetchMore? fetchMore, Refetch? refetch}) {
          if (result.isLoading && result.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (result.hasException) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text('${result.exception}'),
              ),
            );
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text('${result.data}'),
            ),
          );
        },
      ),
      bottomNavigationBar: const MainBottomNavigation(),
    );
  }
}
