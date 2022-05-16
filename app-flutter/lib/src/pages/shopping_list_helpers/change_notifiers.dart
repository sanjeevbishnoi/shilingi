import 'package:flutter/material.dart';

class ShoppingListItemChangeNotifier extends ChangeNotifier {
  ShoppingListItemChangeNotifier({
    this.amount,
    this.units = 1,
    this.quantity,
    this.quantityType,
    this.brand,
  });

  double? amount;
  int units = 1;
  double? quantity;
  String? quantityType;
  String? brand;

  // Error messages
  String? _amountErr;
  String? _unitsErr;

  String? get amountErr => _amountErr;
  String? get unitsErr => _unitsErr;

  bool validate() {
    clearErrors();

    var foundErr = false;

    if (amount == null || amount == 0) {
      _amountErr = 'Amount is required';
      foundErr = true;
    }
    if (units < 1) {
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
    amount = null;
    units = 1;
    quantity = null;
    quantityType = brand = null;

    clearErrors();
  }

  Map<String, dynamic> toJson() {
    return {
      'pricePerUnit': amount?.toInt() ?? 0,
      'units': units,
      if (quantity != null) 'quantity': quantity,
      if (quantityType != null) 'quantityType': quantityType,
      if (brand != null) 'brand': brand,
    };
  }
}
