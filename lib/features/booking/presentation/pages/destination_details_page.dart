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
  
  static const List<Map<String, dynamic>> popularDestinations = [
    {
      'image': "assets/images/bali.jpg",
      'title': "Bali Beach Resort",
      'location': "Bali, Indonesia",
      'rating': 4.6,
      'price': 1200,
      'description': "Experience the tropical paradise of Bali with pristine beaches, ancient temples, and lush rice terraces. Discover the perfect blend of relaxation and adventure in Indonesia's most famous island destination.",
      'attractions': ["Tanah Lot Temple", "Ubud Monkey Forest", "Tegallalang Rice Terraces", "Seminyak Beach", "Mount Batur"],
      'images': [
        "https://images.unsplash.com/photo-1577717903315-1691ae25ab3f?w=800",
        "https://images.unsplash.com/photo-1539367628448-4bc5c9d171c8?w=800",
        "https://images.unsplash.com/photo-1532186651327-6ac23687d189?w=800",
        "https://images.unsplash.com/photo-1546484475-7f7bd55792da?w=800",
        "https://images.unsplash.com/photo-1557093793-d149a38a1be8?w=800",
      ],
    },
    {
      'image': "assets/images/rome.jpg",
      'title': "Historic Rome Escape",
      'location': "Rome, Italy",
      'rating': 4.7,
      'price': 350,
      'description': "Step back in time and explore the Eternal City. From the Colosseum to the Vatican, Rome offers an unparalleled journey through history, art, and culture.",
      'attractions': ["Colosseum", "Vatican City", "Trevi Fountain", "Pantheon", "Roman Forum"],
      'images': [
        "https://images.unsplash.com/photo-1520175480921-4edfa2983e0f?w=800",
        "https://images.unsplash.com/photo-1534445867742-43195f401b6c?w=800",
        "https://plus.unsplash.com/premium_photo-1661963952208-2db3512ef3de?w=800",
        "https://images.unsplash.com/photo-1583855282680-6dbdc69b0932?w=800",
        "https://images.unsplash.com/photo-1535063406830-27dfae54262a?w=800",
      ],
    },
    {
      'image': "assets/images/paris.jpg",
      'title': "Parisian Getaway",
      'location': "Paris, France",
      'rating': 4.8,
      'price': 920,
      'description': "The City of Light awaits you with its iconic landmarks, world-class museums, and romantic atmosphere. Experience the charm of French culture and cuisine.",
      'attractions': ["Eiffel Tower", "Louvre Museum", "Notre-Dame Cathedral", "Champs-Élysées", "Montmartre"],
      'images': [
       "https://plus.unsplash.com/premium_photo-1694475374910-bc597c74b738?w=800",
       "https://images.unsplash.com/photo-1585944285854-d06c019aaca3?w=800",
       "https://plus.unsplash.com/premium_photo-1717351887353-befc71e582bb?w=800",
       "https://images.unsplash.com/photo-1551634979-2b11f8c946fe?w=800",
       "https://plus.unsplash.com/premium_photo-1661956135713-f93a5a95904d?w=800",
      ],
    },
    {
      'image': "assets/images/dubai.jpg",
      'title': "Dubai Luxury Retreat",
      'location': "Dubai, UAE",
      'rating': 4.5,
      'price': 1050,
      'description': "Indulge in luxury and modern architecture in Dubai. From the world's tallest building to pristine beaches and desert adventures, Dubai offers an unforgettable experience.",
      'attractions': ["Burj Khalifa", "Burj Al Arab", "Palm Jumeirah", "Dubai Mall", "Desert Safari"],
      'images': [
        "https://images.unsplash.com/photo-1459787915554-b34915863013?w=800",
        "https://images.unsplash.com/photo-1546412414-8035e1776c9a?w=800",
        "https://plus.unsplash.com/premium_photo-1697729914552-368899dc4757?w=800",
        "https://images.unsplash.com/photo-1518684079-3c830dcef090?w=800",
        "https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=800",
      ],
    },
    {
      'image': "assets/images/cairo.jpg",
      'title': "Cairo Cultural Tour",
      'location': "Cairo, Egypt",
      'rating': 4.4,
      'price': 640,
      'description': "Discover the ancient wonders of Egypt in Cairo. Explore the Pyramids of Giza, the Sphinx, and immerse yourself in thousands of years of history and culture.",
      'attractions': ["Pyramids of Giza", "Great Sphinx", "Egyptian Museum", "Khan el-Khalili", "Nile River"],
      'images': [
        "https://images.unsplash.com/photo-1695159151179-23b79aeba7d8?w=800",
        "https://images.unsplash.com/photo-1719659018185-8a239c35fb4a?w=800",
        "https://images.unsplash.com/photo-1697582718102-bd0e67cdf7ad?w=800",
        "https://images.unsplash.com/photo-1559738933-d69ac3ff674b?w=800",
        "https://images.unsplash.com/photo-1630201187972-dc4136076c6c?w=800",
      ],
    },
    {
      'image': "assets/images/istanbul.jpg",
      'title': "Istanbul Bazaar Trail",
      'location': "Istanbul, Turkey",
      'rating': 4.3,
      'price': 580,
      'description': "Where East meets West. Istanbul offers a unique blend of cultures, stunning architecture, and vibrant bazaars. Experience the magic of this transcontinental city.",
      'attractions': ["Hagia Sophia", "Blue Mosque", "Grand Bazaar", "Topkapi Palace", "Bosphorus Strait"],
      'images': [
        "https://images.unsplash.com/photo-1527838832700-5059252407fa?w=800",
        "https://plus.unsplash.com/premium_photo-1691338312403-e9f7f7984eeb?w=800",
        "https://images.unsplash.com/photo-1526048598645-62b31f82b8f5?w=800",
        "https://images.unsplash.com/photo-1531257240678-d5b1922e672d?w=800",
        "https://images.unsplash.com/photo-1567527259232-3a7fcd490c55?w=800",
        ],
    },
    {
      'image': "assets/images/bangkok.jpg",
      'title': "Bangkok City Adventure",
      'location': "Bangkok, Thailand",
      'rating': 4.6,
      'price': 720,
      'description': "Experience the vibrant energy of Bangkok with its bustling markets, ornate temples, and delicious street food. A city that never sleeps, offering endless adventures.",
      'attractions': ["Wat Pho", "Grand Palace", "Chatuchak Market", "Wat Arun", "Floating Markets"],
      'images': [
        "https://plus.unsplash.com/premium_photo-1661962432490-6188a6420a81?w=800",
        "https://plus.unsplash.com/premium_photo-1693149386423-2e4e264712e5?w=800",
        "https://plus.unsplash.com/premium_photo-1661962958462-9e52fda9954d?w=800",
        "https://images.unsplash.com/photo-1483683804023-6ccdb62f86ef?w=800",
        "https://images.unsplash.com/photo-1521109464564-2fa2faa95858?w=800",
      ],
    },
    {
      'image': "assets/images/london.jpg",
      'title': "London Royal Experience",
      'location': "London, UK",
      'rating': 4.9,
      'price': 980,
      'description': "Explore the royal capital of England with its rich history, iconic landmarks, and world-class museums. From Buckingham Palace to the Tower of London, experience British heritage.",
      'attractions': ["Big Ben", "Tower Bridge", "Buckingham Palace", "British Museum", "London Eye"],
      'images': [
        "https://images.unsplash.com/photo-1547254002-e65e0179fe9f?w=800",
        "https://images.unsplash.com/photo-1546885692-8e7c1b59da2c?w=800",
        "https://images.unsplash.com/photo-1575227092814-b3087ab73fc8?w=800",
        "https://images.unsplash.com/photo-1500380804539-4e1e8c1e7118?w=800",
        "https://images.unsplash.com/photo-1534359265607-b9cdb5e0a81e?w=800",
      ],
    },
    {
      'image': "assets/images/newyork.jpg",
      'title': "New York City Lights",
      'location': "New York, USA",
      'rating': 4.7,
      'price': 1100,
      'description': "The city that never sleeps! Experience the energy of New York with its iconic skyline, Broadway shows, world-class dining, and endless entertainment options.",
      'attractions': ["Statue of Liberty", "Central Park", "Times Square", "Empire State Building", "Brooklyn Bridge"],
      'images': [
        "https://plus.unsplash.com/premium_photo-1670176447606-b186805a6ac1?w=800",
        "https://plus.unsplash.com/premium_photo-1673266630624-4cbef6d25ff4?w=800",
        "https://images.unsplash.com/photo-1576723658639-513237fdd520?w=800",
        "https://images.unsplash.com/photo-1515081774057-84dcf72d0cf1?w=800",
        "https://images.unsplash.com/photo-1529619768328-e37af76c6fe5?w=800",
      ],
    },
    {
      'image': "assets/images/abuja.jpg",
      'title': "Abuja Capital Discovery",
      'location': "Abuja, Nigeria",
      'rating': 4.5,
      'price': 450,
      'description': "Discover Nigeria's modern capital city with its impressive architecture, beautiful parks, and rich cultural heritage. Experience the vibrant African culture and warm hospitality.",
      'attractions': ["Aso Rock", "National Mosque", "Millennium Park", "Nigerian National Museum", "Zuma Rock"],
      'images': [
        "https://images.unsplash.com/photo-1618828665347-d870c38c95c7?w=800",
        "https://images.unsplash.com/photo-1587858090544-ed2017db3f12?w=800",
        "https://images.unsplash.com/photo-1734257855024-d41a1e1d9a0c?w=800",
        "https://images.unsplash.com/photo-1648023200358-9dc050df521d?w=800",
        "https://images.unsplash.com/photo-1719314073622-9399d167725b?w=800",

      ],
    },
  ];
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
    final query = widget.searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() {
        showSearchResults = false;
        searchResults = [];
      });
      return;
    }

    // Search in available destinations and cities for auto-complete
    final localResults = _searchLocalDestinations(query);
    
    if (localResults.isNotEmpty) {
      setState(() {
        searchResults = localResults;
        showSearchResults = true;
        isSearching = false;
      });
    } else {
      // If no local results, perform API search
      _performSearch(widget.searchController.text);
    }
  }

  List<Map<String, dynamic>> _searchLocalDestinations(String query) {
    final results = <Map<String, dynamic>>[];
    
    // Search in popular destinations
    for (var dest in TravelHomePage.popularDestinations) {
      final title = (dest['title'] as String).toLowerCase();
      final location = (dest['location'] as String).toLowerCase();
      
      if (title.contains(query) || location.contains(query)) {
        results.add({
          'name': dest['title'],
          'location': dest['location'],
          'type': 'destination',
          'data': dest,
        });
      }
    }
    
    // Search in cities
    for (var city in cities) {
      final name = (city['name'] as String).toLowerCase();
      final location = (city['location'] as String).toLowerCase();
      
      if (name.contains(query) || location.contains(query)) {
        // Try to find matching destination from popularDestinations
        Map<String, dynamic>? matchingDest;
        try {
          matchingDest = TravelHomePage.popularDestinations.firstWhere(
            (dest) => (dest['location'] as String).contains(city['name'] as String) ||
                       (dest['title'] as String).contains(city['name'] as String),
          );
        } catch (e) {
          matchingDest = null;
        }
        
        if (matchingDest != null) {
          results.add({
            'name': matchingDest['title'],
            'location': matchingDest['location'],
            'type': 'destination',
            'data': matchingDest,
          });
        } else {
          results.add({
            'name': city['name'],
            'location': city['location'],
            'type': 'city',
            'data': city,
          });
        }
      }
    }
    
    return results;
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

    // First check local destinations
    final localResults = _searchLocalDestinations(query.toLowerCase());
    
    setState(() {
      isSearching = true;
      showSearchResults = true;
    });

    try {
      final places = await amadeusService.searchPlace(query);
      
      // Combine local results with API results
      final combinedResults = <Map<String, dynamic>>[];
      
      // Add local results first (they have priority)
      combinedResults.addAll(localResults);
      
      // Add API results, avoiding duplicates
      for (var place in places) {
        final placeName = (place['name'] ?? place['detailedName'] ?? '').toString().toLowerCase();
        final isDuplicate = localResults.any((local) => 
          (local['name'] as String).toLowerCase() == placeName
        );
        
        if (!isDuplicate) {
          combinedResults.add(place);
        }
      }
      
      setState(() {
        searchResults = combinedResults;
        isSearching = false;
      });
    } catch (e) {
      // If API fails, still show local results
      setState(() {
        searchResults = localResults;
        isSearching = false;
      });
      
      if (mounted && localResults.isEmpty) {
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
    // Check if it's a local destination or city
    if (place['type'] == 'destination' || place['type'] == 'city') {
      final data = place['data'] as Map<String, dynamic>;
      
      if (place['type'] == 'destination') {
        // Open destination detail page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FlightDetailPage(
              flightName: data['title'] as String,
              location: data['location'] as String,
              price: data['price'] as int,
              rating: data['rating'] as double,
              imagePath: data['image'] as String,
              description: data['description'] as String?,
              attractions: data['attractions'] as List<String>?,
              images: data['images'] as List<String>?,
            ),
          ),
        );
      } else {
        // It's a city, try to find matching destination or go to flight search
        final cityName = data['name'] as String;
        Map<String, dynamic>? matchingDest;
        try {
          matchingDest = TravelHomePage.popularDestinations.firstWhere(
            (dest) => (dest['location'] as String).contains(cityName) ||
                       (dest['title'] as String).contains(cityName),
          );
        } catch (e) {
          matchingDest = null;
        }
        
        if (matchingDest != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FlightDetailPage(
                flightName: matchingDest!['title'] as String,
                location: matchingDest!['location'] as String,
                price: matchingDest!['price'] as int,
                rating: matchingDest!['rating'] as double,
                imagePath: matchingDest!['image'] as String,
                description: matchingDest!['description'] as String?,
                attractions: matchingDest!['attractions'] as List<String>?,
                images: matchingDest!['images'] as List<String>?,
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FlightSearchPage(initialDestination: cityName),
            ),
          );
        }
      }
      
      widget.searchController.clear();
      setState(() {
        showSearchResults = false;
        searchResults = [];
      });
      return;
    }
    
    // Handle API results (original logic)
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
                              hintText: "Search",
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
                                
                                // Check if it's a local destination/city
                                if (place['type'] == 'destination' || place['type'] == 'city') {
                                  final data = place['data'] as Map<String, dynamic>;
                                  final placeName = place['name'] as String;
                                  final location = place['location'] as String;
                                  final rating = data['rating'] as double?;
                                  
                                  return ListTile(
                                    leading: const Icon(Icons.place, color: Colors.orange, size: 28),
                                    title: Text(
                                      placeName,
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(location, style: const TextStyle(fontSize: 13)),
                                        if (rating != null)
                                          Row(
                                            children: [
                                              const Icon(Icons.star, size: 14, color: Colors.amber),
                                              const SizedBox(width: 4),
                                              Text(
                                                rating.toString(),
                                                style: const TextStyle(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                    onTap: () => _onPlaceSelected(place),
                                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.teal),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  );
                                }
                                
                                // Handle API results (original logic)
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
                itemCount: TravelHomePage.popularDestinations.length,
                itemBuilder: (context, index) {
                  final destination = TravelHomePage.popularDestinations[index];
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
        Map<String, dynamic>? destination;
        try {
          destination = TravelHomePage.popularDestinations.firstWhere(
            (dest) => dest['title'] == title,
          );
        } catch (e) {
          destination = null;
        }
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FlightDetailPage(
                  flightName: title,
                  location: location,
                  price: price,
                  rating: rating,
              imagePath: image,
              description: destination?['description'] as String?,
              attractions: destination?['attractions'] as List<String>?,
              images: destination?['images'] as List<String>?,
                ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover)),
        child: Stack(
          children: [
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
