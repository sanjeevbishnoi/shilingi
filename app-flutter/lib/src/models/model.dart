library model;

import 'package:json_annotation/json_annotation.dart';

import '../components/azlistview_component.dart' show Nameable;

part 'model.g.dart';

@JsonSerializable()
class PurchaseItem {
  final double? quantity;
  final String? quantityType;
  final int? units;
  final String? brand;
  final double pricePerUnit;
  final Item? item;
  @JsonKey(includeIfNull: false)
  final Purchase? shopping;

  const PurchaseItem(
      {required this.quantity,
      required this.quantityType,
      required this.units,
      this.brand,
      required this.pricePerUnit,
      required this.item,
      this.shopping});

  double get total => units != null ? units! * pricePerUnit : pricePerUnit;

  Map<String, dynamic> toJson() => _$PurchaseItemToJson(this);

  factory PurchaseItem.fromJson(Map<String, dynamic> json) =>
      _$PurchaseItemFromJson(json);
}

@JsonSerializable()
class PurchaseItems {
  final List<PurchaseItem> shoppingItems;

  const PurchaseItems({required this.shoppingItems});

  factory PurchaseItems.fromJson(Map<String, dynamic> json) =>
      _$PurchaseItemsFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseItemsToJson(this);
}

@JsonSerializable()
class PurchaseItemEdge {
  final String? cursor;
  final PurchaseItem? node;

  const PurchaseItemEdge({this.cursor, this.node});

  factory PurchaseItemEdge.fromJson(Json json) =>
      _$PurchaseItemEdgeFromJson(json);

  Json toJson() => _$PurchaseItemEdgeToJson(this);
}

@JsonSerializable()
class PurchaseItemConnection {
  final int? totalCount;
  final PageInfo? pageInfo;
  final List<PurchaseItemEdge>? edges;

  const PurchaseItemConnection({this.totalCount, this.pageInfo, this.edges});

  factory PurchaseItemConnection.fromJson(Json json) =>
      _$PurchaseItemConnectionFromJson(json);

  Json toJson() => _$PurchaseItemConnectionToJson(this);
}

@JsonSerializable()
class Item implements Nameable {
  @override
  final String name;
  @JsonKey(includeIfNull: false)
  final int? id;
  @JsonKey(includeIfNull: false)
  final List<Tag>? tags;
  @JsonKey(includeIfNull: false)
  final PurchaseItemConnection? purchases;

  const Item({required this.name, this.id, this.tags, this.purchases});

  Map<String, dynamic> toJson() => _$ItemToJson(this);

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
}

@JsonSerializable()
class Items {
  final List<Item> items;
  @JsonKey(includeIfNull: false)
  final List<Tag>? tags;

  const Items({required this.items, this.tags});

  factory Items.fromJson(Map<String, dynamic> json) => _$ItemsFromJson(json);
  Map<String, dynamic> toJson() => _$ItemsToJson(this);
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
  final Vendor? vendor;
  final List<PurchaseItem>? items;
  @JsonKey(includeIfNull: false)
  final double? total;

  const Purchase(
      {this.id, required this.date, this.vendor, this.items, this.total});

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

@JsonSerializable()
class Tag {
  @JsonKey(includeIfNull: false)
  final int? id;
  final String name;
  @JsonKey(includeIfNull: false)
  final List<SubLabel>? children;

  const Tag({required this.name, this.id, this.children});

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
  Map<String, dynamic> toJson() => _$TagToJson(this);

  @override
  int get hashCode => id ?? 0;

  @override
  bool operator ==(Object other) {
    if (other is! Tag) {
      return false;
    }

    if (id != null) {
      return id == other.id;
    }
    return name == other.name;
  }
}

@JsonSerializable()
class Tags {
  final List<Tag> tags;

  const Tags({required this.tags});

  factory Tags.fromJson(Map<String, dynamic> json) => _$TagsFromJson(json);
  Map<String, dynamic> toJson() => _$TagsToJson(this);
}

@JsonSerializable()
class SubLabel {
  @JsonKey(includeIfNull: false)
  final int? id;
  final String name;
  @JsonKey(includeIfNull: false)
  final List<Item>? items;

  const SubLabel({required this.name, this.id, this.items});

  factory SubLabel.fromJson(Map<String, dynamic> json) =>
      _$SubLabelFromJson(json);

  Map<String, dynamic> toJson() => _$SubLabelToJson(this);
}

@JsonSerializable()
class PageInfo {
  final bool? hasNextPage;
  final bool? hasPreviousPage;
  final String? startCursor;
  final String? endCursor;

  const PageInfo(
      {this.hasNextPage,
      this.hasPreviousPage,
      this.startCursor,
      this.endCursor});

  factory PageInfo.fromJson(Json json) => _$PageInfoFromJson(json);

  Json toJson() => _$PageInfoToJson(this);
}

typedef Json = Map<String, dynamic>;

@JsonSerializable()
class ShoppingListItem {
  final int id;
  final Item item;
  final PurchaseItem? purchase;

  const ShoppingListItem({required this.id, required this.item, this.purchase});

  factory ShoppingListItem.fromJson(Json json) =>
      _$ShoppingListItemFromJson(json);

  Json toJson() => _$ShoppingListItemToJson(this);
}

@JsonSerializable()
class ShoppingList {
  final int id;
  final String name;
  final DateTime? createTime;
  final DateTime? updateTime;
  final List<ShoppingListItem>? items;

  const ShoppingList(
      {required this.id,
      required this.name,
      this.createTime,
      this.updateTime,
      this.items});

  factory ShoppingList.fromJson(Json json) => _$ShoppingListFromJson(json);

  Json toJson() => _$ShoppingListToJson(this);
}

@JsonSerializable()
class ShoppingListEdge {
  final String? cursor;
  final ShoppingList node;

  const ShoppingListEdge({this.cursor, required this.node});

  factory ShoppingListEdge.fromJson(Json json) =>
      _$ShoppingListEdgeFromJson(json);

  Json toJson() => _$ShoppingListEdgeToJson(this);
}

@JsonSerializable()
class ShoppingListConnection {
  final int? totalCount;
  final PageInfo? pageInfo;
  final List<ShoppingListEdge> edges;

  const ShoppingListConnection(
      {this.totalCount, this.pageInfo, required this.edges});

  factory ShoppingListConnection.fromJson(Json json) =>
      _$ShoppingListConnectionFromJson(json);

  Json toJson() => _$ShoppingListConnectionToJson(this);
}
