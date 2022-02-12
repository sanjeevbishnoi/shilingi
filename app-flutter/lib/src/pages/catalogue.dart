import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:azlistview/azlistview.dart';

import '../constants/constants.dart';
import '../components/components.dart';
import '../gql/gql.dart';
import '../models/model.dart';

class _ItemAZItem extends ISuspensionBean {
  final Item item;

  _ItemAZItem({required this.item});

  @override
  String getSuspensionTag() {
    return item.name[0];
  }
}

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

          return _ItemsCatalogue(items: catalogue.items);
        },
      ),
      bottomNavigationBar: const MainBottomNavigation(),
    );
  }
}

class _ItemsCatalogue extends StatelessWidget {
  final List<Item> items;

  const _ItemsCatalogue({required this.items, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Text(
            'Item list',
            style: TextStyle(
              color: Colors.black38,
              fontWeight: FontWeight.w600,
              fontSize: 18.0,
            ),
          ),
        ),
        Expanded(
          child: AzListView(
            data: _data.toList(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: _ItemWidget(item: items[index]));
            },
          ),
        ),
      ],
    );
  }

  Iterable<_ItemAZItem> get _data =>
      items.map<_ItemAZItem>((i) => _ItemAZItem(item: i));
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
