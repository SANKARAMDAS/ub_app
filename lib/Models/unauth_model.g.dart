// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unauth_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UnAuthModelAdapter extends TypeAdapter<UnAuthModel> {
  @override
  final int typeId = 2;

  @override
  UnAuthModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UnAuthModel(
      loginTime: fields[0] as DateTime?,
      seen: fields[1] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, UnAuthModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.loginTime)
      ..writeByte(1)
      ..write(obj.seen);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnAuthModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
