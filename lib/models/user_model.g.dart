// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 1;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      firstName: fields[0] as String,
      lastName: fields[1] as String,
      dOB: fields[2] as String,
      profilePhoto: fields[3] as String,
      sex: fields[4] as String,
      height: fields[5] as int,
      weight: fields[6] as int,
      sport: fields[10] as String,
      shortTermGoal: fields[11] as String,
      mediumTermGoal: fields[12] as String,
      longTermGoal: fields[13] as String,
    )
      ..profilePhotoToSend = fields[7] as String
      ..newPhoto = fields[8] as File
      ..tempImage = fields[9] as ImageProvider<dynamic>
      ..lastLogin = fields[14] as String
      ..dateJoined = fields[15] as String
      ..jwt = fields[16] as String;
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.firstName)
      ..writeByte(1)
      ..write(obj.lastName)
      ..writeByte(2)
      ..write(obj.dOB)
      ..writeByte(3)
      ..write(obj.profilePhoto)
      ..writeByte(4)
      ..write(obj.sex)
      ..writeByte(5)
      ..write(obj.height)
      ..writeByte(6)
      ..write(obj.weight)
      ..writeByte(7)
      ..write(obj.profilePhotoToSend)
      ..writeByte(8)
      ..write(obj.newPhoto)
      ..writeByte(9)
      ..write(obj.tempImage)
      ..writeByte(10)
      ..write(obj.sport)
      ..writeByte(11)
      ..write(obj.shortTermGoal)
      ..writeByte(12)
      ..write(obj.mediumTermGoal)
      ..writeByte(13)
      ..write(obj.longTermGoal)
      ..writeByte(14)
      ..write(obj.lastLogin)
      ..writeByte(15)
      ..write(obj.dateJoined)
      ..writeByte(16)
      ..write(obj.jwt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
