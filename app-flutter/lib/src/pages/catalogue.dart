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
          var catalogue = Catalogue.fromJson(result.data!);

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: _ItemsCatalogue(items: catalogue.items),
            ),
          );
        },
      ),
      bottomNavigationBar: const MainBottomNavigation(),
    );
  }
}

class _ItemsCatalogue extends StatelessWidget {
  final List<Item> items;

  _ItemsCatalogue({required this.items, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Text(
          'Item list',
          style: TextStyle(
            color: Colors.black38,
            fontWeight: FontWeight.w600,
            fontSize: 18.0,
          ),
        ),
        const SizedBox(height: 10.0),
        ...ListTile.divideTiles(tiles: [
          for (var item in items) _ItemWidget(item: item),
        ], context: context),
      ],
    );
  }
}

class _ItemWidget extends StatelessWidget {
  final Item item;

  const _ItemWidget({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.black38,
          onTap: () {},
          child: ListTile(
            title: Text(item.name),
            trailing: const Icon(Icons.chevron_right_sharp),
          ),
        ),
      ),
    );
  }
}
