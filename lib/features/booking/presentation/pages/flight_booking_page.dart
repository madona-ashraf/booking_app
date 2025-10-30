import 'package:flutter/material.dart';
import 'package:bookingapp/core/widgets/app_drawer.dart';
import 'package:intl/intl.dart';

import '../../../../core/models/flight.dart';
import 'booking_confirmation_page.dart';

class FlightBookingPage extends StatefulWidget {
  final Flight flight;
  final double passengers;
  final String classType;

  const FlightBookingPage({
    super.key,
    required this.flight,
    required this.passengers,
    required this.classType,
  });

  @override
  State<FlightBookingPage> createState() => _FlightBookingPageState();
}

class _FlightBookingPageState extends State<FlightBookingPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passportController = TextEditingController();

  List<String> _selectedSeats = [];
  String _selectedMeal = 'Standard';
  bool _hasInsurance = false;
  bool _hasExtraBaggage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Book Flight',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFlightSummary(),
            const SizedBox(height: 20),
            _buildPassengerDetails(),
            const SizedBox(height: 20),
            _buildSeatSelection(),
            const SizedBox(height: 20),
            _buildAddOns(),
            const SizedBox(height: 20),
            _buildPriceBreakdown(),
            const SizedBox(height: 30),
            _buildBookButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildFlightSummary() {
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.flight.airline,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                widget.flight.flightNumber,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('HH:mm').format(widget.flight.departureTime),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.flight.departureAirport,
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
                    widget.flight.durationString,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(width: 60, height: 1, color: Colors.grey[300]),
                  const Icon(Icons.flight, color: Colors.teal, size: 16),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      DateFormat('HH:mm').format(widget.flight.arrivalTime),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.flight.arrivalAirport,
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
          const SizedBox(height: 12),
          Text(
            '${widget.passengers} ${widget.passengers == 1 ? 'Passenger' : 'Passengers'} • ${widget.classType}',
            style: TextStyle(fontFamily: 'Poppins', color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerDetails() {
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Passenger Details',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your full name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passportController,
              decoration: InputDecoration(
                labelText: 'Passport Number',
                prefixIcon: const Icon(Icons.credit_card),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your passport number';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeatSelection() {
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
          const Text(
            'Seat Selection',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Select ${widget.passengers} ${widget.passengers == 1 ? 'seat' : 'seats'}',
            style: TextStyle(fontFamily: 'Poppins', color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          _buildSeatMap(),
        ],
      ),
    );
  }

  Widget _buildSeatMap() {
    final rows = ['A', 'B', 'C', 'D', 'E', 'F'];
    final seats = List.generate(6, (index) => index + 1);

    return Column(
      children: [
        // Seat legend
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSeatLegend('Available', Colors.grey[300]!),
            _buildSeatLegend('Selected', Colors.teal),
            _buildSeatLegend('Occupied', Colors.red[300]!),
          ],
        ),
        const SizedBox(height: 16),
        // Seat map
        ...rows
            .map(
              (row) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      row,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ...seats.map((seat) => _buildSeat('$row$seat')),
                    const SizedBox(width: 20),
                    ...seats.map((seat) => _buildSeat('$row${seat + 6}')),
                  ],
                ),
              ),
            )
            .toList(),
      ],
    );
  }

  Widget _buildSeatLegend(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildSeat(String seatNumber) {
    final isSelected = _selectedSeats.contains(seatNumber);
    final isOccupied =
        seatNumber.contains('A') ||
        seatNumber.contains('F'); // Mock occupied seats

    return GestureDetector(
      onTap:
          isOccupied
              ? null
              : () {
                setState(() {
                  if (isSelected) {
                    _selectedSeats.remove(seatNumber);
                  } else if (_selectedSeats.length < widget.passengers) {
                    _selectedSeats.add(seatNumber);
                  }
                });
              },
      child: Container(
        width: 24,
        height: 24,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color:
              isOccupied
                  ? Colors.red[300]
                  : isSelected
                  ? Colors.teal
                  : Colors.grey[300],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            seatNumber.substring(1),
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 10,
              color: isOccupied ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddOns() {
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
          const Text(
            'Add-ons',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildAddOnItem(
            'Meal Selection',
            'Standard',
            Icons.restaurant,
            () => _showMealSelection(),
          ),
          const Divider(),
          _buildAddOnItem(
            'Travel Insurance',
            '\$25',
            Icons.security,
            () => setState(() => _hasInsurance = !_hasInsurance),
            isToggle: true,
            isSelected: _hasInsurance,
          ),
          const Divider(),
          _buildAddOnItem(
            'Extra Baggage',
            '\$50',
            Icons.luggage,
            () => setState(() => _hasExtraBaggage = !_hasExtraBaggage),
            isToggle: true,
            isSelected: _hasExtraBaggage,
          ),
        ],
      ),
    );
  }

  Widget _buildAddOnItem(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    bool isToggle = false,
    bool isSelected = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontFamily: 'Poppins', color: Colors.grey[600]),
      ),
      trailing:
          isToggle
              ? Switch(
                value: isSelected,
                onChanged: (_) => onTap(),
                activeColor: Colors.teal,
              )
              : const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: isToggle ? null : onTap,
    );
  }

  Widget _buildPriceBreakdown() {
    double basePrice = widget.flight.price * widget.passengers;
    double mealPrice = _selectedMeal != 'Standard' ? 15 * widget.passengers : 0;
    double insurancePrice = _hasInsurance ? 25 * widget.passengers : 0;
    double baggagePrice = _hasExtraBaggage ? 50 * widget.passengers : 0;
    double total = basePrice + mealPrice + insurancePrice + baggagePrice;

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
          const Text(
            'Price Breakdown',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildPriceRow('Base Price', basePrice),
          if (mealPrice > 0) _buildPriceRow('Meals', mealPrice),
          if (insurancePrice > 0) _buildPriceRow('Insurance', insurancePrice),
          if (baggagePrice > 0) _buildPriceRow('Extra Baggage', baggagePrice),
          const Divider(),
          _buildPriceRow('Total', total, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            '\$${amount.toInt()}',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 18 : 14,
              color: isTotal ? Colors.teal : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _proceedToPayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        ),
        child: const Text(
          'Proceed to Payment',
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

  void _showMealSelection() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Meal',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ...['Standard', 'Vegetarian', 'Halal', 'Kosher'].map((meal) {
                  return ListTile(
                    title: Text(
                      meal,
                      style: const TextStyle(fontFamily: 'Poppins'),
                    ),
                    trailing:
                        _selectedMeal == meal
                            ? const Icon(Icons.check, color: Colors.teal)
                            : null,
                    onTap: () {
                      setState(() => _selectedMeal = meal);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ],
            ),
          ),
    );
  }

  void _proceedToPayment() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedSeats.length != widget.passengers) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select seats for all passengers'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => BookingConfirmationPage(
              flight: widget.flight,
              passengers: widget.passengers,
              classType: widget.classType,
              passengerName: _nameController.text,
              passengerEmail: _emailController.text,
              passengerPhone: _phoneController.text,
              passportNumber: _passportController.text,
              selectedSeats: _selectedSeats,
              selectedMeal: _selectedMeal,
              hasInsurance: _hasInsurance,
              hasExtraBaggage: _hasExtraBaggage,
            ),
      ),
    );
  }
}
