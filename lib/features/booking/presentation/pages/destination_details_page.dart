import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../core/models/tourist_attraction.dart';
import '../../bookingengine/fligthrepo/amadeus_poi_service.dart';
import 'flight_detail_page.dart';
import 'flight_search_page.dart';

class TravelHomePage extends StatefulWidget {
  const TravelHomePage({super.key});

  @override
  State<TravelHomePage> createState() => _TravelHomePageState();

  static Widget _iconCircle(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        // color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          // BoxShadow(
          //   color: Colors.grey.shade200,
          //   blurRadius: 4,
          //   spreadRadius: 1,
          // ),
        ],
      ),
      child: IconButton(
        onPressed: () {},
        icon: Icon(icon, color: Colors.black87, size: 20),
      ),
    );
  }
}

class _TravelHomePageState extends State<TravelHomePage> {
  String? name = FirebaseAuth.instance.currentUser?.displayName;
  late Future<List<TouristAttraction>> attractionsFuture;
  final AmadeusPoiService poiService = AmadeusPoiService();

  // City data with their details
  static const List<Map<String, dynamic>> cities = [
    {
      'name': 'Abuja',
      'image': 'assets/images/abuja.jpg',
      'location': 'Nigeria',
      'price': 450,
      'rating': 4.5,
    },
    {
      'name': 'New York',
      'image': 'assets/images/newyork.jpg',
      'location': 'United States',
      'price': 850,
      'rating': 4.8,
    },
    {
      'name': 'London',
      'image': 'assets/images/london.jpg',
      'location': 'United Kingdom',
      'price': 650,
      'rating': 4.9,
    },
    {
      'name': 'Paris',
      'image': 'assets/images/paris.jpg',
      'location': 'France',
      'price': 780,
      'rating': 4.7,
    },
    {
      'name': 'Dubai',
      'image': 'assets/images/dubai.jpg',
      'location': 'United Arab Emirates',
      'price': 980,
      'rating': 4.6,
    },
  ];

  static const List<Map<String, dynamic>> categories = [
    {'icon': Icons.beach_access, 'label': 'Beach'},
    {'icon': Icons.terrain, 'label': 'Mountain'},
    {'icon': Icons.location_city, 'label': 'City'},
    {'icon': Icons.spa, 'label': 'Wellness'},
    {'icon': Icons.fastfood, 'label': 'Foodie'},
  ];

  static const List<Map<String, dynamic>> popularDestinations = [
    {
      'image': "assets/images/bali.jpg",
      'title': "Bali Beach Resort",
      'location': "Bali, Indonesia",
      'rating': 4.6,
      'price': 1200,
    },
    {
      'image': "assets/images/rome.jpg",
      'title': "Historic Rome Escape",
      'location': "Rome, Italy",
      'rating': 4.7,
      'price': 350,
    },
    {
      'image': "assets/images/paris.jpg",
      'title': "Parisian Getaway",
      'location': "Paris, France",
      'rating': 4.8,
      'price': 920,
    },
    {
      'image': "assets/images/dubai.jpg",
      'title': "Dubai Luxury Retreat",
      'location': "Dubai, UAE",
      'rating': 4.5,
      'price': 1050,
    },
    {
      'image': "assets/images/cairo.jpg",
      'title': "Cairo Cultural Tour",
      'location': "Cairo, Egypt",
      'rating': 4.4,
      'price': 640,
    },
    {
      'image': "assets/images/istanbul.jpg",
      'title': "Istanbul Bazaar Trail",
      'location': "Istanbul, Turkey",
      'rating': 4.3,
      'price': 580,
    },
    {
      'image': "assets/images/bangkok.jpg",
      'title': "Bangkok City Adventure",
      'location': "Bangkok, Thailand",
      'rating': 4.6,
      'price': 720,
    },
    {
      'image': "assets/images/london.jpg",
      'title': "London Royal Experience",
      'location': "London, UK",
      'rating': 4.9,
      'price': 980,
    },
    {
      'image': "assets/images/newyork.jpg",
      'title': "New York City Lights",
      'location': "New York, USA",
      'rating': 4.7,
      'price': 1100,
    },
    {
      'image': "assets/images/abuja.jpg",
      'title': "Abuja Capital Discovery",
      'location': "Abuja, Nigeria",
      'rating': 4.5,
      'price': 450,
    },
    {
      'image': "assets/images/bali.jpg",
      'title': "Bali Tropical Paradise",
      'location': "Bali, Indonesia",
      'rating': 4.8,
      'price': 1350,
    },
    {
      'image': "assets/images/paris.jpg",
      'title': "Paris Romance Package",
      'location': "Paris, France",
      'rating': 4.9,
      'price': 1250,
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        title: Text('Home'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 27,
                          backgroundColor: Colors.teal,
                          backgroundImage: AssetImage(
                            'assets/images/home_bg.jpg',
                          ),
                          child: Icon(
                            Icons.person,
                            size: 35,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hi, ${name ?? 'there'}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Search bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.teal.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search",
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    TravelHomePage._iconCircle(Icons.search),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Cities
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [Text("Where would you like to visit?")],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children:
                      cities.map((city) {
                        return _CityCircle(
                          name: city['name'] as String,
                          image: city['image'] as String,
                          location: city['location'] as String,
                          price: city['price'] as int,
                          rating: city['rating'] as double,
                        );
                      }).toList(),
                ),
              ),

              const SizedBox(height: 25),

              // Popular destinations
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [const Text("Popular Destinations")],
              ),

              const SizedBox(height: 15),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 0.75,
                ),
                itemCount: popularDestinations.length,
                itemBuilder: (context, index) {
                  final destination = popularDestinations[index];
                  return _DestinationCard(
                    image: destination['image'] as String,
                    title: destination['title'] as String,
                    location: destination['location'] as String,
                    rating: destination['rating'] as double,
                    price: destination['price'] as int,
                  );
                },
              ),

              const SizedBox(height: 25),

              // Categories
            ],
          ),
        ),
      ),
    );
  }
}

class _CityCircle extends StatelessWidget {
  final String name;
  final String image;
  final String location;
  final int price;
  final double rating;

  const _CityCircle({
    required this.name,
    required this.image,
    required this.location,
    required this.price,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              // Navigate to flight search page with selected city as destination
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => FlightSearchPage(initialDestination: name),
                ),
              );
            },
            child: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(image),
              backgroundColor: Colors.grey[300],
              child:
                  image.isEmpty
                      ? const Icon(Icons.location_city, color: Colors.grey)
                      : null,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _DestinationCard extends StatelessWidget {
  final String image, title, location;
  final double rating;
  final int price;

  const _DestinationCard({
    required this.image,
    required this.title,
    required this.location,
    required this.rating,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to destination details when card is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => FlightDetailPage(
                  flightName: title,
                  location: location,
                  price: price,
                  rating: rating,
                  imagePath: image, // Use the card's image
                ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
        ),
        child: Stack(
          children: [
            Positioned(
              right: 10,
              top: 10,
              child: Icon(Icons.favorite_border, color: Colors.white, size: 24),
            ),

            Positioned(
              bottom: 15,
              left: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.black.withOpacity(0.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 13,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            location,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 13, color: Colors.yellow),
                        const SizedBox(width: 3),
                        Text(
                          rating.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _CategoryChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.teal.withOpacity(0.1),
        border: Border.all(color: Colors.teal.shade100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.teal),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _DestinationListTile extends StatelessWidget {
  final String image;
  final String title;
  final String location;
  final double rating;
  final int price;
  final VoidCallback onTap;

  const _DestinationListTile({
    required this.image,
    required this.title,
    required this.location,
    required this.rating,
    required this.price,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.yellow),
                      const SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: const TextStyle(fontSize: 12),
                      ),
                      const Spacer(),
                      Text(
                        '\$$price',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
