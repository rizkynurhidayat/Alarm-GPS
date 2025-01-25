// lib/main.dart
import 'package:alrm_gps/features/location/data/models/circle_area_model.dart';
import 'package:alrm_gps/features/location/presentation/controller/map_binding.dart';
import 'package:alrm_gps/features/location/presentation/pages/map_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'boxes.dart';
import 'features/location/data/models/location_model.dart';
// import 'features/location/presentation/controller/location_binding.dart';
// import 'features/location/presentation/pages/location_page.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(LocationModelAdapter());
  Hive.registerAdapter(CircleAreaModelAdapter());

  // Open Hive boxes
  locationBox = await Hive.openBox<LocationModel>('locationBox');
  circleAreaBox = await Hive.openBox<CircleAreaModel>('circleAreaBox');

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: MapBinding(),
      home: MapView(),
    );
  }
}
