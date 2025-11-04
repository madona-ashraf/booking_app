import 'package:flutter/material.dart';
import 'flight_search_page.dart';
import '../../../../core/widgets/app_bottom_navigation.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../auth/presentation/pages/profile_page.dart';

class DestinationsPage extends StatefulWidget {
  const DestinationsPage({super.key});

  @override
  State<DestinationsPage> createState() => _DestinationsPageState();
}

class _DestinationsPageState extends State<DestinationsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredDestinations = [];
  List<Map<String, dynamic>> _allDestinations = [];
  
  // Filter and sort state
  String _sortBy = 'default'; // default, price-low, price-high, rating, name
  String _filterCategory = 'all'; // all, hot-deals, budget, luxury, beach, city
  double _minPrice = 0;
  double _maxPrice = 1000;
  double _minRating = 0;
  bool _showFilters = false;
  bool _isGridView = true;
  Set<String> _favorites = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeDestinations();
    _searchController.addListener(() {
      _filterDestinations();
    });
  }

  void _initializeDestinations() {
    setState(() {
      _isLoading = true;
    });
    
    // Simulate loading
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
        _allDestinations = [
          {
            'city': 'Dubai',
            'country': 'UAE',
            'price': 450,
            'rating': 4.8,
            'image': 'assets/images/dubai.jpg',
            'isHotDeal': true,
            'category': 'luxury',
            'description': 'Modern city with stunning architecture',
            'reviews': 12450,
          },
          {
            'city': 'Paris',
            'country': 'France',
            'price': 680,
            'rating': 4.7,
            'image': 'assets/images/paris.jpg',
            'isHotDeal': false,
            'category': 'city',
            'description': 'City of lights and romance',
            'reviews': 18920,
          },
          {
            'city': 'New York',
            'country': 'USA',
            'price': 720,
            'rating': 4.6,
            'image': 'assets/images/new york.jpg',
            'isHotDeal': true,
            'category': 'city',
            'description': 'The city that never sleeps',
            'reviews': 15230,
          },
          {
            'city': 'Istanbul',
            'country': 'Turkey',
            'price': 400,
            'rating': 4.5,
            'image': 'assets/images/istanbul.jpg',
            'isHotDeal': false,
            'category': 'city',
            'description': 'Where East meets West',
            'reviews': 9870,
          },
          {
            'city': 'Cairo',
            'country': 'Egypt',
            'price': 350,
            'rating': 4.4,
            'image': 'assets/images/cairo.jpg',
            'isHotDeal': true,
            'category': 'city',
            'description': 'Ancient wonders and rich history',
            'reviews': 7650,
          },
          {
            'city': 'Rome',
            'country': 'Italy',
            'price': 600,
            'rating': 4.7,
            'image': 'assets/images/rome.jpg',
            'isHotDeal': false,
            'category': 'city',
            'description': 'Eternal city with timeless beauty',
            'reviews': 11240,
          },
          {
            'city': 'London',
            'country': 'UK',
            'price': 750,
            'rating': 4.9,
            'image': 'assets/images/london.jpg',
            'isHotDeal': true,
            'category': 'city',
            'description': 'Historic charm meets modern culture',
            'reviews': 20340,
          },
          {
            'city': 'Bali',
            'country': 'Indonesia',
            'price': 500,
            'rating': 4.8,
            'image': 'assets/images/bali.jpg',
            'isHotDeal': false,
            'category': 'beach',
            'description': 'Tropical paradise with stunning beaches',
            'reviews': 14560,
          },
          {
            'city': 'Tokyo',
            'country': 'Japan',
            'price': 850,
            'rating': 4.9,
            'image': 'assets/images/tokyo.jpg',
            'isHotDeal': false,
            'category': 'city',
            'description': 'Modern metropolis with traditional culture',
            'reviews': 17890,
          },
          {
            'city': 'Sydney',
            'country': 'Australia',
            'price': 650,
            'rating': 4.7,
            'image': 'assets/images/sydney.jpg',
            'isHotDeal': true,
            'category': 'beach',
            'description': 'Coastal beauty with iconic landmarks',
            'reviews': 13200,
          },
          {
            'city': 'Bangkok',
            'country': 'Thailand',
            'price': 380,
            'rating': 4.6,
            'image': 'assets/images/bangkok.jpg',
            'isHotDeal': true,
            'category': 'budget',
            'description': 'Vibrant city with amazing food',
            'reviews': 10980,
          },
          {
            'city': 'Singapore',
            'country': 'Singapore',
            'price': 550,
            'rating': 4.8,
            'image': 'assets/images/singapore.jpg',
            'isHotDeal': false,
            'category': 'city',
            'description': 'Clean and modern city-state',
            'reviews': 15670,
          },
        ];
        _filteredDestinations = List.from(_allDestinations);
        if (_allDestinations.isNotEmpty) {
          _maxPrice = _allDestinations.map((d) => d['price'] as int).reduce((a, b) => a > b ? a : b).toDouble();
        }
        _isLoading = false;
        _applyFilters();
        });
      }
    });
  }

  void _filterDestinations() {
    _applyFilters();
  }

  void _applyFilters() {
    setState(() {
      _filteredDestinations = _allDestinations.where((destination) {
        // Search filter
        final searchQuery = _searchController.text.toLowerCase();
        if (searchQuery.isNotEmpty) {
          final city = destination['city'].toString().toLowerCase();
          final country = destination['country'].toString().toLowerCase();
          if (!city.contains(searchQuery) && !country.contains(searchQuery)) {
            return false;
          }
        }

        // Category filter
        if (_filterCategory != 'all') {
          if (_filterCategory == 'hot-deals' && !destination['isHotDeal']) {
            return false;
          }
          if (_filterCategory != 'hot-deals' && destination['category'] != _filterCategory) {
            return false;
          }
        }

        // Price filter
        final price = destination['price'] as int;
        if (price < _minPrice || price > _maxPrice) {
          return false;
        }

        // Rating filter
        final rating = destination['rating'] as double;
        if (rating < _minRating) {
          return false;
        }

        return true;
      }).toList();

      // Sort
      _sortDestinations();
    });
  }

  void _sortDestinations() {
    switch (_sortBy) {
      case 'price-low':
        _filteredDestinations.sort((a, b) => (a['price'] as int).compareTo(b['price'] as int));
        break;
      case 'price-high':
        _filteredDestinations.sort((a, b) => (b['price'] as int).compareTo(a['price'] as int));
        break;
      case 'rating':
        _filteredDestinations.sort((a, b) => (b['rating'] as double).compareTo(a['rating'] as double));
        break;
      case 'name':
        _filteredDestinations.sort((a, b) => (a['city'] as String).compareTo(b['city'] as String));
        break;
      default:
        // Keep original order
        break;
    }
  }

  void _toggleFavorite(String city) {
    setState(() {
      if (_favorites.contains(city)) {
        _favorites.remove(city);
      } else {
        _favorites.add(city);
      }
    });
  }

  Future<void> _refreshDestinations() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    _applyFilters();
    if (!mounted) return;
    setState(() {
      _isLoading = false;
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
        title: const Text(
          "Discover Destinations",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
            tooltip: _isGridView ? 'List View' : 'Grid View',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
            tooltip: 'Filters',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshDestinations,
        color: Colors.teal,
        child: CustomScrollView(
          slivers: [
            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search destinations...',
                    prefixIcon: const Icon(Icons.search, color: Colors.teal),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.teal),
                            onPressed: () {
                              _searchController.clear();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.teal, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ),

            // Category Chips
            SliverToBoxAdapter(
              child: SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildCategoryChip('all', 'All', Icons.public),
                    _buildCategoryChip('hot-deals', 'Hot Deals', Icons.local_fire_department),
                    _buildCategoryChip('budget', 'Budget', Icons.attach_money),
                    _buildCategoryChip('luxury', 'Luxury', Icons.diamond),
                    _buildCategoryChip('beach', 'Beach', Icons.beach_access),
                    _buildCategoryChip('city', 'City', Icons.location_city),
                  ],
                ),
              ),
            ),

            // Filters Panel
            if (_showFilters)
              SliverToBoxAdapter(
                child: _buildFiltersPanel(),
              ),

            // Results Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_filteredDestinations.length} destination${_filteredDestinations.length != 1 ? 's' : ''} found',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.sort, color: Colors.teal),
                      onSelected: (value) {
                        setState(() {
                          _sortBy = value;
                          _applyFilters();
                        });
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'default', child: Text('Default')),
                        const PopupMenuItem(value: 'price-low', child: Text('Price: Low to High')),
                        const PopupMenuItem(value: 'price-high', child: Text('Price: High to Low')),
                        const PopupMenuItem(value: 'rating', child: Text('Highest Rating')),
                        const PopupMenuItem(value: 'name', child: Text('Name A-Z')),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Loading State
            if (_isLoading)
              const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                  ),
                ),
              )
            // Destinations Grid/List
            else if (_filteredDestinations.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No destinations found',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Try adjusting your filters',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (_isGridView)
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final destination = _filteredDestinations[index];
                      return _buildDestinationCard(destination, true);
                    },
                    childCount: _filteredDestinations.length,
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final destination = _filteredDestinations[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildDestinationCard(destination, false),
                      );
                    },
                    childCount: _filteredDestinations.length,
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => HomePage()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            );
          }
        },
      ),
    );
  }

  Widget _buildCategoryChip(String category, String label, IconData icon) {
    final isSelected = _filterCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : Colors.teal),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(fontFamily: 'Poppins', color: isSelected ? Colors.white : Colors.teal)),
          ],
        ),
        onSelected: (selected) {
          setState(() {
            _filterCategory = category;
            _applyFilters();
          });
        },
        selectedColor: Colors.teal,
        checkmarkColor: Colors.white,
        backgroundColor: Colors.white,
        side: BorderSide(color: Colors.teal, width: 1.5),
      ),
    );
  }

  Widget _buildFiltersPanel() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filters',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _minPrice = 0;
                    _maxPrice = _allDestinations.isNotEmpty
                        ? _allDestinations.map((d) => d['price'] as int).reduce((a, b) => a > b ? a : b).toDouble()
                        : 1000;
                    _minRating = 0;
                    _applyFilters();
                  });
                },
                child: const Text('Reset', style: TextStyle(fontFamily: 'Poppins')),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Price Range: \$${_minPrice.toInt()} - \$${_maxPrice.toInt()}',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          RangeSlider(
            values: RangeValues(_minPrice, _maxPrice > 1000 ? 1000 : _maxPrice),
            min: 0,
            max: _maxPrice > 1000 ? _maxPrice : 1000,
            divisions: 20,
            onChanged: (values) {
              setState(() {
                _minPrice = values.start;
                _maxPrice = values.end;
                _applyFilters();
              });
            },
            activeColor: Colors.teal,
          ),
          const SizedBox(height: 20),
          Text(
            'Minimum Rating: ${_minRating.toStringAsFixed(1)}',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          Slider(
            value: _minRating,
            min: 0,
            max: 5,
            divisions: 10,
            onChanged: (value) {
              setState(() {
                _minRating = value;
                _applyFilters();
              });
            },
            activeColor: Colors.teal,
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationCard(Map<String, dynamic> destination, bool isGrid) {
    final city = destination['city'] ?? '';
    final country = destination['country'] ?? '';
    final price = destination['price'] ?? 0;
    final rating = destination['rating'] ?? 0.0;
    final isHotDeal = destination['isHotDeal'] ?? false;
    final image = destination['image'] ?? 'assets/images/dubai.jpg';
    final reviews = destination['reviews'] ?? 0;
    final isFavorite = _favorites.contains(city);

    if (isGrid) {
      return _buildGridCard(city, country, price, rating, isHotDeal, image, reviews, isFavorite);
    } else {
      return _buildListCard(city, country, price, rating, isHotDeal, image, reviews, isFavorite);
    }
  }

  Widget _buildGridCard(String city, String country, int price, double rating, bool isHotDeal, String image, int reviews, bool isFavorite) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FlightSearchPage(
              selectedCity: city,
              selectedCountry: country,
            ),
          ),
        );
      },
      child: Hero(
        tag: city,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // Image
                Positioned.fill(
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image, size: 50, color: Colors.grey),
                      );
                    },
                  ),
                ),
                // Gradient overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ),
                // Favorite button
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () => _toggleFavorite(city),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                // Hot Deal badge
                if (isHotDeal)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.local_fire_department, color: Colors.white, size: 14),
                          SizedBox(width: 4),
                          Text(
                            'HOT DEAL',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Content
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          city,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.white70, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              country,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              rating.toStringAsFixed(1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '(${_formatNumber(reviews)})',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '\$$price',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
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
        ),
      ),
    );
  }

  Widget _buildListCard(String city, String country, int price, double rating, bool isHotDeal, String image, int reviews, bool isFavorite) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FlightSearchPage(
              selectedCity: city,
              selectedCountry: country,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: Image.asset(
                image,
                width: 120,
                height: 140,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 120,
                    height: 140,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, size: 40, color: Colors.grey),
                  );
                },
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (isHotDeal)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'HOT DEAL',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (isHotDeal) const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            city,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _toggleFavorite(city),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.grey, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          country,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 13,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${_formatNumber(reviews)})',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 11,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '\$$price',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                            fontFamily: 'Poppins',
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

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return number.toString();
  }
}
