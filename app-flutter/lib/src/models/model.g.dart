// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseItem _$PurchaseItemFromJson(Map<String, dynamic> json) => PurchaseItem(
      quantity: (json['quantity'] as num).toDouble(),
      quantityType: json['quantityType'] as String,
      units: json['units'] as int,
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
      date: DateTime.parse(json['date'] as String),
      vendor: Vendor.fromJson(json['vendor'] as Map<String, dynamic>),
      items: (json['items'] as List<dynamic>)
          .map((e) => PurchaseItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PurchaseToJson(Purchase instance) => <String, dynamic>{
      'date': _DateTimeToJson(instance.date),
      'vendor': instance.vendor,
      'items': instance.items,
    };

Vendor _$VendorFromJson(Map<String, dynamic> json) => Vendor(
      name: json['name'] as String,
    );

Map<String, dynamic> _$VendorToJson(Vendor instance) => <String, dynamic>{
      'name': instance.name,
    };
