import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable()
class PurchaseItem {
  final double? quantity;
  final String? quantityType;
  final int? units;
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

  double get total => units != null ? units! * pricePerUnit : pricePerUnit;

  Map<String, dynamic> toJson() => _$PurchaseItemToJson(this);

  factory PurchaseItem.fromJson(Map<String, dynamic> json) =>
      _$PurchaseItemFromJson(json);
}

@JsonSerializable()
class Item {
  final String name;
  @JsonKey(includeIfNull: false)
  final int? id;

  const Item({required this.name, this.id});

  Map<String, dynamic> toJson() => _$ItemToJson(this);

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
}

@JsonSerializable()
class Catalogue {
  final List<Item> items;
  final List<Vendor> vendors;

  const Catalogue({required this.items, required this.vendors});

  factory Catalogue.fromJson(Map<String, dynamic> json) =>
      _$CatalogueFromJson(json);

  Map<String, dynamic> toJson() => _$CatalogueToJson(this);
}

@JsonSerializable()
class Purchase {
  @JsonKey(includeIfNull: false)
  final int? id;
  @JsonKey(toJson: DateTimeToJson)
  final DateTime date;
  final Vendor vendor;
  final List<PurchaseItem>? items;
  @JsonKey(includeIfNull: false)
  final double? total;

  const Purchase(
      {this.id,
      required this.date,
      required this.vendor,
      this.items,
      this.total});

  factory Purchase.fromJson(Map<String, dynamic> json) =>
      _$PurchaseFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseToJson(this);
}

@JsonSerializable()
class Purchases {
  final List<Purchase> purchases;

  Purchases({required this.purchases});

  factory Purchases.fromJson(Map<String, dynamic> json) =>
      _$PurchasesFromJson(json);

  Map<String, dynamic> toJson() => _$PurchasesToJson(this);
}

@JsonSerializable()
class Vendor {
  @JsonKey(includeIfNull: false)
  final int? id;
  final String name;

  const Vendor({required this.name, this.id});

  factory Vendor.fromJson(Map<String, dynamic> json) => _$VendorFromJson(json);
  Map<String, dynamic> toJson() => _$VendorToJson(this);
}

String DateTimeToJson(DateTime date) {
  var duration = date.timeZoneOffset;
  if (duration.isNegative) {
    return (date.toLocal().toIso8601String().replaceAll(RegExp(r'Z'), '') +
        "-${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes - (duration.inHours * 60)).toString().padLeft(2, '0')}");
  } else {
    return (date.toLocal().toIso8601String().replaceAll(RegExp(r'Z'), '') +
        "+${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes - (duration.inHours * 60)).toString().padLeft(2, '0')}");
  }
}
