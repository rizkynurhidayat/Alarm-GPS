
import 'package:alrm_gps/features/location/data/repositories/searchLocation_repo_impl.dart';
import 'package:get/get.dart';


import '../../data/datasources/circleArea_datasource.dart';
import '../../data/datasources/location_datasource.dart';

import '../../data/repositories/circleArea_repo_impl.dart';
import '../../data/repositories/location_repo_impl.dart';
import '../../domain/usecases/manageLoaction.dart';
import '../../domain/usecases/manageCircleArea.dart';
import '../../domain/usecases/searchLocation.dart';
import 'mapController.dart';

class MapBinding extends Bindings {
  @override
  void dependencies() async {
    // Initialize Hive Boxes
    // final locationBox = Hive.box<LocationModel>('locationBox');
    // final circleAreaBox = Hive.box<CircleAreaModel>('circleAreaBox');

    // Data Sources
    final locationDataSource = LocationLocalDataSourceImpl();
    final circleAreaDataSource = CircleAreaLocalDataSourceImpl();

    // Repositories
    final locationRepository = LocationRepositoryImpl(locationDataSource);
    final circleAreaRepository = CircleAreaRepositoryImpl(circleAreaDataSource);
    final searchLocationRepository = SearchLocationRepositoryImpl();

    // Use Cases
    final getUserLocationUseCase = ManageLocationUseCase(locationRepository);
    final manageCircleAreasUseCase =
        ManageCircleAreasUseCase(circleAreaRepository);
    final searchLocationUseCase =
        SearchLocationUseCase(searchLocationRepository);

    // Controller
    Get.lazyPut(()=>MyMapController(
        manageLocationUseCase: getUserLocationUseCase,
        manageCircleAreasUseCase: manageCircleAreasUseCase,
        searchLocationUseCase: searchLocationUseCase));
  }
}
