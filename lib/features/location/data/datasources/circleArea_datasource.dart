// import '../../../../boxes.dart';
import 'package:get_storage/get_storage.dart';

import '../models/circle_area_model.dart';

abstract class CircleAreaLocalDataSource {
  Future<void> addCircleArea(List<CircleAreaModel?> areas, String id);
  Future<List<CircleAreaModel?>> getCircleAreas(String id);
  Future<void> deleteCircleArea(CircleAreaModel name, String id);
  Future<void> deleteAllCircleArea();
}

class CircleAreaLocalDataSourceImpl implements CircleAreaLocalDataSource {
  CircleAreaLocalDataSourceImpl();

  final box = GetStorage();

  @override
  Future<void> addCircleArea(List<CircleAreaModel?> areas, String id) async {
    List<dynamic> listMap = [];
    // final data = await box.read('list_area/$id');
    // if (data != null) {
    //   listMap = data;
    // }

    areas.forEach((area) async {
      listMap.add(area!.toJson());
    });
    await box.write('list_area/$id', listMap);
  }

  @override
  Future<List<CircleAreaModel>> getCircleAreas(String id) async {
    final data = await box.read('list_area/$id');
    if (data != null) {
      print("cek isi circlearea box id: $id: ${data.length}");
      return List.generate(
          data.length, (index) => CircleAreaModel.fromJson(data[index]));
    } else {
      return [];
    }
  }

  @override
  Future<void> deleteCircleArea(CircleAreaModel name, String id) async {
    final List<Map<String, dynamic>> data = await box.read('list_area/$id');
    data.removeWhere(
      (element) => CircleAreaModel.fromJson(element).name == name,
    );
    await box.write('list_area', data);
  }

  @override
  Future<void> deleteAllCircleArea() async {
    await box.remove('list_area');
    print('delete all data');
  }
}
