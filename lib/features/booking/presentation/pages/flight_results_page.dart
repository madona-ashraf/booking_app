import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/models/flight.dart';
import 'flight_booking_page.dart';

class FlightResultsPage extends StatefulWidget {
  final String departureCity;
  final String arrivalCity;
  final DateTime departureDate;
  final DateTime returnDate;
  final double passengers;
  final String classType;

  const FlightResultsPage({
    super.key,
    required this.departureCity,
    required this.arrivalCity,
    required this.departureDate,
    required this.returnDate,
    required this.passengers,
    required this.classType,
  });

  @override
  State<FlightResultsPage> createState() => _FlightResultsPageState();
}

class _FlightResultsPageState extends State<FlightResultsPage> {
  List<Flight> _flights = [];
  List<Flight> _filteredFlights = [];
  bool _isLoading = true;
  String _sortBy = 'price'; // price, duration, departure
  String _filterBy = 'all'; // all, direct, stops
  double _maxPrice = 1000.0;
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _loadFlights();
  }

  void _loadFlights() {
    // Simulate API call delay
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _flights = _generateMockFlights();
        _filteredFlights = List.from(_flights);
        _isLoading = false;
        _sortFlights();
      });
    });
  }

  List<Flight> _generateMockFlights() {
    final baseDate = widget.departureDate;
    return [
      Flight(
        id: '1',
        airline: 'Emirates',
        flightNumber: 'EK123',
        departureCity: widget.departureCity,
        departureAirport: 'CAI',
        arrivalCity: widget.arrivalCity,
        arrivalAirport: 'DXB',
        departureTime: baseDate.add(const Duration(hours: 8)),
        arrivalTime: baseDate.add(const Duration(hours: 12, minutes: 30)),
        price: 450.0,
        availableSeats: 15,
        aircraft: 'Boeing 777',
        rating: 4.8,
        amenities: ['WiFi', 'Meal', 'Entertainment', 'Lounge Access'],
        isHotDeal: true,
        imageUrl: 'assets/images/dubai.jpg',
      ),
      Flight(
        id: '2',
        airline: 'Turkish Airlines',
        flightNumber: 'TK456',
        departureCity: widget.departureCity,
        departureAirport: 'CAI',
        arrivalCity: widget.arrivalCity,
        arrivalAirport: 'IST',
        departureTime: baseDate.add(const Duration(hours: 10)),
        arrivalTime: baseDate.add(const Duration(hours: 16, minutes: 45)),
        price: 380.0,
        availableSeats: 8,
        aircraft: 'Airbus A330',
        rating: 4.6,
        amenities: ['WiFi', 'Meal', 'Entertainment'],
        isHotDeal: false,
        imageUrl: 'assets/images/istanbul.jpg',
      ),
      Flight(
        id: '3',
        airline: 'Qatar Airways',
        flightNumber: 'QR789',
        departureCity: widget.departureCity,
        departureAirport: 'CAI',
        arrivalCity: widget.arrivalCity,
        arrivalAirport: 'DOH',
        departureTime: baseDate.add(const Duration(hours: 14)),
        arrivalTime: baseDate.add(const Duration(hours: 20, minutes: 15)),
        price: 520.0,
        availableSeats: 12,
        aircraft: 'Boeing 787',
        rating: 4.9,
        amenities: ['WiFi', 'Meal', 'Entertainment', 'Lounge Access', 'Priority Boarding'],
        isHotDeal: true,
        imageUrl: 'assets/images/dubai.jpg',
      ),
      Flight(
        id: '4',
        airline: 'EgyptAir',
        flightNumber: 'MS321',
        departureCity: widget.departureCity,
        departureAirport: 'CAI',
        arrivalCity: widget.arrivalCity,
        arrivalAirport: 'DXB',
        departureTime: baseDate.add(const Duration(hours: 6)),
        arrivalTime: baseDate.add(const Duration(hours: 10, minutes: 30)),
        price: 320.0,
        availableSeats: 25,
        aircraft: 'Airbus A320',
        rating: 4.3,
        amenities: ['Meal', 'Entertainment'],
        isHotDeal: false,
        imageUrl: 'assets/images/dubai.jpg',
      ),
      Flight(
        id: '5',
        airline: 'Etihad Airways',
        flightNumber: 'EY654',
        departureCity: widget.departureCity,
        departureAirport: 'CAI',
        arrivalCity: widget.arrivalCity,
        arrivalAirport: 'AUH',
        departureTime: baseDate.add(const Duration(hours: 18)),
        arrivalTime: baseDate.add(const Duration(hours: 23, minutes: 45)),
        price: 480.0,
        availableSeats: 6,
        aircraft: 'Boeing 777',
        rating: 4.7,
        amenities: ['WiFi', 'Meal', 'Entertainment', 'Lounge Access'],
        isHotDeal: false,
        imageUrl: 'assets/images/dubai.jpg',
      ),
    ];
  }

  void _sortFlights() {
    setState(() {
      switch (_sortBy) {
        case 'price':
          _filteredFlights.sort((a, b) => a.price.compareTo(b.price));
          break;
        case 'duration':
          _filteredFlights.sort((a, b) => a.duration.compareTo(b.duration));
          break;
        case 'departure':
          _filteredFlights.sort((a, b) => a.departureTime.compareTo(b.departureTime));
          break;
        case 'rating':
          _filteredFlights.sort((a, b) => b.rating.compareTo(a.rating));
          break;
      }
    });
  }

  void _filterFlights() {
    setState(() {
      _filteredFlights = _flights.where((flight) {
        bool priceFilter = flight.price <= _maxPrice;
        bool typeFilter = true;
        
        if (_filterBy == 'direct') {
          // Assuming direct flights have shorter duration (less than 6 hours)
          typeFilter = flight.duration.inHours < 6;
        } else if (_filterBy == 'stops') {
          // Assuming flights with stops have longer duration (more than 6 hours)
          typeFilter = flight.duration.inHours >= 6;
        }
        
        return priceFilter && typeFilter;
      }).toList();
      _sortFlights();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.departureCity} → ${widget.arrivalCity}',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              DateFormat('MMM dd, yyyy').format(widget.departureDate),
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Summary
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_filteredFlights.length} flights found',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${widget.passengers.toInt()} passenger${widget.passengers > 1 ? 's' : ''} • ${widget.classType}',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                // Sort Dropdown
                DropdownButton<String>(
                  value: _sortBy,
                  underline: Container(),
                  items: const [
                    DropdownMenuItem(value: 'price', child: Text('Price')),
                    DropdownMenuItem(value: 'duration', child: Text('Duration')),
                    DropdownMenuItem(value: 'departure', child: Text('Departure')),
                    DropdownMenuItem(value: 'rating', child: Text('Rating')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _sortBy = value!;
                      _sortFlights();
                    });
                  },
                ),
              ],
            ),
          ),
          
          // Filters Panel
          if (_showFilters)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filters',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Flight Type Filter
                  const Text(
                    'Flight Type',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildFilterChip('all', 'All Flights'),
                      const SizedBox(width: 8),
                      _buildFilterChip('direct', 'Direct'),
                      const SizedBox(width: 8),
                      _buildFilterChip('stops', 'With Stops'),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Price Range Filter
                  Text(
                    'Max Price: \$${_maxPrice.toInt()}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Slider(
                    value: _maxPrice,
                    min: 100,
                    max: 1000,
                    divisions: 18,
                    onChanged: (value) {
                      setState(() {
                        _maxPrice = value;
                        _filterFlights();
                      });
                    },
                    activeColor: Colors.teal,
                  ),
                ],
              ),
            ),
          
          // Flights List
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                    ),
                  )
                : _filteredFlights.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.flight_takeoff,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No flights found',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try adjusting your filters',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _filteredFlights.length,
                        itemBuilder: (context, index) {
                          final flight = _filteredFlights[index];
                          return _buildFlightCard(flight);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _filterBy == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _filterBy = value;
          _filterFlights();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.teal : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            color: isSelected ? Colors.white : Colors.black87,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildFlightCard(Flight flight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Flight Header
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Airline Logo Placeholder
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.flight,
                    color: Colors.teal,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                
                // Airline Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        flight.airline,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        flight.flightNumber,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Rating
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        flight.rating.toString(),
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Flight Details
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Departure
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('HH:mm').format(flight.departureTime),
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
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
                      Text(
                        flight.departureCity,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.grey[600],
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Flight Path
                Expanded(
                  child: Column(
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
                      Row(
                        children: [
                          Container(
                            width: 20,
                            height: 1,
                            color: Colors.grey[400],
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            child: const Icon(
                              Icons.flight_takeoff,
                              color: Colors.teal,
                              size: 16,
                            ),
                          ),
                          Container(
                            width: 20,
                            height: 1,
                            color: Colors.grey[400],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Direct',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.grey[600],
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Arrival
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        DateFormat('HH:mm').format(flight.arrivalTime),
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
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
                      Text(
                        flight.arrivalCity,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.grey[600],
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Amenities
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: flight.amenities.take(3).map((amenity) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.teal.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          amenity,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10,
                            color: Colors.teal,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                if (flight.amenities.length > 3)
                  Text(
                    '+${flight.amenities.length - 3} more',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Price and Book Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                // Price
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\$${flight.price.toInt()}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
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
                ),
                
                // Hot Deal Badge
                if (flight.isHotDeal)
                  Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'HOT DEAL',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                
                // Book Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FlightBookingPage(
                          flight: flight,
                          passengers: widget.passengers,
                          classType: widget.classType,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text(
                    'Select',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}