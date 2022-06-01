import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:date_field/date_field.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../models/model.dart';
import '../components/components.dart';
import '../gql/gql.dart';
import '../constants/constants.dart';

var f = NumberFormat('#,##0.00', 'en_US');

class NewPurchasePage extends StatefulWidget {
  const NewPurchasePage([Key? key]) : super(key: key);

  @override
  State createState() => _NewPurchasePageState();
}

class _NewPurchasePageState extends State<NewPurchasePage> {
  DateTime? _date = DateTime.now();
  String? _vendor;
  final List<PurchaseItem> _items = [];
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  final List<String> _vendors = [];
  final List<String> _itemNames = [];

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  double _total() {
    double total = 0;
    for (var item in _items) {
      total += item.units! * item.pricePerUnit;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New purchase'),
        actions: [
          Builder(
            builder: (context) {
              return Mutation(
                options: MutationOptions(
                  document: mutationCreatePurchase,
                  onCompleted: (_) {
                    loading = false;
                  },
                ),
                builder: (createPurchase, result) {
                  return IconButton(
                    onPressed: loading
                        ? null
                        : () {
                            _submit(context, createPurchase);
                          },
                    icon: const Icon(
                      Icons.save,
                    ),
                  );
                },
              );
            },
          ),
        ],
        backgroundColor: mainScaffoldBg,
      ),
      backgroundColor: mainScaffoldBg,
      resizeToAvoidBottomInset: true,
      body: Query(
        options: QueryOptions(document: vendorAndItemsNames),
        builder: (QueryResult result,
            {FetchMore? fetchMore, Refetch? refetch}) {
          if (result.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (result.data != null) {
            var vendorNames = result.data!['vendors'] as List<Object?>;
            _vendors.clear();
            vendorNames.forEach((element) {
              _vendors
                  .add((element! as Map<String, dynamic>)['name'] as String);
            });
            var itemNames = result.data!['items'] as List<Object?>;
            _itemNames.clear();
            itemNames.forEach((element) {
              _itemNames
                  .add((element! as Map<String, dynamic>)['name'] as String);
            });
          }

          return SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 18.0, horizontal: 30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Autocomplete<String>(
                      optionsBuilder: (value) {
                        return _vendors.where((element) => element
                            .toLowerCase()
                            .contains(value.text.toLowerCase()));
                      },
                      onSelected: (vendor) {
                        _vendor = vendor;
                      },
                      fieldViewBuilder:
                          (context, controller, focusNode, onFieldSubmitted) {
                        return TextFormField(
                          style: GoogleFonts.rubik().copyWith(
                            fontWeight: FontWeight.w900,
                            fontSize: 20.0,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Type in place of purchase',
                            border: InputBorder.none,
                          ),
                          validator: requiredValidatorWithMessage(
                              'Provide the specific vendor you purchased from'),
                          onChanged: (vendor) {
                            _vendor = vendor;
                          },
                          focusNode: focusNode,
                          controller: controller,
                        );
                      },
                    ),
                    const SizedBox(height: 12.0),
                    DateTimeFormField(
                      mode: DateTimeFieldPickerMode.date,
                      decoration: InputDecoration(
                        suffixIcon: const Icon(Icons.event_note),
                        filled: true,
                        fillColor: const Color(0xFFF3F3F3),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        labelText: 'Date of purchase',
                      ),
                      validator: (date) {
                        if (date == null) {
                          return 'When did you make this purchase?';
                        }
                        return null;
                      },
                      onDateSelected: (d) {
                        _date = d;
                      },
                      initialValue: DateTime.now(),
                    ),
                    const SizedBox(height: 24.0),
                    Row(
                      children: [
                        const Expanded(
                            child: Text('Total:',
                                style: TextStyle(fontWeight: FontWeight.w700))),
                        Text('Kes ' + f.format(_total()),
                            style:
                                const TextStyle(fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 14.0),
                    _Items(
                      items: _items,
                      removeItem: _removeItem,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          label: const Text('New item'),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: NewItemModalSheet(
                      addItem: (item) {
                        addItem(context, item);
                      },
                      itemNames: _itemNames,
                    ),
                  );
                });
          }),
    );
  }

  void _submit(BuildContext context, RunMutation createPurchase) {
    if (_formKey.currentState!.validate()) {
      if (_items.isEmpty) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                content: const Text(
                    'You have not provided a list of items purchased'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'))
                ],
              );
            });
      } else {
        var purchase = Purchase(
            date: _date!, vendor: Vendor(name: _vendor!), items: _items);
        var data = purchase.toJson();
        var items = <dynamic>[];
        for (var item in purchase.items ?? []) {
          var d = item.toJson();
          d['item'] = item.item.name;
          items.add(d);
        }
        data['vendor'] = purchase.vendor!.toJson();
        data['items'] = items;
        showDialog(
            context: context,
            builder: (_) {
              return WillPopScope(
                child: AlertDialog(
                  content: Row(
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(width: 20),
                      Text('Saving'),
                    ],
                  ),
                ),
                onWillPop: () async {
                  return !loading;
                },
              );
            },
            barrierDismissible: false);
        setState(() {
          loading = true;
        });
        var result = createPurchase(<String, dynamic>{"input": data});
        var networkResult = result.networkResult! as Future<QueryResult>;
        networkResult.then((result) {
          if (result.data != null) {
            var snackBar = const SnackBar(
              content: Text('Your purchase has been saved'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Navigator.of(context).popUntil(ModalRoute.withName('/'));
          } else {
            Navigator.of(context).pop();
            var snackBar = const SnackBar(
              content: Text('Unable to save your purchase'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        }).onError((error, stackTrace) {
          // Do some debugging
        });
      }
    }
  }

  bool _checkDuplicate(PurchaseItem item) {
    return _items.indexWhere((element) =>
            element.item!.name.toLowerCase() ==
            item.item!.name.toLowerCase()) !=
        -1;
  }

  void addItem(BuildContext context, PurchaseItem item) {
    if (_checkDuplicate(item)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: const Text('An existing item already exists'),
          actions: [
            TextButton(
                onPressed: () {
                  var index = _items.indexWhere((element) =>
                      element.item!.name.toLowerCase() ==
                      item.item!.name.toLowerCase());
                  setState(() {
                    _items[index] = item;
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Replace')),
            TextButton(
                onPressed: () {
                  setState(() {
                    _items.add(item);
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Add anyway')),
          ],
        ),
      );
    } else {
      setState(() {
        _items.add(item);
      });
    }
  }
}

class _Items extends StatelessWidget {
  final List<PurchaseItem> items;
  final Function(int) removeItem;

  const _Items({required this.items, required this.removeItem, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            minWidth: MediaQuery.of(context).size.width - 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Items',
              style: TextStyle(
                color: Color(0xFFA3A3A3),
                fontSize: 18.0,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12.0),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DataTable(
                    columns: const [
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Units'), numeric: true),
                      DataColumn(label: Text('Price (Ksh)'), numeric: true),
                      DataColumn(label: Text('')),
                    ],
                    rows: [
                      ...items
                          .asMap()
                          .keys
                          .toList()
                          .map<DataRow>((i) => DataRow(cells: [
                                DataCell(
                                  ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(maxWidth: 80),
                                    child: Text(items[i].item!.name),
                                  ),
                                ),
                                DataCell(Text(items[i].units.toString())),
                                DataCell(Text(f.format(items[i].total))),
                                DataCell(
                                    ConstrainedBox(
                                      constraints:
                                          const BoxConstraints(maxWidth: 1.0),
                                      child: const Icon(Icons.delete),
                                    ), onTap: () {
                                  removeItem(i);
                                }),
                              ]))
                          .toList()
                    ],
                  ),
                  if (items.isEmpty)
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xffffe08a),
                      ),
                      width: double.infinity,
                      child: const Padding(
                        child: Text('No items added yet'),
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 12.0),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
