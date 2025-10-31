import 'package:flutter/material.dart';

import 'flight_detail_page.dart';
import 'flight_search_page.dart';

class DestinationsPage extends StatefulWidget {
  const DestinationsPage({super.key});

  @override
  State<DestinationsPage> createState() => _DestinationsPageState();
}

class _DestinationsPageState extends State<DestinationsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredDestinations = [];
  List<Map<String, dynamic>> _allDestinations = [];

  @override
  void initState() {
    super.initState();
    _initializeDestinations();
  }

  void _initializeDestinations() {
    _allDestinations = [
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
    _filteredDestinations = List.from(_allDestinations);
  }

  void _filterDestinations(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredDestinations = List.from(_allDestinations);
      } else {
        _filteredDestinations =
            _allDestinations.where((destination) {
              final city = destination['city'].toString().toLowerCase();
              final country = destination['country'].toString().toLowerCase();
              final searchQuery = query.toLowerCase();
              return city.contains(searchQuery) ||
                  country.contains(searchQuery);
            }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FlightSearchPage(),
                ),
              );
            },
            icon: Icon(Icons.book_outlined, color: Colors.white, size: 30),
          ),
        ],
        title: const Text(
          "Available Flights",
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterDestinations,
              decoration: InputDecoration(
                hintText: 'Search destinations...',
                prefixIcon: const Icon(Icons.search, color: Colors.teal),
                suffixIcon:
                    _searchController.text.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.teal),
                          onPressed: () {
                            _searchController.clear();
                            _filterDestinations('');
                          },
                        )
                        : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          // Results count
          if (_searchController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${_filteredDestinations.length} destination(s) found',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          // Destinations Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child:
                  _filteredDestinations.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No destinations found',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try searching with different keywords',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      )
                      : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 0.8,
                            ),
                        itemCount: _filteredDestinations.length,
                        itemBuilder: (context, index) {
                          final flight = _filteredDestinations[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => FlightDetailPage(
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
          ),
        ],
      ),
    );
  }

  // Flight card design
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
        image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
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
                colors: [Colors.black.withOpacity(0.3), Colors.transparent],
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
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
