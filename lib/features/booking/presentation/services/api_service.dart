import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/models/tourist_attraction.dart';

class OpenTripService {
  // TODO: Add your OpenTripMap API key here
  // Get your free API key from: https://opentripmap.io/docs
  static const String apiKey = ""; // Add your API key here
  static const String baseUrl = "https://api.opentripmap.com/0.1/en/places";

  /// Get tourist attractions by city name
  static Future<List<TouristAttraction>> getTouristAttractionsByCity(
    String city,
  ) async {
    try {
      // Step 1: Get coordinates of the city
      final geoUrl = Uri.parse("$baseUrl/geoname?name=$city&apikey=$apiKey");

      final geoResponse = await http.get(geoUrl);
      if (geoResponse.statusCode != 200) {
        throw Exception("Failed to get geolocation for $city");
      }

      final geoData = jsonDecode(geoResponse.body);

      // Handle different response formats
      if (geoData is! Map<String, dynamic>) {
        throw Exception("Invalid response format from geolocation API");
      }

      // Safely extract coordinates with null checking
      final latValue = geoData["lat"];
      final lonValue = geoData["lon"];

      if (latValue == null || lonValue == null) {
        // Log the response for debugging
        print("Geo API Response: $geoData");
        throw Exception(
          "Failed to get coordinates for $city: Invalid response - lat or lon is null",
        );
      }

      final double? parsedLat = _parseDouble(latValue);
      final double? parsedLon = _parseDouble(lonValue);

      if (parsedLat == null || parsedLon == null) {
        throw Exception(
          "Failed to parse coordinates for $city: lat=$latValue, lon=$lonValue",
        );
      }

      final double lat = parsedLat;
      final double lon = parsedLon;

      if (lat == 0.0 || lon == 0.0) {
        throw Exception("Failed to get valid coordinates for $city");
      }

      // Step 2: Get tourist attractions around coords
      final placesUrl = Uri.parse(
        "$baseUrl/radius?radius=5000&lon=$lon&lat=$lat&format=json&apikey=$apiKey&limit=50",
      );

      final placesResponse = await http.get(placesUrl);
      if (placesResponse.statusCode != 200) {
        throw Exception("Failed to load places: ${placesResponse.statusCode}");
      }

      final places = jsonDecode(placesResponse.body) as List<dynamic>;

      // Convert OpenTripMap places to TouristAttraction objects
      final List<TouristAttraction> attractions = [];

      for (var place in places) {
        if (place is Map<String, dynamic>) {
          try {
            final attraction = _convertToTouristAttraction(place);
            if (attraction.name.isNotEmpty &&
                attraction.name != 'Unknown Attraction' &&
                attraction.latitude != 0.0 &&
                attraction.longitude != 0.0) {
              attractions.add(attraction);
            }
          } catch (e) {
            // Skip invalid places
            continue;
          }
        }
      }

      return attractions;
    } catch (e) {
      throw Exception('Error fetching attractions from OpenTripMap: $e');
    }
  }

  /// Convert OpenTripMap place data to TouristAttraction
  static TouristAttraction _convertToTouristAttraction(
    Map<String, dynamic> place,
  ) {
    // Extract coordinates
    double lat = 0.0;
    double lon = 0.0;

    if (place['point'] != null && place['point'] is Map) {
      final point = place['point'] as Map<String, dynamic>;
      lat = _parseDouble(point['lat']) ?? 0.0;
      lon = _parseDouble(point['lon']) ?? 0.0;
    } else if (place['lat'] != null && place['lon'] != null) {
      lat = _parseDouble(place['lat']) ?? 0.0;
      lon = _parseDouble(place['lon']) ?? 0.0;
    }

    // Extract name
    String name =
        place['name']?.toString() ??
        place['display_name']?.toString() ??
        'Unknown Attraction';

    // Extract category/kinds
    String category = 'Attraction';
    if (place['kinds'] != null) {
      final kinds = place['kinds'].toString().split(',');
      if (kinds.isNotEmpty) {
        // Get the first kind and format it
        category = kinds[0].trim().replaceAll('_', ' ').toUpperCase();
      }
    } else if (place['category'] != null) {
      category = place['category'].toString();
    }

    // Extract description
    String? description;
    if (place['wikipedia_extracts'] != null &&
        place['wikipedia_extracts'] is Map) {
      final extracts = place['wikipedia_extracts'] as Map<String, dynamic>;
      description = extracts['text']?.toString();
    } else if (place['description'] != null) {
      description = place['description'].toString();
    }

    // Use xid as ID
    String id =
        place['xid']?.toString() ??
        place['id']?.toString() ??
        '${lat}_${lon}_${DateTime.now().millisecondsSinceEpoch}';

    return TouristAttraction(
      id: id,
      name: name,
      category: category,
      latitude: lat,
      longitude: lon,
      description: description,
      imageUrl: TouristAttraction.getImageUrlForCategory(category),
    );
  }

  /// Helper method to parse double from various types
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  /// Get full place details by xid
  static Future<dynamic> getPlaceDetails(String xid) async {
    final url = Uri.parse("$baseUrl/xid/$xid?apikey=$apiKey");

    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception("Failed to load details");
    }

    return jsonDecode(response.body);
  }

  /// Get places by city name (legacy method for backward compatibility)
  static Future<List<dynamic>> getPlacesByCity(String city) async {
    final attractions = await getTouristAttractionsByCity(city);
    return attractions.map((a) => a.toJson()).toList();
  }
}
