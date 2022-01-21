import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable()
class PurchaseItem {
  final double quantity;
  final String quantityType;
  final int units;
  final String? brand;
  final double pricePerUnit;
  final Item item;

  const PurchaseItem(
      {required this.quantity,
      required this.quantityType,
      required this.units,
      this.brand,
      required this.pricePerUnit,
      required this.item});

  double get total => units * pricePerUnit;

  Map<String, dynamic> toJson() => _$PurchaseItemToJson(this);

  factory PurchaseItem.fromJson(Map<String, dynamic> json) =>
      _$PurchaseItemFromJson(json);
}

@JsonSerializable()
class Item {
  final String name;

  const Item({required this.name});

  Map<String, dynamic> toJson() => _$ItemToJson(this);

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
}

class Purchase {
  final DateTime date;
  final Vendor vendor;
  final List<PurchaseItem> items;

  const Purchase(
      {required this.date, required this.vendor, required this.items});

  factory Purchase.fromJson(Map<String, dynamic> json) =>
      _$PurchaseFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseToJson(this);
}

@JsonSerializable()
class Vendor {
  final String name;

  const Vendor({required this.name});

  factory Vendor.fromJson(Map<String, dynamic> json) => _$VendorFromJson(json);
  Map<String, dynamic> toJson() => _$VendorToJson(this);
}
