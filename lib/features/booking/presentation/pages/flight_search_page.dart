import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'flight_results_page.dart';
import 'package:bookingapp/core/services/ninjas_api_service.dart';

class FlightSearchPage extends StatefulWidget {
  final String? selectedCity;
  final String? selectedCountry;

  const FlightSearchPage({
    super.key,
    this.selectedCity,
    this.selectedCountry,
  });

  @override
  State<FlightSearchPage> createState() => _FlightSearchPageState();
}

class _FlightSearchPageState extends State<FlightSearchPage> {
  final TextEditingController _toController = TextEditingController();
  DateTime _departureDate = DateTime.now().add(const Duration(days: 1));
  DateTime? _returnDate;
  double _passengers = 1;
  String _classType = 'Economy';
  bool _isRoundTrip = false;

  // List of destinations for "from" dropdown
  final List<String> _fromDestinations = [
    'Cairo',
    'Dubai',
    'Paris',
    'New York',
    'London',
    'Istanbul',
    'Rome',
    'Bali',
    'Tokyo',
    'Sydney',
    'Los Angeles',
    'Singapore',
    'Bangkok',
    'Amsterdam',
    'Berlin',
  ];

  String? _selectedFrom;

  @override
  void initState() {
    super.initState();
    // Pre-populate "to" field with selected country from destinations page
    if (widget.selectedCountry != null) {
      _toController.text = widget.selectedCountry!;
    }
    // Set default "from" to first destination if list is not empty
    if (_fromDestinations.isNotEmpty) {
      _selectedFrom = _fromDestinations[0]; // Default to first destination
    }
  }

  final List<String> _popularCities = [
    'New York',
    'London',
    'Paris',
    'Dubai',
    'Tokyo',
    'Sydney',
    'Los Angeles',
    'Istanbul',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Search Flights',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trip Type Toggle
            _buildTripTypeToggle(),
            const SizedBox(height: 20),

            // Search Form
            _buildSearchForm(),
            const SizedBox(height: 20),

            // Popular Destinations
            _buildPopularDestinations(),
            const SizedBox(height: 30),

            // Search Button
            _buildSearchButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTripTypeToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isRoundTrip = false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !_isRoundTrip ? Colors.teal : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'One Way',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: !_isRoundTrip ? Colors.white : Colors.grey[600],
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isRoundTrip = true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _isRoundTrip ? Colors.teal : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Round Trip',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _isRoundTrip ? Colors.white : Colors.grey[600],
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchForm() {
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
          // From and To Fields
          Row(
            children: [
              Expanded(
                child: _buildFromField(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildToField(),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Date Fields
          Row(
            children: [
              Expanded(
                child: _buildDateField(
                  label: 'Departure',
                  date: _departureDate,
                  onTap: () => _selectDate(context, true),
                ),
              ),
              if (_isRoundTrip) ...[
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDateField(
                    label: 'Return',
                    date: _returnDate,
                    onTap: () => _selectDate(context, false),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 20),

          // Passengers and Class
          Row(
            children: [
              Expanded(child: _buildPassengerField()),
              const SizedBox(width: 16),
              Expanded(child: _buildClassField()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFromField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'From',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedFrom,
            decoration: InputDecoration(
              hintText: 'Select departure city',
              prefixIcon: const Icon(Icons.flight_takeoff, color: Colors.teal),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.teal),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            ),
            items: _fromDestinations.map((destination) {
              return DropdownMenuItem<String>(
                value: destination,
                child: Text(
                  destination,
                  style: const TextStyle(fontFamily: 'Poppins'),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedFrom = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildToField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'To',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _toController,
          readOnly: false, // Make it read-only since it's pre-populated from destination selection
          decoration: InputDecoration(
            hintText: 'Destination country',
            prefixIcon: const Icon(Icons.flight_land, color: Colors.teal),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.teal),
            ),
            filled: false,
            fillColor: Colors.grey[100], // Indicate it's read-only
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.teal, size: 20),
                const SizedBox(width: 8),
                Text(
                  date != null
                      ? DateFormat('MMM dd, yyyy').format(date)
                      : 'Select date',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: date != null ? Colors.black : Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPassengerField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Passengers',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _showPassengerSelector,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.person, color: Colors.teal, size: 20),
                const SizedBox(width: 8),
                Text(
                  '$_passengers ${_passengers == 1 ? 'Passenger' : 'Passengers'}',
                  style: const TextStyle(fontFamily: 'Poppins'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClassField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Class',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _showClassSelector,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.flight_class, color: Colors.teal, size: 20),
                const SizedBox(width: 8),
                Text(_classType, style: const TextStyle(fontFamily: 'Poppins')),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPopularDestinations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Popular Destinations',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _popularCities.length,
            itemBuilder: (context, index) {
              final city = _popularCities[index];
              return GestureDetector(
                onTap: () => _toController.text = city,
                child: Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.location_city,
                        color: Colors.teal,
                        size: 24,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        city,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _searchFlights,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        ),
        child: const Text(
          'Search Flights',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }


  Future<void> _selectDate(BuildContext context, bool isDeparture) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          isDeparture
              ? _departureDate
              : (_returnDate ?? DateTime.now().add(const Duration(days: 2))),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isDeparture) {
          _departureDate = picked;
          if (_returnDate != null && _returnDate!.isBefore(_departureDate)) {
            _returnDate = _departureDate.add(const Duration(days: 1));
          }
        } else {
          _returnDate = picked;
        }
      });
    }
  }

  void _showPassengerSelector() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Number of Passengers',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Passengers',
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed:
                              _passengers > 1
                                  ? () => setState(() => _passengers--)
                                  : null,
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                        Text(
                          '$_passengers',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed:
                              _passengers < 9
                                  ? () => setState(() => _passengers++)
                                  : null,
                          icon: const Icon(Icons.add_circle_outline),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void _showClassSelector() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Class',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ...['Economy', 'Business', 'First Class'].map((classType) {
                  return ListTile(
                    title: Text(
                      classType,
                      style: const TextStyle(fontFamily: 'Poppins'),
                    ),
                    trailing:
                        _classType == classType
                            ? const Icon(Icons.check, color: Colors.teal)
                            : null,
                    onTap: () {
                      setState(() => _classType = classType);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ],
            ),
          ),
    );
  }

  void _searchFlights() async {
    if (_selectedFrom == null || _selectedFrom!.isEmpty || _toController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select departure city and destination'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Search flights using Ninjas API
      final flights = await NinjasApiService.searchFlights(
        from: _selectedFrom!,
        to: _toController.text,
        departureDate: _departureDate,
      );

      // Close loading dialog
      if (mounted) Navigator.pop(context);

      // Navigate to results page
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FlightResultsPage(
              departureCity: _selectedFrom!,
              arrivalCity: _toController.text,
              departureDate: _departureDate,
              returnDate: _returnDate ?? _departureDate.add(const Duration(days: 1)),
              passengers: _passengers,
              classType: _classType,
              apiFlights: flights, // Pass API results
            ),
          ),
        );
      }
    } catch (e) {
      // Close loading dialog
      if (mounted) Navigator.pop(context);
      
      // Show error and navigate with empty results (will show mock data as fallback)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error searching flights: $e. Showing available options.'),
            backgroundColor: Colors.orange,
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FlightResultsPage(
              departureCity: _selectedFrom!,
              arrivalCity: _toController.text,
              departureDate: _departureDate,
              returnDate: _returnDate ?? _departureDate.add(const Duration(days: 1)),
              passengers: _passengers,
              classType: _classType,
            ),
          ),
        );
      }
    }
  }
}
