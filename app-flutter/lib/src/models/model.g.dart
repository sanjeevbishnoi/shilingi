// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseItem _$PurchaseItemFromJson(Map<String, dynamic> json) => PurchaseItem(
      quantity: (json['quantity'] as num?)?.toDouble(),
      quantityType: json['quantityType'] as String?,
      units: json['units'] as int?,
      brand: json['brand'] as String?,
      pricePerUnit: (json['pricePerUnit'] as num).toDouble(),
      item: Item.fromJson(json['item'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PurchaseItemToJson(PurchaseItem instance) =>
    <String, dynamic>{
      'quantity': instance.quantity,
      'quantityType': instance.quantityType,
      'units': instance.units,
      'brand': instance.brand,
      'pricePerUnit': instance.pricePerUnit,
      'item': instance.item,
    };

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      name: json['name'] as String,
    );

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'name': instance.name,
    };

Purchase _$PurchaseFromJson(Map<String, dynamic> json) => Purchase(
      id: json['id'] as int?,
      date: DateTime.parse(json['date'] as String),
      vendor: Vendor.fromJson(json['vendor'] as Map<String, dynamic>),
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => PurchaseItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$PurchaseToJson(Purchase instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['date'] = DateTimeToJson(instance.date);
  val['vendor'] = instance.vendor;
  val['items'] = instance.items;
  writeNotNull('total', instance.total);
  return val;
}

Purchases _$PurchasesFromJson(Map<String, dynamic> json) => Purchases(
      purchases: (json['purchases'] as List<dynamic>)
          .map((e) => Purchase.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PurchasesToJson(Purchases instance) => <String, dynamic>{
      'purchases': instance.purchases,
    };

Vendor _$VendorFromJson(Map<String, dynamic> json) => Vendor(
      name: json['name'] as String,
    );

Map<String, dynamic> _$VendorToJson(Vendor instance) => <String, dynamic>{
      'name': instance.name,
    };
