// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShoppingListAdapter extends TypeAdapter<ShoppingList> {
  @override
  final int typeId = 1;

  @override
  ShoppingList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShoppingList(
      id: fields[0] as int,
      items: (fields[1] as List).cast<ShoppingListItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, ShoppingList obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShoppingListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ShoppingListItemAdapter extends TypeAdapter<ShoppingListItem> {
  @override
  final int typeId = 2;

  @override
  ShoppingListItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShoppingListItem(
      id: fields[0] as int,
      pricePerUnit: fields[2] as int,
      units: fields[1] as int,
      quantity: fields[3] as int?,
      quantityType: fields[4] as String?,
      brand: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ShoppingListItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.units)
      ..writeByte(2)
      ..write(obj.pricePerUnit)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.quantityType)
      ..writeByte(5)
      ..write(obj.brand);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShoppingListItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShoppingListItem _$ShoppingListItemFromJson(Map<String, dynamic> json) =>
    ShoppingListItem(
      id: json['id'] as int,
      pricePerUnit: json['pricePerUnit'] as int,
      units: json['units'] as int? ?? 1,
      quantity: json['quantity'] as int?,
      quantityType: json['quantityType'] as String?,
      brand: json['brand'] as String?,
    );

Map<String, dynamic> _$ShoppingListItemToJson(ShoppingListItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'units': instance.units,
      'pricePerUnit': instance.pricePerUnit,
      'quantity': instance.quantity,
      'quantityType': instance.quantityType,
      'brand': instance.brand,
    };
