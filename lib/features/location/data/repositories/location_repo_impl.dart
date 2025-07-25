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
  Future<LocationModel> getCurrentLocation() async {
    try {
      print("start get possition");

      Position position = await Geolocator.getCurrentPosition(
          locationSettings: locationSettings,
          desiredAccuracy: LocationAccuracy.high,
          forceAndroidLocationManager: true);

      print("get possition");
      return LocationModel(
          lat: position.latitude,
          lon: position.longitude,
          timestamp: position.timestamp.toString(),
          name: 'me');
    } catch (e) {
      print("Error get location: $e");
      rethrow;
    }
  }

  @override
  Future<void> saveMarkLocation(List<LocationModel?> location) async {
    // //clear all data
    // await datasource.deleteAllData();

    // //convert to model
    // datasource.saveLocation
    // print('saveLocation');

    //save all new data
    // await datasource.saveMarkLocation(location);
  }

  @override
  Future<List<LocationModel?>> getSavedLocations() async {
    // final locationModel = await datasource.getSavedLocation();

    print('get saved location');
    // return locationModel;
    return [];
  }

  @override
  Future<void> deleteLocation(LocationModel loc) async {
    await datasource.deleteData(loc);
  }
}
