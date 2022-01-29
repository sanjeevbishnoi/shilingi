import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:date_field/date_field.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../models/model.dart';
import '../components/components.dart';
import '../gql/gql.dart';

var f = NumberFormat('#,##0.00', 'en_US');

class NewPurchasePage extends StatefulWidget {
  const NewPurchasePage([Key? key]) : super(key: key);

  @override
  State createState() => _NewPurchasePageState();
}

class _NewPurchasePageState extends State<NewPurchasePage> {
  DateTime? _date;
  String? _vendor;
  final List<PurchaseItem> _items = [];
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

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
                      color: Colors.white,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF8F8F8),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 30.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
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
                ),
                const SizedBox(height: 24.0),
                _Items(items: _items),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          label: Text('New item $loading'),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return NewItemModalSheet(
                    addItem: (item) {
                      addItem(item);
                    },
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
        data['vendor'] = purchase.vendor.toJson();
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
            Navigator.of(context).popUntil(ModalRoute.withName('/'));
          } else {
            Navigator.of(context).pop();
            var snackBar = const SnackBar(
              content: Text('Unable to save your purchase.'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        }).onError((error, stackTrace) {
          // Do some debugging
        });
      }
    }
  }

  void addItem(PurchaseItem item) {
    setState(() {
      _items.add(item);
    });
  }
}

class _Items extends StatelessWidget {
  final List<PurchaseItem> items;

  const _Items({required this.items, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
            children: [
              DataTable(
                columns: const [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Units'), numeric: true),
                  DataColumn(label: Text('Price (Ksh)'), numeric: true),
                ],
                rows: [
                  for (var item in items)
                    DataRow(cells: [
                      DataCell(
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 80),
                          child: Text(item.item.name),
                        ),
                      ),
                      DataCell(Text(item.units.toString())),
                      DataCell(Text(f.format(item.total))),
                    ]),
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
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
