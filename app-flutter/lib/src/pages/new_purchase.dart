import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

import '../models/model.dart';

var f = NumberFormat('#,##0.00', 'en_US');

class NewPurchasePage extends StatefulWidget {
  const NewPurchasePage([Key? key]) : super(key: key);

  @override
  State createState() => _NewPurchasePageState();
}

class _NewPurchasePageState extends State<NewPurchasePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New purchase')),
      backgroundColor: const Color(0xFFF8F8F8),
      body: _Body(),
    );
  }
}

class _Body extends StatefulWidget {
  @override
  State createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  DateTime? _date;

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
          const _Items(
            items: [
              PurchaseItem(
                quantity: 100,
                quantityType: 'grams',
                units: 50,
                pricePerUnit: 300,
                item: Item(name: 'Flour'),
              ),
              PurchaseItem(
                quantity: 100,
                quantityType: 'grams',
                units: 100,
                pricePerUnit: 300,
                item: Item(name: "Sugar"),
              ),
              PurchaseItem(
                quantity: 100,
                quantityType: 'grams',
                units: 4,
                pricePerUnit: 150,
                item: Item(name: "Salt"),
              ),
            ],
          ),
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
        DataTable(
          columns: const [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Units'), numeric: true),
            DataColumn(label: Text('Price (Ksh)'), numeric: true),
          ],
          rows: [
            for (var item in items)
              DataRow(cells: [
                DataCell(Text(item.item.name)),
                DataCell(Text(item.units.toString())),
                DataCell(Text(f.format(item.total))),
              ]),
          ],
        ),
      ],
    );
  }
}
