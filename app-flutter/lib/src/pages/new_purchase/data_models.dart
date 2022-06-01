import 'package:flutter/material.dart';

import 'package:uuid/uuid.dart';

import '../../models/model.dart';

const _uuid = Uuid();

class PurchaseItemModel extends ChangeNotifier {
  PurchaseItemModel({
    required this.itemId,
    int? units,
    double? pricePerUnit,
    double? quantity,
    String? quantityType,
    String? brand,
    this.uuid,
    this.item,
    bool isAmountPerItem = false,
  })  : _units = units,
        _pricePerUnit = pricePerUnit,
        _quantity = quantity,
        _quantityType = quantityType,
        _brand = brand,
        _isAmountPerItem = isAmountPerItem;

  factory PurchaseItemModel.fromItemModel(ItemModel model) {
    return PurchaseItemModel(
      itemId: model.itemId,
      units: model.units,
      pricePerUnit:
          model.isAmountPerItem ? model.amount : model.amount * model.units,
      quantity: model.quantity,
      quantityType: model.quantityType,
      brand: model.brand,
      uuid: model.uuid,
      item: model.item,
      isAmountPerItem: model.isAmountPerItem,
    );
  }

  final Item? item;
  final int itemId;
  final String? uuid;
  double? _pricePerUnit;
  int? _units = 1;
  double? _quantity;
  String? _quantityType;
  String? _brand;
  bool _isAmountPerItem;

  final Map<String, String> _errors = {};

  int? get units => _units;
  set units(int? units) {
    _units = units;
    notifyListeners();
  }

  double? get pricePerUnit => _pricePerUnit;
  set pricePerUnit(double? pricePerUnit) {
    _pricePerUnit = pricePerUnit;
    notifyListeners();
  }

  double? get quantity => _quantity;
  set quantity(double? quantity) {
    _quantity = quantity;
    notifyListeners();
  }

  String? get quantityType => _quantityType;
  set quantityType(String? quantityType) {
    _quantityType = quantityType;
    notifyListeners();
  }

  String? get brand => _brand;
  set brand(String? brand) {
    _brand = brand;
    notifyListeners();
  }

  bool get isAmountPerItem => _isAmountPerItem;
  set isAmountPerItem(bool isAmountPerItem) {
    _isAmountPerItem = isAmountPerItem;
    notifyListeners();
  }

  bool validate() {
    _errors.clear();
    if (_units == null) {
      _errors['units'] = 'This field is required';
    } else if (_units! < 1) {
      _errors['units'] = 'Units cannot be less than 1';
    }

    if (_pricePerUnit == null) {
      _errors['pricePerUnit'] = 'Amount is required';
    }

    notifyListeners();
    return _errors.isEmpty;
  }

  Map<String, String> get errors => _errors;

  ItemModel toItemModel() {
    if (uuid == null) {
      return ItemModel(
        uuid: _uuid.v1(),
        item: item,
        itemId: itemId,
        amount: _isAmountPerItem ? _pricePerUnit! : _pricePerUnit! / _units!,
        units: units!,
        quantity: _quantity,
        quantityType: _quantityType,
        brand: _brand,
        isAmountPerItem: _isAmountPerItem,
      );
    }
    return ItemModel(
      uuid: uuid!,
      item: item,
      itemId: itemId,
      amount: _isAmountPerItem ? _pricePerUnit! : _pricePerUnit! / _units!,
      units: units!,
      quantity: _quantity,
      quantityType: _quantityType,
      brand: _brand,
      isAmountPerItem: _isAmountPerItem,
    );
  }
}

class NewPurchaseModel extends ChangeNotifier {
  NewPurchaseModel(
      {Vendor? vendor, DateTime? date, List<ItemModel> items = const []})
      : _vendor = vendor,
        _date = date,
        _items = items;

  Vendor? _vendor;
  DateTime? _date;
  List<ItemModel> _items;

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

  List<ItemModel> get items => _items;
  set items(List<ItemModel> items) {
    _items = items;
    notifyListeners();
  }

  void addItem(ItemModel item) {
    _items = [...items, item];
    notifyListeners();
  }

  /// We could optionally use an index but that would mean we pass the index
  /// to the child widget that is responsible for displaying a modal in the base
  /// new page list view
  /// We will just stick to using uuid here to indentify what needs to be replaced
  void updateItem(ItemModel item) {
    final index = _items.indexWhere((i) => item.uuid == i.uuid);
    if (index != -1) {
      _items[index] = item;
      notifyListeners();
    }
  }

  void removeItem(int index) {
    _items = [...items.sublist(0, index), ...items.sublist(index + 1)];
    notifyListeners();
  }

  double get total {
    var total = 0.0;
    _items.forEach((item) {
      total += item.total;
    });
    return total;
  }
}

class ItemModel {
  const ItemModel({
    required this.itemId,
    required this.amount,
    required this.units,
    required this.uuid,
    this.isAmountPerItem = false,
    this.quantity,
    this.quantityType,
    this.brand,
    this.item,
  });

  final String uuid;
  final Item? item;
  final int itemId;
  final double amount;
  final int units;
  final double? quantity;
  final String? quantityType;
  final String? brand;
  final bool isAmountPerItem;

  double get total => units * amount;
}
