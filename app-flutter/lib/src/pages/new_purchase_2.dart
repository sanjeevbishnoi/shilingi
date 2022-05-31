import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:date_field/date_field.dart';

import '../models/model.dart';
import '../constants/constants.dart';
import './select_vendors.dart';
import './select_item.dart';
import '../components/numeric.dart';
import './new_purchase/data_models.dart';

const _textFieldBg = Color(0XFFFAFAFA);
var _format = NumberFormat('#,##0', 'en_US');

class NewPurchasePage2 extends HookWidget {
  const NewPurchasePage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NewPurchaseModel(date: DateTime.now()),
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
                    final i = await showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (context) {
                        return ChangeNotifierProvider(
                          create: (context) => PurchaseItemModel(
                            item: item,
                            itemId: item.id!,
                            units: 1,
                          ),
                          builder: (context, child) {
                            return Padding(
                              padding: MediaQuery.of(context).viewInsets,
                              child: _NewItemModal(item: item),
                            );
                          },
                        );
                      },
                    );
                    if (i is ItemModel) {
                      Provider.of<NewPurchaseModel>(
                        context,
                        listen: false,
                      ).addItem(i);
                    }
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
            child: Consumer<NewPurchaseModel>(
              builder: (context, model, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15.0),
                    _VendorInput(
                      vendor: model.vendor,
                      onChanged: (vendor) {
                        Provider.of<NewPurchaseModel>(context, listen: false)
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
                        Provider.of<NewPurchaseModel>(context, listen: false)
                            .date = d;
                      },
                      initialValue: model.date,
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        const Text(
                          'Added',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 10.0),
                        Text(
                          model.items.length.toString() +
                              ' item' +
                              (model.items.length > 1 ? 's' : ''),
                          style: const TextStyle(color: Colors.grey),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text('Total'),
                              const SizedBox(width: 10.0),
                              Text(
                                _format.format(model.total),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Expanded(
                      child: ListView.builder(
                          itemBuilder: (context, index) {
                            return Dismissible(
                              key: ValueKey(model.items[index].uuid),
                              child: _ItemModelWidget(
                                model: model.items[index],
                              ),
                              background: Container(
                                margin: const EdgeInsets.only(bottom: 16.0),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14.0, horizontal: 14.0),
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Row(
                                  children: const [
                                    Icon(FeatherIcons.trash),
                                    SizedBox(width: 10.0),
                                    Text('Remove'),
                                  ],
                                ),
                              ),
                              direction: DismissDirection.startToEnd,
                              onDismissed: (direction) {
                                Provider.of<NewPurchaseModel>(
                                  context,
                                  listen: false,
                                ).removeItem(index);
                              },
                            );
                          },
                          itemCount: model.items.length),
                    ),
                  ],
                );
              },
            ),
          ),
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

class _NewItemModal extends StatelessWidget {
  const _NewItemModal({Key? key, required this.item}) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Consumer<PurchaseItemModel>(
      builder: (context, model, child) {
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
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: _AmountTextField(
                          amount: model.pricePerUnit,
                          onChanged: (pricePerUnit) {
                            Provider.of<PurchaseItemModel>(
                              context,
                              listen: false,
                            ).pricePerUnit = pricePerUnit;
                          },
                          error: model.errors['pricePerUnit'],
                        ),
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
                              return SpinBox(
                                initial: model.units ?? 1,
                                onChanged: (units) {
                                  Provider.of<PurchaseItemModel>(
                                    context,
                                    listen: false,
                                  ).units = units;
                                },
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
                      Text('Optional fields',
                          style: TextStyle(color: Colors.grey)),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: Divider(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _QuantityField(
                          quantity: model.quantity?.toString() ?? '',
                          quantityType: model.quantityType,
                          quantityChanged: (quantity) {
                            Provider.of<PurchaseItemModel>(
                              context,
                              listen: false,
                            ).quantity = quantity;
                          },
                          quantityTypeChanged: (quantityType) {
                            Provider.of<PurchaseItemModel>(
                              context,
                              listen: false,
                            ).quantityType = quantityType;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  _BrandField(
                    brand: model.brand,
                    onChanged: (brand) {
                      Provider.of<PurchaseItemModel>(
                        context,
                        listen: false,
                      ).brand = brand;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel',
                              style: TextStyle(color: Colors.grey))),
                      // if (storeItem != null) ...[
                      // const SizedBox(width: 10.0),
                      // TextButton(
                      // onPressed: () {
                      // onRemove();
                      // },
                      // child: const Text('Remove',
                      // style: TextStyle(color: Colors.redAccent))),
                      // ],
                      const SizedBox(width: 10.0),
                      Builder(builder: (context) {
                        return ElevatedButton(
                          onPressed: () {
                            final provider = Provider.of<PurchaseItemModel>(
                              context,
                              listen: false,
                            );
                            if (provider.validate()) {
                              Navigator.of(context).pop(provider.toItemModel());
                            }
                          },
                          child: const Text('Save'),
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all<double>(0),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AmountTextField extends HookWidget {
  const _AmountTextField({Key? key, this.amount, this.onChanged, this.error})
      : super(key: key);

  final double? amount;
  final ValueChanged<double?>? onChanged;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final controller =
        useTextEditingController(text: amount != null ? amount.toString() : '');
    controller.addListener(() {
      if (onChanged != null && controller.text.isNotEmpty) {
        final val = double.tryParse(controller.text);
        onChanged!(val);
      } else if (onChanged != null) {
        onChanged!(null);
      }
    });
    final focusNodeValue = useState<FocusNode>(FocusNode());
    final isMounted = useIsMounted();
    useEffect(() {
      if (isMounted()) {
        focusNodeValue.value.requestFocus();
      }
      return;
    }, [isMounted]);

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
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              error!,
              style: const TextStyle(fontSize: 10.0, color: Colors.redAccent),
            ),
          ),
      ],
    );
  }
}

class _QuantityField extends HookWidget {
  const _QuantityField(
      {Key? key,
      this.quantity,
      this.quantityType,
      this.quantityChanged,
      this.quantityTypeChanged})
      : super(key: key);

  final String? quantity;
  final String? quantityType;
  final ValueChanged<double?>? quantityChanged;
  final ValueChanged<String?>? quantityTypeChanged;

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

                  Provider.of<PurchaseItemModel>(
                    context,
                    listen: false,
                  ).quantity = quantity;
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
                Provider.of<PurchaseItemModel>(
                  context,
                  listen: false,
                ).quantityType = val;
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

class _BrandField extends StatelessWidget {
  const _BrandField({Key? key, this.brand, this.onChanged}) : super(key: key);

  final String? brand;
  final ValueChanged<String?>? onChanged;

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
                  if (onChanged != null) {
                    onChanged!(val);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemModelWidget extends StatelessWidget {
  const _ItemModelWidget({Key? key, required this.model}) : super(key: key);

  final ItemModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
        child: InkWell(
          splashColor: Colors.black12,
          borderRadius: BorderRadius.circular(8.0),
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.transparent,
            ),
            padding:
                const EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.item!.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14.0),
                      ),
                      const SizedBox(height: 5.0),
                      if (model.quantity != null) ...[
                        Row(
                          children: [
                            Text(
                              _format.format(model.quantity!),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12.0,
                              ),
                            ),
                            if (model.quantityType != null) ...[
                              const SizedBox(width: 2.0),
                              Text(
                                model.quantityType!,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                      if (model.brand != null) ...[
                        Text(
                          model.brand!,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Text('Ksh ' + _format.format(model.total)),
                const SizedBox(width: 5.0),
                const Icon(FeatherIcons.chevronRight),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
