class Flight {
  final String id;
  final String airline;
  final String flightNumber;
  final String departureCity;
  final String departureAirport;
  final String arrivalCity;
  final String arrivalAirport;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final double price;
  final String currency;
  final int availableSeats;
  final String aircraft;
  final double rating;
  final List<String> amenities;
  final bool isHotDeal;
  final String imageUrl;

  Flight({
    required this.id,
    required this.airline,
    required this.flightNumber,
    required this.departureCity,
    required this.departureAirport,
    required this.arrivalCity,
    required this.arrivalAirport,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
    this.currency = 'USD',
    required this.availableSeats,
    required this.aircraft,
    required this.rating,
    this.amenities = const [],
    this.isHotDeal = false,
    required this.imageUrl,
  });

  // Calculate flight duration
  Duration get duration => arrivalTime.difference(departureTime);

  // Format duration as string
  String get durationString {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  // Check if flight is today
  bool get isToday {
    final now = DateTime.now();
    return departureTime.year == now.year &&
        departureTime.month == now.month &&
        departureTime.day == now.day;
  }

  // Check if flight is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return departureTime.year == tomorrow.year &&
        departureTime.month == tomorrow.month &&
        departureTime.day == tomorrow.day;
  }

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
      id: json['id'] ?? '',
      airline: json['airline'] ?? '',
      flightNumber: json['flightNumber'] ?? '',
      departureCity: json['departureCity'] ?? '',
      departureAirport: json['departureAirport'] ?? '',
      arrivalCity: json['arrivalCity'] ?? '',
      arrivalAirport: json['arrivalAirport'] ?? '',
      departureTime: DateTime.parse(json['departureTime']),
      arrivalTime: DateTime.parse(json['arrivalTime']),
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'USD',
      availableSeats: json['availableSeats'] ?? 0,
      aircraft: json['aircraft'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      amenities: List<String>.from(json['amenities'] ?? []),
      isHotDeal: json['isHotDeal'] ?? false,
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'airline': airline,
      'flightNumber': flightNumber,
      'departureCity': departureCity,
      'departureAirport': departureAirport,
      'arrivalCity': arrivalCity,
      'arrivalAirport': arrivalAirport,
      'departureTime': departureTime.toIso8601String(),
      'arrivalTime': arrivalTime.toIso8601String(),
      'price': price,
      'currency': currency,
      'availableSeats': availableSeats,
      'aircraft': aircraft,
      'rating': rating,
      'amenities': amenities,
      'isHotDeal': isHotDeal,
      'imageUrl': imageUrl,
    };
  }
}
