import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ms_undraw/ms_undraw.dart';
import 'package:intl/intl.dart';
import 'package:timeago_flutter/timeago_flutter.dart';
import 'package:badges/badges.dart';

import '../constants/constants.dart';
import '../gql/gql.dart';
import '../models/model.dart';
import './select_items.dart' show SelectItemsPage;
import '../components/components.dart';

enum _FilterState {
  all,
  completed,
  uncompleted,
}

var _format = NumberFormat('#,##0', 'en_US');

class ShoppingListDetail extends HookWidget {
  final int id;

  const ShoppingListDetail({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filterState = useState<_FilterState>(_FilterState.all);
    var selectedItems = useState<List<int>>([]);
    var queryResult = useQuery(
      QueryOptions(document: shoppingDetailQuery, variables: {
        'id': id,
      }),
    );
    var result = queryResult.result;

    ShoppingList? list;
    Widget body;
    var all = 0;

    if (result.isLoading && result.data == null) {
      body = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (result.hasException) {
      body = Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UnDraw(
                illustration: UnDrawIllustration.warning,
                color: Colors.redAccent,
                height: 150,
              ),
              const Text('Unable to load shopping details'),
              const SizedBox(height: 4.0),
              TextButton(
                onPressed: () {
                  queryResult.refetch();
                },
                child: const Text('Retry reload'),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      list = ShoppingList.fromJson(result.data!['node']);
      var items = list.items;
      all = items!.length;

      switch (filterState.value) {
        case _FilterState.all:
          // We can just pass, this is the default
          break;
        case _FilterState.completed:
          items = items
              .where((item) => selectedItems.value.contains(item.id))
              .toList();
          break;
        case _FilterState.uncompleted:
          items = items
              .where((item) => !selectedItems.value.contains(item.id))
              .toList();
          break;
      }

      body = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(list.name + ' (${list.items!.length})',
                style: const TextStyle(fontSize: 20.0)),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
            child: Text(
                'Last modified: ' +
                    DateFormat("EEE h:ma, MMM d, ''yy'").format(
                      list.updateTime!.toLocal(),
                    ),
                style: const TextStyle(color: Colors.black45)),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 14.0),
            child: Wrap(
              spacing: 6.0,
              children: [
                _SelectButton(
                  selected: filterState.value == _FilterState.all,
                  text: 'All',
                  onPressed: () {
                    filterState.value = _FilterState.all;
                  },
                  count: all,
                ),
                _SelectButton(
                  selected: filterState.value == _FilterState.completed,
                  text: 'Completed',
                  onPressed: () {
                    filterState.value = _FilterState.completed;
                  },
                  count: selectedItems.value.length,
                ),
                _SelectButton(
                  selected: filterState.value == _FilterState.uncompleted,
                  text: 'Uncompleted',
                  onPressed: () {
                    filterState.value = _FilterState.uncompleted;
                  },
                  count: all - selectedItems.value.length,
                ),
              ],
            ),
          ),
          if (items.isNotEmpty)
            Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  itemBuilder: (context, index) {
                    final item = items![index];
                    return _Item(
                      item: item,
                      shoppingListId: id,
                      selected: selectedItems.value.contains(item.id),
                      onChanged: (val) {
                        if (val != null) {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (context) {
                              return Padding(
                                padding: MediaQuery.of(context).viewInsets,
                                child: _ConfirmItemCheck(item: item.item),
                              );
                            },
                          ).then((value) {
                            final list = selectedItems.value.toList();
                            if (val) {
                              list.add(item.id);
                            } else {
                              list.remove(item.id);
                            }
                            selectedItems.value = list;
                          });
                        }
                      },
                      onDeleted: (item) {
                        queryResult.refetch();
                      },
                    );
                  },
                  itemCount: items.length),
            ),
          if (items.isEmpty) ...[
            const SizedBox(height: 10.0),
            Center(
              child: UnDraw(
                illustration: filterState.value == _FilterState.uncompleted
                    ? UnDrawIllustration.well_done
                    : UnDrawIllustration.not_found,
                color: Colors.lightGreen,
                height: 100,
              ),
            ),
            if (list.items!.isNotEmpty &&
                filterState.value == _FilterState.uncompleted)
              const Center(child: Text('Great job!')),
          ]
        ],
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(backgroundColor: mainScaffoldBg, actions: [
          _ShoppingListPopupButton(
            list: list,
            onItemsAdded: (ids) {
              _addItems(context, ids, queryResult.refetch);
            },
          ),
        ]),
        backgroundColor: mainScaffoldBg,
        body: body,
        floatingActionButton: list != null
            ? FloatingActionButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return _ShowApproxTotal(list: list!);
                      },
                      backgroundColor: Colors.transparent);
                },
                child: const Icon(Icons.keyboard_arrow_up),
                backgroundColor: Colors.white,
              )
            : null,
      ),
    );
  }

  void _addItems(BuildContext context, List<int> ids, Refetch refetch) {
    final cli = GraphQLProvider.of(context).value;
    final f = cli.mutate(
        MutationOptions(document: mutationAddToShoppingList, variables: {
      'id': id,
      'items': ids,
    }));

    showDialog(
        context: context,
        builder: (context) {
          f.then((value) {
            Navigator.of(context).pop();
            if (value.hasException) {
              _showSnackbar(
                  context,
                  'Unable to add items to list. If this is an error on our part, we are working to resolve it',
                  true);
            } else {
              _showSnackbar(context, 'List updated successfully', false);
              refetch();
            }
          });
          return WillPopScope(
              child: AlertDialog(
                content: Row(
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(width: 10.0),
                    Expanded(child: Text('Updating list...')),
                  ],
                ),
              ),
              onWillPop: () {
                return f.then((v) => true);
              });
        });
  }

  void _showSnackbar(BuildContext context, String msg, bool isException) {
    final snackBar = SnackBar(
        content: Text(msg),
        backgroundColor: isException ? Colors.redAccent : Colors.black87);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class _SelectButton extends StatelessWidget {
  final bool selected;
  final String text;
  final VoidCallback onPressed;
  final int count;

  const _SelectButton(
      {Key? key,
      required this.selected,
      required this.text,
      required this.onPressed,
      required this.count})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Badge(
      badgeContent: Text(count.toString(),
          style: const TextStyle(fontSize: 10.0, color: Colors.white)),
      badgeColor: selected ? Colors.lightGreen : Colors.grey,
      child: TextButton(
        onPressed: onPressed,
        child: Text(text,
            style: selected
                ? const TextStyle(color: Colors.lightGreen)
                : const TextStyle(color: Colors.black87)),
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              side: selected
                  ? const BorderSide(color: Colors.lightGreen)
                  : BorderSide.none,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          padding: MaterialStateProperty.all<EdgeInsets>(
            const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          // minimumSize:
          // MaterialStateProperty.all<Size?>(const Size.fromHeight(20.0)),
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final ShoppingListItem item;
  final int shoppingListId;
  final bool selected;
  final ValueChanged<bool?> onChanged;
  final ValueChanged<ShoppingListItem> onDeleted;

  const _Item(
      {Key? key,
      required this.item,
      required this.selected,
      required this.onChanged,
      required this.onDeleted,
      required this.shoppingListId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Dismissible(
        background: Container(
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(children: const [
            Padding(
              padding: EdgeInsets.only(left: 30.0, top: 30.0, bottom: 30.0),
              child: Icon(Icons.delete),
            ),
            SizedBox(width: 10.0),
            Text('Delete', style: TextStyle(fontSize: 16.0)),
          ]),
        ),
        direction: DismissDirection.startToEnd,
        confirmDismiss: (direction) async {
          final cli = GraphQLProvider.of(context).value;
          final result = await cli.mutate(MutationOptions(
            document: mutationRemoveFromShoppingList,
            variables: {
              'id': shoppingListId,
              'listItems': [item.id],
            },
          ));
          if (result.hasException) {
            var snackBar =
                const SnackBar(content: Text('Unable to remove item.'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            return Future.value(false);
          }
          onDeleted(item);
          return Future.value(true);
        },
        key: ValueKey(item.id),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            onChanged(!selected);
          },
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 14.0, horizontal: 8.0),
            child: Row(mainAxisSize: MainAxisSize.max, children: [
              Checkbox(
                value: selected,
                onChanged: onChanged,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              const SizedBox(width: 5.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        item.item.name,
                        style: TextStyle(
                            fontSize: 16.0,
                            decoration:
                                selected ? TextDecoration.lineThrough : null,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Icon(
                        Icons.date_range,
                        size: 14.0,
                        color: Colors.black45,
                      ),
                      const SizedBox(width: 5.0),
                      if (purchase != null)
                        Wrap(children: [
                          const Text('Last bought ',
                              style: TextStyle(color: Colors.grey)),
                          Timeago(
                              builder: (_, value) => Tooltip(
                                    child: Text(value,
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w600)),
                                    message: DateFormat("EEE, MMM d, ''y'")
                                        .format(purchase!.date),
                                  ),
                              date: purchase!.date),
                        ]),
                      if (purchase == null)
                        const Text('No purchase record',
                            style: TextStyle(color: Colors.grey))
                    ],
                  ),
                  if (purchaseItem != null)
                    Row(
                      children: [
                        // const Icon(
                        // FeatherIcons.creditCard,
                        // size: 14.0,
                        // color: Colors.black45,
                        // ),
                        const Text('At',
                            style: TextStyle(color: Colors.black45)),
                        const SizedBox(width: 5.0),
                        Text(
                            NumberFormat('#,##0 /=', 'en_US')
                                .format(purchaseItem!.total),
                            style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }

  Purchase? get purchase {
    var length = item.item.purchases?.edges?.length ?? 0;
    if (length == 0) {
      return null;
    }
    return item.item.purchases!.edges![0].node!.shopping;
  }

  PurchaseItem? get purchaseItem {
    var length = item.item.purchases?.edges?.length ?? 0;
    if (length == 0) {
      return null;
    }

    return item.item.purchases!.edges![0].node;
  }
}

enum _ShoppingListPopupActions {
  delete,
  add,
}

class _ShoppingListPopupButton extends StatelessWidget {
  final ShoppingList? list;
  final ValueChanged<List<int>> onItemsAdded;

  const _ShoppingListPopupButton(
      {Key? key, required this.list, required this.onItemsAdded})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_ShoppingListPopupActions>(
      onSelected: (value) async {
        switch (value) {
          case _ShoppingListPopupActions.delete:
            var result = await _onDelete(context);
            if (result is bool && result) {
              var snackBar = const SnackBar(
                  content: Text('The list has been successfully deleted'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.of(context).pop(true);
            }
            break;
          case _ShoppingListPopupActions.add:
            final results = await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const SelectItemsPage(
                      title: 'Update list',
                      buttonString: 'Add selected items',
                      resultsOnPop: true,
                    )));
            if (results is List<int>) {
              onItemsAdded(results);
            }
            break;
        }
      },
      itemBuilder: (context) => [
        if (list != null)
          PopupMenuItem<_ShoppingListPopupActions>(
            child: Row(
              children: const [
                Icon(Icons.delete, color: Colors.redAccent),
                SizedBox(width: 5.0),
                Text('Delete')
              ],
            ),
            value: _ShoppingListPopupActions.delete,
          ),
        PopupMenuItem<_ShoppingListPopupActions>(
          child: Row(
            children: const [
              Icon(Icons.add, color: Colors.grey),
              SizedBox(width: 5.0),
              Text('Add to list')
            ],
          ),
          value: _ShoppingListPopupActions.add,
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  Future _onDelete(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          var deleting = false;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Row(
                children: const [
                  Icon(Icons.delete, color: Colors.redAccent),
                  SizedBox(width: 5.0),
                  Text('Delete list'),
                ],
              ),
              content: const Text('Are you sure?'),
              actions: [
                TextButton(
                    onPressed: deleting
                        ? null
                        : () {
                            Navigator.of(context).pop();
                          },
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.grey))),
                ElevatedButton.icon(
                  onPressed: deleting
                      ? null
                      : () async {
                          setState(() {
                            deleting = true;
                          });
                          var cli = GraphQLProvider.of(context).value;
                          var result = await cli.mutate(MutationOptions(
                              document: mutationDeleteShoppingList,
                              variables: {
                                'id': list!.id,
                              }));
                          if (!result.hasException) {
                            Navigator.of(context).pop(true);
                            return;
                          }
                          // Show user error
                          var errMessage =
                              result.exception?.graphqlErrors[0].message ?? "";
                          if (errMessage.isNotEmpty) {
                            var snackBar = SnackBar(
                              content: Text(errMessage),
                              backgroundColor: Colors.redAccent,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                          Navigator.of(context).pop(false);
                        },
                  icon: const Icon(Icons.delete_sweep),
                  label: Text(deleting ? 'Deleting...' : 'Yes, delete'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.redAccent),
                    elevation: MaterialStateProperty.all<double>(0.0),
                  ),
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              contentPadding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 5.0),
            );
          });
        },
        barrierDismissible: false,
        useSafeArea: true);
  }
}

class _ShowApproxTotal extends StatelessWidget {
  final ShoppingList list;

  const _ShowApproxTotal({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6.0),
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: mainScaffoldBg,
          borderRadius: BorderRadius.circular(4.0),
        ),
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.only(bottom: 10.0, top: 10.0),
                width: 30.0,
                height: 4.0,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Approx. Total',
                    style: TextStyle(color: Colors.grey)),
                const SizedBox(width: 10.0),
                Text('Ksh ' + _format.format(total),
                    style: const TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double get total {
    var total = 0.0;
    list.items?.forEach((element) {
      final purchases = element.item.purchases;
      if (purchases != null && purchases.edges!.isNotEmpty) {
        total += purchases.edges![0].node!.total;
      }
    });

    return total;
  }
}

class _ConfirmItemCheck extends StatelessWidget {
  final Item item;

  const _ConfirmItemCheck({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        decoration: BoxDecoration(
          color: mainScaffoldBg,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10.0, top: 10.0),
                  width: 30.0,
                  height: 4.0,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(item.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 24.0)),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _AmountTextField(),
                  SizedBox(width: 8.0),
                  SpinBox(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AmountTextField extends HookWidget {
  const _AmountTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        children: const [
          Text('Ksh'),
          SizedBox(width: 5.0),
          SizedBox(
            width: 70.0,
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
