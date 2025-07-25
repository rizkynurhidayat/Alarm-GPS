// lib/presentation/controllers/map_controller.dart

import 'dart:math';

import 'package:alrm_gps/features/location/data/datasources/circleArea_datasource.dart';
import 'package:alrm_gps/features/location/data/datasources/location_datasource.dart';
import 'package:alrm_gps/features/location/data/models/circle_area_model.dart';
import 'package:alrm_gps/features/location/data/models/location_model.dart';
import 'package:alrm_gps/features/location/data/models/rute_model.dart';
import 'package:alrm_gps/features/location/domain/usecases/searchLocation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../../foregroundTask.dart';
import '../../domain/entities/circleArea.dart';
import '../../domain/entities/location.dart';
import '../../domain/entities/searchLocation.dart';
import '../../domain/usecases/manageLoaction.dart';
import '../../domain/usecases/manageCircleArea.dart';

class MyMapController extends GetxController with WidgetsBindingObserver {
  final ManageLocationUseCase manageLocationUseCase;
  final ManageCircleAreasUseCase manageCircleAreasUseCase;
  final SearchLocationUseCase searchLocationUseCase;

  MyMapController({
    required this.manageLocationUseCase,
    required this.manageCircleAreasUseCase,
    required this.searchLocationUseCase,
  });

  // var locationFromDb = Rxn<LocationModel>();
  var userLocation = Rxn<LatLng>();
  var circleAreas = <CircleAreaModel?>[].obs;
  var locationMark = <LocationModel?>[].obs;
  var isInside = false.obs;
  var isLoading = false.obs;
  var isInit = true.obs;
  var geofanText = 'ketuk dan tahan untuk menambahkan area'.obs;

  MapController map = MapController();
  final LayerHitNotifier hitNotifier = ValueNotifier(null);

  final searchController = TextEditingController();
  RxList<SearchLocation> searchResults = <SearchLocation>[].obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    // init();
    fetchUserLocation();
    // loadLocalData();
    getAllRute();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  RxBool isInBackground = false.obs;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // App masuk background
      isInBackground.value = true;
      print('Sayang, app-nya lagi ngilang ke background 💔');
    } else if (state == AppLifecycleState.resumed) {
      // App kembali ke foreground
      isInBackground.value = false;
      final service = FlutterBackgroundService();
      service.invoke("stopService");
      print('Yay! App-nya balik lagi ke depan mata 💘');
    }
  }

  void init() async {
    if (serviceEnabled.isTrue) {
      //  await initializeService();
    } else {
      reqPermission();
      if (serviceEnabled.isTrue) {
        // await initializeService();
      }
    }
  }

  var serviceEnabled = false.obs;
  void reqPermission() async {
    LocationPermission permission;
    serviceEnabled.value = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled.isTrue) {
      Get.snackbar('Permission Denied', 'Tolong nyalain lokasinya dong!');
      await Future.delayed(Duration(seconds: 3));
      await Geolocator.openLocationSettings();
      // update();
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar(
            'izin ditolak', 'yaah sayang banget kamu blm aktifin lokasi');
      }
    }
    if (permission == LocationPermission.whileInUse) {
      final LocationPermission backgroundPermission =
          await Geolocator.requestPermission();
      if (backgroundPermission != LocationPermission.always) {
        //
        Get.snackbar('Aktifin izin lokasinya dong !!',
            'aplikasi ini butuh izin lokasi untuk melanjutkan');
      }
    }
  }

  final datasource = LocationLocalDataSourceImpl();

  void tambahRute(
    String nama,
    String deksripsi,
  ) async {
    // getAllRute();
    final rute = RuteModel(
        deskripsi: deksripsi,
        name: nama,
        id: (rutes.isNotEmpty) ? rutes.length + 1 : 1,
        isActive: false,
        timestamp: DateTime.now().toString());

    rutes.add(rute);
    final json = <Map<String, dynamic>>[];
    // List<RuteModel> data = await datasource.getAllRuteKA();

    rutes.forEach((e) {
      json.add(e.toJson());
    });
    print("data new: $json");
    datasource.saveRuteKA(json);
    print('save data rute $json');
    // final index = rutes.where((a) => a.id == rute.id);
    // if (index == -1) {
    // } else {
    //   // await datasource.editRuteKA(rute);
    // }
  }

  void editDute(RuteModel rute) async {
    await datasource.editRuteKA(rute);
  }

  void deleteRute(int id) async {
    await datasource.deleteRuteKA(id);
  }

  var rutes = <RuteModel>[].obs;

  getAllRute() async {
    // await initializeService();
    rutes.value = await datasource.getAllRuteKA();
  }

  final locationDatasource = LocationLocalDataSourceImpl();
  final circleAreaDatasource = CircleAreaLocalDataSourceImpl();

  Future<void> fetchUserLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar('Permission Denied', 'Tolong nyalain lokasinya dong!');
        await Future.delayed(Duration(seconds: 3));
        final a = await Geolocator.openLocationSettings();
        // update();
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar('Permission Denied',
              'Location permission is required to continue.');
        }
      }
      while (serviceEnabled) {
        isLoading.value = true;
        if (circleAreas.length != 0 && locationMark.length != 0) {}
        final location = await manageLocationUseCase.getCurrentLocation();
        locationDatasource.saveMyLocation(location);
        // userLocation.value = LatLng(location.lat!, location.lon!);
        // if (locationMark.isNotEmpty) {
        //   final homeMark = locationMark.indexWhere((e) => e!.name! == 'me');
        //   if (homeMark == -1) {
        //     locationMark.add(location);
        //   } else {
        //     locationMark[homeMark] = location;
        //     if (isInit.isTrue) {
        //       goToUserLocation();
        //     }
        //   }
        // } else {
        //   locationMark.add(location);
        //   if (isInit.isTrue) {
        //     goToUserLocation();
        //   }
        // }
        // // await manageLocationUseCase.saveLocation(locationMark);
        // geofacing();
        // isLoading.toggle();
        // isInit.value = false;

        // saveData();
        await Future.delayed(Duration(minutes: 1));
      }
    } catch (e) {
      debugPrint('Error fetching user location: $e');
    }
  }

  // LocationModel? myLocation;
  RxBool isLocationupdate = false.obs;
  void updateMap(String id) async {

    isLocationupdate.value = true;
    while (isLocationupdate.value) {
      final markLocation = await locationDatasource.getSavedLocation(id);
      final circleAreaData = await circleAreaDatasource.getCircleAreas(id);
      locationMark.value = markLocation;
      circleAreas.value = circleAreaData;
      final myLocation = await locationDatasource.getMyLocation();
      userLocation.value = LatLng(myLocation.lat!, myLocation.lon!);
      // locationMark.add(myLocation);
      final homeMark = locationMark.indexWhere((e) => e!.name! == 'me');
      if (homeMark == -1) {
        locationMark.add(myLocation);
        goToUserLocation();
      } else {
        locationMark[homeMark] = myLocation;
        if (isInit.isTrue) {
          // goToUserLocation();
          // map.move(userLocation.value!, 15);
        }
      }

      print('add all mark count: ${markLocation.length}');
      await Future.delayed(Duration(seconds: 30));
    }
  }

  // void loadLocalData() async {
    // try {
    //   final areas = await manageCircleAreasUseCase.getCircleAreas();
    //   circleAreas.value = areas;

    //   final locations = await manageLocationUseCase.getSavedLocation();
    //   locationMark.value = locations;
    //   print('load data');
    // } catch (e) {
    //   debugPrint('Error loading local data areas: $e');
    // }
  // }

  Future<void> addCircleArea(
    String name,
    double latitude,
    double longitude,
    double radius,
    String id,
  ) async {
    try {
      final newArea = CircleAreaModel(
        name: name,
        lat: latitude,
        lon: longitude,
        rad: radius,
        alrmPath: (alarmPath.isNotEmpty) ? alarmPath.value : "default",
      );
      final locationArea = LocationModel(
          lat: latitude,
          lon: longitude,
          timestamp: DateTime.now().toIso8601String(),
          name: name);
      final hasCircle = circleAreas.indexWhere((e) => e!.name! == newArea.name);
      if (hasCircle == -1) {
        circleAreas.add(newArea);
      } else {
        circleAreas[hasCircle] = newArea;
      }
      final hasLoc =
          locationMark.indexWhere((e) => e!.name == locationArea.name);
      if (hasLoc == -1) {
        locationMark.add(locationArea);
      } else {
        locationMark[hasLoc] = locationArea;
      }
      circleAreaDatasource.addCircleArea(circleAreas, id);
      locationDatasource.saveMarkLocation(locationMark, id);
      searchLoc = null;
      isSearchLoc.value = false;
      alarmPath.value = '';
      alarmPathName.value = '';
    } catch (e) {
      debugPrint('Error adding circle area: $e');
    }
  }

  bool isUserInCircle(LocationModel userLocation, CircleAreaModel circleArea) {
    final distance = calculateDistance(
      userLocation.lat!,
      userLocation.lon!,
      circleArea.lat!,
      circleArea.lon!,
    );
    return distance <= circleArea.rad!;
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 6371000; // meters
    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a = (sin(dLat / 2) * sin(dLat / 2)) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            (sin(dLon / 2) * sin(dLon / 2));

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (3.14159265359 / 180);
  }

  void saveData(String id) async {
    print('loc length : ${locationMark.length}');
    print('circle length : ${circleAreas.length}');
    // await manageLocationUseCase.saveLocation(locationMark);
    // await manageCircleAreasUseCase.addCircleArea(circleAreas);
    locationDatasource.saveMarkLocation(locationMark, id);
  }

  Future<void> searchLocation(String query) async {
    try {
      final results = await searchLocationUseCase(query);
      searchResults.assignAll(results);
    } catch (e) {
      Get.snackbar('Error', 'Failed to search location $e');
    }
  }

  RxDouble radius = 4000.0.obs;
  RxBool isSearchLoc = false.obs;
  LocationModel? searchLoc;
  RxString alarmPath = ''.obs;
  RxString alarmPathName = ''.obs;
  void goToSearchLocation(SearchLocation loc) {
    map.move(LatLng(loc.latitude, loc.longitude), 15);
    isSearchLoc.value = true;
    searchLoc = LocationModel(
        name: loc.name,
        lat: loc.latitude,
        lon: loc.longitude,
        timestamp: DateTime.now().toString());

    final hasLoc = locationMark.indexWhere((e) => e!.name == searchLoc!.name);
    if (hasLoc == -1) {
      locationMark.add(searchLoc);
    } else {
      locationMark[hasLoc] = searchLoc;
    }

    searchResults.clear();
    searchController.clear();
  }

  void cancelSearchLocation() {
    final hasLoc = locationMark.indexWhere((e) => e!.name == searchLoc!.name);
    if (hasLoc == -1) {
      // locationMark.add(searchLoc);
      print('serachloc no data');
    } else {
      locationMark.removeAt(hasLoc);
      isSearchLoc.value = false;
      radius.value = 4000.0;
      alarmPathName.value = '';
    }
  }

  void addAlarmAudio() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null && result.files.isNotEmpty) {
      alarmPath.value = result.files.single.path!;
      alarmPathName.value = result.files.single.name;
    }
  }

  void goToUserLocation() {
    map.move(userLocation.value!, 15);
  }

  void geofacing() async {
    if (userLocation.value == null) return;

    CircleAreaModel? closestArea;
    double? closestDistance;

    for (final area in circleAreas) {
      double distance = Geolocator.distanceBetween(
        area!.lat!,
        area.lon!,
        userLocation.value!.latitude,
        userLocation.value!.longitude,
      );

      if (closestDistance == null || distance < closestDistance) {
        closestDistance = distance;
        closestArea = area;
      }
    }

    if (closestArea == null) {
      geofanText.value = "ketuk dan tahan untuk menambahkan area";
      isInside.value = false;
    }
    if (closestArea != null && closestDistance != null) {
      bool wasInside = isInside.value;
      isInside.value = closestDistance <= closestArea.rad!;

      if (!wasInside && isInside.value) {
        Get.snackbar("Geofence", "Kamu memasuki area ${closestArea.name}");
        playAudio(closestArea.alrmPath!);
        print(closestArea.alrmPath);
        geofanText.value = "Kamu memasuki area ${closestArea.name}";
      } else if (wasInside && !isInside.value) {
        Get.snackbar("Geofence", "Kamu keluar dari area ${closestArea.name}");
        geofanText.value = "Kamu keluar dari area ${closestArea.name}";
      }
    }
  }

  void deleteCircleArea(CircleAreaModel name) async {
    try {
      await manageCircleAreasUseCase.deleteCircleArea(name);
      circleAreas.removeWhere((area) => area!.name == name.name);
      locationMark.removeWhere((area) => area!.name == name.name);
    } catch (e) {
      debugPrint('Error deleting circle area: $e');
    }
  }

  void deleteMarkOverlay(String id) {
    final LayerHitResult? hitResult = hitNotifier.value;
    if (hitResult == null) return;
    final area = hitResult.hitValues.first as CircleAreaModel;

    Get.dialog(
      AlertDialog(
        title: Text('Konfirmasi'),
        content: Text('Apakah kamu yakin mau hapus lokasi ini?'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Tutup dialog tanpa aksi
            },
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              // Aksi delete di sini
              // deleteCircleArea(area);
              circleAreas.removeWhere(
                  (e) => e!.lat! == area.lat && e.lon! == area.lon);
              locationMark.removeWhere(
                  (e) => e!.lat! == area.lat && e.lon! == area.lon);
              print('remove circle area');
              await circleAreaDatasource.addCircleArea(circleAreas, id);
              await locationDatasource.saveMarkLocation(locationMark, id);
              Get.back(); // Tutup dialog setelah aksi
              Get.snackbar('Hapus', 'Item berhasil dihapus!',
                  snackPosition: SnackPosition.BOTTOM);
            },
            child: Text('Hapus'),
          ),
        ],
      ),
      barrierDismissible:
          false, // Supaya user nggak bisa tutup dialog dengan klik di luar
    );
  }

  final AudioPlayer _audioPlayer = AudioPlayer();
  var isPlaying = false.obs;

  void playAudio(String path) async {
    try {
      if (path == 'default') {
        // Play audio from assets
        await _audioPlayer.play(AssetSource('alarm.wav'));
      } else {
        // Play audio from the given path

        await _audioPlayer.play(DeviceFileSource(path));
      }
      isPlaying.value = true;
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  void stopAudio() async {
    await _audioPlayer.stop();
    isPlaying.value = false;
  }

  void pauseAudio() async {
    await _audioPlayer.pause();
  }

  void resumeAudio() async {
    await _audioPlayer.resume();
    isPlaying.value = true;
  }
}
