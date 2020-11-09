// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GoalAdapter extends TypeAdapter<Goal> {
  @override
  final int typeId = 6;

  @override
  Goal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Goal(
      content: fields[0] as String,
      deadlineDate: fields[1] as String,
      setOnDate: fields[2] as String,
      id: fields[4] as String,
      goalType: fields[3] as String,
      achieved: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Goal obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.content)
      ..writeByte(1)
      ..write(obj.deadlineDate)
      ..writeByte(2)
      ..write(obj.setOnDate)
      ..writeByte(3)
      ..write(obj.goalType)
      ..writeByte(4)
      ..write(obj.id)
      ..writeByte(5)
      ..write(obj.achieved);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ObjectiveAdapter extends TypeAdapter<Objective> {
  @override
  final int typeId = 7;

  @override
  Objective read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Objective(
      startDate: fields[0] as DateTime,
      endDate: fields[1] as DateTime,
      isFinished: fields[2] as String,
      objectiveType: fields[3] as String,
      hoursOfWork: fields[5] as int,
      average: fields[4] as int,
    )..id = fields[6] as String;
  }

  @override
  void write(BinaryWriter writer, Objective obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.startDate)
      ..writeByte(1)
      ..write(obj.endDate)
      ..writeByte(2)
      ..write(obj.isFinished)
      ..writeByte(3)
      ..write(obj.objectiveType)
      ..writeByte(4)
      ..write(obj.average)
      ..writeByte(5)
      ..write(obj.hoursOfWork)
      ..writeByte(6)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ObjectiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
