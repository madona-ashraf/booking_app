class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? profileImage;
  final DateTime createdAt;
  final List<String> preferences;
  final List<String> bookingHistory;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.profileImage,
    required this.createdAt,
    this.preferences = const [],
    this.bookingHistory = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      profileImage: json['profileImage'],
      createdAt: DateTime.parse(json['createdAt']),
      preferences: List<String>.from(json['preferences'] ?? []),
      bookingHistory: List<String>.from(json['bookingHistory'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'createdAt': createdAt.toIso8601String(),
      'preferences': preferences,
      'bookingHistory': bookingHistory,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    DateTime? createdAt,
    List<String>? preferences,
    List<String>? bookingHistory,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      preferences: preferences ?? this.preferences,
      bookingHistory: bookingHistory ?? this.bookingHistory,
    );
  }
}
