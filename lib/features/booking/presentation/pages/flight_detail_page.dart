import 'package:flutter/material.dart';
import 'package:bookingapp/core/widgets/app_drawer.dart';
import 'flight_search_page.dart';

class FlightDetailPage extends StatelessWidget {
  final String flightName;
  final String location;
  final int price;
  final double rating;
  final bool isHotDeal;

  const FlightDetailPage({
    super.key,
    required this.flightName,
    required this.location,
    required this.price,
    required this.rating,
    required this.isHotDeal,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          flightName,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Destination image
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/${flightName.toLowerCase()}.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 230,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 230,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Title and location
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$flightName, $location",
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    Text(
                      rating.toString(),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Price display
            Text(
              "\$$price / person",
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 20),

            // Flight description
            const Text(
              "About this destination",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Enjoy your stay in one of the most beautiful cities in the world. "
              "Discover amazing attractions, local culture, and unique experiences. "
              "Book now and start your journey today!",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 30),

            // HOT DEAL badge
            if (isHotDeal)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Limited Time HOT DEAL!",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(height: 40),

            // Book button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigate to flight search page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FlightSearchPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  elevation: 6,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.flight_takeoff_rounded),
                label: const Text(
                  "Book Now",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Flight booking page
class FlightBookingPage extends StatelessWidget {
  final String flightName;
  final String location;
  final int price;

  const FlightBookingPage({
    super.key,
    required this.flightName,
    required this.location,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Flight Booking",
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Booking for: $flightName, $location",
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Price: \$$price / person",
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 30),

            const Text(
              "Enter your details:",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Data input
            const TextField(
              decoration: InputDecoration(
                labelText: "Full Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            const TextField(
              decoration: InputDecoration(
                labelText: "Email Address",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            const TextField(
              decoration: InputDecoration(
                labelText: "Number of Passengers",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),

            // Confirm booking button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Booking Confirmed"),
                      backgroundColor: Colors.teal,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Confirm Booking",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
