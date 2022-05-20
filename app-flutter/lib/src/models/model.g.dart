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

PurchaseItemEdge _$PurchaseItemEdgeFromJson(Map<String, dynamic> json) =>
    PurchaseItemEdge(
      cursor: json['cursor'] as String?,
      node: json['node'] == null
          ? null
          : PurchaseItem.fromJson(json['node'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PurchaseItemEdgeToJson(PurchaseItemEdge instance) =>
    <String, dynamic>{
      'cursor': instance.cursor,
      'node': instance.node,
    };

PurchaseItemConnection _$PurchaseItemConnectionFromJson(
        Map<String, dynamic> json) =>
    PurchaseItemConnection(
      totalCount: json['totalCount'] as int?,
      pageInfo: json['pageInfo'] == null
          ? null
          : PageInfo.fromJson(json['pageInfo'] as Map<String, dynamic>),
      edges: (json['edges'] as List<dynamic>?)
          ?.map((e) => PurchaseItemEdge.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PurchaseItemConnectionToJson(
        PurchaseItemConnection instance) =>
    <String, dynamic>{
      'totalCount': instance.totalCount,
      'pageInfo': instance.pageInfo,
      'edges': instance.edges,
    };

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      name: json['name'] as String,
      id: json['id'] as int?,
      tags: (json['tags'] as List<dynamic>?)
          ?.map((e) => Tag.fromJson(e as Map<String, dynamic>))
          .toList(),
      purchases: json['purchases'] == null
          ? null
          : PurchaseItemConnection.fromJson(
              json['purchases'] as Map<String, dynamic>),
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
  writeNotNull('purchases', instance.purchases);
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
      vendor: json['vendor'] == null
          ? null
          : Vendor.fromJson(json['vendor'] as Map<String, dynamic>),
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

Vendors _$VendorsFromJson(Map<String, dynamic> json) => Vendors(
      vendors: (json['vendors'] as List<dynamic>)
          .map((e) => Vendor.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VendorsToJson(Vendors instance) => <String, dynamic>{
      'vendors': instance.vendors,
    };

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

PageInfo _$PageInfoFromJson(Map<String, dynamic> json) => PageInfo(
      hasNextPage: json['hasNextPage'] as bool?,
      hasPreviousPage: json['hasPreviousPage'] as bool?,
      startCursor: json['startCursor'] as String?,
      endCursor: json['endCursor'] as String?,
    );

Map<String, dynamic> _$PageInfoToJson(PageInfo instance) => <String, dynamic>{
      'hasNextPage': instance.hasNextPage,
      'hasPreviousPage': instance.hasPreviousPage,
      'startCursor': instance.startCursor,
      'endCursor': instance.endCursor,
    };

ShoppingListItem _$ShoppingListItemFromJson(Map<String, dynamic> json) =>
    ShoppingListItem(
      id: json['id'] as int,
      item: Item.fromJson(json['item'] as Map<String, dynamic>),
      purchase: json['purchase'] == null
          ? null
          : PurchaseItem.fromJson(json['purchase'] as Map<String, dynamic>),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$ShoppingListItemToJson(ShoppingListItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'item': instance.item,
      'purchase': instance.purchase,
      'note': instance.note,
    };

ShoppingList _$ShoppingListFromJson(Map<String, dynamic> json) => ShoppingList(
      id: json['id'] as int,
      name: json['name'] as String,
      createTime: json['createTime'] == null
          ? null
          : DateTime.parse(json['createTime'] as String),
      updateTime: json['updateTime'] == null
          ? null
          : DateTime.parse(json['updateTime'] as String),
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => ShoppingListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ShoppingListToJson(ShoppingList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'createTime': instance.createTime?.toIso8601String(),
      'updateTime': instance.updateTime?.toIso8601String(),
      'items': instance.items,
    };

ShoppingListEdge _$ShoppingListEdgeFromJson(Map<String, dynamic> json) =>
    ShoppingListEdge(
      cursor: json['cursor'] as String?,
      node: ShoppingList.fromJson(json['node'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ShoppingListEdgeToJson(ShoppingListEdge instance) =>
    <String, dynamic>{
      'cursor': instance.cursor,
      'node': instance.node,
    };

ShoppingListConnection _$ShoppingListConnectionFromJson(
        Map<String, dynamic> json) =>
    ShoppingListConnection(
      totalCount: json['totalCount'] as int?,
      pageInfo: json['pageInfo'] == null
          ? null
          : PageInfo.fromJson(json['pageInfo'] as Map<String, dynamic>),
      edges: (json['edges'] as List<dynamic>)
          .map((e) => ShoppingListEdge.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ShoppingListConnectionToJson(
        ShoppingListConnection instance) =>
    <String, dynamic>{
      'totalCount': instance.totalCount,
      'pageInfo': instance.pageInfo,
      'edges': instance.edges,
    };
