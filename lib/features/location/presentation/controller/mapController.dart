// lib/presentation/controllers/map_controller.dart

import 'dart:math';

import 'package:alrm_gps/features/location/domain/usecases/searchLocation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../domain/entities/circleArea.dart';
import '../../domain/entities/location.dart';
import '../../domain/entities/searchLocation.dart';
import '../../domain/usecases/manageLoaction.dart';
import '../../domain/usecases/manageCircleArea.dart';

class MyMapController extends GetxController {
  final ManageLocationUseCase manageLocationUseCase;
  final ManageCircleAreasUseCase manageCircleAreasUseCase;
  final SearchLocationUseCase searchLocationUseCase;

  MyMapController({
    required this.manageLocationUseCase,
    required this.manageCircleAreasUseCase,
    required this.searchLocationUseCase,
  });

  var locationFromDb = Rxn<Location>();
  var userLocation = Rxn<LatLng>();
  var circleAreas = <CircleArea>[].obs;
  var locationMark = <Location>[].obs;
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

    loadLocalData();
    fetchUserLocation();
  }

  Future<void> fetchUserLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar('Permission Denied', 'Tolong nyalain lokasinya dong!');
        await Future.delayed(Duration(seconds: 3));
        final a = await Geolocator.openLocationSettings();
        update();
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
        final location = await manageLocationUseCase.getCurrentLocation();
        userLocation.value = LatLng(location.latitude, location.longitude);
        if (locationMark.length != 0) {
          final homeMark = locationMark.indexWhere((e) => e.name == 'me');
          if (homeMark == -1) {
            locationMark.add(location);
          } else {
            locationMark[homeMark] = location;
            if (isInit.isTrue) {
              goToUserLocation();
            }
          }
        } else {
          locationMark.add(location);
          if (isInit.isTrue) {
            goToUserLocation();
          }
        }
        // await manageLocationUseCase.saveLocation(locationMark);
        geofacing();
        isLoading.toggle();
        isInit.value = false;

        saveData();
        await Future.delayed(Duration(minutes: 1));
      }
    } catch (e) {
      debugPrint('Error fetching user location: $e');
    }
  }

  void loadLocalData() async {
    try {
      final areas = await manageCircleAreasUseCase.getCircleAreas();
      circleAreas.value = areas;

      final locations = await manageLocationUseCase.getSavedLocation();
      locationMark.value = locations;
      print('load data');
    } catch (e) {
      debugPrint('Error loading local data areas: $e');
    }
  }

  Future<void> addCircleArea(String name, double latitude, double longitude,
      double radius, String alarmFilePath) async {
    try {
      final newArea = CircleArea(
        name: name,
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        alarmFilePath: alarmFilePath,
      );
      final locationArea = Location(
          latitude: latitude,
          longitude: longitude,
          timestamp: DateTime.now(),
          name: name);
      final hasCircle = circleAreas.indexWhere((e) => e.name == newArea.name);
      if (hasCircle == -1) {
        circleAreas.add(newArea);
      } else {
        circleAreas[hasCircle] = newArea;
      }
      final hasLoc =
          locationMark.indexWhere((e) => e.name == locationArea.name);
      if (hasLoc == -1) {
        locationMark.add(locationArea);
      } else {
        locationMark[hasLoc] = locationArea;
      }
    } catch (e) {
      debugPrint('Error adding circle area: $e');
    }
  }

  bool isUserInCircle(Location userLocation, CircleArea circleArea) {
    final distance = calculateDistance(
      userLocation.latitude,
      userLocation.longitude,
      circleArea.latitude,
      circleArea.longitude,
    );
    return distance <= circleArea.radius;
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

  void saveData() async {
    print('loc length : ${locationMark.length}');
    print('circle length : ${circleAreas.length}');
    await manageLocationUseCase.saveLocation(locationMark);
    await manageCircleAreasUseCase.addCircleArea(circleAreas);
  }

  Future<void> searchLocation(String query) async {
    try {
      final results = await searchLocationUseCase(query);
      searchResults.assignAll(results);
    } catch (e) {
      Get.snackbar('Error', 'Failed to search location');
    }
  }

  void goToSearchLocation(SearchLocation loc) {
    map.move(LatLng(loc.latitude, loc.longitude), 15);
    searchResults.clear();
    searchController.clear();
  }

  void goToUserLocation() {
    map.move(userLocation.value!, 15);
  }

  void geofacing() async {
    if (userLocation.value == null) return;

    CircleArea? closestArea;
    double? closestDistance;

    for (final area in circleAreas) {
      double distance = Geolocator.distanceBetween(
        area.latitude,
        area.longitude,
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
      isInside.value = closestDistance <= closestArea.radius;

      if (!wasInside && isInside.value) {
        Get.snackbar("Geofence", "Kamu memasuki area ${closestArea.name}");
        playAudio(closestArea.alarmFilePath);
        geofanText.value = "Kamu memasuki area ${closestArea.name}";
      } else if (wasInside && !isInside.value) {
        Get.snackbar("Geofence", "Kamu keluar dari area ${closestArea.name}");
        geofanText.value = "Kamu keluar dari area ${closestArea.name}";
      }
    }
  }

  void deleteCircleArea(CircleArea name) async {
    try {
      await manageCircleAreasUseCase.deleteCircleArea(name);
      circleAreas.removeWhere((area) => area.name == name.name);
      locationMark.removeWhere((area) => area.name == name.name);
    } catch (e) {
      debugPrint('Error deleting circle area: $e');
    }
  }

  void deleteMarkOverlay() {
    final LayerHitResult? hitResult = hitNotifier.value;
    if (hitResult == null) return;
    final area = hitResult.hitValues.first as CircleArea;

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
            onPressed: () {
              // Aksi delete di sini
              deleteCircleArea(area);
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
