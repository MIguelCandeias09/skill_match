import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class GeocodingService {
  static const String _nominatimUrl =
      'https://nominatim.openstreetmap.org/search';

  // Cache para evitar requests repetidos
  static final Map<String, LatLng?> _cache = {};

  /// Converte uma localização (texto) em coordenadas GPS
  /// Exemplo: "Lisboa, Portugal" -> LatLng(38.7223, -9.1393)
  static Future<LatLng?> getCoordinates(String location) async {
    if (location.trim().isEmpty) return null;

    // Verifica cache primeiro
    if (_cache.containsKey(location)) {
      return _cache[location];
    }

    try {
      // Adiciona ", Portugal" se não estiver presente para melhor precisão
      String searchQuery = location;
      if (!location.toLowerCase().contains('portugal')) {
        searchQuery = '$location, Portugal';
      }

      final response = await http.get(
        Uri.parse(_nominatimUrl).replace(queryParameters: {
          'q': searchQuery,
          'format': 'json',
          'limit': '1',
          'addressdetails': '1',
        }),
        headers: {
          'User-Agent': 'SkillMatch-App/1.0', // Nominatim requer User-Agent
        },
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final List<dynamic> results = json.decode(response.body);

        if (results.isNotEmpty) {
          final result = results[0];
          final lat = double.parse(result['lat']);
          final lon = double.parse(result['lon']);

          final coordinates = LatLng(lat, lon);
          _cache[location] = coordinates;

          return coordinates;
        }
      }
    } catch (e) {
      print('Erro ao buscar coordenadas para "$location": $e');
    }

    // Se falhar, retorna null
    _cache[location] = null;
    return null;
  }

  /// Busca coordenadas para múltiplas localizações em paralelo
  static Future<Map<String, LatLng?>> getMultipleCoordinates(
    List<String> locations,
  ) async {
    final Map<String, LatLng?> results = {};

    // Processa em paralelo com pequeno delay entre requests (política do Nominatim)
    for (int i = 0; i < locations.length; i++) {
      final location = locations[i];
      results[location] = await getCoordinates(location);

      // Pequeno delay para respeitar rate limit do Nominatim (1 req/segundo)
      if (i < locations.length - 1) {
        await Future.delayed(const Duration(milliseconds: 1100));
      }
    }

    return results;
  }

  /// Limpa o cache
  static void clearCache() {
    _cache.clear();
  }
}
