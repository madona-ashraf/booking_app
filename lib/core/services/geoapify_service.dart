import 'dart:convert';
import 'package:http/http.dart' as http;

class GeoapifyService {
  static const String _apiKey = '3250ab673698435c8f0a175404c265c9';
  static const String _baseUrl = 'https://api.geoapify.com/v1';

  /// Search for places/autocomplete
  static Future<List<Map<String, dynamic>>> searchPlaces(String query) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/geocode/autocomplete?text=$query&apiKey=$_apiKey&limit=10',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final features = data['features'] as List?;
        
        if (features != null) {
          return features.map((feature) {
            final properties = feature['properties'] as Map<String, dynamic>;
            final geometry = feature['geometry'] as Map<String, dynamic>;
            final coordinates = geometry['coordinates'] as List;
            
            return {
              'name': properties['name'] ?? '',
              'country': properties['country'] ?? '',
              'city': properties['city'] ?? properties['name'] ?? '',
              'lat': coordinates[1],
              'lon': coordinates[0],
              'formatted': properties['formatted'] ?? properties['name'] ?? '',
            };
          }).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error searching places: $e');
      return [];
    }
  }

  /// Get place details by coordinates
  static Future<Map<String, dynamic>?> getPlaceDetails(
    double lat,
    double lon,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/geocode/reverse?lat=$lat&lon=$lon&apiKey=$_apiKey',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final features = data['features'] as List?;
        
        if (features != null && features.isNotEmpty) {
          final feature = features[0];
          final properties = feature['properties'] as Map<String, dynamic>;
          
          return {
            'name': properties['name'] ?? '',
            'country': properties['country'] ?? '',
            'city': properties['city'] ?? '',
            'formatted': properties['formatted'] ?? properties['name'] ?? '',
          };
        }
      }
      return null;
    } catch (e) {
      print('Error getting place details: $e');
      return null;
    }
  }

  /// Search for airports
  static Future<List<Map<String, dynamic>>> searchAirports(String query) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/geocode/autocomplete?text=$query&apiKey=$_apiKey&limit=10&filter=airport',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final features = data['features'] as List?;
        
        if (features != null) {
          return features.map((feature) {
            final properties = feature['properties'] as Map<String, dynamic>;
            final geometry = feature['geometry'] as Map<String, dynamic>;
            final coordinates = geometry['coordinates'] as List;
            
            return {
              'name': properties['name'] ?? '',
              'country': properties['country'] ?? '',
              'city': properties['city'] ?? '',
              'lat': coordinates[1],
              'lon': coordinates[0],
              'formatted': properties['formatted'] ?? properties['name'] ?? '',
              'iata': properties['iata'] ?? '',
            };
          }).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error searching airports: $e');
      return [];
    }
  }
}

