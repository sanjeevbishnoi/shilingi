import 'package:flutter/material.dart';

import 'package:uuid/uuid.dart';

import '../../models/model.dart';

const uuid = Uuid();

class PurchaseItemModel extends ChangeNotifier {
  PurchaseItemModel({
    required this.itemId,
    int? units,
    double? pricePerUnit,
    double? quantity,
    String? quantityType,
    String? brand,
    this.item,
  })  : _units = units,
        _pricePerUnit = pricePerUnit,
        _quantity = quantity,
        _quantityType = quantityType,
        _brand = brand;

  final Item? item;
  final int itemId;
  double? _pricePerUnit;
  int? _units = 1;
  double? _quantity;
  String? _quantityType;
  String? _brand;

  Map<String, String> _errors = {};

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

  ItemModel toItemModel() => ItemModel(
        uuid: uuid.v1(),
        item: item,
        itemId: itemId,
        amount: _pricePerUnit!,
        units: units!,
        quantity: _quantity,
        quantityType: _quantityType,
        brand: _brand,
      );
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

  double get total => units * amount;
}
