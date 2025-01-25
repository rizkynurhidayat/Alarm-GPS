// import '../entities/search_location.dart';
import '../entities/searchLocation.dart';
import '../repositories/searchLocation_repo.dart';
// import '../repositories/search_location_repository.dart';

class SearchLocationUseCase {
  final SearchLocationRepository repository;

  SearchLocationUseCase(this.repository);

  Future<List<SearchLocation>> call(String query) async {
    return await repository.searchLocationByName(query);
  }
}
