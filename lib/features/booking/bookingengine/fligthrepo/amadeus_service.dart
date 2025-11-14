import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/models/flight.dart';

class AmadeusService {
  static const String _baseUrl = 'https://test.api.amadeus.com';
  static const String _tokenUrl = '$_baseUrl/v1/security/oauth2/token';
  static const String _flightOffersUrl = '$_baseUrl/v2/shopping/flight-offers';

  static const String _clientId = 'mZuWoMjXITmm0Deugy7GlGv95cmRfdez';
  static const String _clientSecret = 'VfoBl3kJstHzGsAJ';

  String? _accessToken;
  DateTime? _tokenExpiry;

  /// Get access token from Amadeus API
  Future<String> getAccessToken() async {
    // Check if token is still valid (tokens typically last 30 minutes)
    if (_accessToken != null && _tokenExpiry != null) {
      if (DateTime.now().isBefore(_tokenExpiry!)) {
        return _accessToken!;
      }
    }

    try {
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
        // Set expiry to 25 minutes (tokens last 30 minutes, refresh 5 minutes early)
        _tokenExpiry = DateTime.now().add(const Duration(minutes: 25));
        return _accessToken!;
      } else {
        throw Exception('Failed to get access token: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting access token: $e');
    }
  }

  /// Search for flights using Amadeus API
  Future<List<Flight>> searchFlights({
    required String originLocationCode,
    required String destinationLocationCode,
    required DateTime departureDate,
    DateTime? returnDate,
    int adults = 1,
    int children = 0,
    int infants = 0,
    String travelClass = 'ECONOMY',
    int max = 10,
  }) async {
    try {
      final token = await getAccessToken();

      // Build query parameters
      final queryParams = {
        'originLocationCode': originLocationCode,
        'destinationLocationCode': destinationLocationCode,
        'departureDate': _formatDate(departureDate),
        'adults': adults.toString(),
        'max': max.toString(),
        'currencyCode': 'USD',
      };

      if (returnDate != null) {
        queryParams['returnDate'] = _formatDate(returnDate);
      }

      if (children > 0) {
        queryParams['children'] = children.toString();
      }

      if (infants > 0) {
        queryParams['infants'] = infants.toString();
      }

      queryParams['travelClass'] = travelClass;

      // Build URI with query parameters
      final uri = Uri.parse(
        _flightOffersUrl,
      ).replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _parseFlightOffers(data);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
          'Failed to search flights: ${errorData['errors']?[0]?['detail'] ?? response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error searching flights: $e');
    }
  }

  /// Parse Amadeus API response to Flight models
  List<Flight> _parseFlightOffers(Map<String, dynamic> data) {
    final List<Flight> flights = [];

    if (data['data'] == null) {
      return flights;
    }

    final offers = data['data'] as List;

    for (var offer in offers) {
      try {
        final flight = _parseFlightOffer(offer);
        if (flight != null) {
          flights.add(flight);
        }
      } catch (e) {
        // Skip invalid flight offers

        continue;
      }
    }

    return flights;
  }

  /// Parse a single flight offer to Flight model
  Flight? _parseFlightOffer(Map<String, dynamic> offer) {
    try {
      // Get the first itinerary (outbound flight)
      final itineraries = offer['itineraries'] as List;
      if (itineraries.isEmpty) return null;

      final outboundItinerary = itineraries[0];
      final segments = outboundItinerary['segments'] as List;
      if (segments.isEmpty) return null;

      final firstSegment = segments[0];
      final lastSegment = segments[segments.length - 1];

      // Extract flight information
      final carrier = firstSegment['carrierCode'] as String;
      final flightNumber = firstSegment['number'] as String;
      final departure = firstSegment['departure'];
      final arrival = lastSegment['arrival'];

      // Parse dates
      final departureDateTime = DateTime.parse(departure['at'] as String);
      final arrivalDateTime = DateTime.parse(arrival['at'] as String);

      // Get price
      final priceData = offer['price'] as Map<String, dynamic>;
      final totalPrice = double.parse(priceData['total'] as String);

      // Get city names from airport codes (you might want to maintain a mapping)
      final departureAirport = departure['iataCode'] as String;
      final arrivalAirport = arrival['iataCode'] as String;

      // Duration is calculated from departure and arrival times
      // The API provides duration string but we calculate from actual times for accuracy

      return Flight(
        id: offer['id'] as String,
        airline: _getAirlineName(carrier),
        flightNumber: '$carrier$flightNumber',
        departureCity: _getCityName(departureAirport),
        departureAirport: departureAirport,
        arrivalCity: _getCityName(arrivalAirport),
        arrivalAirport: arrivalAirport,
        departureTime: departureDateTime,
        arrivalTime: arrivalDateTime,
        price: totalPrice,
        currency: priceData['currency'] as String? ?? 'USD',
        availableSeats: offer['numberOfBookableSeats'] as int? ?? 9,
        aircraft: segments[0]['aircraft']?['code'] as String? ?? 'Unknown',
        rating: 4.5, // Default rating, as Amadeus doesn't provide this
        amenities: _getDefaultAmenities(),
        isHotDeal: totalPrice < 500, // Consider flights under $500 as hot deals
        imageUrl:
            'assets/images/${_getCityName(arrivalAirport).toLowerCase().replaceAll(' ', '_')}.jpg',
      );
    } catch (e) {
      return null;
    }
  }

  /// Get airline name from carrier code
  String _getAirlineName(String carrierCode) {
    final airlineMap = {
      'EK': 'Emirates',
      'TK': 'Turkish Airlines',
      'QR': 'Qatar Airways',
      'MS': 'EgyptAir',
      'EY': 'Etihad Airways',
      'LH': 'Lufthansa',
      'BA': 'British Airways',
      'AF': 'Air France',
      'KL': 'KLM',
      'AA': 'American Airlines',
      'DL': 'Delta Air Lines',
      'UA': 'United Airlines',
    };
    return airlineMap[carrierCode] ?? carrierCode;
  }

  /// Get city name from airport code
  String _getCityName(String airportCode) {
    final cityMap = {
      'CAI': 'Cairo',
      'DXB': 'Dubai',
      'IST': 'Istanbul',
      'DOH': 'Doha',
      'AUH': 'Abu Dhabi',
      'LHR': 'London',
      'JFK': 'New York',
      'CDG': 'Paris',
      'FRA': 'Frankfurt',
      'AMS': 'Amsterdam',
      'LAX': 'Los Angeles',
      'NRT': 'Tokyo',
      'SYD': 'Sydney',
      'BKK': 'Bangkok',
      'ROM': 'Rome',
    };
    return cityMap[airportCode] ?? airportCode;
  }

  /// Get default amenities for flights
  List<String> _getDefaultAmenities() {
    return ['WiFi', 'Meal', 'Entertainment'];
  }

  /// Format date to YYYY-MM-DD
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
