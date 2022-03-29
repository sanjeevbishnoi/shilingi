import 'package:flutter/material.dart';

import 'package:ms_undraw/ms_undraw.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../constants/constants.dart';
import '../models/model.dart';
import '../gql/gql.dart';
import './settings/settings.dart';
import '../components/components.dart';

enum LabelsAppbarMore {
  removeItem,
  editLabel,
  deleteLabel,
}

class LabelItemsPage extends StatefulWidget {
  const LabelItemsPage({Key? key}) : super(key: key);

  @override
  _LabelItemsPageState createState() => _LabelItemsPageState();
}

class _LabelItemsPageState extends State<LabelItemsPage> {
  Refetch? _refetch;
  bool _removeItems = false;
  String _tagName = '';
  @override
  Widget build(BuildContext context) {
    var settings = ModalRoute.of(context)!.settings.arguments
        as LabelItemPageRouteSettings;
    if (_tagName.isEmpty) {
      _tagName = settings.tag.name;
    } else {
      settings = LabelItemPageRouteSettings(
          tag: Tag(name: _tagName, id: settings.tag.id));
    }

    var appBar = AppBar(
      elevation: 0,
      title: Text(_tagName),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) =>
                        _SelectItemPageView(tag: settings.tag)))
                .then((value) {
              if (_refetch != null) _refetch!();
            });
          },
          icon: const Icon(Icons.playlist_add),
        ),
        PopupMenuButton(
          onSelected: (value) {
            switch (value) {
              case LabelsAppbarMore.removeItem:
                setState(() {
                  _removeItems = true;
                });
                break;
              case LabelsAppbarMore.editLabel:
                showDialog(
                    context: context,
                    builder: (context) => EditLabelDialog(
                        tag: settings.tag,
                        onSuccess: (value) {
                          Future.value(value).then((value) {
                            setState(() {
                              _tagName = value;
                            });
                          });
                        }));
                break;
              case LabelsAppbarMore.deleteLabel:
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: const Text(
                            'Are you sure you want to delete this label?'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('No')),
                          TextButton(
                              onPressed: () {
                                var cli = GraphQLProvider.of(context).value;
                                var result = cli.mutate(
                                  MutationOptions(
                                    document: mutationDeleteTag,
                                    variables: {
                                      'id': settings.tag.id,
                                    },
                                  ),
                                );
                                var hasPopped = false;
                                result.then((value) {
                                  if (value.hasException) {
                                    var snackBar = const SnackBar(
                                        content:
                                            Text('Unable to delete label'));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                    if (!hasPopped) {
                                      // Close alert dialog with delete loading bar
                                      Navigator.of(context).pop();
                                    }
                                    return;
                                  }
                                  // Navigator.of(context).popUntil((route) =>
                                  // route.settings.name == '/catalogue');
                                });
                                Navigator.of(context).pop();
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return FutureBuilder(
                                        future: result,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            return AlertDialog(
                                              content:
                                                  const Text('Label deleted'),
                                              actions: [
                                                TextButton(
                                                  child: const Text('Ok'),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .popUntil((route) =>
                                                            route.settings
                                                                .name ==
                                                            '/catalogue');
                                                  },
                                                ),
                                              ],
                                            );
                                          }

                                          return WillPopScope(
                                            onWillPop: () async {
                                              return result.then(
                                                (value) {
                                                  hasPopped = true;
                                                  return true;
                                                },
                                              );
                                            },
                                            child: AlertDialog(
                                              content: Row(
                                                children: const [
                                                  CircularProgressIndicator(),
                                                  SizedBox(width: 10),
                                                  Text('Deleting label...')
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }).then(
                                  (value) {
                                    Navigator.of(context).popUntil((route) =>
                                        route.settings.name == '/catalogue');
                                  },
                                );
                              },
                              child: const Text('Yes',
                                  style: TextStyle(color: Colors.redAccent))),
                        ],
                      );
                    });
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem<LabelsAppbarMore>(
              child: Text('Remove items'),
              value: LabelsAppbarMore.removeItem,
            ),
            const PopupMenuItem<LabelsAppbarMore>(
              child: Text('Rename label'),
              value: LabelsAppbarMore.editLabel,
            ),
            const PopupMenuItem<LabelsAppbarMore>(
              child: Text('Delete label'),
              value: LabelsAppbarMore.deleteLabel,
            ),
          ],
        ),
      ],
    );
    if (_removeItems) {
      appBar = AppBar(
        elevation: 0,
        backgroundColor: Colors.redAccent,
        title: const Text('Remove items'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            setState(() {
              _removeItems = false;
            });
          },
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: mainScaffoldBg,
        appBar: appBar,
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
              return _EmptyLabelList(
                tag: settings.tag,
                refetch: () {
                  if (_refetch != null) _refetch!();
                },
              );
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
                      child: _ItemList(
                          items: items.items,
                          removeItems: _removeItems,
                          tag: settings.tag,
                          refetch: () {
                            if (_refetch != null) {
                              _refetch!();
                            }
                          }),
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
  final Tag tag;
  final VoidCallback? refetch;

  const _EmptyLabelList({Key? key, required this.tag, this.refetch})
      : super(key: key);

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
              color: Colors.lightGreen,
              useMemCache: true,
            ),
            const Text('No items with this label',
                style: TextStyle(fontSize: 18.0)),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => _SelectItemPageView(tag: tag)))
                    .then((value) {
                  if (refetch != null) refetch!();
                });
              },
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
  final bool removeItems;
  final Tag tag;
  final VoidCallback refetch;

  const _ItemList(
      {required this.items,
      required this.removeItems,
      required this.tag,
      required this.refetch,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var item in items)
          _ItemWidget(
            item: item,
            toggleItem: (i) {},
            selectedItems: const [],
            removeItems: removeItems,
            tag: tag,
            refetch: refetch,
            key: Key(item.id.toString()),
          ),
      ],
    );
  }
}

class _ItemWidget extends StatefulWidget {
  final Item item;
  final Function(Item) toggleItem;
  final List<Item> selectedItems;
  final bool removeItems;
  final Tag tag;
  final VoidCallback refetch;

  const _ItemWidget(
      {Key? key,
      required this.item,
      required this.toggleItem,
      required this.removeItems,
      required this.selectedItems,
      required this.tag,
      required this.refetch})
      : super(key: key);

  @override
  State createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<_ItemWidget> {
  bool _loading = false;

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
            if (_loading || widget.removeItems) {
              return;
            }

            if (widget.selectedItems.isNotEmpty) {
              widget.toggleItem(widget.item);
              return;
            }

            Navigator.of(context).pushNamed(shoppingItemPage,
                arguments: ShoppingItemRouteSettings(
                    itemId: widget.item.id!, name: widget.item.name));
          },
          onLongPress: () {
            widget.toggleItem(widget.item);
          },
          child: ListTile(
            leading: widget.selectedItems.any((i) => i.id == widget.item.id)
                ? const Icon(Icons.check)
                : Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.lightGreen,
                    ),
                    height: 40,
                    width: 40,
                    child: Center(
                      child: Text(widget.item.name[0].toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
            title: Text(widget.item.name),
            trailing: _TrailingItemWidget(
                loading: _loading,
                removeItem: widget.removeItems,
                removeItemFn: _removeItem),
          ),
        ),
      ),
    );
  }

  void _removeItem() {
    setState(() {
      _loading = true;
    });
    var cli = GraphQLProvider.of(context).value;
    cli
        .mutate(
      MutationOptions(document: mutationUntagItems, variables: {
        'itemIDs': [widget.item.id],
        'tagID': widget.tag.id,
      }),
    )
        .then((value) => widget.refetch(), onError: (e, s) {
      var snackBar = const SnackBar(
        content: Text('Unable to remove the item'),
        backgroundColor: Colors.redAccent,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }
}

class _TrailingItemWidget extends StatelessWidget {
  final bool loading;
  final bool removeItem;
  final VoidCallback removeItemFn;

  const _TrailingItemWidget(
      {Key? key,
      required this.loading,
      required this.removeItem,
      required this.removeItemFn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Padding(
            padding: EdgeInsets.all(14.0),
            child: SizedBox(
                child: CircularProgressIndicator(), width: 20, height: 20),
          )
        : removeItem
            ? IconButton(
                icon: const Icon(Icons.highlight_remove_outlined,
                    color: Colors.redAccent),
                onPressed: removeItemFn,
              )
            : const Icon(Icons.chevron_right_sharp);
  }
}

class _SelectItemPageView extends StatelessWidget {
  final Tag tag;

  const _SelectItemPageView({Key? key, required this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainScaffoldBg,
      appBar: AppBar(title: const Text('Choose an item')),
      body: Query(
        options: QueryOptions(document: itemsQuery, variables: {
          "negate": true,
          "tagID": tag.id,
        }),
        builder: (QueryResult result,
            {Refetch? refetch, FetchMore? fetchMore}) {
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
                    TextButton(
                      onPressed: () {
                        if (refetch != null) refetch();
                      },
                      child: const Text('Try again'),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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

          var items = Items.fromJson(result.data!);

          return RefreshIndicator(
            onRefresh: () {
              if (refetch != null) {
                return refetch();
              }
              return Future.value(null);
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              child: _ItemsListSelect(items: items.items, tag: tag),
            ),
          );
        },
      ),
    );
  }
}

class _ItemsListSelect extends StatefulWidget {
  final List<Item> items;
  final Tag tag;

  const _ItemsListSelect({Key? key, required this.items, required this.tag})
      : super(key: key);

  @override
  State createState() => _ItemsListSelectState();
}

class _ItemsListSelectState extends State<_ItemsListSelect> {
  @override
  Widget build(BuildContext context) {
    if (widget.items.isNotEmpty) {
      return ListView(
        children: [
          for (var item in widget.items)
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  var cli = GraphQLProvider.of(context).value;
                  var result = cli.mutate(
                      MutationOptions(document: mutationTagItems, variables: {
                    'tagID': widget.tag.id,
                    'itemIDs': [item.id],
                  }));

                  showDialog(
                    context: context,
                    builder: (context) {
                      return FutureBuilder(
                        future: result,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return const AlertDialog(
                              content: Text('Item added successfully'),
                            );
                          }
                          return WillPopScope(
                            onWillPop: () async {
                              return false;
                            },
                            child: AlertDialog(
                              content: Row(
                                children: const [
                                  CircularProgressIndicator(),
                                  SizedBox(width: 20),
                                  Text('Adding item...'),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ).whenComplete(() => Navigator.pop(context));
                },
                splashColor: Colors.black38,
                child: ListTile(
                  leading: Container(
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
                ),
              ),
            ),
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0),
        child: Align(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UnDraw(
                height: 150.0,
                illustration: UnDrawIllustration.empty_street,
                color: Colors.lightGreen,
                useMemCache: true,
              ),
              const Text('No items to add',
                  style: TextStyle(fontSize: 18.0, color: Colors.grey)),
            ],
          ),
        ),
      );
    }
  }
}
