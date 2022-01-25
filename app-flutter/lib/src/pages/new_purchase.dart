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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New purchase'),
        actions: [
          Mutation(
            options: MutationOptions(document: mutationCreatePurchase),
            builder: (createPurchase, result) {
              var loading = false;
              if (result != null && result.isLoading) {
                loading = true;
              }

              return IconButton(
                onPressed: loading
                    ? null
                    : () {
                        _submit(createPurchase);
                      },
                icon: const Icon(
                  Icons.save,
                  color: Colors.white,
                ),
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
          label: const Text('New item'),
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

  void _submit(RunMutation createPurchase) {
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
        for (var item in purchase.items) {
          var d = item.toJson();
          d['item'] = item.item.name;
          items.add(d);
        }
        data['vendor'] = purchase.vendor.toJson();
        data['items'] = items;
        createPurchase(<String, dynamic>{"input": data});
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
          child: DataTable(
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
        ),
      ],
    );
  }
}
