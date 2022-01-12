import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

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
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 18.0),
              child: Row(
                children: [
                  Expanded(child: Text(_dateString())),
                  IconButton(
                      onPressed: () {
                        DatePicker.showDatePicker(context, onConfirm: (dt) {
                          setState(() {
                            _date = dt;
                          });
                        });
                      },
                      icon: const Icon(Icons.calendar_today)),
                ],
              ),
            ),
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
}
