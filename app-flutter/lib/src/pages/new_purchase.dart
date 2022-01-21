import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

import '../models/model.dart';
import '../components/components.dart';

var f = NumberFormat('#,##0.00', 'en_US');

class NewPurchasePage extends StatefulWidget {
  const NewPurchasePage([Key? key]) : super(key: key);

  @override
  State createState() => _NewPurchasePageState();
}

class _NewPurchasePageState extends State<NewPurchasePage> {
  _BodyState? _bodyState;
  @override
  void initState() {
    super.initState();
    _bodyState = _BodyState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New purchase')),
      backgroundColor: const Color(0xFFF8F8F8),
      resizeToAvoidBottomInset: true,
      body: _Body(state: _bodyState!),
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
                      _bodyState!.addItem(item);
                    },
                  );
                });
          }),
    );
  }
}

class _Body extends StatefulWidget {
  final _BodyState state;

  const _Body({required this.state});

  @override
  State createState() => state;
}

class _BodyState extends State<_Body> {
  DateTime? _date;
  final List<PurchaseItem> _items = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 30.0),
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
          ),
          const SizedBox(height: 12.0),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F3),
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: GestureDetector(
              onTap: _showDatePicker,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 18.0),
                child: Row(
                  children: [
                    Expanded(child: Text(_dateString())),
                    IconButton(
                        onPressed: () {
                          _showDatePicker();
                        },
                        icon: const Icon(Icons.calendar_today)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24.0),
          _Items(items: _items),
          const SizedBox(height: 24.0),
          ConstrainedBox(
              constraints: const BoxConstraints(minWidth: double.infinity),
              child:
                  ElevatedButton(onPressed: () {}, child: const Text('Save'))),
        ],
      ),
    );
  }

  String _dateString() {
    return _date != null
        ? DateFormat("EEE, MMM d, ''yy'").format(_date!)
        : 'Date of purchase';
  }

  void _showDatePicker() {
    DatePicker.showDatePicker(context, onConfirm: (dt) {
      setState(() {
        _date = dt;
      });
    });
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
          scrollDirection: Axis.horizontal,
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
