import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:azlistview/azlistview.dart';

import '../constants/constants.dart';
import '../components/components.dart';
import '../gql/gql.dart';
import '../models/model.dart';
import './settings/settings.dart';
import './items_to_label_page.dart';

enum Popup {
  label,
}

class _ItemAZItem extends ISuspensionBean {
  final Item item;

  _ItemAZItem({required this.item});

  @override
  String getSuspensionTag() {
    return item.name[0];
  }
}

class CataloguePage extends StatefulWidget {
  static const routeName = '/catalogue';

  const CataloguePage({Key? key}) : super(key: key);

  @override
  State createState() => _CataloguePageState();
}

class _CataloguePageState extends State<CataloguePage> {
  final List<Item> _selectedItems = [];

  void _addSelectedItem(Item item) {
    setState(() {
      _selectedItems.add(item);
    });
  }

  void _removeItem(Item item, int index) {
    setState(() {
      _selectedItems.removeAt(index);
    });
  }

  void _toggleItem(Item item) {
    var index = _selectedItems.indexWhere((element) => element.id == item.id);
    if (index == -1) {
      _addSelectedItem(item);
      return;
    }
    _removeItem(item, index);
  }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(title: const Text('Catalogue'));
    if (_selectedItems.isNotEmpty) {
      appBar = AppBar(
        leading: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _selectedItems.clear();
              });
            }),
        title: Text('${_selectedItems.length} selected'),
        actions: [
          PopupMenuButton(
            onSelected: (selected) {
              switch (selected) {
                case Popup.label:
                  var args = SelectLabelSettings(
                      itemIds: _selectedItems.map<int>((e) => e.id!).toList());
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SelectLabelPage(),
                      settings: RouteSettings(arguments: args),
                    ),
                  );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<Popup>(
                child: Text('Add to label'),
                value: Popup.label,
              ),
            ],
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: mainScaffoldBg,
      appBar: appBar,
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

          return _ItemsCatalogue(
            items: catalogue.items,
            toggleItem: _toggleItem,
            selectedItems: _selectedItems,
          );
        },
      ),
      bottomNavigationBar: const ClassicBottomNavigation(),
    );
  }
}

class _ItemsCatalogue extends StatelessWidget {
  final List<Item> items;
  final Function(Item) toggleItem;
  final List<Item> selectedItems;

  const _ItemsCatalogue({
    required this.items,
    Key? key,
    required this.toggleItem,
    required this.selectedItems,
  }) : super(key: key);

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
                child: _ItemWidget(
                  item: items[index],
                  toggleItem: toggleItem,
                  selectedItems: selectedItems,
                ),
              );
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
