// lib/domain/repositories/location_repository.dart
import '../../data/models/location_model.dart';
import '../entities/location.dart';

abstract class LocationRepository {
  Future<void> saveMarkLocation(List<LocationModel?> location);
  Future<List<LocationModel?>> getSavedLocations();
  Future<LocationModel> getCurrentLocation();
  Future<void> deleteLocation(LocationModel loc);
}
