import 'package:flutter/material.dart';

import '../../../../core/models/tourist_attraction.dart';
import '../../bookingengine/fligthrepo/amadeus_poi_service.dart';

class PlaceSearchResultsPage extends StatefulWidget {
  final String placeName;
  final double latitude;
  final double longitude;

  const PlaceSearchResultsPage({
    super.key,
    required this.placeName,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<PlaceSearchResultsPage> createState() => _PlaceSearchResultsPageState();
}

class _PlaceSearchResultsPageState extends State<PlaceSearchResultsPage> {
  final AmadeusPoiService _poiService = AmadeusPoiService();
  List<TouristAttraction> _attractions = [];
  List<TouristAttraction> _sortedAttractions = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _selectedSort = 'Recommended';

  @override
  void initState() {
    super.initState();
    _loadAttractions();
  }

  Future<void> _loadAttractions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final attractions = await _poiService.fetchAttractions(
        widget.latitude,
        widget.longitude,
      );

      // If no attractions from API, use fallback mock data
      if (attractions.isEmpty) {
        _attractions = _getFallbackAttractions();
      } else {
        _attractions = attractions;
      }

      _applySort(_selectedSort, updateState: false);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading attractions: $e');
      // Use fallback data on error
      _attractions = _getFallbackAttractions();
      _applySort(_selectedSort, updateState: false);
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fallback mock attractions when API doesn't return results
  List<TouristAttraction> _getFallbackAttractions() {
    return [
      TouristAttraction(
        id: '1',
        name: 'City Center',
        category: 'MONUMENT',
        latitude: widget.latitude + 0.01,
        longitude: widget.longitude + 0.01,
        description:
            'The heart of ${widget.placeName}, featuring historic architecture and cultural landmarks.',
        imageUrl: TouristAttraction.getImageUrlForCategory('MONUMENT'),
      ),
      TouristAttraction(
        id: '2',
        name: 'Central Park',
        category: 'PARK',
        latitude: widget.latitude - 0.01,
        longitude: widget.longitude - 0.01,
        description:
            'A beautiful park in ${widget.placeName} perfect for relaxation and outdoor activities.',
        imageUrl: TouristAttraction.getImageUrlForCategory('PARK'),
      ),
      TouristAttraction(
        id: '3',
        name: 'Historic Museum',
        category: 'MUSEUM',
        latitude: widget.latitude + 0.005,
        longitude: widget.longitude - 0.005,
        description:
            'Explore the rich history and culture of ${widget.placeName} at this renowned museum.',
        imageUrl: TouristAttraction.getImageUrlForCategory('MUSEUM'),
      ),
      TouristAttraction(
        id: '4',
        name: 'Main Cathedral',
        category: 'CATHEDRAL',
        latitude: widget.latitude - 0.005,
        longitude: widget.longitude + 0.005,
        description:
            'A stunning architectural masterpiece and important religious site in ${widget.placeName}.',
        imageUrl: TouristAttraction.getImageUrlForCategory('CATHEDRAL'),
      ),
      TouristAttraction(
        id: '5',
        name: 'Shopping District',
        category: 'SHOPPING',
        latitude: widget.latitude + 0.008,
        longitude: widget.longitude + 0.008,
        description:
            'Discover local shops, markets, and boutiques in ${widget.placeName}\'s vibrant shopping area.',
        imageUrl: TouristAttraction.getImageUrlForCategory('SHOPPING'),
      ),
    ];
  }

  void _applySort(String sortOption, {bool updateState = true}) {
    List<TouristAttraction> sorted = List.from(_attractions);

    switch (sortOption) {
      case 'Nearest':
        sorted.sort((a, b) => _distanceTo(a).compareTo(_distanceTo(b)));
        break;
      case 'Farthest':
        sorted.sort((a, b) => _distanceTo(b).compareTo(_distanceTo(a)));
        break;
      case 'Alphabetical':
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
      default:
        break;
    }

    if (updateState) {
      setState(() => _sortedAttractions = sorted);
    } else {
      _sortedAttractions = sorted;
    }
  }

  double _distanceTo(TouristAttraction attraction) {
    final dx = attraction.latitude - widget.latitude;
    final dy = attraction.longitude - widget.longitude;
    return (dx * dx) + (dy * dy);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.placeName),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadAttractions,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
              : _sortedAttractions.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_off, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'No attractions found for ${widget.placeName}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Place header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.1),
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.teal.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.teal,
                              size: 28,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.placeName,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_attractions.length} attractions found',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Sort & list
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sort by',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        DropdownButton<String>(
                          value: _selectedSort,
                          items: const [
                            DropdownMenuItem(
                              value: 'Recommended',
                              child: Text('Recommended'),
                            ),
                            DropdownMenuItem(
                              value: 'Nearest',
                              child: Text('Nearest'),
                            ),
                            DropdownMenuItem(
                              value: 'Farthest',
                              child: Text('Farthest'),
                            ),
                            DropdownMenuItem(
                              value: 'Alphabetical',
                              child: Text('Alphabetical'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() => _selectedSort = value);
                            _applySort(value);
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _sortedAttractions.length,
                      itemBuilder: (context, index) {
                        final attraction = _sortedAttractions[index];
                        return _AttractionCard(attraction: attraction);
                      },
                    ),
                  ),
                ],
              ),
    );
  }
}

class _AttractionCard extends StatelessWidget {
  final TouristAttraction attraction;

  const _AttractionCard({required this.attraction});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child:
                attraction.imageUrl != null && attraction.imageUrl!.isNotEmpty
                    ? Image.network(
                      attraction.imageUrl!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey,
                          ),
                        );
                      },
                    )
                    : Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.place,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and category
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        attraction.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        attraction.category,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.teal[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Description
                if (attraction.description != null &&
                    attraction.description!.isNotEmpty)
                  Text(
                    attraction.description!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                const SizedBox(height: 12),

                // Location info
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '${attraction.latitude.toStringAsFixed(4)}, ${attraction.longitude.toStringAsFixed(4)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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
