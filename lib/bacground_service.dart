import 'dart:async';
import 'package:geolocator/geolocator.dart';

class MyLocationServiceHandler {
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  StreamSubscription<Position>? _locationSubscription;

  Future<bool> _handlePermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await _geolocatorPlatform.openLocationSettings();
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        await _geolocatorPlatform.openLocationSettings();
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  Future<Position?> getCurrentLocation() async {
    bool isAllowed = await _handlePermission();
    if (isAllowed) {
      return await _geolocatorPlatform.getCurrentPosition();
    } else {
      print("GPS not allowed sayang...");
      return null;
    }
  }

  void startLocationStream(Function(Position) onData) async {
    bool isAllowed = await _handlePermission();
    if (isAllowed) {
      _locationSubscription = _geolocatorPlatform.getPositionStream(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          distanceFilter: 10,
          timeLimit: null, // Biar terus streaming tanpa timeout
        ),
      ).listen((Position position) {
        onData(position);
      });
    } else {
      print("GPS access ditolak sayangku...");
    }
  }

  void stopLocationStream() {
    _locationSubscription?.cancel();
    _locationSubscription = null;
  }
}
