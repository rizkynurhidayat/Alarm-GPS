
import '../../../../boxes.dart';
import '../models/circle_area_model.dart';

abstract class CircleAreaLocalDataSource {
  Future<void> addCircleArea(List<CircleAreaModel> areas);
  Future<List<CircleAreaModel?>> getCircleAreas();
  Future<void> deleteCircleArea(CircleAreaModel name);
  Future<void> deleteAllCircleArea();
}

class CircleAreaLocalDataSourceImpl implements CircleAreaLocalDataSource {
  CircleAreaLocalDataSourceImpl();

  @override
  Future<void> addCircleArea(List<CircleAreaModel> areas) async {
    areas.forEach((area) async {
      await circleAreaBox.add(area);
      print('save circle data : ${area.name}');
    });
  }

  @override
  Future<List<CircleAreaModel?>> getCircleAreas() async {
    print("cek isi circlearea box: ${circleAreaBox.length}");
    return List.generate(
        circleAreaBox.length, (index) => circleAreaBox.getAt(index));
  }

  @override
  Future<void> deleteCircleArea(CircleAreaModel name) async {
    await circleAreaBox.delete(name);
  }

  @override
  Future<void> deleteAllCircleArea() async {
    await circleAreaBox.clear();
    print('delete all data');
  }
}
