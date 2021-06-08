// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voice_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VoiceAdapter extends TypeAdapter<Voice> {
  @override
  final int typeId = 1;

  @override
  Voice read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Voice(
      fields[0] as String,
      fields[1] as Uint8List,
    );
  }

  @override
  void write(BinaryWriter writer, Voice obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.voice);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VoiceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
