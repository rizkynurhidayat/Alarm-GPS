// lib/domain/repositories/location_repository.dart
import '../entities/location.dart';

abstract class LocationRepository {
  Future<void> saveLocation(List<Location> location);
  Future<List<Location>> getSavedLocations();
  Future<Location> getCurrentLocation();
  Future<void> deleteLocation(Location loc);
}
