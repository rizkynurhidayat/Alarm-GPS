import 'package:alrm_gps/features/location/data/datasources/circleArea_datasource.dart';

import '../../domain/entities/circleArea.dart';

import '../../domain/repositories/circle_area_repo.dart';
import '../models/circle_area_model.dart';

class CircleAreaRepositoryImpl implements CircleAreaRepository {
  // final Box<CircleAreaModel> circleAreaBox;
  final CircleAreaLocalDataSource datasource;
  CircleAreaRepositoryImpl(this.datasource);

  @override
  Future<void> addCircleArea(List<CircleArea> area) async {
    //delete all data
    datasource.deleteAllCircleArea();

    //convert to model
    final areaModel = area.map((e) => CircleAreaModel.fromEntity(e)).toList();

    //save data
    await datasource.addCircleArea(areaModel);
  }

  @override
  Future<List<CircleArea>> getCircleAreas() async {
    final data = await datasource.getCircleAreas();
    return data.map((e) => e!.toEntity()).toList();
  }

  @override
  Future<void> deleteCircleArea(CircleArea name) async {
    final model = CircleAreaModel.fromEntity(name);
    await datasource.deleteCircleArea(model);
  }
}
