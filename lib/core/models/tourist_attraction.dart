class TouristAttraction {
  final String id;
  final String name;
  final String category;
  final double latitude;
  final double longitude;
  final String? description;
  final String? imageUrl;

  TouristAttraction({
    required this.id,
    required this.name,
    required this.category,
    required this.latitude,
    required this.longitude,
    this.description,
    this.imageUrl,
  });

  factory TouristAttraction.fromJson(Map<String, dynamic> json) {
    // Extract coordinates
    double lat = 0.0;
    double lon = 0.0;

    if (json['geoCode'] != null) {
      final geoCode = json['geoCode'];
      if (geoCode is Map<String, dynamic>) {
        lat = _parseDouble(geoCode['latitude']) ?? 0.0;
        lon = _parseDouble(geoCode['longitude']) ?? 0.0;
      }
    }

    // Extract category
    String category = 'Attraction';
    if (json['category'] != null) {
      category = json['category'].toString();
    } else if (json['tags'] != null && json['tags'] is List) {
      final tags = json['tags'] as List;
      if (tags.isNotEmpty) {
        category = tags[0].toString();
      }
    } else if (json['type'] != null) {
      category = json['type'].toString();
    }

    // Generate ID if not present
    String id = json['id']?.toString() ?? 
                json['name']?.toString() ?? 
                '${lat}_${lon}_${DateTime.now().millisecondsSinceEpoch}';

    // Extract name
    String name = json['name']?.toString() ?? 
                  json['title']?.toString() ?? 
                  'Unknown Attraction';

    // Get image URL based on category
    final imageUrl = getImageUrlForCategory(category);

    return TouristAttraction(
      id: id,
      name: name,
      category: category,
      latitude: lat,
      longitude: lon,
      description: json['description']?.toString() ?? 
                   json['shortDescription']?.toString(),
      imageUrl: imageUrl,
    );
  }

  // Helper method to parse double from various types
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  // Get Unsplash image URL based on category
  static String getImageUrlForCategory(String category) {
    final categoryMap = {
      'MUSEUM': 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=800',
      'HISTORICAL': 'https://images.unsplash.com/photo-1524230507669-5fff97907b41?w=800',
      'MONUMENT': 'https://images.unsplash.com/photo-1539650116574-75c0c6d73a56?w=800',
      'PARK': 'https://images.unsplash.com/photo-1473773508845-188df298d2d1?w=800',
      'GARDEN': 'https://images.unsplash.com/photo-1464822759844-d150ad6bf09c?w=800',
      'CATHEDRAL': 'https://images.unsplash.com/photo-1519491050284-3c4125d0a0a6?w=800',
      'CHURCH': 'https://images.unsplash.com/photo-1519491050284-3c4125d0a0a6?w=800',
      'TEMPLE': 'https://images.unsplash.com/photo-1564501049412-61c2a3083791?w=800',
      'BRIDGE': 'https://images.unsplash.com/photo-1519802772250-a52a9af0eacb?w=800',
      'TOWER': 'https://images.unsplash.com/photo-1493612276216-ee3925520721?w=800',
      'PALACE': 'https://images.unsplash.com/photo-1514565131-fce0801e5785?w=800',
      'CASTLE': 'https://images.unsplash.com/photo-1544966503-7cc5ac882d5e?w=800',
      'SQUARE': 'https://images.unsplash.com/photo-1514565131-fce0801e5785?w=800',
      'BEACH': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800',
      'RESTAURANT': 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800',
      'SHOPPING': 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=800',
    };

    // Try to find matching category (case insensitive)
    final categoryLower = category.toUpperCase();
    for (var key in categoryMap.keys) {
      if (categoryLower.contains(key)) {
        return categoryMap[key]!;
      }
    }

    // Default image
    return 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}

