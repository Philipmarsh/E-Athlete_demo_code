// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SessionAdapter extends TypeAdapter<Session> {
  @override
  final int typeId = 2;

  @override
  Session read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Session(
      date: fields[0] as String,
      lengthOfSession: fields[1] as int,
      title: fields[2] as String,
      intensity: fields[3] as int,
      performance: fields[4] as int,
      feeling: fields[5] as String,
      target: fields[6] as String,
      reflections: fields[7] as String,
      id: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Session obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.lengthOfSession)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.intensity)
      ..writeByte(4)
      ..write(obj.performance)
      ..writeByte(5)
      ..write(obj.feeling)
      ..writeByte(6)
      ..write(obj.target)
      ..writeByte(7)
      ..write(obj.reflections)
      ..writeByte(8)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GeneralDayAdapter extends TypeAdapter<GeneralDay> {
  @override
  final int typeId = 3;

  @override
  GeneralDay read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GeneralDay(
      date: fields[0] as String,
      rested: fields[1] as int,
      nutrition: fields[2] as int,
      concentration: fields[3] as int,
      reflections: fields[4] as String,
      id: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GeneralDay obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.rested)
      ..writeByte(2)
      ..write(obj.nutrition)
      ..writeByte(3)
      ..write(obj.concentration)
      ..writeByte(4)
      ..write(obj.reflections)
      ..writeByte(5)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeneralDayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CompetitionAdapter extends TypeAdapter<Competition> {
  @override
  final int typeId = 4;

  @override
  Competition read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Competition(
      date: fields[0] as String,
      name: fields[1] as String,
      address: fields[2] as String,
      startTime: fields[3] as String,
      id: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Competition obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.startTime)
      ..writeByte(4)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompetitionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ResultAdapter extends TypeAdapter<Result> {
  @override
  final int typeId = 5;

  @override
  Result read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Result(
      id: fields[0] as String,
      date: fields[1] as String,
      name: fields[2] as String,
      position: fields[3] as int,
      reflections: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Result obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.position)
      ..writeByte(4)
      ..write(obj.reflections);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
