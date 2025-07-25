import '../../data/models/circle_area_model.dart';
import '../entities/circleArea.dart';

import '../repositories/circle_area_repo.dart';

class ManageCircleAreasUseCase {
  final CircleAreaRepository repository;

  ManageCircleAreasUseCase(this.repository);

  Future<void> addCircleArea(List<CircleAreaModel?> area) async {
    await repository.addCircleArea(area);
  }

  Future<List<CircleAreaModel?>> getCircleAreas() async {
    return await repository.getCircleAreas();
  }

  Future<void> deleteCircleArea(CircleAreaModel name) async {
    await repository.deleteCircleArea(name);
  }
}