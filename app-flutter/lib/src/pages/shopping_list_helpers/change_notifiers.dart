import 'package:flutter/material.dart';

class ShoppingListItemChangeNotifier extends ChangeNotifier {
  ShoppingListItemChangeNotifier();

  double? _amount;
  int _units = 1;
  double? _quantity;
  String? _quantityType;
  String? _brand = '';

  // Error messages
  String? _amountErr;
  String? _unitsErr;

  set amount(double? amount) => _amount = amount;
  set units(int units) => _units = units;
  set quantity(double quantity) => _quantity = quantity;
  set quantityType(String quantityType) => _quantityType = quantityType;
  set brand(String brand) => _brand = brand;

  String? get amountErr => _amountErr;
  String? get unitsErr => _unitsErr;

  bool validate() {
    clearErrors();

    var foundErr = false;

    if (_amount == null || _amount == 0) {
      _amountErr = 'Amount is required';
      foundErr = true;
    }
    if (_units < 1) {
      _unitsErr = 'Units cannot be less than 1';
      foundErr = true;
    }

    notifyListeners();
    return !foundErr;
  }

  void clearErrors() {
    _amountErr = null;
    _unitsErr = null;
    notifyListeners();
  }

  void clear() {
    _amount = null;
    _units = 1;
    _quantity = null;
    _quantityType = _brand = null;

    clearErrors();
  }

  Map<String, dynamic> toJson() {
    return {
      'pricePerUnit': _amount,
      'units': _units,
      if (_quantity != null) 'quantity': _quantity,
      if (_quantityType != null) 'quantityType': _quantityType,
      if (_brand != null) 'brand': _brand,
    };
  }
}
