

import '../entities/circleArea.dart';

abstract class CircleAreaRepository {
  /// Adds a new geofence [CircleArea].
  Future<void> addCircleArea(List<CircleArea> area);

  /// Retrieves all saved geofencing areas.
  Future<List<CircleArea>> getCircleAreas();

  /// Deletes a specific geofencing area.
  Future<void> deleteCircleArea(CircleArea name);
}