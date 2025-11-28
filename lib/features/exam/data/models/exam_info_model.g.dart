// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_info_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExamInfoAdapter extends TypeAdapter<ExamInfo> {
  @override
  final int typeId = 0;

  @override
  ExamInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExamInfo(
      title: fields[0] as String?,
      description: fields[1] as String?,
      totalMarks: fields[2] as int?,
      durationMinutes: fields[3] as int?,
      scheduledAt: fields[4] as DateTime?,
      classIds: (fields[5] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ExamInfo obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.totalMarks)
      ..writeByte(3)
      ..write(obj.durationMinutes)
      ..writeByte(4)
      ..write(obj.scheduledAt)
      ..writeByte(5)
      ..write(obj.classIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExamInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
