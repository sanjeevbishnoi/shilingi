import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:date_field/date_field.dart';

import '../models/model.dart';
import '../constants/constants.dart';
import './select_vendors.dart';
import './select_item.dart';
import '../components/numeric.dart';

const _textFieldBg = Color(0XFFFAFAFA);

class NewPurchasePage2 extends HookWidget {
  const NewPurchasePage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _NewPurchaseModel(date: DateTime.now()),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('New purchase'),
            backgroundColor: mainScaffoldBg,
            actions: [
              IconButton(
                onPressed: () async {
                  final item = await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) =>
                              const SelectItemPage(title: 'Add items')));
                  if (item is Item) {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (context) {
                        return Padding(
                          padding: MediaQuery.of(context).viewInsets,
                          child: _NewItemModal(item: item),
                        );
                      },
                    );
                  }
                },
                icon: const Icon(FeatherIcons.plusCircle),
                color: Colors.greenAccent,
                iconSize: 18.0,
              ),
              TextButton(
                  onPressed: () {},
                  child: const Text('SAVE',
                      style: TextStyle(color: Colors.black87))),
            ],
          ),
          backgroundColor: mainScaffoldBg,
          body: Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: Consumer<_NewPurchaseModel>(
                builder: (context, model, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15.0),
                      _VendorInput(
                        vendor: model.vendor,
                        onChanged: (vendor) {
                          Provider.of<_NewPurchaseModel>(context, listen: false)
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
                          Provider.of<_NewPurchaseModel>(context, listen: false)
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

class _ItemModel {
  const _ItemModel({
    required this.itemId,
    required this.amount,
    required this.units,
    this.quantity,
    this.quantityType,
    this.brand,
  });

  final int itemId;
  final double amount;
  final int units;
  final double? quantity;
  final String? quantityType;
  final String? brand;
}

class _NewPurchaseModel extends ChangeNotifier {
  _NewPurchaseModel(
      {Vendor? vendor, DateTime? date, List<_ItemModel> items = const []})
      : _vendor = vendor,
        _date = date,
        _items = items;

  Vendor? _vendor;
  DateTime? _date;
  List<_ItemModel> _items;

  Vendor? get vendor => _vendor;
  set vendor(Vendor? vendor) {
    _vendor = vendor;
    notifyListeners();
  }

  DateTime? get date => _date;
  set date(DateTime? date) {
    _date = date;
    notifyListeners();
  }

  List<_ItemModel> get items => _items;
  set items(List<_ItemModel> items) {
    _items = items;
    notifyListeners();
  }

  void addItem(_ItemModel item) {
    _items.add(item);
    notifyListeners();
  }
}

class _NewItemModal extends StatelessWidget {
  const _NewItemModal({Key? key, required this.item}) : super(key: key);

  final Item item;

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
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 5.0),
                    child: _AmountTextField(),
                  ),
                  const SizedBox(width: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Text('Items'),
                      ),
                      Builder(
                        builder: (context) {
                          return const SpinBox(
                            initial: 1,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: const [
                  Text('Optional fields', style: TextStyle(color: Colors.grey)),
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
            ],
          ),
        ),
      ),
    );
  }
}

class _AmountTextField extends HookWidget {
  const _AmountTextField({Key? key, this.amount}) : super(key: key);

  final double? amount;

  @override
  Widget build(BuildContext context) {
    final controller =
        useTextEditingController(text: amount != null ? amount.toString() : '');
    controller.addListener(() {});
    final focusNodeValue = useState<FocusNode>(FocusNode());
    focusNodeValue.value.requestFocus();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.0),
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
                  color: _textFieldBg,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0)),
                ),
                child: TextField(
                  focusNode: focusNodeValue.value,
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
      ],
    );
  }
}

class _QuantityField extends HookWidget {
  const _QuantityField({Key? key, this.quantity, this.quantityType})
      : super(key: key);

  final String? quantity;
  final String? quantityType;

  @override
  Widget build(BuildContext context) {
    final qtyType = useState<String?>(quantityType);
    final qtyInitial =
        useState<String>(quantity != null ? quantity.toString() : '');

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
                color: _textFieldBg,
              ),
              child: TextFormField(
                initialValue: qtyInitial.value,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'e.g 2.5'),
                onChanged: (val) {
                  double? quantity;
                  if (val.isNotEmpty) {
                    quantity = double.tryParse(val);
                  }

                  // TODO: Set value
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
                // TODO: Set value
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
  const _BrandField({Key? key, this.brand}) : super(key: key);

  final String? brand;

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
                color: _textFieldBg,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0)),
              ),
              child: TextFormField(
                initialValue: brand,
                decoration: const InputDecoration(border: InputBorder.none),
                onChanged: (val) {
                  // TODO: Set value
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
