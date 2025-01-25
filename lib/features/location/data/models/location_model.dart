// lib/data/models/location_model.dart
import 'package:hive/hive.dart';
import '../../domain/entities/location.dart';

part 'location_model.g.dart';

@HiveType(typeId: 1)
class LocationModel extends Location {
  @HiveField(0)
  final double latitude;
  
  @HiveField(1)
  final double longitude;

  @HiveField(2)
  final DateTime timestamp;

  @HiveField(3)
   final String name;

  LocationModel({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.name
  }) : super(latitude: latitude, longitude: longitude,timestamp: timestamp, name: name);

  /// Converts a [LocationModel] to a [Location].
  Location toEntity() => Location(
        latitude: latitude,
        longitude: longitude,
        timestamp: timestamp,
        name: name

      );

  /// Creates a [LocationModel] from a [Location].
  factory LocationModel.fromEntity(Location location) {
    return LocationModel(
      latitude: location.latitude,
      longitude: location.longitude,
      timestamp: location.timestamp,
      name: location.name
    );
  }
}
