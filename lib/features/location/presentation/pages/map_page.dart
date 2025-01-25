// lib/presentation/views/map_view.dart

import 'package:alrm_gps/features/location/presentation/controller/mapController.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class MapView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mapController = Get.find<MyMapController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Map View'),
        actions: [
          Obx(() {
            if (mapController.isInside.isTrue) {
              return ElevatedButton(
                onPressed: () {
                  if (mapController.isPlaying.isTrue) {
                    mapController.pauseAudio();
                  } else {
                    mapController.resumeAudio();
                  }
                },
                child: Icon((mapController.isPlaying.isTrue)
                    ? Icons.pause
                    : Icons.play_arrow),
              );
            } else {
              return SizedBox();
            }
          }),
        ],
      ),
      body: Column(
        children: [
          Obx(() {
            if (mapController.isLoading.value) {
              return CircularProgressIndicator();
            } else {
              return Obx(() => Text(
                    mapController.geofanText.value,
                    style: TextStyle(
                      color: (mapController.isInside.isTrue)
                          ? Colors.green
                          : Colors.black,
                      fontWeight: (mapController.isInside.isTrue)
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ));
            }
          }),
          Container(
            width: Get.width,
            height: 80,
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: mapController.searchController,
              decoration: InputDecoration(labelText: 'search location'),
              onSubmitted: (value) {
                mapController.searchLocation(value);
              },
            ),
          ),
          Obx(() {
            if (mapController.searchResults.isNotEmpty) {
              return Container(
                width: Get.width,
                height: 200,
                child: SingleChildScrollView(
                    child: Column(
                  children: mapController.searchResults
                      .map((e) => ListTile(
                            title: Text(e.name),
                            onTap: () {
                              mapController.goToSearchLocation(e);
                            },
                            subtitle:
                                Text('lat: ${e.latitude} lon: ${e.longitude}'),
                          ))
                      .toList(),
                )),
              );
            } else {
              return SizedBox();
            }
          }),
          Expanded(
              child: Obx(() => FlutterMap(
                    mapController: mapController.map,
                    options: MapOptions(
                      initialCenter: mapController.userLocation.value != null
                          ? mapController.userLocation.value!
                          : LatLng(0, 0),
                      initialZoom: 13.0,
                      onLongPress: (_, latLng) =>
                          _showAddCircleDialog(context, mapController, latLng),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      ),
                      Obx(() => GestureDetector(
                            onTap: () {
                              mapController.deleteMarkOverlay();
                            },
                            child: CircleLayer(
                              hitNotifier: mapController.hitNotifier,
                              circles: mapController.circleAreas
                                  .map(
                                    (area) => CircleMarker(
                                      hitValue: area,
                                      point:
                                          LatLng(area.latitude, area.longitude),
                                      useRadiusInMeter: true,
                                      radius: area.radius,
                                      color: Colors.blue.withOpacity(0.5),
                                      borderColor: Colors.blue,
                                      borderStrokeWidth: 2,
                                    ),
                                  )
                                  .toList(),
                            ),
                          )),
                      Obx(() => MarkerLayer(
                            markers: mapController.locationMark
                                .map((point) => Marker(
                                    width: 100,
                                    height: 100,
                                    point:
                                        LatLng(point.latitude, point.longitude),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.location_pin,
                                          color: (point.name == 'me')
                                              ? Colors.blue
                                              : Colors.red,
                                          size: 40,
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            point.name ?? '',
                                            style: TextStyle(fontSize: 12),
                                            maxLines: 3,
                                          ),
                                        ),
                                      ],
                                    )))
                                .toList(),
                          )),
                    ],
                  )))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          mapController.goToUserLocation();
        },
        child: Icon(Icons.location_on),
      ),
    );
  }

  void _showAddCircleDialog(
    BuildContext context,
    MyMapController mapController,
    LatLng latLng,
  ) {
    final nameController = TextEditingController();
    final radiusController = TextEditingController();
    double radius = 500;
    var selectedFilePath = ''.obs;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Circle Area'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: radiusController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'radius (m)'),
              onChanged: (value) {
                radius = double.parse(value);
              },
            ),
            TextButton(
              onPressed: () async {
                final result =
                    await FilePicker.platform.pickFiles(type: FileType.audio);
                if (result != null && result.files.isNotEmpty) {
                  selectedFilePath.value = result.files.single.path!;
                }
              },
              child: Obx(
                  () => Text('Select Alarm File ' + selectedFilePath.value)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  radiusController.text.isNotEmpty) {
                mapController.addCircleArea(
                  nameController.text,
                  latLng.latitude,
                  latLng.longitude,
                  radius,
                  (selectedFilePath.value == '') ? selectedFilePath.value : 'default',
                );
                Navigator.of(context).pop();
              } else {
                Get.snackbar(
                    'Error', 'Please fill all fields and select a file');
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}
