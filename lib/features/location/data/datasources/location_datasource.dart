// import '../../../../boxes.dart';
import 'package:get_storage/get_storage.dart';

import '../models/location_model.dart';
import '../models/rute_model.dart';

abstract class LocationLocalDataSource {
  Future<void> saveMyLocation(LocationModel location);
  Future<LocationModel> getMyLocation();
  Future<void> saveMarkLocation(List<LocationModel?> marks, String id);
  Future<void> saveRuteKA(List<Map<String, dynamic>> rute);
  Future<void> editRuteKA(RuteModel rute);
  Future<void> deleteRuteKA(int id);
  Future<List<RuteModel>> getAllRuteKA();
  Future<void> deleteAllRuteKA();
  Future<void> deleteAllData();
  Future<void> deleteData(LocationModel loc);
  Future<List<LocationModel?>> getSavedLocation(String id);
}

class LocationLocalDataSourceImpl implements LocationLocalDataSource {
  LocationLocalDataSourceImpl();
  final box = GetStorage();
  @override
  Future<void> saveMyLocation(LocationModel location) async {
    await box.write('my_location', location.toJson());
    print("save my Location");
    // await box.write('list_location', data);
  }

  @override
  Future<LocationModel> getMyLocation() async {
    // TODO: implement getMyLocation
    final Map<String, dynamic> res = box.read("my_location");

    return LocationModel.fromJson(res);
  }

  @override
  Future<void> saveMarkLocation(
      List<LocationModel?> location, String id) async {
    List<Map<String, dynamic>> json = [];
    // final data = await box.read('list_location/$id');
    // if (data.length == null) {}
    // json = data;
    location.forEach((e) {
      e != null ? json.add(e.toJson()) : {};
    });
    await box.write('list_location/$id', json);
    print("save list mark Location");
  }

  @override
  Future<List<LocationModel?>> getSavedLocation(String id) async {
    // listData = [];
    final data = await box.read('list_location/$id');
    if (data != null) {
      print("cek isi location box: ${data.length}");
      return List.generate(
          data.length, (index) => LocationModel.fromJson(data[index]));
    } else {
      return [];
    }
  }

  @override
  Future<void> deleteAllData() async {
    await box.remove('list_location');
    print("delete all data");
  }

  @override
  Future<void> deleteData(LocationModel loc) async {
    final List<Map<String, dynamic>> data = await box.read('list_location');
    data.removeWhere(
      (element) => LocationModel.fromJson(element) == loc,
    );
    await box.write('list_location', data);
  }

  @override
  Future<void> deleteAllRuteKA() async {
    // TODO: implement deleteAllRuteKA
    await box.remove('list_rute');
    print('remove "list_rute"');
  }

  @override
  Future<void> deleteRuteKA(int id) async {
    // TODO: implement deleteRuteKA
    final json = <Map<String, dynamic>>[];
    final data = await getAllRuteKA();

    data.removeWhere((a) => a.id == id);
    data.forEach((e) {
      json.add(e.toJson());
    });
    await saveRuteKA(json);
  }

  @override
  Future<void> saveRuteKA(List<Map<String, dynamic>> rute) async {
    // TODO: implement saveRuteKA.

    await box.write('list_rute', rute);
    print('save to local "list_rute"');
  }

  @override
  Future<List<RuteModel>> getAllRuteKA() async {
    // TODO: implement getAllRuteKA
    final models = <RuteModel>[];
    final List<dynamic>? res = await box.read('list_rute');
    print('get all data "list_rute $res"');
    if (res == null) {
      return [];
    }
    res.forEach((e) {
      models.add(RuteModel.fromJson(e));
    });
    return models;
  }

  @override
  Future<void> editRuteKA(RuteModel rute) async {
    // TODO: implement editRuteKA
    final json = <Map<String, dynamic>>[];
    final data = await getAllRuteKA();
    final index = data.indexWhere((a) => a.id == rute.id);
    if (index == -1) {
      await saveRuteKA([rute.toJson()]);
    }
    print("before update: ${data[index].toJson()}");
    data[index] = rute;
    print("after update: ${data[index].toJson()}");
    data.forEach((e) {
      json.add(e.toJson());
    });
    await saveRuteKA(json);
    print('update data rute: "$json"');
  }
}
