import 'package:alrm_gps/features/location/domain/repositories/location_repo.dart';

import '../entities/location.dart';

class ManageLocationUseCase {
  final LocationRepository repository;
  ManageLocationUseCase(this.repository);

  Future<Location> getCurrentLocation() async {
    return await repository.getCurrentLocation();
  }

  Future<void> saveLocation(List<Location> location) async {
    await repository.saveLocation(location);
  }

  Future<List<Location>> getSavedLocation() async {
    final res = await repository.getSavedLocations();
    return res;
  }

Future<void> deleteLocationAt(Location loc)async{
  await repository.deleteLocation(loc);
}

}
