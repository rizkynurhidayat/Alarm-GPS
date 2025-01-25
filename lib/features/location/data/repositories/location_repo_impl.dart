// lib/data/repositories/location_repository_impl.dart
import 'package:alrm_gps/features/location/data/datasources/location_datasource.dart';
import 'package:geolocator/geolocator.dart';

import '../../domain/entities/location.dart';

import '../../domain/repositories/location_repo.dart';

import '../models/location_model.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationLocalDataSource datasource;

  LocationRepositoryImpl(this.datasource);
  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );
  @override
  Future<Location> getCurrentLocation() async {
    try {
      print("start get possition");

      Position position = await Geolocator.getCurrentPosition(
          locationSettings: locationSettings,
          desiredAccuracy: LocationAccuracy.high,
          forceAndroidLocationManager: true);

      print("get possition");
      return Location(
          latitude: position.latitude,
          longitude: position.longitude,
          timestamp: position.timestamp,
          name: 'me');
    } catch (e) {
      print("Error get location: $e");
      rethrow;
    }
  }

  @override
  Future<void> saveLocation(List<Location> location) async {
    //clear all data
    await datasource.deleteAllData();

    //convert to model
    final locationModel =
        location.map((e) => LocationModel.fromEntity(e)).toList();
    print('saveLocation');
    //save all new data
    await datasource.saveLocation(locationModel);
  }

  @override
  Future<List<Location>> getSavedLocations() async {
    final locationModel = await datasource.getLastSavedLocation();
    final loc = locationModel.map((e) => e!.toEntity()).toList();
    print('get saved location');
    return loc;
  }

  @override
  Future<void> deleteLocation(Location loc) async {
    final model = LocationModel.fromEntity(loc);
    await datasource.deleteData(model);
  }
}
