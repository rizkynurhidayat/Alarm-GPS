// // lib/presentation/controllers/location_controller.dart
// import 'package:alrm_gps/features/location/domain/usecases/getCurrentLocation.dart';
// import 'package:alrm_gps/features/location/domain/usecases/getsavedlocation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:get/get.dart';
// import 'package:latlong2/latlong.dart';
// import '../../domain/entities/location.dart';

// import 'package:geolocator/geolocator.dart';

// import '../../domain/usecases/savelocation.dart';

// class LocationController extends GetxController {
//   final SaveLocationUseCase saveLocationUseCase;
//   final GetSavedLocationsUseCase getSavedLocationsUseCase;
//   final GetCurrentLocationUseCase getCurrentLocationUsecase;

//   LocationController(this.saveLocationUseCase, this.getSavedLocationsUseCase,
//       this.getCurrentLocationUsecase);

//   final RxList<Location> locations = <Location>[].obs;
//   RxBool isLoading = false.obs;

//   var userLocation = Rxn<LatLng>();
//   var circleMarkers = <CircleMarker>[].obs;
//   var Markers = <Marker>[].obs;

//   final nama = TextEditingController();
//   final radius = TextEditingController();

//   @override
//   void onInit() {
//     super.onInit();
//     _startLocationTracking();
//     // _loadSavedLocations();
//     // fetchUserLocation();
//   }

//   @override
//   void onClose() {
//     // TODO: implement onClose
//     super.onClose();
//   }

//   void _startLocationTracking() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       Get.snackbar(
//           'Permission Denied', 'Location permission is required to continue.');
//       return Future.error('Location services are disabled.');
//     }
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         Get.snackbar('Permission Denied',
//             'Location permission is required to continue.');
//         return Future.error('Location permissions are denied');
//       }
//     }

//     while (serviceEnabled) {
//       isLoading.value = true;
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//       Location location = Location(
//         latitude: position.latitude,
//         longitude: position.longitude,
//         timestamp: DateTime.now(),
//       );
//       await saveLocationUseCase.execute(location);
//       userLocation.value = LatLng(location.latitude, location.longitude);

//       updateUserLocationMark(userLocation.value!);
//       locations.add(location);
//       isLoading.value = false;
//       await Future.delayed(Duration(minutes: 1)); // 1 menit delay
//     }
//   }

//   void getCurrentLocation() async {
//     // isLoading.value = true;
//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//     Location location = Location(
//       latitude: position.latitude,
//       longitude: position.longitude,
//       timestamp: DateTime.now(),
//     );
//     await saveLocationUseCase.execute(location);
//     locations.add(location);
//     updateUserLocationMark(LatLng(location.latitude, location.longitude));
//     // isLoading.value = false;
//   }

//   void _loadSavedLocations() async {
//     final savedLocations = await getSavedLocationsUseCase.execute();
//     locations.addAll(savedLocations); // Tambahkan data ke list
//   }

//   Future<void> fetchUserLocation() async {
//     try {
//       final location = await getCurrentLocationUsecase.execute();
//       userLocation.value = LatLng(location.latitude, location.longitude);
//     } catch (e) {
//       Get.snackbar('Error', e.toString());
//     }
//   }

//   void addCircleMarker(LatLng point) {
//     final circle = CircleMarker(
//       key: Key(nama.text),
//       point: point,
//       radius: double.parse(radius.text),
//       useRadiusInMeter: true,
//       color: Colors.blue.withOpacity(0.3),
//       borderColor: Colors.blue,
//       borderStrokeWidth: 2,
//     );
//     circleMarkers.add(circle);

//     final mark = Marker(
//       width: 100,
//       height: 100,
//       key: Key(nama.text),
//       point: point,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             Icons.location_on,
//             color: Colors.blue,
//             size: 40,
//           ),
//           Container(
//             padding: EdgeInsets.all(4),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(4),
//             ),
//             child: Text(
//               nama.text,
//               style: TextStyle(fontSize: 12),
//             ),
//           ),
//         ],
//       ),
//     );

//     Markers.add(mark);
//   }

//   void updateUserLocationMark(LatLng point) {
//     final existingMarkerIndex =
//         Markers.indexWhere((marker) => marker.key == Key('userLocation'));
//     if (existingMarkerIndex != -1) {
//       Markers[existingMarkerIndex] = Marker(
//         key: Key('userLocation'),
//         point: point,
//         child: const Icon(
//           Icons.location_pin,
//           color: Colors.red,
//           size: 40,
//         ),
//       );
//     } else {
//       Markers.add(Marker(
//         key: Key('userLocation'),
//         point: point,
//         child: const Icon(
//           Icons.location_pin,
//           color: Colors.red,
//           size: 40,
//         ),
//       ));
//     }
//   }
// }
