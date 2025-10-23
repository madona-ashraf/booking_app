import 'package:flutter/material.dart';
import 'flight_detail_page.dart';

class DestinationsPage extends StatelessWidget {
  const DestinationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> destinations = [
      {
        'city': 'Dubai',
        'country': 'UAE',
        'price': 450,
        'rating': 4.8,
        'image': 'assets/images/dubai.jpg',
        'isHotDeal': true,
      },
      {
        'city': 'Paris',
        'country': 'France',
        'price': 680,
        'rating': 4.7,
        'image': 'assets/images/paris.jpg',
        'isHotDeal': false,
      },
      {
        'city': 'New York',
        'country': 'USA',
        'price': 720,
        'rating': 4.6,
        'image': 'assets/images/new york.jpg',
        'isHotDeal': true,
      },
      {
        'city': 'Istanbul',
        'country': 'Turkey',
        'price': 400,
        'rating': 4.5,
        'image': 'assets/images/istanbul.jpg',
        'isHotDeal': false,
      },
      {
        'city': 'Cairo',
        'country': 'Egypt',
        'price': 350,
        'rating': 4.4,
        'image': 'assets/images/cairo.jpg',
        'isHotDeal': true,
      },
      {
        'city': 'Rome',
        'country': 'Italy',
        'price': 600,
        'rating': 4.7,
        'image': 'assets/images/rome.jpg',
        'isHotDeal': false,
      },
      {
        'city': 'London',
        'country': 'UK',
        'price': 750,
        'rating': 4.9,
        'image': 'assets/images/london.jpg',
        'isHotDeal': true,
      },
      {
        'city': 'Bali',
        'country': 'Indonesia',
        'price': 500,
        'rating': 4.8,
        'image': 'assets/images/bali.jpg',
        'isHotDeal': false,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Available Flights",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemCount: destinations.length,
          itemBuilder: (context, index) {
            final flight = destinations[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FlightDetailPage(
                      flightName: flight['city'] ?? '',
                      location: flight['country'] ?? '',
                      price: flight['price'] ?? 0,
                      rating: flight['rating'] ?? 0.0,
                      isHotDeal: flight['isHotDeal'] ?? false,
                    ),
                  ),
                );
              },
              child: _flightCard(
                flight['city'] ?? '',
                flight['country'] ?? '',
                flight['image'] ?? 'assets/images/dubai.jpg',
                flight['price'] ?? 0,
                flight['rating'] ?? 0.0,
                flight['isHotDeal'] ?? false,
              ),
            );
          },
        ),
      ),
    );
  }

  // تصميم كارت الرحلة
  Widget _flightCard(
    String city,
    String country,
    String image,
    int price,
    double rating,
    bool isHotDeal,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Positioned(
            left: 10,
            bottom: 20,
            right: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isHotDeal)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'HOT DEAL',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const SizedBox(height: 6),
                Text(
                  city,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  country,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.yellow, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '$rating',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '\$$price',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
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
}
