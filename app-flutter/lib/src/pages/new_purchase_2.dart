import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:date_field/date_field.dart';

import '../models/model.dart';
import '../constants/constants.dart';
import './select_vendors.dart';

class NewPurchasePage2 extends HookWidget {
  const NewPurchasePage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _NewPurchaseNotifier(date: DateTime.now()),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('New purchase'),
            backgroundColor: mainScaffoldBg,
            actions: [
              TextButton(
                  onPressed: () {},
                  child: const Text('SAVE',
                      style: TextStyle(color: Colors.black87))),
            ],
          ),
          backgroundColor: mainScaffoldBg,
          body: Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: Consumer<_NewPurchaseNotifier>(
                builder: (context, model, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15.0),
                      _VendorInput(
                        vendor: model.vendor,
                        onChanged: (vendor) {
                          Provider.of<_NewPurchaseNotifier>(context,
                                  listen: false)
                              .vendor = vendor;
                        },
                      ),
                      const SizedBox(height: 16.0),
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
                          Provider.of<_NewPurchaseNotifier>(context,
                                  listen: false)
                              .date = d;
                        },
                        initialValue: model.date,
                      ),
                    ],
                  );
                },
              )),
        );
      },
    );
  }
}

class _VendorInput extends StatelessWidget {
  const _VendorInput({Key? key, required this.onChanged, this.vendor})
      : super(key: key);

  final Vendor? vendor;
  final ValueChanged<Vendor> onChanged;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            final vendor = await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    const SelectVendorPage(title: 'Select place of purchase')));
            if (vendor is Vendor) {
              onChanged(vendor);
            }
          },
          splashColor: Colors.black26,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              // border: Border.all(color: Colors.black26),
            ),
            child: Row(
              children: [
                if (vendor == null)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Purchasing from',
                            style: TextStyle(
                                color: Colors.black54, fontSize: 12.0)),
                        Text('Select place of purchase',
                            style: TextStyle(
                                color: Colors.black38, fontSize: 18.0))
                      ],
                    ),
                  ),
                if (vendor != null)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Purchasing from',
                            style: TextStyle(
                                color: Colors.black54, fontSize: 12.0)),
                        Text(vendor!.name,
                            style: const TextStyle(
                                fontSize: 16.0, color: Colors.black87))
                      ],
                    ),
                  ),
                const SizedBox(width: 5.0),
                const Icon(FeatherIcons.chevronDown, color: Colors.black26),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NewPurchaseNotifier extends ChangeNotifier {
  _NewPurchaseNotifier({Vendor? vendor, DateTime? date})
      : _vendor = vendor,
        _date = date;

  Vendor? _vendor;
  DateTime? _date;

  set vendor(Vendor? vendor) {
    _vendor = vendor;
    notifyListeners();
  }

  Vendor? get vendor => _vendor;

  DateTime? get date => _date;
  set date(DateTime? date) {
    _date = date;
    notifyListeners();
  }
}
