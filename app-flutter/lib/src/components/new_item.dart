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
                  fieldName: "units",
                  labelText: 'How many items?',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return _itemName != null && !_itemName!.isEmpty
                          ? 'How many units of $_itemName did you get?'
                          : 'Specify the number of items you bought';
                    }
                  },
                  data: data,
                ),
                const SizedBox(height: 14.0),
                CustomTextFormField(
                  fieldName: "pricePerUnit",
                  labelText: 'Price per item',
                  keyboardType: TextInputType.number,
                  validator: requiredValidatorWithMessage(
                      'What is the price for each item?'),
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
                  validator:
                      requiredValidatorWithMessage('E.g liters, kgs, grams'),
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
            d['quantity'] = double.parse(v.value.text);
            break;
          case 'quantityType':
            d['quantityType'] = v.value.text;
            break;
          case 'units':
            d['units'] = int.parse(v.value.text);
            break;
          case 'brand':
            d['brand'] = v.value.text;
            break;
          case 'pricePerUnit':
            d['pricePerUnit'] = double.parse(v.value.text);
            break;
        }
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
