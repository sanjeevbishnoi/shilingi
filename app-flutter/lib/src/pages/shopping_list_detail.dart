import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ms_undraw/ms_undraw.dart';
import 'package:intl/intl.dart';
import 'package:timeago_flutter/timeago_flutter.dart';
import 'package:badges/badges.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../gql/gql.dart';
import '../models/model.dart';
import '../models/hive.dart' as hive;
import './select_items.dart' show SelectItemsPage;
import '../components/components.dart';
import './shopping_list_helpers/change_notifiers.dart';

enum _FilterState {
  all,
  completed,
  uncompleted,
}

const textFieldBg = Color(0XFFFAFAFA);

var _format = NumberFormat('#,##0', 'en_US');

class ShoppingListDetail extends HookWidget {
  final int id;

  const ShoppingListDetail({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchString = useState<String>('');
    final filterState = useState<_FilterState>(_FilterState.all);
    var selectedItems = useState<List<int>>([]);
    // Is used to check whether we have already loaded the selected items from hive store
    var selectedItemsLoaded = useState<bool>(false);
    var storeState =
        useState<Future<hive.ShoppingList>>(hive.ShoppingList.getList(id));
    var store = storeState.value;
    var queryResult = useQuery(
      QueryOptions(document: shoppingDetailQuery, variables: {
        'id': id,
      }),
    );
    var result = queryResult.result;

    // Populate the selected items from the saved store
    store.then((shoppingList) {
      if (!selectedItemsLoaded.value) {
        selectedItems.value = shoppingList.items.map<int>((e) => e.id).toList();
        selectedItemsLoaded.value = true;
      }
    });

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

      if (searchString.value.isNotEmpty) {
        items = items
            .where((item) => item.item.name
                .toLowerCase()
                .contains(searchString.value.toLowerCase()))
            .toList();
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
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: _SearchListItemsField(
                onChanged: (search) {
                  searchString.value = search;
                },
              )),
          const SizedBox(height: 15.0),
          if (items.isNotEmpty) ...[
            Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  itemBuilder: (context, index) {
                    final item = items![index];
                    return _Item(
                      item: item,
                      shoppingListId: id,
                      selected: selectedItems.value.contains(item.id),
                      onChanged: (val) async {
                        if (val != null) {
                          final result = await showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (context) {
                              // Since we can only get the hive.ShoppingList class as a Future
                              // hence why we have to use a FutureBuilder
                              return FutureBuilder<hive.ShoppingList>(
                                future: store,
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.done:
                                      return Padding(
                                        padding:
                                            MediaQuery.of(context).viewInsets,
                                        child: _ConfirmItemCheck(
                                          item: item.item,
                                          storeItem: snapshot.requireData
                                              .getItem(item.id),
                                        ),
                                      );
                                    default:
                                      return const Placeholder();
                                  }
                                },
                              );
                            },
                          );

                          if (result is Map<String, dynamic>) {
                            final list = selectedItems.value.toList();
                            if (!list.contains(item.id)) {
                              list.add(item.id);
                              selectedItems.value = list;
                            }
                            // Update hive store for the specific list
                            final s = await store;
                            result['id'] = item.id;
                            final listItem =
                                hive.ShoppingListItem.fromJson(result);
                            s.addItem(listItem);
                          }
                        }
                      },
                      onDeleted: (item) {
                        queryResult.refetch();
                      },
                    );
                  },
                  itemCount: items.length),
            ),
          ],
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
                Text('Delete list')
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

class _ConfirmItemCheck extends HookWidget {
  final Item item;
  final hive.ShoppingListItem? storeItem;

  const _ConfirmItemCheck({Key? key, required this.item, this.storeItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ChangeNotifierProvider(
        create: (context) {
          if (storeItem == null) {
            return ShoppingListItemChangeNotifier();
          }
          return ShoppingListItemChangeNotifier(
            amount: storeItem!.pricePerUnit.toDouble(),
          );
        },
        child: Padding(
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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 5.0),
                        child: _AmountTextField(),
                      ),
                      const SizedBox(width: 8.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child: Text('Units'),
                          ),
                          SpinBox(),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: const [
                      Text('Optional fields',
                          style: TextStyle(color: Colors.grey)),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: Divider(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Expanded(child: _QuantityField()),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  const _BrandField(),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel',
                              style: TextStyle(color: Colors.grey))),
                      const SizedBox(width: 10.0),
                      Builder(builder: (context) {
                        return ElevatedButton(
                          onPressed: () {
                            // if (formKey.value.currentState!.validate()) {
                            // Navigator.of(context).pop(true);
                            // }
                            final provider =
                                Provider.of<ShoppingListItemChangeNotifier>(
                                    context,
                                    listen: false);
                            if (provider.validate()) {
                              Navigator.of(context).pop(provider.toJson());
                            }
                          },
                          child: const Text('Save'),
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all<double>(0),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
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
    final controller = useTextEditingController();
    final store =
        Provider.of<ShoppingListItemChangeNotifier>(context, listen: false);
    controller.addListener(() {
      final val = controller.text;
      if (val.isNotEmpty) {
        final amount = double.tryParse(val);
        if (amount != null) {
          store.amount = amount;
        }
      } else {
        store.amount = null;
      }
    });
    if (store.amount != null) {
      controller.text = store.amount!.toInt().toString();
    }

    return Consumer<ShoppingListItemChangeNotifier>(
      builder: (context, value, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
                border: value.amountErr != null
                    ? Border.all(color: Colors.red)
                    : null,
              ),
              padding: const EdgeInsets.only(left: 15.0),
              child: Row(
                children: [
                  const Text('Ksh'),
                  const SizedBox(width: 10.0),
                  Container(
                    width: 80.0,
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    decoration: const BoxDecoration(
                      color: textFieldBg,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0)),
                    ),
                    child: TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (value.amountErr != null)
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  value.amountErr!,
                  style:
                      const TextStyle(fontSize: 10.0, color: Colors.redAccent),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _SearchListItemsField extends HookWidget {
  final ValueChanged<String> onChanged;

  const _SearchListItemsField({Key? key, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final text = useState<String>('');
    controller.addListener(() {
      text.value = controller.text;
      onChanged(text.value);
    });

    return Container(
      height: 40.0,
      padding: const EdgeInsets.only(right: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        children: [
          if (text.value.isNotEmpty)
            SizedBox(
              width: 40.0,
              height: 40.0,
              child: Center(
                child: IconButton(
                  iconSize: 14.0,
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.clear();
                  },
                ),
              ),
            ),
          Expanded(
            child: TextField(
              // onChanged: (val) {
              // controller.text = val;
              // },
              controller: controller,
              // onChanged: onChanged,
              decoration: InputDecoration(
                hintText: 'Search list',
                focusedBorder: InputBorder.none,
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                    vertical: 8, horizontal: controller.text.isEmpty ? 14 : 0),
              ),
              style: const TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityField extends HookWidget {
  const _QuantityField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final qtyType = useState<String?>(null);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        children: [
          const Text('Qty'),
          const SizedBox(width: 10.0),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 15.0),
              decoration: const BoxDecoration(
                color: textFieldBg,
              ),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'e.g 2.5'),
                onChanged: (val) {
                  double? quantity;
                  if (val.isNotEmpty) {
                    quantity = double.tryParse(val);
                  }

                  Provider.of<ShoppingListItemChangeNotifier>(context,
                          listen: false)
                      .quantity = quantity;
                },
              ),
            ),
            flex: 1,
          ),
          const SizedBox(width: 5.0),
          const VerticalDivider(color: Colors.black, width: 2.0),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: qtyType.value,
              alignment: Alignment.centerRight,
              items: [
                for (final val in const [
                  'KG',
                  'Grams',
                  'ML',
                  'Litres',
                  'Other'
                ])
                  DropdownMenuItem(
                    child: Text(val),
                    value: val,
                  )
              ],
              onChanged: (val) {
                qtyType.value = val ?? '';
                Provider.of<ShoppingListItemChangeNotifier>(context,
                        listen: false)
                    .quantityType = val?.isEmpty ?? true ? null : val;
              },
              hint: const Text('e.g KG'),
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandField extends HookWidget {
  const _BrandField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
      ),
      padding: const EdgeInsets.only(left: 15.0),
      child: Row(
        children: [
          const Text('Brand'),
          const SizedBox(width: 10.0),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 15.0),
              decoration: const BoxDecoration(
                color: textFieldBg,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0)),
              ),
              child: TextField(
                decoration: const InputDecoration(border: InputBorder.none),
                onChanged: (val) {
                  Provider.of<ShoppingListItemChangeNotifier>(context,
                          listen: false)
                      .brand = val.isEmpty ? null : val;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
