// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NewPurchaseModelAdapter extends TypeAdapter<NewPurchaseModel> {
  @override
  final int typeId = 3;

  @override
  NewPurchaseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NewPurchaseModel()
      .._date = fields[0] as DateTime?
      .._items = (fields[1] as List).cast<ItemModel>()
      ..vendorId = fields[2] as int?;
  }

  @override
  void write(BinaryWriter writer, NewPurchaseModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj._date)
      ..writeByte(1)
      ..write(obj._items)
      ..writeByte(2)
      ..write(obj.vendorId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewPurchaseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ItemModelAdapter extends TypeAdapter<ItemModel> {
  @override
  final int typeId = 4;

  @override
  ItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItemModel(
      itemId: fields[1] as int,
      amount: fields[2] as double,
      units: fields[3] as int,
      uuid: fields[0] as String,
      isAmountPerItem: fields[7] as bool,
      quantity: fields[4] as double?,
      quantityType: fields[5] as String?,
      brand: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ItemModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.itemId)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.units)
      ..writeByte(4)
      ..write(obj.quantity)
      ..writeByte(5)
      ..write(obj.quantityType)
      ..writeByte(6)
      ..write(obj.brand)
      ..writeByte(7)
      ..write(obj.isAmountPerItem);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
