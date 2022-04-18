import 'package:flutter/material.dart';

import 'package:sorted_list/sorted_list.dart';
import 'package:intl/intl.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ms_undraw/ms_undraw.dart';

import '../../constants/constants.dart';
import '../../components/analytics/simple_bar.dart';
import '../../models/model.dart';
import '../items_to_label_page.dart';
import '../settings/settings.dart';
import '../../gql/gql.dart';

var _format = NumberFormat('#,##0', 'en_US');

enum _Popup {
  remove,
  add,
}

// PurchaseItemEntries shows a list of items analytics break by a specific label
class PurchaseItemEntries extends StatefulWidget {
  final LabelsSimpleBarEntry entry;

  const PurchaseItemEntries({Key? key, required this.entry}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PurchaseItemEntries();
  }
}

class _PurchaseItemEntries extends State<PurchaseItemEntries> {
  bool _showPercentage = false;
  final List<int> _selected = <int>[];
  Refetch? _refetch;

  String get _label {
    return widget.entry.label;
  }

  void _toggleItem(int id) {
    if (_selected.contains(id)) {
      _selected.remove(id);
      return;
    }
    _selected.add(id);
  }

  SortedList<TagTotal> _processItems(List<PurchaseItem> items) {
    var sortedList = SortedList<TagTotal>((a, b) => a.compareTo(b));
    var map = <String, TagTotal>{};

    for (var item in items) {
      var entry =
          TagTotal(name: item.item!.name, value: item.total, id: item.item!.id);
      map.update(entry.name, (value) => value + entry, ifAbsent: () => entry);
    }

    map.values.forEach((element) => sortedList.add(element));
    return sortedList;
  }

  Future _refresh() {
    if (_refetch != null) {
      return _refetch!();
    }
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(title: Text('$_label expenditure'));
    if (_selected.isNotEmpty) {
      appBar = AppBar(
        backgroundColor: Colors.lightGreenAccent,
        leading: IconButton(
          onPressed: () {
            setState(() {
              _selected.clear();
            });
          },
          icon: const Icon(Icons.close),
        ),
        title: Text('${_selected.length} selected items'),
        actions: [
          PopupMenuButton<_Popup>(
            onSelected: (value) {
              switch (value) {
                case _Popup.add:
                  var args = SelectLabelSettings(
                      genericPop: true,
                      itemIds: _selected.map<int>((e) => e).toList());
                  Navigator.of(context)
                      .push(
                    MaterialPageRoute(
                      builder: (context) => const SelectLabelPage(),
                      settings: RouteSettings(arguments: args),
                    ),
                  )
                      .then((value) {
                    _refresh();
                    // Unselect selected elements
                    if (value is bool && value) {
                      setState(() {
                        _selected.clear();
                      });
                    }
                  });
                  break;
                case _Popup.remove:
                  var payload = <String, dynamic>{
                    'itemIDs': _selected,
                    'tagID': widget.entry.labelId,
                  };
                  var cli = GraphQLProvider.of(context).value;
                  var result = cli.mutate(MutationOptions(
                      document: mutationUntagItems, variables: payload));
                  showDialog(
                      context: context,
                      builder: (context) {
                        // TODO(jack): Use a StatefulBuilder widget instead
                        return FutureBuilder<QueryResult>(
                          future: result,
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.done:
                                _refresh();
                                return AlertDialog(
                                  content: const Text(
                                    'Done, items removed from label',
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text('close'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              default:
                                return WillPopScope(
                                  child: AlertDialog(
                                    content: Row(
                                      children: const [
                                        CircularProgressIndicator(),
                                        SizedBox(width: 14),
                                        Text('Working...'),
                                      ],
                                    ),
                                  ),
                                  onWillPop: () async {
                                    return true;
                                  },
                                );
                            }
                          },
                        );
                      }).then(
                    (value) {
                      setState(() {
                        _selected.clear();
                      });
                    },
                  );
                  break;
              }
            },
            itemBuilder: (context) => [
              if (widget.entry.label == "uncategorized")
                const PopupMenuItem(
                  child: Text('Add to label'),
                  value: _Popup.add,
                ),
              if (widget.entry.label != "uncategorized")
                PopupMenuItem(
                  child: Text('Remove from ${widget.entry.label}'),
                  value: _Popup.remove,
                ),
            ],
          ),
        ],
      );
    }

    var analyticsFor = widget.entry.analyticsFor;

    var queryName = 'shoppingItemsByTag';
    if (widget.entry.label == 'uncategorized') {
      queryName = 'untaggedShoppingItems';
    }

    var body = Query(
      options: QueryOptions(
        document: widget.entry.label == 'uncategorized'
            ? unlabeledPurchaseItemsQuery
            : purchaseItemsByLabelQuery,
        variables: {
          'after': DateTimeToJson(analyticsFor.start),
          'before': DateTimeToJson(analyticsFor.end),
          'tagID': widget.entry.labelId,
        },
      ),
      builder: (QueryResult result, {Refetch? refetch, FetchMore? fetchMore}) {
        _refetch = refetch;
        if (result.isLoading && result.data == null) {
          return const Padding(
            padding: EdgeInsets.all(30.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (result.hasException) {
          return Padding(
            padding: const EdgeInsets.all(30.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  UnDraw(
                      height: 150.0,
                      illustration: UnDrawIllustration.warning,
                      color: Colors.redAccent),
                  Text('Unable to load analytics for ${widget.entry.label}',
                      style:
                          const TextStyle(fontSize: 16.0, color: Colors.grey)),
                  TextButton(
                    onPressed: () {
                      if (refetch != null) refetch();
                    },
                    child: const Text('Try again'),
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

        var purchaseItems =
            PurchaseItems.fromJson({'shoppingItems': result.data![queryName]});
        var items = _processItems(purchaseItems.shoppingItems).reversed;
        var total = 0.0;
        var max = 0.0;
        if (items.isNotEmpty) {
          max = items.first.value;
        }
        purchaseItems.shoppingItems.forEach(((element) {
          total += element.total;
        }));

        return RefreshIndicator(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Kes ${_format.format(total)}',
                                style: const TextStyle(
                                  fontSize: 22,
                                )),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Text('Total spend on ',
                                    style: TextStyle(color: Colors.grey)),
                                Text(widget.entry.label),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CircleAvatar(
                            radius: 15,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _showPercentage = !_showPercentage;
                                });
                              },
                              icon: const Icon(Icons.percent),
                              iconSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      for (var item in items)
                        SelectableWidget(
                          tapCallback: () {
                            if (_selected.isNotEmpty) {
                              setState(() {
                                _toggleItem(item.id!);
                              });
                            } else {
                              Navigator.of(context).pushNamed(shoppingItemPage,
                                  arguments: ShoppingItemRouteSettings(
                                      itemId: item.id!, name: item.name));
                            }
                          },
                          onLongPress: () {
                            setState(() {
                              _toggleItem(item.id!);
                            });
                          },
                          child: _PurchaseItemEntry(
                            entry: item,
                            total: widget.entry.value,
                            max: max,
                            showPercentage: _showPercentage,
                            selected: _selected.contains(item.id),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            onRefresh: () {
              if (refetch != null) {
                return refetch();
              }
              return Future.value();
            });
      },
    );

    return Scaffold(
      backgroundColor: mainScaffoldBg,
      appBar: appBar,
      body: body,
    );
  }
}

// _Uncategorized is used to show items that are uncategorized
class _Uncategorized extends StatelessWidget {
  final LabelsSimpleBarEntry entry;
  final VoidCallback togglePercentage;
  final Function(int) toggleItem;
  final List<TagTotal> items;
  final List<int> selected;
  final bool showPercentage;

  const _Uncategorized(
      {Key? key,
      required this.entry,
      required this.togglePercentage,
      required this.items,
      required this.toggleItem,
      required this.selected,
      required this.showPercentage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var total = 0.0;
    entry.items.forEach(((element) {
      total += element.total;
    }));
    var max = 0.0;
    if (items.isNotEmpty) {
      max = items.first.value;
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Kes ${_format.format(total)}',
                        style: const TextStyle(
                          fontSize: 22,
                        )),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Text('Total spend on ',
                            style: TextStyle(color: Colors.grey)),
                        Text(entry.label),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 15,
                    child: IconButton(
                      onPressed: togglePercentage,
                      icon: const Icon(Icons.percent),
                      iconSize: 14.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              for (var item in items)
                SelectableWidget(
                  tapCallback: () {
                    if (selected.isNotEmpty) {
                      toggleItem(item.id!);
                    } else {
                      Navigator.of(context).pushNamed(shoppingItemPage,
                          arguments: ShoppingItemRouteSettings(
                              itemId: item.id!, name: item.name));
                    }
                  },
                  onLongPress: () {
                    toggleItem(item.id!);
                  },
                  child: _PurchaseItemEntry(
                    entry: item,
                    total: entry.value,
                    max: max,
                    showPercentage: showPercentage,
                    selected: selected.contains(item.id),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class SelectableWidget extends StatelessWidget {
  final Widget child;
  final VoidCallback tapCallback;
  final VoidCallback? onLongPress;

  const SelectableWidget(
      {Key? key,
      required this.child,
      required this.tapCallback,
      this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.black12,
        onTap: tapCallback,
        onLongPress: onLongPress,
        child: child,
      ),
    );
  }
}

class LabelsSimpleBarEntry extends SimpleBarEntry<PurchaseItem>
    implements NavigatableBarEntry {
  final int labelId;
  final AnalyticsForSettings analyticsFor;

  const LabelsSimpleBarEntry(
      {required String label,
      required double value,
      required List<PurchaseItem> items,
      required this.labelId,
      required this.analyticsFor})
      : super(label: label, value: value, items: items);

  @override
  Future goTo(BuildContext context) {
    return Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PurchaseItemEntries(entry: this)));
  }

  @override
  SimpleBarEntry<PurchaseItem> operator +(SimpleBarEntry<PurchaseItem> other) {
    return LabelsSimpleBarEntry(
        labelId: labelId,
        label: label,
        value: value + other.value,
        items: [...items, ...other.items],
        analyticsFor: analyticsFor);
  }
}

class _PurchaseItemEntry extends StatefulWidget {
  final TagTotal entry;
  final bool showPercentage;
  final double max;
  final double total;
  final bool selected;

  const _PurchaseItemEntry(
      {Key? key,
      required this.entry,
      this.showPercentage = false,
      required this.total,
      required this.max,
      this.selected = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PurchaseItemEntryState();
  }
}

class _PurchaseItemEntryState extends State<_PurchaseItemEntry> {
  double _width = 0;

  @override
  Widget build(BuildContext context) {
    var per = widget.entry.value / widget.max;
    if (widget.showPercentage) {
      per = widget.entry.value / widget.total;
    }
    var valueText = 'Kes ' + _format.format(widget.entry.value);
    if (widget.showPercentage) {
      valueText = _format.format(per * 100) + '%';
    }
    // print('${widget.entry.value}, ${widget.max}');
    return ListTile(
      dense: true,
      leading: CircleAvatar(
          child: widget.selected
              ? const Icon(Icons.check)
              : Text(widget.entry.name[0].toUpperCase())),
      title: Row(children: [
        Expanded(
            child: Text(widget.entry.name,
                style: const TextStyle(fontWeight: FontWeight.w600))),
        Text(valueText),
      ]),
      subtitle: LayoutBuilder(
        builder: (context, constraints) {
          var w = constraints.maxWidth;
          Future.delayed(Duration.zero, () {
            setState(() {
              var result = per * w;
              if (_width != result) {
                _width = result;
              }
            });
          });

          return UnconstrainedBox(
            alignment: Alignment.centerLeft,
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              curve: Curves.easeOutExpo,
              width: _width,
              height: 10.0,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
          );
        },
      ),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
