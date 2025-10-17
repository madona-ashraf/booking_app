import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/models/flight.dart';
import 'flight_booking_page.dart';

class FlightResultsPage extends StatefulWidget {
  final String from;
  final String to;
  final DateTime departureDate;
  final DateTime? returnDate;
  final double passengers;
  final String classType;
  final bool isRoundTrip;

  const FlightResultsPage({
    super.key,
    required this.from,
    required this.to,
    required this.departureDate,
    this.returnDate,
    required this.passengers,
    required this.classType,
    required this.isRoundTrip,
  });

  @override
  State<FlightResultsPage> createState() => _FlightResultsPageState();
}

class _FlightResultsPageState extends State<FlightResultsPage> {
  List<Flight> _flights = [];
  bool _isLoading = true;
  String _sortBy = 'price';
  double _maxPrice = 1000;
  List<String> _selectedAirlines = [];

  @override
  void initState() {
    super.initState();
    _loadFlights();
  }

  void _loadFlights() {
    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _flights = _generateMockFlights();
        _isLoading = false;
      });
    });
  }

  List<Flight> _generateMockFlights() {
    final airlines = [
      'Emirates',
      'Qatar Airways',
      'Turkish Airlines',
      'Lufthansa',
      'Air France',
    ];
    final aircrafts = [
      'Boeing 777',
      'Airbus A350',
      'Boeing 787',
      'Airbus A380',
    ];
    final amenities = ['WiFi', 'Entertainment', 'Meals', 'Extra Legroom'];

    return List.generate(10, (index) {
      final departureTime = widget.departureDate.add(
        Duration(hours: 6 + index * 2),
      );
      final arrivalTime = departureTime.add(Duration(hours: 3 + (index % 4)));

      return Flight(
        id: 'flight_$index',
        airline: airlines[index % airlines.length],
        flightNumber:
            '${airlines[index % airlines.length].substring(0, 2).toUpperCase()}${100 + index}',
        departureCity: widget.from,
        departureAirport:
            '${widget.from.substring(0, 3).toUpperCase()} Airport',
        arrivalCity: widget.to,
        arrivalAirport: '${widget.to.substring(0, 3).toUpperCase()} Airport',
        departureTime: departureTime,
        arrivalTime: arrivalTime,
        price:
            300 +
            (index * 50) +
            (widget.classType == 'Business' ? 200 : 0) +
            (widget.classType == 'First Class' ? 500 : 0),
        availableSeats: 50 - index,
        aircraft: aircrafts[index % aircrafts.length],
        rating: 4.0 + (index % 5) * 0.2,
        amenities: amenities.take(2 + (index % 3)).toList(),
        isHotDeal: index % 3 == 0,
        imageUrl:
            'assets/images/${widget.to.toLowerCase().replaceAll(' ', '_')}.jpg',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          '${widget.from} → ${widget.to}',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilters,
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                ),
              )
              : Column(
                children: [
                  _buildSearchSummary(),
                  _buildSortAndFilter(),
                  Expanded(
                    child:
                        _flights.isEmpty
                            ? _buildNoResults()
                            : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: _flights.length,
                              itemBuilder: (context, index) {
                                final flight = _flights[index];
                                return _buildFlightCard(flight);
                              },
                            ),
                  ),
                ],
              ),
    );
  }

  Widget _buildSearchSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.from} → ${widget.to}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  DateFormat('MMM dd, yyyy').format(widget.departureDate),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${widget.passengers} ${widget.passengers == 1 ? 'Passenger' : 'Passengers'}',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                widget.classType,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSortAndFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          const Text(
            'Sort by:',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButton<String>(
              value: _sortBy,
              isExpanded: true,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: 'price', child: Text('Price')),
                DropdownMenuItem(value: 'duration', child: Text('Duration')),
                DropdownMenuItem(
                  value: 'departure',
                  child: Text('Departure Time'),
                ),
                DropdownMenuItem(value: 'rating', child: Text('Rating')),
              ],
              onChanged: (value) {
                setState(() {
                  _sortBy = value!;
                  _sortFlights();
                });
              },
            ),
          ),
          Text(
            '${_flights.length} flights found',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlightCard(Flight flight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          if (flight.isHotDeal)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: const Text(
                '🔥 HOT DEAL',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Airline and Flight Number
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        flight.airline,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      flight.flightNumber,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.grey[600],
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          flight.rating.toString(),
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Flight Times
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('HH:mm').format(flight.departureTime),
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            flight.departureAirport,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          flight.durationString,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 60,
                          height: 1,
                          color: Colors.grey[300],
                        ),
                        const Icon(Icons.flight, color: Colors.teal, size: 16),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            DateFormat('HH:mm').format(flight.arrivalTime),
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            flight.arrivalAirport,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Amenities
                if (flight.amenities.isNotEmpty)
                  Row(
                    children: [
                      const Icon(
                        Icons.local_airport,
                        color: Colors.teal,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          flight.amenities.join(' • '),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),

                // Price and Book Button
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\$${flight.price.toInt()}',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        Text(
                          'per person',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => FlightBookingPage(
                                  flight: flight,
                                  passengers: widget.passengers,
                                  classType: widget.classType,
                                ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Select',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.flight_takeoff, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No flights found',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search criteria',
            style: TextStyle(fontFamily: 'Poppins', color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setModalState) => Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Filters',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Price Range',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Slider(
                        value: _maxPrice,
                        min: 100,
                        max: 2000,
                        divisions: 19,
                        label: '\$${_maxPrice.toInt()}',
                        onChanged: (value) {
                          setModalState(() {
                            _maxPrice = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _flights =
                                _flights
                                    .where(
                                      (flight) => flight.price <= _maxPrice,
                                    )
                                    .toList();
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child: const Text(
                          'Apply Filters',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          ),
    );
  }

  void _sortFlights() {
    setState(() {
      switch (_sortBy) {
        case 'price':
          _flights.sort((a, b) => a.price.compareTo(b.price));
          break;
        case 'duration':
          _flights.sort((a, b) => a.duration.compareTo(b.duration));
          break;
        case 'departure':
          _flights.sort((a, b) => a.departureTime.compareTo(b.departureTime));
          break;
        case 'rating':
          _flights.sort((a, b) => b.rating.compareTo(a.rating));
          break;
      }
    });
  }
}
