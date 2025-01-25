import '../entities/circleArea.dart';

import '../repositories/circle_area_repo.dart';

class ManageCircleAreasUseCase {
  final CircleAreaRepository repository;

  ManageCircleAreasUseCase(this.repository);

  Future<void> addCircleArea(List<CircleArea> area) async {
    await repository.addCircleArea(area);
  }

  Future<List<CircleArea>> getCircleAreas() async {
    return await repository.getCircleAreas();
  }

  Future<void> deleteCircleArea(CircleArea name) async {
    await repository.deleteCircleArea(name);
  }
}