

import 'package:alrm_gps/features/location/data/models/circle_area_model.dart';

import '../entities/circleArea.dart';

abstract class CircleAreaRepository {
  /// Adds a new geofence [CircleArea].
  Future<void> addCircleArea(List<CircleAreaModel?> area);

  /// Retrieves all saved geofencing areas.
  Future<List<CircleAreaModel?>> getCircleAreas();

  /// Deletes a specific geofencing area.
  Future<void> deleteCircleArea(CircleAreaModel name);
}