// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final int typeId = 0;

  @override
  Note read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Note(
      fields[0] as String?,
      fields[1] as String?,
      fields[2] as bool?,
      fields[3] as int?,
      (fields[4] as List?)?.cast<Image>(),
      (fields[5] as List?)?.cast<Voice>(),
      (fields[6] as List?)?.cast<Task>(),
      fields[7] as bool?,
      fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.isChecked)
      ..writeByte(3)
      ..write(obj.color)
      ..writeByte(4)
      ..write(obj.imageList)
      ..writeByte(5)
      ..write(obj.voiceList)
      ..writeByte(6)
      ..write(obj.taskList)
      ..writeByte(7)
      ..write(obj.resetCheckBoxs)
      ..writeByte(8)
      ..write(obj.password);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
