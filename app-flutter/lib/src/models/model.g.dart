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
      item: json['item'] == null
          ? null
          : Item.fromJson(json['item'] as Map<String, dynamic>),
      shopping: json['shopping'] == null
          ? null
          : Purchase.fromJson(json['shopping'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PurchaseItemToJson(PurchaseItem instance) {
  final val = <String, dynamic>{
    'quantity': instance.quantity,
    'quantityType': instance.quantityType,
    'units': instance.units,
    'brand': instance.brand,
    'pricePerUnit': instance.pricePerUnit,
    'item': instance.item,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('shopping', instance.shopping);
  return val;
}

PurchaseItems _$PurchaseItemsFromJson(Map<String, dynamic> json) =>
    PurchaseItems(
      shoppingItems: (json['shoppingItems'] as List<dynamic>)
          .map((e) => PurchaseItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PurchaseItemsToJson(PurchaseItems instance) =>
    <String, dynamic>{
      'shoppingItems': instance.shoppingItems,
    };

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      name: json['name'] as String,
      id: json['id'] as int?,
      tags: (json['tags'] as List<dynamic>?)
          ?.map((e) => Tag.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ItemToJson(Item instance) {
  final val = <String, dynamic>{
    'name': instance.name,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('tags', instance.tags);
  return val;
}

Items _$ItemsFromJson(Map<String, dynamic> json) => Items(
      items: (json['items'] as List<dynamic>)
          .map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList(),
      tags: (json['tags'] as List<dynamic>?)
          ?.map((e) => Tag.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ItemsToJson(Items instance) {
  final val = <String, dynamic>{
    'items': instance.items,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('tags', instance.tags);
  return val;
}

Catalogue _$CatalogueFromJson(Map<String, dynamic> json) => Catalogue(
      items: (json['items'] as List<dynamic>)
          .map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList(),
      vendors: (json['vendors'] as List<dynamic>)
          .map((e) => Vendor.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CatalogueToJson(Catalogue instance) => <String, dynamic>{
      'items': instance.items,
      'vendors': instance.vendors,
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
      id: json['id'] as int?,
    );

Map<String, dynamic> _$VendorToJson(Vendor instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['name'] = instance.name;
  return val;
}

Tag _$TagFromJson(Map<String, dynamic> json) => Tag(
      name: json['name'] as String,
      id: json['id'] as int?,
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => SubLabel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TagToJson(Tag instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['name'] = instance.name;
  writeNotNull('children', instance.children);
  return val;
}

Tags _$TagsFromJson(Map<String, dynamic> json) => Tags(
      tags: (json['tags'] as List<dynamic>)
          .map((e) => Tag.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TagsToJson(Tags instance) => <String, dynamic>{
      'tags': instance.tags,
    };

SubLabel _$SubLabelFromJson(Map<String, dynamic> json) => SubLabel(
      name: json['name'] as String,
      id: json['id'] as int?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SubLabelToJson(SubLabel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['name'] = instance.name;
  writeNotNull('items', instance.items);
  return val;
}
