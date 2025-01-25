

import '../../../../boxes.dart';
import '../models/location_model.dart';

abstract class LocationLocalDataSource {
  Future<void> saveLocation(List<LocationModel> location);
  Future<void> deleteAllData();
  Future<void> deleteData(LocationModel loc);
  Future<List<LocationModel?>> getLastSavedLocation();
}

class LocationLocalDataSourceImpl implements LocationLocalDataSource {
  LocationLocalDataSourceImpl();

  @override
  Future<void> saveLocation(List<LocationModel> location) async {
    location.forEach((e) async {
      await locationBox.add(e);
      print('save data : ${e.name}');
    });
  }

  @override
  Future<List<LocationModel?>> getLastSavedLocation() async {
    print("cek isi location box: ${locationBox.length}");
    return List.generate(
        locationBox.length, (index) => locationBox.getAt(index));
  }

  @override
  Future<void> deleteAllData() async {
    await locationBox.clear();
    print("delete all data");
  }

  @override
  Future<void> deleteData(LocationModel loc) async {
    await locationBox.delete(loc);
    print("delete data : ${loc.name}");
  }
}
