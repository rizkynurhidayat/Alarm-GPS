import 'package:alrm_gps/features/location/data/models/location_model.dart';
import 'package:alrm_gps/features/location/domain/repositories/location_repo.dart';

import '../entities/location.dart';

class ManageLocationUseCase {
  final LocationRepository repository;
  ManageLocationUseCase(this.repository);

  Future<LocationModel> getCurrentLocation() async {
    return await repository.getCurrentLocation();
  }

  Future<void> saveLocation(List<LocationModel?> location) async {
    await repository.saveMarkLocation(location);
  }

  Future<List<LocationModel?>> getSavedLocation() async {
    final res = await repository.getSavedLocations();
    return res;
  }

Future<void> deleteLocationAt(LocationModel loc)async{
  await repository.deleteLocation(loc);
}

}
