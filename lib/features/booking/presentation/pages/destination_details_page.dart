import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../core/models/tourist_attraction.dart';
import '../../bookingengine/fligthrepo/amadeus_poi_service.dart';
import 'flight_detail_page.dart';

class TravelHomePage extends StatefulWidget {
  const TravelHomePage({super.key});

  @override
  State<TravelHomePage> createState() => _TravelHomePageState();

  static Widget _iconCircle(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Icon(icon, color: Colors.black87, size: 20),
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
      'image': 'assets/abuja.jpg',
      'location': 'Nigeria',
      'price': 450,
      'rating': 4.5,
    },
    {
      'name': 'NewYork',
      'image': 'assets/newyork.jpg',
      'location': 'United States',
      'price': 850,
      'rating': 4.8,
    },
    {
      'name': 'Sydney',
      'image': 'assets/sydney.jpg',
      'location': 'Australia',
      'price': 1200,
      'rating': 4.7,
    },
    {
      'name': 'Toronto',
      'image': 'assets/toronto.jpg',
      'location': 'Canada',
      'price': 750,
      'rating': 4.6,
    },
    {
      'name': 'London',
      'image': 'assets/london.jpg',
      'location': 'United Kingdom',
      'price': 650,
      'rating': 4.9,
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
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),

          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () async {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(20),
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
                          backgroundImage: AssetImage('assets/user.jpg'),
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
                    Row(
                      children: [
                        TravelHomePage._iconCircle(Icons.settings),
                        const SizedBox(width: 10),
                        Stack(
                          children: [
                            TravelHomePage._iconCircle(
                              Icons.notifications_outlined,
                            ),
                            Positioned(
                              right: 6,
                              top: 6,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.blueAccent,
                                  shape: BoxShape.circle,
                                ),
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
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search",
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    TravelHomePage._iconCircle(Icons.tune),
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
                children: [Text("Popular Destinations"), Text("See all")],
              ),

              const SizedBox(height: 15),

              SizedBox(
                height: 230,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    _DestinationCard(
                      image: "assets/maldives.jpg",
                      title: "The Nautilus Maldives",
                      location: "Baa Atoll, Maldives",
                      rating: 4.6,
                      price: 1200,
                    ),
                    _DestinationCard(
                      image: "assets/falls.jpg",
                      title: "Erin-Ijesha Falls",
                      location: "Ekiti, Nigeria",
                      rating: 4.6,
                      price: 350,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Categories
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("Choose Category"), Text("See all")],
              ),

              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  // _CategoryChip(icon: Icons.beach_access, label: "Beach"),
                  // _CategoryChip(icon: Icons.ac_unit, label: "Mountain"),
                ],
              ),
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
              // Navigate to destination details with correct city data
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => FlightDetailPage(
                        flightName: name,
                        location: location,
                        price: price,
                        rating: rating,
                        imagePath: image, // Pass the image path
                      ),
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
        width: 180,
        margin: const EdgeInsets.only(right: 15),
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
