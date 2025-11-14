import 'dart:convert';

import 'package:http/http.dart' as http;

const apiKey = '5ae2e3f221c38a28845f05b6c973a39f350aa14828fc47355fd7ac01';

Future<List<dynamic>> fetchAttractions(double lat, double lon) async {
  try {
    final response = await http.get(
      Uri.parse('https://api.opentripmap.com/0.1/en/places/'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['features'] ?? [];
    } else {
      print('Error: ${response.statusCode}');
      return []; // ✅ Always return a list
    }
  } catch (e) {
    print('Error fetching attractions: $e');
    return []; // ✅ Return empty list on error
  }
}

Future<Map<String, dynamic>> fetchPlaceDetails(String xid) async {
  final url = Uri.parse(
    'https://api.opentripmap.com/0.1/en/places/xid/$xid?apikey=$apiKey',
  );

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      print('❌ Failed to load details for xid=$xid: ${response.statusCode}');
      return {}; // ✅ return empty map instead of throwing — prevents app crash
    }
  } catch (e) {
    print('⚠️ Error fetching place details: $e');
    return {}; // ✅ safer than throwing — app keeps running
  }
}
