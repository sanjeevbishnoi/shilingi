import 'package:flutter/material.dart';

import './text_field.dart';
import '../models/model.dart';

class NewItemModalSheet extends StatefulWidget {
  final void Function(PurchaseItem) addItem;

  const NewItemModalSheet({Key? key, required this.addItem}) : super(key: key);

  @override
  State createState() => _NewItemFormWidget();
}

class _NewItemFormWidget extends State<NewItemModalSheet> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> data = {};

  _NewItemFormWidget();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFE7E9F2),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 30.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextFormField(
                  fieldName: "itemName",
                  labelText: 'Item name',
                  validator: requiredValidatorWithMessage(
                      'The name of the item is required'),
                  data: data,
                ),
                const SizedBox(height: 14.0),
                CustomTextFormField(
                  fieldName: "cost",
                  labelText: 'Cost of the items',
                  keyboardType: TextInputType.number,
                  validator: requiredValidatorWithMessage(
                      'How much did you pay for these set of items?'),
                  data: data,
                ),
                const SizedBox(height: 14.0),
                CustomTextFormField(
                  fieldName: "units",
                  labelText: 'How many items?',
                  keyboardType: TextInputType.number,
                  data: data,
                ),
                const SizedBox(height: 14.0),
                CustomTextFormField(
                  fieldName: "quantity",
                  labelText: 'Size per item e.g how many liters is it?',
                  keyboardType: TextInputType.number,
                  data: data,
                ),
                const SizedBox(height: 14.0),
                CustomTextFormField(
                  fieldName: "quantityType",
                  labelText: 'Unit of measurement? e.g grams, liters',
                  data: data,
                ),
                const SizedBox(height: 14.0),
                CustomTextFormField(
                  fieldName: 'brand',
                  labelText: 'What is the brand of the item?',
                  data: data,
                ),
                const SizedBox(height: 14.0),
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: double.infinity),
                  child: ElevatedButton(
                      onPressed: () {
                        _submit(context);
                      },
                      child: const Text('Add')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var d = <String, dynamic>{};
      for (var v in data.entries) {
        switch (v.key) {
          case 'itemName':
            d['item'] = {'name': v.value.text};
            break;
          case 'quantity':
            if (v.value.text.isNotEmpty) {
              d['quantity'] = double.parse(v.value.text);
            }
            break;
          case 'quantityType':
            d['quantityType'] = v.value.text;
            break;
          case 'units':
            if (v.value.text.isNotEmpty) {
              var units = int.parse(v.value.text);
              d['units'] = units;
              if (data.containsKey('cost') &&
                  data['cost']!.value.text.isNotEmpty) {
                d['pricePerUnit'] =
                    double.parse(data['cost']!.value.text) / units;
              }
            }
            break;
          case 'brand':
            d['brand'] = v.value.text;
            break;
          case 'cost':
            if (v.value.text.isNotEmpty) {
              // check if we have set units yet
              if (data.containsKey('units') &&
                  data['units']!.value.text.isNotEmpty) {
                var units = int.parse(data['units']!.value.text);
                d['pricePerUnit'] = double.parse(v.value.text) / units;
              } else {
                d['pricePerUnit'] = double.parse(v.value.text);
              }
            }
            break;
        }
      }
      // If units key has not been provided, manually set it to 1
      if (!d.containsKey('units') || d['units'] is! num) {
        d['units'] = 1;
      }
      var item = PurchaseItem.fromJson(d);
      widget.addItem(item);
      Navigator.of(context).pop();
    }
  }

  // Check whether item name has been provided and return it
  String? get _itemName {
    if (data.containsKey('itemName')) {
      return data['itemName']!.text;
    }
    return null;
  }
}
