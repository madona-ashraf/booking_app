import 'package:flutter/material.dart';
import 'package:bookingapp/core/widgets/app_drawer.dart';
import 'package:intl/intl.dart';

import '../../../../core/models/flight.dart';

class BookingConfirmationPage extends StatefulWidget {
  final Flight flight;
  final double passengers;
  final String classType;
  final String passengerName;
  final String passengerEmail;
  final String passengerPhone;
  final String passportNumber;
  final List<String> selectedSeats;
  final String selectedMeal;
  final bool hasInsurance;
  final bool hasExtraBaggage;

  const BookingConfirmationPage({
    super.key,
    required this.flight,
    required this.passengers,
    required this.classType,
    required this.passengerName,
    required this.passengerEmail,
    required this.passengerPhone,
    required this.passportNumber,
    required this.selectedSeats,
    required this.selectedMeal,
    required this.hasInsurance,
    required this.hasExtraBaggage,
  });

  @override
  State<BookingConfirmationPage> createState() =>
      _BookingConfirmationPageState();
}

class _BookingConfirmationPageState extends State<BookingConfirmationPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isProcessing = false;
  bool _isConfirmed = false;
  String _confirmationNumber = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Booking Confirmation',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child:
                  _isConfirmed ? _buildConfirmationView() : _buildPaymentView(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaymentView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBookingSummary(),
          const SizedBox(height: 20),
          _buildPaymentMethod(),
          const SizedBox(height: 20),
          _buildPriceBreakdown(),
          const SizedBox(height: 30),
          _buildConfirmButton(),
        ],
      ),
    );
  }

  Widget _buildConfirmationView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSuccessHeader(),
          const SizedBox(height: 30),
          _buildConfirmationDetails(),
          const SizedBox(height: 30),
          _buildFlightSummary(),
          const SizedBox(height: 30),
          _buildPassengerDetails(),
          const SizedBox(height: 30),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildBookingSummary() {
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

  Widget _buildPaymentMethod() {
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
            'Payment Method',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildPaymentOption('Credit/Debit Card', Icons.credit_card, true),
          const Divider(),
          _buildPaymentOption('PayPal', Icons.payment, false),
          const Divider(),
          _buildPaymentOption('Apple Pay', Icons.apple, false),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String title, IconData icon, bool isSelected) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing:
          isSelected
              ? const Icon(Icons.check_circle, color: Colors.teal)
              : const Icon(Icons.radio_button_unchecked, color: Colors.grey),
      onTap: () {
        // Handle payment method selection
      },
    );
  }

  Widget _buildPriceBreakdown() {
    double basePrice = widget.flight.price * widget.passengers;
    double mealPrice =
        widget.selectedMeal != 'Standard' ? 15.0 * widget.passengers : 0.0;
    double insurancePrice =
        widget.hasInsurance ? 25.0 * widget.passengers : 0.0;
    double baggagePrice =
        widget.hasExtraBaggage ? 50.0 * widget.passengers : 0.0;
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

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isProcessing ? null : _processPayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        ),
        child:
            _isProcessing
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                  'Confirm Payment',
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

  Widget _buildSuccessHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 16),
          const Text(
            'Booking Confirmed!',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your flight has been successfully booked',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.grey[600],
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationDetails() {
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
            'Confirmation Details',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Confirmation Number', _confirmationNumber),
          _buildDetailRow(
            'Booking Date',
            DateFormat('MMM dd, yyyy').format(DateTime.now()),
          ),
          _buildDetailRow('Seats', widget.selectedSeats.join(', ')),
          _buildDetailRow('Meal', widget.selectedMeal),
          if (widget.hasInsurance) _buildDetailRow('Insurance', 'Included'),
          if (widget.hasExtraBaggage)
            _buildDetailRow('Extra Baggage', 'Included'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontFamily: 'Poppins', color: Colors.grey[600]),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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
          const Text(
            'Flight Details',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
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
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.flight.departureAirport,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      DateFormat('MMM dd').format(widget.flight.departureTime),
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
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.flight.arrivalAirport,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      DateFormat('MMM dd').format(widget.flight.arrivalTime),
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
          _buildDetailRow('Name', widget.passengerName),
          _buildDetailRow('Email', widget.passengerEmail),
          _buildDetailRow('Phone', widget.passengerPhone),
          _buildDetailRow('Passport', widget.passportNumber),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: _downloadTicket,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: const Icon(Icons.download, color: Colors.white),
            label: const Text(
              'Download Ticket',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: _goToHome,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.teal),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Back to Home',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _processPayment() async {
    setState(() {
      _isProcessing = true;
    });

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isProcessing = false;
      _isConfirmed = true;
      _confirmationNumber =
          'BK${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    });

    _animationController.reset();
    _animationController.forward();
  }

  void _downloadTicket() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ticket downloaded successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _goToHome() {
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }
}
