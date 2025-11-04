import 'dart:convert';
import 'package:http/http.dart' as http;

class NinjasApiService {
  static const String _apiKey = 'KPOum+AtLsjvPf5wHJ8/VQ==rmM3YrAIVMn9FCNJ';
  static const String _baseUrl = 'https://api.api-ninjas.com/v1';

  /// Search for flights using Ninjas API
  /// Returns flight information based on departure and arrival cities
  static Future<List<Map<String, dynamic>>> searchFlights({
    required String from,
    required String to,
    DateTime? departureDate,
  }) async {
    try {
      // Get airport codes for cities using Geoapify or direct search
      // For now, we'll use IATA codes or city names
      final fromCode = _getCityCode(from);
      final toCode = _getCityCode(to);
      
      final dateStr = departureDate != null
          ? '${departureDate.year}-${departureDate.month.toString().padLeft(2, '0')}-${departureDate.day.toString().padLeft(2, '0')}'
          : null;

      // Note: API Ninjas flights API endpoint structure
      // Adjust the endpoint based on actual API documentation
      final queryParams = <String, String>{
        'from': fromCode,
        'to': toCode,
      };
      
      if (dateStr != null) {
        queryParams['date'] = dateStr;
      }

      final queryString = queryParams.entries
          .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');

      final response = await http.get(
        Uri.parse('$_baseUrl/flights?$queryString'),
        headers: {
          'X-Api-Key': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        } else if (data is Map && data.containsKey('flights')) {
          final flights = data['flights'] as List?;
          if (flights != null) {
            return List<Map<String, dynamic>>.from(flights);
          }
        }
      } else {
        print('Ninjas API Error: ${response.statusCode} - ${response.body}');
      }
      
      return [];
    } catch (e) {
      print('Error searching flights with Ninjas API: $e');
      return [];
    }
  }

  /// Get airport codes for cities
  /// This is a helper method - you may want to use Geoapify API for this
  static String _getCityCode(String cityName) {
    // Map common city names to IATA codes
    final cityMap = {
      'Cairo': 'CAI',
      'Dubai': 'DXB',
      'Paris': 'CDG',
      'New York': 'JFK',
      'London': 'LHR',
      'Istanbul': 'IST',
      'Rome': 'FCO',
      'Bali': 'DPS',
      'Tokyo': 'NRT',
      'Sydney': 'SYD',
      'Los Angeles': 'LAX',
      'Singapore': 'SIN',
      'Bangkok': 'BKK',
      'Amsterdam': 'AMS',
      'Berlin': 'BER',
    };
    
    return cityMap[cityName] ?? cityName.toUpperCase().substring(0, cityName.length > 3 ? 3 : cityName.length);
  }

  /// Get flight information by route
  static Future<Map<String, dynamic>?> getFlightInfo({
    required String from,
    required String to,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/flights?from=$from&to=$to'),
        headers: {
          'X-Api-Key': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map) {
          return Map<String, dynamic>.from(data);
        }
      }
      return null;
    } catch (e) {
      print('Error getting flight info: $e');
      return null;
    }
  }
}

