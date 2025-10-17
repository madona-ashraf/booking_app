class Booking {
  final String id;
  final String userId;
  final String flightId;
  final String passengerName;
  final String passengerEmail;
  final String passengerPhone;
  final int numberOfPassengers;
  final List<String> seatNumbers;
  final double totalPrice;
  final String currency;
  final DateTime bookingDate;
  final BookingStatus status;
  final String? paymentId;
  final String? confirmationNumber;

  Booking({
    required this.id,
    required this.userId,
    required this.flightId,
    required this.passengerName,
    required this.passengerEmail,
    required this.passengerPhone,
    required this.numberOfPassengers,
    required this.seatNumbers,
    required this.totalPrice,
    this.currency = 'USD',
    required this.bookingDate,
    required this.status,
    this.paymentId,
    this.confirmationNumber,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      flightId: json['flightId'] ?? '',
      passengerName: json['passengerName'] ?? '',
      passengerEmail: json['passengerEmail'] ?? '',
      passengerPhone: json['passengerPhone'] ?? '',
      numberOfPassengers: json['numberOfPassengers'] ?? 1,
      seatNumbers: List<String>.from(json['seatNumbers'] ?? []),
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'USD',
      bookingDate: DateTime.parse(json['bookingDate']),
      status: BookingStatus.values.firstWhere(
        (e) => e.toString() == 'BookingStatus.${json['status']}',
        orElse: () => BookingStatus.pending,
      ),
      paymentId: json['paymentId'],
      confirmationNumber: json['confirmationNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'flightId': flightId,
      'passengerName': passengerName,
      'passengerEmail': passengerEmail,
      'passengerPhone': passengerPhone,
      'numberOfPassengers': numberOfPassengers,
      'seatNumbers': seatNumbers,
      'totalPrice': totalPrice,
      'currency': currency,
      'bookingDate': bookingDate.toIso8601String(),
      'status': status.toString().split('.').last,
      'paymentId': paymentId,
      'confirmationNumber': confirmationNumber,
    };
  }

  Booking copyWith({
    String? id,
    String? userId,
    String? flightId,
    String? passengerName,
    String? passengerEmail,
    String? passengerPhone,
    int? numberOfPassengers,
    List<String>? seatNumbers,
    double? totalPrice,
    String? currency,
    DateTime? bookingDate,
    BookingStatus? status,
    String? paymentId,
    String? confirmationNumber,
  }) {
    return Booking(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      flightId: flightId ?? this.flightId,
      passengerName: passengerName ?? this.passengerName,
      passengerEmail: passengerEmail ?? this.passengerEmail,
      passengerPhone: passengerPhone ?? this.passengerPhone,
      numberOfPassengers: numberOfPassengers ?? this.numberOfPassengers,
      seatNumbers: seatNumbers ?? this.seatNumbers,
      totalPrice: totalPrice ?? this.totalPrice,
      currency: currency ?? this.currency,
      bookingDate: bookingDate ?? this.bookingDate,
      status: status ?? this.status,
      paymentId: paymentId ?? this.paymentId,
      confirmationNumber: confirmationNumber ?? this.confirmationNumber,
    );
  }
}

enum BookingStatus {
  pending,
  confirmed,
  cancelled,
  completed,
}
