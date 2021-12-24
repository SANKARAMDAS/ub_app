// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BusinessModelAdapter extends TypeAdapter<BusinessModel> {
  @override
  final int typeId = 1;

  @override
  BusinessModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BusinessModel(
      businessId: fields[0] as String,
      businessName: fields[1] as String,
      isChanged: fields[3] as bool,
      isDeleted: fields[4] as bool,
      deleteAction: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, BusinessModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.businessId)
      ..writeByte(1)
      ..write(obj.businessName)
      ..writeByte(2)
      ..write(obj.deleteAction)
      ..writeByte(3)
      ..write(obj.isChanged)
      ..writeByte(4)
      ..write(obj.isDeleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
