import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shilingi/src/components/components.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import '../gql/gql.dart';
import '../models/model.dart';
import '../constants/constants.dart';
import './purchase_details.dart';
import './settings/settings.dart';
import '../style/style.dart';

var shoppingNumberFormat =
    NumberFormat.compactCurrency(decimalDigits: 2, symbol: '');

enum appBarDropDown {
  editItem,
}

class ShoppingItemDetailPage extends StatefulWidget {
  const ShoppingItemDetailPage({Key? key}) : super(key: key);

  @override
  State createState() => _ShoppingItemDetailPage();
}

class _ShoppingItemDetailPage extends State {
  bool _loading = false;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<PurchaseItem> _items = [];
  String _itemName = '';

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ShoppingItemRouteSettings;
    if (_itemName.isEmpty) {
      _itemName = args.name;
    }
    return Scaffold(
      backgroundColor: mainScaffoldBg,
      appBar: AppBar(
        title: Text('$_itemName Details'),
        actions: [
          PopupMenuButton(
              onSelected: (value) {
                switch (value) {
                  case appBarDropDown.editItem:
                    showDialog(
                        context: context,
                        builder: (context) {
                          return _EditItemNameDialog(
                              name: _itemName,
                              itemId: args.itemId,
                              onSuccess: (value) {
                                setState(() {
                                  _itemName = value;
                                });
                              });
                        });
                    break;
                }
              },
              itemBuilder: (context) => <PopupMenuItem<appBarDropDown>>[
                    const PopupMenuItem(
                      child: Text('Edit name'),
                      value: appBarDropDown.editItem,
                    ),
                  ]),
        ],
      ),
      body: ListView(
        children: [
          TableCalendar<PurchaseItem>(
            calendarStyle: customCalendarStyle,
            focusedDay: _focusedDay,
            firstDay: DateTime.now().subtract(const Duration(days: 365 * 3)),
            lastDay: DateTime.now(),
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });
            },
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onCalendarCreated: (_) {
              var dates = _getMonthDateRange(_focusedDay);
              var after = dates[0];
              var before = dates[1];
              _fetchShoppingItems(context, args.itemId, after, before);
            },
            onPageChanged: (focused) {
              var dates = _getMonthDateRange(focused);
              var after = dates[0];
              var before = dates[1];
              _fetchShoppingItems(context, args.itemId, after, before);
              _focusedDay = focused;
            },
            eventLoader: (day) {
              return _items
                  .where((element) =>
                      isSameDay(element.shopping!.date.toLocal(), day))
                  .toList();
            },
            calendarBuilders:
                CalendarBuilders(markerBuilder: (context, day, events) {
              if (events.isEmpty) {
                return null;
              }
              var total = 0.0;
              events.forEach((element) => total += element.total);
              return Align(
                alignment: Alignment.bottomCenter,
                child: Text('${shoppingNumberFormat.format(total)}/=',
                    style: const TextStyle(
                        fontSize: 10.0, fontWeight: FontWeight.w700)),
              );
            }),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 18.0, horizontal: 18.0),
            child: Row(
              children: [
                Expanded(
                    child: _StatCard(
                        title:
                            'Total in ${DateFormat("MMM").format(_focusedDay)}',
                        value: shoppingNumberFormat
                            .format(_calculateTotal(_items)))),
                const Expanded(child: SizedBox(width: 10)),
              ],
            ),
          ),
          _SelectedPurchaseItemsWidget(
            items: _items,
            loading: _loading,
            selectedDay: _selectedDay,
          )
        ],
      ),
    );
  }

  Future _fetchShoppingItems(
      BuildContext context, int id, DateTime after, DateTime before) {
    var client = GraphQLProvider.of(context).value;
    _loading = true;
    return client
        .query(
          QueryOptions(
            document: shoppingItemsQuery,
            variables: {
              'after': DateTimeToJson(after),
              'before': DateTimeToJson(before),
              'itemID': id,
            },
            fetchPolicy: FetchPolicy.cacheFirst,
          ),
        )
        .then((result) {
          if (result.data != null) {
            var items = PurchaseItems.fromJson(result.data!);
            setState(() {
              _items = items.shoppingItems;
            });
          }
        })
        .onError((error, stackTrace) {})
        .whenComplete(() {
          setState(() {
            _loading = false;
          });
        });
  }

  double _calculateTotal(List<PurchaseItem> items) {
    double total = 0;
    items.forEach((element) {
      total += element.total;
    });
    return total;
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 12.0),
          ),
        ],
      ),
    );
  }
}

List<DateTime> _getMonthDateRange(DateTime start) {
  var year = start.year;
  int month = 1;
  if (start.month < 12) {
    month = start.month + 1;
  } else {
    year += 1;
  }
  var end = DateTime(year, month, 1);

  return [DateTime(start.year, start.month, 1), end];
}

class _SelectedPurchaseItemsWidget extends StatelessWidget {
  final bool loading;
  final DateTime? selectedDay;
  final List<PurchaseItem> items;

  const _SelectedPurchaseItemsWidget(
      {Key? key, this.selectedDay, required this.items, required this.loading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
          child: Padding(
              padding: EdgeInsets.all(30.0),
              child: CircularProgressIndicator()));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 18.0),
      child: Column(
        children: items
            .where((element) =>
                isSameDay(element.shopping!.date.toLocal(), selectedDay))
            .map((e) => _PurchaseItem(item: e))
            .toList(),
      ),
    );
  }
}

class _PurchaseItem extends StatelessWidget {
  final PurchaseItem item;

  const _PurchaseItem({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
      ),
      margin: const EdgeInsets.only(bottom: 15.0),
      child: Material(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.transparent,
        child: InkWell(
            borderRadius: BorderRadius.circular(8.0),
            splashColor: Colors.black12,
            onTap: () {
              Navigator.of(context).pushNamed(PurchaseDetailsPage.routeName,
                  arguments: PurchaseDetailsRouteSettings(
                      purchaseId: item.shopping!.id!));
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 18.0, horizontal: 18.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ListTitleText(item.item!.name),
                            ),
                            const SizedBox(width: 10),
                            Text(
                                'Kes ${shoppingNumberFormat.format(item.total)}',
                                style: GoogleFonts.rubik().copyWith(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Text('Bought from ${item.shopping!.vendor!.name}')
                      ],
                    ),
                  ),
                  const SizedBox(width: 5.0),
                  const Icon(Icons.chevron_right),
                ],
              ),
            )),
      ),
    );
  }
}

class _EditItemNameDialog extends StatefulWidget {
  final String name;
  final int itemId;
  final ValueCallback<String> onSuccess;

  const _EditItemNameDialog(
      {Key? key,
      required this.name,
      required this.itemId,
      required this.onSuccess})
      : super(key: key);

  @override
  State createState() => _EditItemNameDialogState();
}

class _EditItemNameDialogState extends State<_EditItemNameDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;
  String _name = '';
  bool _loading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _name = widget.name;
    _controller = TextEditingController();
    _controller.text = _name;
    _controller.addListener(() {
      setState(() {
        _name = _controller.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rename item'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          enabled: !_loading,
          controller: _controller,
          decoration: InputDecoration(
            labelText: 'Item name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            errorText: _errorMessage,
            errorMaxLines: 3,
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: _loading
                ? null
                : () {
                    Navigator.of(context).pop();
                  },
            child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
        TextButton(
            onPressed: !_loading && _name.isNotEmpty
                ? () {
                    setState(() {
                      _loading = true;
                      _errorMessage = '';
                    });
                    var cli = GraphQLProvider.of(context).value;
                    var result = cli.mutate(
                      MutationOptions(
                        document: mutationEditItem,
                        variables: {
                          'id': widget.itemId,
                          'input': {
                            'name': _name,
                          },
                        },
                      ),
                    );
                    result.then((value) {
                      if (value.data != null) {
                        var item = Item.fromJson(value.data!['editItem']);
                        widget.onSuccess(item.name);
                        var snackBar =
                            const SnackBar(content: Text('Item name updated'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else if (value.hasException) {
                        if (value.exception!.graphqlErrors.isNotEmpty) {
                          setState(() {
                            _errorMessage =
                                value.exception!.graphqlErrors[0].message;
                            _loading = false;
                          });
                          return;
                        }
                        var snackBar = const SnackBar(
                            content: Text('Unable to update item name'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      Navigator.of(context).pop();
                    });
                  }
                : null,
            child: Text(_loading ? 'Saving...' : 'Ok')),
      ],
    );
  }
}
