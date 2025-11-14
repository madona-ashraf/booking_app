import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/airport_codes.dart';
import '../../../../core/models/flight.dart';
import '../../bookingengine/fligthrepo/amadeus_service.dart';
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
  String? _errorMessage;
  String _sortBy = 'price';
  final double _maxPrice = 1000.0;
  final bool _showFilters = false;
  final AmadeusService _amadeusService = AmadeusService();

  @override
  void initState() {
    super.initState();
    _loadFlights();
  }

  Future<void> _loadFlights() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Convert city names to airport codes
      final originCode = AirportCodes.getAirportCodeOrInput(
        widget.departureCity,
      );
      final destinationCode = AirportCodes.getAirportCodeOrInput(
        widget.arrivalCity,
      );

      // Convert class type to Amadeus format
      String travelClass = 'ECONOMY';
      if (widget.classType.toLowerCase().contains('business')) {
        travelClass = 'BUSINESS';
      } else if (widget.classType.toLowerCase().contains('first')) {
        travelClass = 'FIRST';
      }

      // Search flights using Amadeus API
      final flights = await _amadeusService.searchFlights(
        originLocationCode: originCode,
        destinationLocationCode: destinationCode,
        departureDate: widget.departureDate,
        returnDate: widget.returnDate,
        adults: widget.passengers.toInt(),
        travelClass: travelClass,
        max: 25,
      );

      setState(() {
        _flights = flights;
        _filteredFlights = List.from(_flights);
        _isLoading = false;
        _sortFlights();

        if (_flights.isEmpty) {
          _errorMessage = 'No flights found for your search criteria.';
        }
      });
    } catch (e) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.teal,
            duration: Duration(seconds: 2),
          ),
        );
      });
    }
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
          _filteredFlights.sort(
            (a, b) => a.departureTime.compareTo(b.departureTime),
          );
          break;
        case 'rating':
          _filteredFlights.sort((a, b) => b.rating.compareTo(a.rating));
          break;
      }
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
                    DropdownMenuItem(
                      value: 'duration',
                      child: Text('Duration'),
                    ),
                    DropdownMenuItem(
                      value: 'departure',
                      child: Text('Departure'),
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
                  // Price Range Filter
                  Text(
                    'Max Price: \$${_maxPrice.toInt()}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

          // Flights List
          Expanded(
            child:
                _isLoading
                    ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                      ),
                    )
                    : _errorMessage != null && _filteredFlights.isEmpty
                    ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _errorMessage!,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: _loadFlights,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
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

          // Error message banner (if API failed but mock data is shown)
          if (_errorMessage != null && _filteredFlights.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.orange[100],
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange[800]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Showing sample data. ${_errorMessage}',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Colors.orange[900],
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _loadFlights,
                    child: Text(
                      'Retry',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.orange[900],
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
                  child: const Icon(Icons.flight, color: Colors.teal, size: 20),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
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
                    children:
                        flight.amenities.take(3).map((amenity) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
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

                // Book Button
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
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
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
