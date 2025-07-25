import 'package:alrm_gps/features/location/data/datasources/circleArea_datasource.dart';

import '../../domain/entities/circleArea.dart';

import '../../domain/repositories/circle_area_repo.dart';
import '../models/circle_area_model.dart';

class CircleAreaRepositoryImpl implements CircleAreaRepository {
  // final Box<CircleAreaModel> circleAreaBox;
  final CircleAreaLocalDataSource datasource;
  CircleAreaRepositoryImpl(this.datasource);

  @override
  Future<void> addCircleArea(List<CircleAreaModel?> area) async {
    //delete all data
    // datasource.deleteAllCircleArea();

    //convert to model
    // final areaModel = area.map((e) => CircleAreaModel.fromJson(e)).toList();

    //save data
    // await datasource.addCircleArea(area);
  }

  @override
  Future<List<CircleAreaModel?>> getCircleAreas() async {
    // final data = await datasource.getCircleAreas();
    // return data;
    return [];
  }

  @override
  Future<void> deleteCircleArea(CircleAreaModel name) async {
    // await datasource.deleteCircleArea(name);
  }
}
