import 'package:flutter/material.dart';

import 'flight_search_page.dart';

class FlightDetailPage extends StatelessWidget {
  final String flightName;
  final String location;
  final int price;
  final double rating;
  final String? imagePath;

  const FlightDetailPage({
    super.key,
    required this.flightName,
    required this.location,
    required this.price,
    required this.rating,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                imagePath ?? 'assets/images/${flightName.toLowerCase()}.jpg',
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
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$flightName, $location",
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Price display
            // Text(
            //   "\$$price / person",
            //   style: const TextStyle(
            //     fontFamily: 'Poppins',
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.teal,
            //   ),
            // ),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 60,
                    vertical: 16,
                  ),
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
