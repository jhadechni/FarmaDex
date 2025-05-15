// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registered_pokemon.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RegisteredPokemonAdapter extends TypeAdapter<RegisteredPokemon> {
  @override
  final int typeId = 3;

  @override
  RegisteredPokemon read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RegisteredPokemon(
      name: fields[0] as String,
      species: fields[1] as String,
      height: fields[2] as String,
      weight: fields[3] as String,
      gender: fields[4] as String,
      imagePath: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RegisteredPokemon obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.species)
      ..writeByte(2)
      ..write(obj.height)
      ..writeByte(3)
      ..write(obj.weight)
      ..writeByte(4)
      ..write(obj.gender)
      ..writeByte(5)
      ..write(obj.imagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegisteredPokemonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
