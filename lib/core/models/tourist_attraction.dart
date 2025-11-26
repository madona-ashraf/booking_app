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

  // Get image URL based on category using reliable image services
  static String getImageUrlForCategory(String category) {
    // Use Pixabay API or placeholder images
    // For now, using placeholder.com which is very reliable
    final categoryMap = {
      'MUSEUM': 'https://picsum.photos/800/600?random=1',
      'HISTORICAL': 'https://picsum.photos/800/600?random=2',
      'MONUMENT': 'https://picsum.photos/800/600?random=3',
      'PARK': 'https://picsum.photos/800/600?random=4',
      'GARDEN': 'https://picsum.photos/800/600?random=5',
      'CATHEDRAL': 'https://picsum.photos/800/600?random=6',
      'CHURCH': 'https://picsum.photos/800/600?random=7',
      'TEMPLE': 'https://picsum.photos/800/600?random=8',
      'BRIDGE': 'https://picsum.photos/800/600?random=9',
      'TOWER': 'https://picsum.photos/800/600?random=10',
      'PALACE': 'https://picsum.photos/800/600?random=11',
      'CASTLE': 'https://picsum.photos/800/600?random=12',
      'SQUARE': 'https://picsum.photos/800/600?random=13',
      'BEACH': 'https://picsum.photos/800/600?random=14',
      'RESTAURANT': 'https://picsum.photos/800/600?random=15',
      'SHOPPING': 'https://picsum.photos/800/600?random=16',
      'GENERAL': 'https://picsum.photos/800/600?random=17',
    };

    // Try to find matching category (case insensitive)
    final categoryUpper = category.toUpperCase();
    for (var key in categoryMap.keys) {
      if (categoryUpper.contains(key)) {
        return categoryMap[key]!;
      }
    }

    // Default image - use Lorem Picsum (very reliable)
    return 'https://picsum.photos/800/600?random=${DateTime.now().millisecondsSinceEpoch}';
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

