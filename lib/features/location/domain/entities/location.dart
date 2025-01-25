// lib/domain/entities/location.dart
class Location {
  final double latitude;
  final double longitude;
  final DateTime timestamp;
   final String name;

  Location({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.name,
  });
}
