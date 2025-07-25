import 'dart:collection';

import 'package:alrm_gps/features/location/presentation/controller/mapController.dart';
import 'package:alrm_gps/features/location/presentation/pages/map_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';

import '../../data/models/rute_model.dart';
import '../controller/map_binding.dart';

class Home_page extends StatelessWidget {
  const Home_page({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<MyMapController>();

    // final MapController c =  Get.find();
    return Scaffold(
      appBar: AppBar(
        title: Text('aplikasi alarm gps'),
      ),
      body: Column(
        children: [
          Container(
            width: Get.width,
            height: 80,
            padding: EdgeInsets.all(10),
            child: TextField(
              // controller: mapController.searchController,
              decoration: InputDecoration(labelText: 'search location'),
              // onSubmitted: (value) {
              //   mapController.searchLocation(value);
              // },
            ),
          ),
          Expanded(child: Obx(() {
            if (c.rutes.isEmpty) {
              return Center(
                child: Text(
                    'klik icon tambah lokasi di bawah untuk menambahkan geo alarm'),
              );
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: List.generate(c.rutes.length, (index) {
                    final data = c.rutes[index];
                    RxBool isActive = data.isActive!.obs;
                    return GestureDetector(
                      onTap: () {
                        
                        Get.to(() => MapViewPage(
                              rute: data,
                            ));
                      },
                      child: Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: Container(
                          width: Get.width,
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(data.name!),
                                subtitle: Text(data.deskripsi!),
                                trailing: PopupMenuButton<String>(
                                  icon: const Icon(Icons.more_vert),
                                  onSelected: (value) {
                                    if (value == 'edit') {
                                      final nama = TextEditingController(
                                          text: data.name);
                                      final desk = TextEditingController(
                                          text: data.deskripsi);

                                      Get.defaultDialog(
                                          title: "edit rute",
                                          content: Column(
                                            children: [
                                              TextField(
                                                controller: nama,
                                              ),
                                              TextField(
                                                controller: desk,
                                              ),
                                            ],
                                          ),
                                          onConfirm: () async {
                                            final RuteModel rute = RuteModel(
                                                id: data.id,
                                                name: nama.text,
                                                deskripsi: desk.text,
                                                isActive: data.isActive,
                                                timestamp:
                                                    DateTime.now().toString());
                                            c.datasource.editRuteKA(rute);
                                            await Future.delayed(
                                                Duration(seconds: 1));
                                            c.getAllRute();
                                            Get.back();
                                          },
                                          onCancel: () {
                                            Get.back();
                                          });
                                    } else if (value == 'delete') {
                                      Get.defaultDialog(
                                          title: "delete ini?",
                                          middleText:
                                              "rute: ${data.name} ${data.deskripsi}",
                                          onConfirm: () async {
                                            c.deleteRute(data.id!);
                                            await Future.delayed(
                                                Duration(seconds: 1));
                                            c.getAllRute();
                                            Get.back();
                                          },
                                          onCancel: () {
                                            Get.back();
                                          });
                                    }
                                  },
                                  itemBuilder: (BuildContext context) => [
                                    const PopupMenuItem(
                                      value: 'edit',
                                      child: Text('Edit'),
                                    ),
                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: Text('Hapus'),
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Switch(
                                      value: isActive.value,
                                      onChanged: (val) {
                                        var newRute = data;
                                        newRute.isActive = val;
                                        isActive.value = val;
                                        c.editDute(newRute);
                                      }),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              );
            }
          }))
        ],
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          // Get.to(MapViewPage(), binding: MapBinding());
          // Get.to(MapViewPage(), binding: MapBinding());

          final nama = TextEditingController();
          final desk = TextEditingController();
          // final isActive = false;
          // final desk = TextEditingController();
          Get.defaultDialog(
              content: Container(
                  child: Column(
            children: [
              Text("isi data ini"),
              TextField(
                controller: nama,
              ),
              TextField(
                controller: desk,
              ),
              ElevatedButton(
                  onPressed: () async {
                    c.tambahRute(nama.text, desk.text);
                    // await Future.delayed(Duration(seconds: 2));
                    // c.geAllRute();
                    Get.back();
                  },
                  child: Text("Ok")),
              ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text("cancel")),
            ],
          )));
        },
        child: Icon(Icons.add_location),
      ),
    );
  }
}
