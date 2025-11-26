import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../core/models/tourist_attraction.dart';
import '../../bookingengine/fligthrepo/amadeus_poi_service.dart';
import '../../bookingengine/fligthrepo/amadeus_service.dart';
import 'flight_detail_page.dart';
import 'flight_search_page.dart';
import 'place_search_results_page.dart';

class TravelHomePage extends StatefulWidget {
  TravelHomePage({super.key});

  @override
  State<TravelHomePage> createState() => _TravelHomePageState();
  TextEditingController searchController = TextEditingController();
}

class _TravelHomePageState extends State<TravelHomePage> {
  String? name = FirebaseAuth.instance.currentUser?.displayName;
  late Future<List<TouristAttraction>> attractionsFuture;
  final AmadeusPoiService poiService = AmadeusPoiService();
  final AmadeusService amadeusService = AmadeusService();
  List<Map<String, dynamic>> searchResults = [];
  bool isSearching = false;
  bool showSearchResults = false;

  // City data with their details
  static const List<Map<String, dynamic>> cities = [
    {'name': 'Abuja','image': 'assets/images/abuja.jpg','location': 'Nigeria','price': 450,'rating': 4.5},
    {'name': 'New York','image': 'assets/images/newyork.jpg','location': 'United States','price': 850,'rating': 4.8},
    {'name': 'London','image': 'assets/images/london.jpg','location': 'United Kingdom','price': 650,'rating': 4.9},
    {'name': 'Paris','image': 'assets/images/paris.jpg','location': 'France','price': 780,'rating': 4.7},
    {'name': 'Dubai','image': 'assets/images/dubai.jpg','location': 'United Arab Emirates','price': 980,'rating': 4.6},
  ];

  static const List<Map<String, dynamic>> popularDestinations = [
    {'image': "assets/images/bali.jpg",'title': "Bali Beach Resort",'location': "Bali, Indonesia",'rating': 4.6,'price': 1200},
    {'image': "assets/images/rome.jpg",'title': "Historic Rome Escape",'location': "Rome, Italy",'rating': 4.7,'price': 350},
    {'image': "assets/images/paris.jpg",'title': "Parisian Getaway",'location': "Paris, France",'rating': 4.8,'price': 920},
    {'image': "assets/images/dubai.jpg",'title': "Dubai Luxury Retreat",'location': "Dubai, UAE",'rating': 4.5,'price': 1050},
    {'image': "assets/images/cairo.jpg",'title': "Cairo Cultural Tour",'location': "Cairo, Egypt",'rating': 4.4,'price': 640},
    {'image': "assets/images/istanbul.jpg",'title': "Istanbul Bazaar Trail",'location': "Istanbul, Turkey",'rating': 4.3,'price': 580},
    {'image': "assets/images/bangkok.jpg",'title': "Bangkok City Adventure",'location': "Bangkok, Thailand",'rating': 4.6,'price': 720},
    {'image': "assets/images/london.jpg",'title': "London Royal Experience",'location': "London, UK",'rating': 4.9,'price': 980},
    {'image': "assets/images/newyork.jpg",'title': "New York City Lights",'location': "New York, USA",'rating': 4.7,'price': 1100},
    {'image': "assets/images/abuja.jpg",'title': "Abuja Capital Discovery",'location': "Abuja, Nigeria",'rating': 4.5,'price': 450},
    {'image': "assets/images/bali.jpg",'title': "Bali Tropical Paradise",'location': "Bali, Indonesia",'rating': 4.8,'price': 1350},
    {'image': "assets/images/paris.jpg",'title': "Paris Romance Package",'location': "Paris, France",'rating': 4.9,'price': 1250},
  ];

  @override
  void initState() {
    super.initState();
    widget.searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    widget.searchController.removeListener(_onSearchChanged);
    super.dispose();
  }

  void _onSearchChanged() {
    final query = widget.searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        showSearchResults = false;
        searchResults = [];
      });
    }
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        showSearchResults = false;
        searchResults = [];
        isSearching = false;
      });
      return;
    }

    setState(() {
      isSearching = true;
      showSearchResults = true;
    });

    try {
      final places = await amadeusService.searchPlace(query);
      setState(() {
        searchResults = places;
        isSearching = false;
      });
    } catch (e) {
      setState(() {
        isSearching = false;
        searchResults = [];
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error searching for places: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _onPlaceSelected(Map<String, dynamic> place) {
    final placeName = place['name'] ?? place['detailedName'] ?? place['subType'] ?? 'Unknown';
    final geoCode = place['geoCode'] as Map<String, dynamic>?;

    if (geoCode != null) {
      final latitude = (geoCode['latitude'] as num?)?.toDouble();
      final longitude = (geoCode['longitude'] as num?)?.toDouble();
      if (latitude != null && longitude != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaceSearchResultsPage(
              placeName: placeName.toString(),
              latitude: latitude,
              longitude: longitude,
            ),
          ),
        );
        widget.searchController.clear();
        setState(() {
          showSearchResults = false;
          searchResults = [];
        });
      }
    } else {
      final iataCode = place['iataCode'] ?? place['iata'] ?? '';
      if (iataCode.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FlightSearchPage(initialDestination: placeName.toString()),
          ),
        );
        widget.searchController.clear();
        setState(() {
          showSearchResults = false;
          searchResults = [];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.teal, elevation: 0, title: Text('Home')),
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
                  children: [
                    const CircleAvatar(
                      radius: 27,
                      backgroundColor: Colors.teal,
                      backgroundImage: AssetImage('assets/images/home_bg.jpg'),
                      child: Icon(Icons.person, size: 35, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hi, ${name ?? 'there'}',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Search bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.teal.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: widget.searchController,
                            decoration: InputDecoration(
                              hintText: "ابحث عن مكان...",
                              hintStyle: TextStyle(color: Colors.grey.shade500),
                              border: InputBorder.none,
                            ),
                            onFieldSubmitted: _performSearch,
                          ),
                        ),
                        IconButton(
                          onPressed: () => _performSearch(widget.searchController.text),
                          icon: isSearching
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.search, color: Colors.teal),
                        ),
                      ],
                    ),
                  ),

                  if (showSearchResults)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.teal.withOpacity(0.3)),
                        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))],
                      ),
                      constraints: BoxConstraints(maxHeight: searchResults.isNotEmpty ? 300 : 100),
                      child: searchResults.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemCount: searchResults.length,
                              itemBuilder: (context, index) {
                                final place = searchResults[index];
                                final placeName = place['name'] ?? place['detailedName'] ?? place['subType'] ?? 'Unknown Place';
                                final iataCode = place['iataCode'] ?? place['iata'] ?? '';
                                final geoCode = place['geoCode'] as Map<String, dynamic>?;
                                String locationInfo = '';
                                if (iataCode.isNotEmpty) {
                                  locationInfo = 'Code: $iataCode';
                                } else if (geoCode != null) {
                                  final lat = geoCode['latitude'];
                                  final lng = geoCode['longitude'];
                                  if (lat != null && lng != null) {
                                    locationInfo = 'Lat: ${lat.toStringAsFixed(2)}, Lng: ${lng.toStringAsFixed(2)}';
                                  }
                                }

                                final address = place['address'] as Map<String, dynamic>?;
                                final cityName = address?['cityName'] ?? place['cityName'] ?? '';
                                final countryCode = address?['countryCode'] ?? place['countryCode'] ?? '';

                                if (locationInfo.isEmpty && cityName.isNotEmpty) {
                                  locationInfo = cityName;
                                  if (countryCode.isNotEmpty) {
                                    locationInfo = '$locationInfo, $countryCode';
                                  }
                                }

                                return ListTile(
                                  leading: const Icon(Icons.location_on, color: Colors.teal),
                                  title: Text(placeName.toString(), style: const TextStyle(fontWeight: FontWeight.w600)),
                                  subtitle: locationInfo.isNotEmpty ? Text(locationInfo) : const Text('Location info not available'),
                                  onTap: () => _onPlaceSelected(place),
                                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                                );
                              },
                            )
                          : Padding(
                              padding: const EdgeInsets.all(16),
                              child: Center(
                                child: isSearching
                                    ? const CircularProgressIndicator()
                                    : const Text('لا توجد نتائج', style: TextStyle(color: Colors.grey)),
                              ),
                            ),
                    ),
                ],
              ),

              const SizedBox(height: 30),

              // Cities
              const Text("Where would you like to visit?"),
              const SizedBox(height: 20),
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: cities.map((city) {
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

              const Text("Popular Destinations"),
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

  const _CityCircle({required this.name, required this.image, required this.location, required this.price, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => FlightSearchPage(initialDestination: name)));
            },
            child: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(image),
              backgroundColor: Colors.grey[300],
              child: image.isEmpty ? const Icon(Icons.location_city, color: Colors.grey) : null,
            ),
          ),
          const SizedBox(height: 6),
          Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _DestinationCard extends StatelessWidget {
  final String image, title, location;
  final double rating;
  final int price;

  const _DestinationCard({required this.image, required this.title, required this.location, required this.rating, required this.price});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FlightDetailPage(
              flightName: title,
              location: location,
              price: price,
              rating: rating,
              imagePath: image,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover)),
        child: Stack(
          children: [
            Positioned(right: 10, top: 10, child: Icon(Icons.favorite_border, color: Colors.white, size: 24)),
            Positioned(
              bottom: 15,
              left: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.black.withOpacity(0.5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 13, color: Colors.orange),
                        const SizedBox(width: 4),
                        Expanded(child: Text(location, style: const TextStyle(color: Colors.white, fontSize: 11), overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 13, color: Colors.yellow),
                        const SizedBox(width: 3),
                        Text(rating.toString(), style: const TextStyle(color: Colors.white, fontSize: 12)),
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
