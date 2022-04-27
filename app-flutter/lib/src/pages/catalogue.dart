import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:azlistview/azlistview.dart';
import 'package:ms_undraw/ms_undraw.dart';

import '../constants/constants.dart';
import '../components/components.dart';
import '../gql/gql.dart';
import '../models/model.dart';
import './settings/settings.dart';
import './items_to_label_page.dart';
import './label_items.dart';

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
  Refetch? _refetch;

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
    var appBar =
        AppBar(title: const Text('Catalogue'), backgroundColor: mainScaffoldBg);
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

    return SafeArea(
      child: Scaffold(
        backgroundColor: mainScaffoldBg,
        appBar: appBar,
        drawer: Drawer(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20.0),
                const ListTile(
                  leading: Icon(Icons.monetization_on),
                  title: Text('Shilingi', style: TextStyle(fontSize: 20.0)),
                  dense: true,
                  contentPadding: EdgeInsets.only(left: 0),
                ),
                const SizedBox(height: 15.0),
                const Text('Labels', style: TextStyle(fontSize: 16.0)),
                const SizedBox(height: 10.0),
                Expanded(
                  child: Query(
                    options: QueryOptions(document: labelsQuery),
                    builder: (QueryResult result,
                        {Refetch? refetch, FetchMore? fetchMore}) {
                      _refetch = refetch;
                      if (result.isLoading && result.data == null) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (result.hasException) {
                        return const Text('Unable to load labels');
                      }

                      var labels = Tags.fromJson(result.data!);
                      return RefreshIndicator(
                          child: ListView(
                            children: [
                              for (var label in labels.tags)
                                Container(
                                  color: Colors.transparent,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        var settings =
                                            LabelItemPageRouteSettings(
                                                tag: label);
                                        Navigator.of(context)
                                            .push(
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return const LabelItemsPage();
                                            },
                                            settings: RouteSettings(
                                                arguments: settings),
                                          ),
                                        )
                                            .then((value) {
                                          if (_refetch != null) _refetch!();
                                          Navigator.of(context).pop();
                                        });
                                      },
                                      splashColor: Colors.black38,
                                      child: ListTile(
                                        leading:
                                            const Icon(Icons.label_outline),
                                        title: Text(label.name,
                                            style: const TextStyle(
                                                fontSize: 16.0)),
                                        dense: true,
                                      ),
                                    ),
                                  ),
                                ),
                              Container(
                                color: Colors.transparent,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => _NewLabelDialog(
                                                refetchLabels: () {
                                                  if (_refetch != null) {
                                                    _refetch!();
                                                  }
                                                },
                                              ));
                                    },
                                    splashColor: Colors.black38,
                                    child: const ListTile(
                                      leading: Icon(Icons.add),
                                      title: Text('Create new...'),
                                    ),
                                  ),
                                ),
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
              ],
            ),
          ),
        ),
        body: Query(
          options: QueryOptions(document: vendorAndItemsNames),
          builder: (QueryResult result,
              {FetchMore? fetchMore, Refetch? refetch}) {
            if (result.isLoading && result.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (result.hasException) {
              return Padding(
                padding: const EdgeInsets.all(30.0),
                child: Align(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      UnDraw(
                          height: 150.0,
                          illustration: UnDrawIllustration.warning,
                          color: Colors.redAccent),
                      const Text('Unable to load items',
                          style: TextStyle(fontSize: 18.0)),
                    ],
                  ),
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
      ),
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
                      color: Colors.lightGreen,
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

// TODO: This is a duplicated container. Refactor
class _NewLabelDialog extends StatefulWidget {
  final VoidCallback refetchLabels;

  const _NewLabelDialog({Key? key, required this.refetchLabels})
      : super(key: key);

  @override
  State createState() => _NewLabelDialogState();
}

class _NewLabelDialogState extends State<_NewLabelDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;
  String _label = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() {
      setState(() {
        _label = _controller.text;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create label'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: 'Label name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel')),
        TextButton(
            onPressed: _label.isNotEmpty
                ? () {
                    var cli = GraphQLProvider.of(context).value;
                    var future = cli.mutate(MutationOptions(
                        document: mutationCreateLabel,
                        variables: {
                          "input": Tag(name: _label).toJson(),
                        }));
                    Navigator.of(context).pop();
                    showDialog(
                      context: context,
                      builder: (context) {
                        return FutureBuilder(
                            future: future,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return AlertDialog(
                                  content: Row(
                                      children: const [Text('Done')],
                                      mainAxisAlignment:
                                          MainAxisAlignment.center),
                                );
                              }
                              return AlertDialog(
                                content: Row(
                                  children: const [
                                    CircularProgressIndicator(),
                                    SizedBox(width: 20),
                                    Text('Saving...'),
                                  ],
                                ),
                              );
                            });
                      },
                    ).then(
                      (value) {
                        widget.refetchLabels();
                      },
                    );
                  }
                : null,
            child: const Text('Ok')),
      ],
    );
  }
}
