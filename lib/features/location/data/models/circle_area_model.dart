import 'package:hive/hive.dart';

import '../../domain/entities/circleArea.dart';


part 'circle_area_model.g.dart';

@HiveType(typeId: 2)
class CircleAreaModel extends CircleArea {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final double latitude;

  @HiveField(2)
  final double longitude;

  @HiveField(3)
  final double radius;

  @HiveField(4)
  final String alarmFilePath;

  CircleAreaModel({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.alarmFilePath,
  }) : super(
          name: name,
          latitude: latitude,
          longitude: longitude,
          radius: radius,
          alarmFilePath: alarmFilePath,
        );

  /// Converts a [CircleAreaModel] to a [CircleArea].
  CircleArea toEntity() => CircleArea(
        name: name,
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        alarmFilePath: alarmFilePath,
      );

  /// Creates a [CircleAreaModel] from a [CircleArea].
  factory CircleAreaModel.fromEntity(CircleArea area) {
    return CircleAreaModel(
      name: area.name,
      latitude: area.latitude,
      longitude: area.longitude,
      radius: area.radius,
      alarmFilePath: area.alarmFilePath,
    );
  }
}
