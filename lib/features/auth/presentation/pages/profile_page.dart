import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/models/booking.dart';
import '../../../booking/presentation/pages/flight_search_page.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback? onBookFlight;

  const ProfilePage({super.key, this.onBookFlight});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String _userName = 'John Doe';
  final String _userEmail = 'john.doe@example.com';

  List<Booking> _bookings = [];
  bool _isLoading = true;
  String? _errorMessage;
  StreamSubscription<QuerySnapshot>? _bookingsSubscription;
  bool _showAllBookings = false;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  @override
  void dispose() {
    _bookingsSubscription?.cancel();
    super.dispose();
  }

  void _loadBookings() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'User not logged in';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _showAllBookings = false;
    });

    _bookingsSubscription = FirebaseFirestore.instance
        .collection('bookings')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .listen(
          (snapshot) {
            try {
              final bookings =
                  snapshot.docs.map((doc) {
                    final data = doc.data();

                    // Handle bookingDate - check date (string), bookingDate, or timestamp
                    DateTime bookingDate;
                    if (data['date'] is String) {
                      // Parse date string like "2025-11-09 16:50:00.000"
                      try {
                        bookingDate = DateTime.parse(data['date'] as String);
                      } catch (e) {
                        // If parsing fails, try timestamp
                        if (data['timestamp'] is Timestamp) {
                          bookingDate =
                              (data['timestamp'] as Timestamp).toDate();
                        } else {
                          bookingDate = DateTime.now();
                        }
                      }
                    } else if (data['bookingDate'] is Timestamp) {
                      bookingDate = (data['bookingDate'] as Timestamp).toDate();
                    } else if (data['bookingDate'] is String) {
                      bookingDate = DateTime.parse(
                        data['bookingDate'] as String,
                      );
                    } else if (data['timestamp'] is Timestamp) {
                      // Fallback to timestamp if bookingDate doesn't exist
                      bookingDate = (data['timestamp'] as Timestamp).toDate();
                    } else {
                      bookingDate = DateTime.now();
                    }

                    // Handle status - could be stored as string or enum name
                    BookingStatus status;
                    if (data['status'] is String) {
                      final statusString = data['status'] as String;
                      status = BookingStatus.values.firstWhere(
                        (e) =>
                            e.toString().split('.').last.toLowerCase() ==
                            statusString.toLowerCase(),
                        orElse: () => BookingStatus.pending,
                      );
                    } else {
                      status = BookingStatus.pending;
                    }

                    return Booking(
                      id: doc.id,
                      userId: data['userId'] ?? user.uid,
                      flightId: data['flightId'] ?? data['flightNumber'] ?? '',
                      passengerName:
                          data['passengerName'] ?? user.displayName ?? 'N/A',
                      passengerEmail:
                          data['passengerEmail'] ?? user.email ?? '',
                      passengerPhone: data['passengerPhone'] ?? '',
                      numberOfPassengers: data['numberOfPassengers'] ?? 1,
                      seatNumbers: List<String>.from(data['seatNumbers'] ?? []),
                      totalPrice:
                          (data['totalPrice'] ?? data['price'] ?? 0).toDouble(),
                      currency: data['currency'] ?? 'USD',
                      bookingDate: bookingDate,
                      status: status,
                      paymentId: data['paymentId'],
                      confirmationNumber:
                          data['loc'] ??
                          'BK${doc.id.substring(0, 8).toUpperCase()}',
                    );
                  }).toList();

              // Sort by bookingDate in memory (most recent first) and limit to 10
              bookings.sort((a, b) => b.bookingDate.compareTo(a.bookingDate));
              final recentBookings = bookings.take(10).toList();

              setState(() {
                _bookings = recentBookings;
                _isLoading = false;
                _errorMessage = null;
              });
            } catch (e) {
              setState(() {
                _isLoading = false;
                _errorMessage = 'Error loading bookings: $e';
              });
            }
          },
          onError: (error) {
            setState(() {
              _isLoading = false;
              _errorMessage = 'Error fetching bookings: $error';
            });
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 20),
            _buildBookingHistory(),
            const SizedBox(height: 20),
            _buildQuickActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    User? user = FirebaseAuth.instance.currentUser;
    final String? name = user?.displayName;
    final String? email = user?.email;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.teal.withOpacity(0.1),
            child: const Icon(Icons.person, size: 50, color: Colors.teal),
          ),
          const SizedBox(height: 16),
          Text(
            name ?? _userName,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            email ?? _userEmail,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  'Book Flight',
                  Icons.flight_takeoff,
                  Colors.blue,
                  () {
                    // Navigate to flight search using callback if provided, otherwise use Navigator
                    if (widget.onBookFlight != null) {
                      widget.onBookFlight!();
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FlightSearchPage(),
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionCard(
                  'Logout',
                  Icons.logout,
                  Colors.green,
                  () {
                    // Navigate to bookings
                    FirebaseAuth.instance.signOut();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingHistory() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Bookings',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_bookings.length > 3)
                TextButton(
                  onPressed: () {
                    setState(() => _showAllBookings = !_showAllBookings);
                  },
                  child: Text(
                    _showAllBookings ? 'Show Less' : 'View All',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.teal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(color: Colors.teal),
              ),
            )
          else if (_errorMessage != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red[300], size: 48),
                    const SizedBox(height: 8),
                    Text(
                      _errorMessage!,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _loadBookings,
                      child: const Text(
                        'Retry',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (_bookings.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(Icons.flight_takeoff, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      'No bookings yet',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...(_showAllBookings ? _bookings : _bookings.take(3))
                .map((booking) => _buildBookingCard(booking))
                .toList(),
        ],
      ),
    );
  }

  Widget _buildBookingCard(Booking booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                booking.confirmationNumber ?? 'N/A',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(booking.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  booking.status.toString().split('.').last.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(booking.status),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${booking.numberOfPassengers} ${booking.numberOfPassengers == 1 ? 'Passenger' : 'Passengers'}',
            style: TextStyle(fontFamily: 'Poppins', color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Text(
            'Seats: ${booking.seatNumbers.join(', ')}',
            style: TextStyle(fontFamily: 'Poppins', color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Booked on ${DateFormat('MMM dd, yyyy').format(booking.bookingDate)}',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              Text(
                '\$${booking.totalPrice.toInt()}',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.confirmed:
        return Colors.green;
      case BookingStatus.cancelled:
        return Colors.red;
      case BookingStatus.completed:
        return Colors.blue;
    }
  }
}
