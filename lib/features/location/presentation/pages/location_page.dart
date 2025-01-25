// // lib/presentation/pages/location_page.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:get/get.dart';
// import '../controller/location_controller.dart';

// class LocationPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final LocationController controller = Get.find<LocationController>();
//     return Scaffold(
//         appBar: AppBar(title: Text('Location Tracker')),
//         body: Obx(() {
//           if (controller.userLocation.value == null) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           return FlutterMap(
//             options: MapOptions(
//               initialCenter: controller.userLocation.value!,
//               initialZoom: 15.0,
//               onLongPress: (tapPosition, point) {
//                 Get.defaultDialog(
//                     title: "Add Circle Mark",
//                     content: Column(
//                       children: [
//                         TextField(
//                           controller: controller.nama,
//                           // decoration: I,
//                         ),
//                         TextField(
//                           controller: controller.radius,
//                           keyboardType: TextInputType.number,
//                         ),
//                       ],
//                     ),
//                     textConfirm: 'add',
//                     onConfirm: () {
//                       controller.addCircleMarker(
//                         point,
//                       );

//                       Get.back();
//                     },
//                     onCancel: () {
//                       Get.back();
//                     });
//               },
//             ),
//             children: [
//               TileLayer(
//                 urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                 // subdomains: ['a', 'b', 'c'],
//               ),
//               Obx(() => MarkerLayer(
//                     markers: controller.Markers.value,
//                   )),
//               Obx(() {
//                 return CircleLayer(
//                   circles: controller.circleMarkers.value,
//                 );
//               }),
//             ],
//           );
//         }),
//         floatingActionButton: FloatingActionButton(
//             onPressed: () {
//               controller.getCurrentLocation();
//             },
//             child: Icon(Icons.location_on)));
//   }
// }
