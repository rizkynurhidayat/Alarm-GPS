// lib/presentation/views/map_view.dart

import 'package:alrm_gps/features/location/presentation/controller/mapController.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../data/models/rute_model.dart';

class MapViewPage extends StatefulWidget {
  MapViewPage({super.key, required this.rute});

  RuteModel rute;

  @override
  State<MapViewPage> createState() => _MapViewPageState();
}

class _MapViewPageState extends State<MapViewPage> {
  final mapController = Get.find<MyMapController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("id: "+ widget.rute.id.toString());
    Future.delayed(Duration(seconds: 2)).then(
      (value) => mapController.updateMap(widget.rute.id.toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // mapController.loadLocalData();
    return Scaffold(
      appBar: AppBar(
        title: Text('Map View'),
        leading: IconButton(
            onPressed: () {
              mapController.isLocationupdate.value = false;
              mapController.isSearchLoc.value = false;
              mapController.circleAreas.clear();
              mapController.locationMark.clear();

              Get.back();
            },
            icon: Icon(Icons.arrow_back)),
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
              child: Stack(alignment: Alignment.center, children: [
            Obx(() => FlutterMap(
                  mapController: mapController.map,
                  options: MapOptions(
                    initialCenter: mapController.userLocation.value != null
                        ? mapController.userLocation.value!
                        : LatLng(0, 0),
                    initialZoom: 13.0,
                    // onLongPress: (_, latLng) =>
                    //     _showAddCircleDialog(context, mapController, latLng),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    ),
                    Obx(() => GestureDetector(
                          onTap: () {
                            mapController
                                .deleteMarkOverlay(widget.rute.id.toString());
                          },
                          child: CircleLayer(
                            hitNotifier: mapController.hitNotifier,
                            circles: mapController.circleAreas
                                .map(
                                  (area) => CircleMarker(
                                    hitValue: area,
                                    point: LatLng(area!.lat!, area.lon!),
                                    useRadiusInMeter: true,
                                    radius: area.rad!,
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
                                  point: LatLng(point!.lat!, point.lon!),
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
                )),
            Positioned(
              right: 8,
              bottom: 5,
              child: IconButton(
                  onPressed: () {
                    mapController.goToUserLocation();
                  },
                  icon: Icon(Icons.location_on)),
            ),
          ])),
          Obx(() {
            if (mapController.isSearchLoc.isTrue) {
              return Container(
                height: 170,
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(children: [
                      Text("radius :"),
                      Expanded(
                        child: Slider(
                          value: mapController.radius.value,
                          min: 500,
                          max: 10000,
                          divisions: (10000 - 500) ~/ 100,
                          label:
                              "${(mapController.radius.value / 1000).toPrecision(2)} km",
                          onChanged: (value) {
                            mapController.radius.value = value;
                          },
                        ),
                      ),
                      Text(
                          "${(mapController.radius.value / 1000).toPrecision(2)} km"),
                    ]),
                    Row(
                      children: [
                        Text("nada: ${mapController.alarmPathName}"),
                        TextButton(
                          onPressed: () {
                            mapController.addAlarmAudio();
                          },
                          child: Text((mapController.alarmPathName != '')
                              ? ''
                              : 'Select Alarm File '),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            mapController.cancelSearchLocation();
                          },
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            final location = mapController.searchLoc!;

                            mapController.addCircleArea(
                              location.name!,
                              location.lat!,
                              location.lon!,
                              mapController.radius.value,
                              widget.rute.id.toString(),
                            );
                          },
                          child: Text("add location"),
                        ),
                      ],
                    )
                  ],
                ),
              );
            } else {
              return SizedBox();
            }
          }),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     mapController.goToUserLocation();
      //   },
      //   child: Icon(Icons.location_on),
      // ),
    );
  }
}
