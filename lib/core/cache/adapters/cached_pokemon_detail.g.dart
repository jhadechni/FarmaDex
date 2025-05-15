// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cached_pokemon_detail.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CachedPokemonDetailAdapter extends TypeAdapter<CachedPokemonDetail> {
  @override
  final int typeId = 0;

  @override
  CachedPokemonDetail read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CachedPokemonDetail(
      name: fields[0] as String,
      number: fields[1] as String,
      types: (fields[2] as List).cast<String>(),
      color: fields[3] as String,
      specie: fields[4] as String,
      imageUrl: fields[5] as String,
      height: fields[6] as String,
      weight: fields[7] as String,
      abilities: (fields[8] as List).cast<String>(),
      description: fields[9] as String,
      moves: (fields[10] as List).cast<CachedMove>(),
      encounterAreas: (fields[11] as List).cast<String>(),
      evolutions: (fields[12] as List).cast<CachedEvolution>(),
      stats: (fields[13] as Map).cast<String, int>(),
      maleRate: fields[14] as double,
      femaleRate: fields[15] as double,
    );
  }

  @override
  void write(BinaryWriter writer, CachedPokemonDetail obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.number)
      ..writeByte(2)
      ..write(obj.types)
      ..writeByte(3)
      ..write(obj.color)
      ..writeByte(4)
      ..write(obj.specie)
      ..writeByte(5)
      ..write(obj.imageUrl)
      ..writeByte(6)
      ..write(obj.height)
      ..writeByte(7)
      ..write(obj.weight)
      ..writeByte(8)
      ..write(obj.abilities)
      ..writeByte(9)
      ..write(obj.description)
      ..writeByte(10)
      ..write(obj.moves)
      ..writeByte(11)
      ..write(obj.encounterAreas)
      ..writeByte(12)
      ..write(obj.evolutions)
      ..writeByte(13)
      ..write(obj.stats)
      ..writeByte(14)
      ..write(obj.maleRate)
      ..writeByte(15)
      ..write(obj.femaleRate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CachedPokemonDetailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
