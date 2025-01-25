// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circle_area_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CircleAreaModelAdapter extends TypeAdapter<CircleAreaModel> {
  @override
  final int typeId = 2;

  @override
  CircleAreaModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CircleAreaModel(
      name: fields[0] as String,
      latitude: fields[1] as double,
      longitude: fields[2] as double,
      radius: fields[3] as double,
      alarmFilePath: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CircleAreaModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.latitude)
      ..writeByte(2)
      ..write(obj.longitude)
      ..writeByte(3)
      ..write(obj.radius)
      ..writeByte(4)
      ..write(obj.alarmFilePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CircleAreaModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
