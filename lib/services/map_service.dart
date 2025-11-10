import '../api/mock_api.dart';

class MapService {
  static List<Map<String, double>> getLocations() {
    return MockAPI.locations;
  }
}
