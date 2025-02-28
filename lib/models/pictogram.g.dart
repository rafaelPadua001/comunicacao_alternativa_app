// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pictogram.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PictogramAdapter extends TypeAdapter<Pictogram> {
  @override
  final int typeId = 0;

  @override
  Pictogram read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Pictogram(
      imagePath: fields[0] as String,
      label: fields[2] as String,
      category: fields[1] as String,
      isLocal: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Pictogram obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.imagePath)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.label)
      ..writeByte(3)
      ..write(obj.isLocal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PictogramAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
