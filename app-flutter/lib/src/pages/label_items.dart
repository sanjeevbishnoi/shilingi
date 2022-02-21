import 'package:flutter/material.dart';

import 'package:ms_undraw/ms_undraw.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../constants/constants.dart';
import '../models/model.dart';
import '../gql/gql.dart';
import './settings/settings.dart';

class LabelItemsPage extends StatefulWidget {
  const LabelItemsPage({Key? key}) : super(key: key);

  @override
  _LabelItemsPageState createState() => _LabelItemsPageState();
}

class _LabelItemsPageState extends State<LabelItemsPage> {
  Refetch? _refetch;
  @override
  Widget build(BuildContext context) {
    var settings = ModalRoute.of(context)!.settings.arguments
        as LabelItemPageRouteSettings;

    return SafeArea(
      child: Scaffold(
        backgroundColor: mainScaffoldBg,
        appBar: AppBar(
          title: Text(settings.tag.name),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.playlist_add),
            ),
          ],
        ),
        body: Query(
          options: QueryOptions(document: itemsQuery, variables: {
            'tagID': settings.tag.id,
          }),
          builder: (QueryResult result,
              {Refetch? refetch, FetchMore? fetchMore}) {
            _refetch = refetch;
            if (result.isLoading && result.data == null) {
              return const Padding(
                padding: EdgeInsets.all(30.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (result.hasException) {
              return const Padding(
                padding: EdgeInsets.all(30.0),
                child:
                    Center(child: Text('Unable to load items with this label')),
              );
            }

            var items = Items.fromJson(result.data!);
            if (items.items.isEmpty) {
              return const _EmptyLabelList();
            }
            return RefreshIndicator(
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 20.0),
                      child: Row(
                        children: [
                          const Icon(Icons.label_outline),
                          const SizedBox(width: 5.0),
                          Text(settings.tag.name),
                          const SizedBox(width: 5.0),
                          const Text('\u2022'),
                          const SizedBox(width: 5.0),
                          Text('${items.items.length} items')
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: _ItemList(items: items.items),
                    ),
                  ],
                ),
                onRefresh: () {
                  if (_refetch != null) {
                    return _refetch!();
                  }
                  return Future.value(null);
                });
          },
        ),
      ),
    );
  }
}

class LabelItemPageRouteSettings {
  final Tag tag;

  const LabelItemPageRouteSettings({required this.tag});
}

class _EmptyLabelList extends StatelessWidget {
  const _EmptyLabelList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Align(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UnDraw(
                height: 150.0,
                illustration: UnDrawIllustration.floating,
                color: Colors.greenAccent),
            const Text('No items with this label',
                style: TextStyle(fontSize: 18.0)),
            TextButton(
              onPressed: () {},
              child: const Text('Add an item'),
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemList extends StatelessWidget {
  final List<Item> items;

  const _ItemList({required this.items, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var item in items)
          _ItemWidget(item: item, toggleItem: (i) {}, selectedItems: []),
      ],
    );
  }
}

class _ItemWidget extends StatelessWidget {
  final Item item;
  final Function(Item) toggleItem;
  final List<Item> selectedItems;

  const _ItemWidget({
    Key? key,
    required this.item,
    required this.toggleItem,
    required this.selectedItems,
  }) : super(key: key);

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
          onTap: () {
            if (selectedItems.isNotEmpty) {
              toggleItem(item);
              return;
            }

            Navigator.of(context).pushNamed(shoppingItemPage,
                arguments: ShoppingItemRouteSettings(
                    itemId: item.id!, name: item.name));
          },
          onLongPress: () {
            toggleItem(item);
          },
          child: ListTile(
            leading: selectedItems.any((i) => i.id == item.id)
                ? const Icon(Icons.check)
                : Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.green,
                    ),
                    height: 40,
                    width: 40,
                    child: Center(
                      child: Text(item.name[0].toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
            title: Text(item.name),
            trailing: const Icon(Icons.chevron_right_sharp),
          ),
        ),
      ),
    );
  }
}
