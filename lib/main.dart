// lib/main.dart
import 'package:alrm_gps/features/location/data/models/circle_area_model.dart';
import 'package:alrm_gps/features/location/presentation/controller/map_binding.dart';
import 'package:alrm_gps/features/location/presentation/pages/home_page.dart';
import 'package:alrm_gps/features/location/presentation/pages/map_page.dart';
import 'package:alrm_gps/foregroundTask.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';

// import 'boxes.dart';
import 'features/location/data/models/location_model.dart';
import 'home_home.dart';
// import 'features/location/presentation/controller/location_binding.dart';
// import 'features/location/presentation/pages/location_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage().initStorage;
  await initNotif();
  // final service = FlutterBackgroundService();
  // service.invoke("stopService");
  // await initializeService();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: MapBinding(),
      home: Home_page(),
    );
  }
}
