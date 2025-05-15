// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cached_move.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CachedMoveAdapter extends TypeAdapter<CachedMove> {
  @override
  final int typeId = 1;

  @override
  CachedMove read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CachedMove(
      name: fields[0] as String,
      type: fields[1] as String,
      category: fields[2] as String,
      power: fields[3] as int?,
      accuracy: fields[4] as int?,
      levelLearnedAt: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CachedMove obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.power)
      ..writeByte(4)
      ..write(obj.accuracy)
      ..writeByte(5)
      ..write(obj.levelLearnedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CachedMoveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
