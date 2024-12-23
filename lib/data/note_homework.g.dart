// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_homework.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NoteHomeworkAdapter extends TypeAdapter<NoteHomework> {
  @override
  final int typeId = 4;

  @override
  NoteHomework read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NoteHomework(
      title: fields[0] as String,
      content: fields[1] as String,
      homeworkKey: fields[2] as int,
      date: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, NoteHomework obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.homeworkKey)
      ..writeByte(3)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteHomeworkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
