// import 'package:flutter/material.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// // import 'package:background_location/background_location.dart';

// import 'foregroundTask.dart';
// // import 'background_location_service.dart';

// class RealtimeLocationPage extends StatefulWidget {
//   const RealtimeLocationPage({Key? key}) : super(key: key);

//   @override
//   _RealtimeLocationPageState createState() => _RealtimeLocationPageState();
// }

// class _RealtimeLocationPageState extends State<RealtimeLocationPage> {
//   String _location = "Belum ada data";

//   @override
//   void initState() {
//     super.initState();
//     initBackgroundLocation();
//   }

//   Future<void> initBackgroundLocation() async {
//     FlutterBackgroundService().on('update').listen((event) {
//       if (event != null) {
//         // final String currentTime = event['current_time'];
//         final  lon = event['lon'];
//         final  lat = event['lat'];
//         setState(() {
//            _location = "location : $lat | $lon";
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     // BackgroundLocationService.stopLocationService();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Realtime Location'),
//       ),
//       body: Center(
//         child: Text(
//           _location,
//           style: const TextStyle(fontSize: 18),
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );
//   }
// }
