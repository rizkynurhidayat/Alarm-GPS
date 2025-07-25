import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../domain/entities/searchLocation.dart';
import '../../domain/repositories/searchLocation_repo.dart';


class SearchLocationRepositoryImpl implements SearchLocationRepository {
  @override
  Future<List<SearchLocation>> searchLocationByName(String name) async {
    // TODO: implement searchLocationByName
   final url =
        'https://nominatim.openstreetmap.org/search?q=$name&format=json&addressdetails=1&limit=5';
    final response = await http.get(Uri.parse(url),headers: {
      'User-Agent': 'com.example.alrm_gps/1.0 (rizkysiap86@gmail.com)'
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) {
        return SearchLocation(
          name: item['display_name'] ?? '',
          latitude: double.tryParse(item['lat'] ?? '0') ?? 0,
          longitude: double.tryParse(item['lon'] ?? '0') ?? 0,
        );
      }).toList();
    } else {
      print('error search: ${response.statusCode} | ${response.body}');
      throw Exception('${response.statusCode}');
    }
  }
  
}
