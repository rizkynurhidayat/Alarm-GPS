import '../entities/searchLocation.dart';

abstract class SearchLocationRepository {
  Future<List<SearchLocation>> searchLocationByName(String name);
}