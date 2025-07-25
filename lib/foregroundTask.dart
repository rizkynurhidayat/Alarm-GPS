import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:alrm_gps/bacground_service.dart';
import 'package:alrm_gps/features/location/data/datasources/location_datasource.dart';
import 'package:alrm_gps/features/location/data/models/location_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_local_notification/flutter_local_notification.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  Timer? timer;
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  // For flutter prior to version 3.0.0
  // We have to register the plugin manually
  late Position? loc;
  await GetStorage().initStorage;
  final datasource = LocationLocalDataSourceImpl();
  late LocationModel myloc;

  /// OPTIONAL when use custom notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // bring to foreground
  // timer = Timer.periodic(const Duration(seconds: 1), (t) async {
  //   final isRUnning = await FlutterBackgroundService().isRunning();
  //   if (isRUnning == false) {
  //     timer?.cancel();
  //     return;
  //   }
  //   loc = await MyLocationServiceHandler().getCurrentLocation();
  //   myloc = LocationModel(
  //       name: "me",
  //       lat: loc!.latitude,
  //       lon: loc!.longitude,
  //       isEntry: false,
  //       timestamp: DateTime.now().toString());
  //   datasource.saveMyLocation(myloc);
  //   if (service is AndroidServiceInstance) {
  //     if (await service.isForegroundService()) {
  //       /// OPTIONAL for use custom notification
  //       /// the notification id must be equals with AndroidConfiguration when you call configure() method.
  //       flutterLocalNotificationsPlugin.show(
  //         888,
  //         'COOL SERVICE',
  //         'Awesome ${DateTime.now()}',
  //         const NotificationDetails(
  //           android: AndroidNotificationDetails(
  //             'my_foreground',
  //             'MY FOREGROUND SERVICE',
  //             icon: 'ic_bg_service_small',
  //             ongoing: true,
  //           ),
  //         ),
  //       );

  //       // if you don't using custom notification, uncomment this
  //       service.setForegroundNotificationInfo(
  //         title: "My App Service",
  //         content: "Updated at ${DateTime.now()}",
  //       );
  //     }
  //     debugPrint('FLUTTER BACKGROUND SERVICE:  ${DateTime.now()}');
  //   }
  //   if (loc != null) {
  //     service.invoke(
  //       'update',
  //       {
  //         "current_time": DateTime.now().toIso8601String(),
  //         "lat": loc!.latitude,
  //         "lon": loc!.longitude,
  //       },
  //     );

  //     debugPrint(
  //         'FLUTTER BACKGROUND SERVICE: ${loc!.latitude} ${loc!.longitude}');
  //   } else {
  //     debugPrint('Location is NULL');
  //   }

    /// you can see this log in logcat
    // debugPrint('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');
  // });
}

Future<void> initNotif() async {
  /// OPTIONAL, using custom notification channel id
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', // id
    'MY FOREGROUND SERVICE', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isIOS || Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('ic_bg_service_small'),
      ),
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,

      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
      foregroundServiceTypes: [AndroidForegroundType.location],
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,
    ),
  );
}
