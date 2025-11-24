import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/models/tourist_attraction.dart';

class AmadeusPoiService {
  static const String _baseUrl = 'https://test.api.amadeus.com';
  static const String _tokenUrl = '$_baseUrl/v1/security/oauth2/token';
  static const String _poiUrl = '$_baseUrl/v1/reference-data/locations/pois';
  // ⚠️ Replace with your credentials (preferably store securely)
  static const String _clientId = 'z8DOvWDB3TRDi0LuhfAzDdLYG8yvIjIR';
  static const String _clientSecret = '656fjObYFCKsQvo3';

  String? _accessToken;
  DateTime? _tokenExpiry;

  /// --- Get Access Token ---
  Future<String> getAccessToken() async {
    if (_accessToken != null &&
        _tokenExpiry != null &&
        DateTime.now().isBefore(_tokenExpiry!)) {
      return _accessToken!;
    }

    final response = await http.post(
      Uri.parse(_tokenUrl),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'client_credentials',
        'client_id': _clientId,
        'client_secret': _clientSecret,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _accessToken = data['access_token'] as String;
      _tokenExpiry = DateTime.now().add(const Duration(minutes: 25));
      return _accessToken!;
    } else {
      throw Exception('Failed to get access token: ${response.statusCode}');
    }
  }

  /// --- Fetch Places of Interest by coordinates ---
  Future<List<TouristAttraction>> fetchAttractions(
    double latitude,
    double longitude,
  ) async {
    try {
      final token = await getAccessToken();

      // Try with a larger radius (20km) and more results (20)
      final url = Uri.parse(
        '$_poiUrl?latitude=$latitude&longitude=$longitude&radius=20&page[limit]=20',
      );

      print('🔍 Fetching POIs for lat: $latitude, lon: $longitude');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final pois = data['data'] as List?;

        print('✅ API Response: Found ${pois?.length ?? 0} POIs');

        if (pois == null || pois.isEmpty) {
          print('⚠️ No POIs found in API response');
          return [];
        }

        final attractions = parsePoiList(pois);
        print('✅ Parsed ${attractions.length} attractions');
        return attractions;
      } else {
        print('❌ Failed to fetch POIs: ${response.statusCode}');
        print('Response body: ${response.body}');
        return [];
      }
    } catch (e) {
      print('❌ Exception in fetchAttractions: $e');
      return [];
    }
  }

  /// --- Parse list of POIs ---
  List<TouristAttraction> parsePoiList(List pois) {
    final List<TouristAttraction> attractions = [];

    for (var poi in pois) {
      try {
        if (poi is Map<String, dynamic>) {
          final category = poi['category'] ?? 'General';
          attractions.add(
            TouristAttraction(
              id: poi['id'] ?? '',
              name: poi['name'] ?? 'Unknown',
              category: category,
              latitude: poi['geoCode']?['latitude']?.toDouble() ?? 0.0,
              longitude: poi['geoCode']?['longitude']?.toDouble() ?? 0.0,
              description:
                  poi['tags'] != null
                      ? (poi['tags'] as List).join(', ')
                      : 'No description available',
              imageUrl: TouristAttraction.getImageUrlForCategory(category),
            ),
          );
        }
      } catch (e) {
        print('⚠️ Skipped invalid POI: $e');
        continue;
      }
    }
    return attractions;
  }
}
