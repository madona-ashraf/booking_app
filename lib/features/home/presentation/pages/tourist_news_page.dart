import 'package:flutter/material.dart';

class TouristNewsPage extends StatelessWidget {
  const TouristNewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Luxury Destinations',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildFeaturedDestination(
            'Maldives Private Islands',
            'Experience ultimate luxury in overwater villas with private pools',
            'assets/images/maldives.jpg',
            ['5-star resorts', 'Private beaches', 'Underwater restaurants'],
          ),
          const SizedBox(height: 24),
          _buildFeaturedDestination(
            'Swiss Alps Luxury Chalets',
            'Exclusive mountain retreats with panoramic views',
            'assets/images/swiss_alps.jpg',
            ['Personal butler', 'Helicopter transfer', 'Spa services'],
          ),
          const SizedBox(height: 24),
          _buildFeaturedDestination(
            'Dubai\'s Burj Al Arab',
            'The world\'s most luxurious hotel experience',
            'assets/images/dubai.jpg',
            ['Royal suite', '24k gold iPads', 'Rolls-Royce fleet'],
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedDestination(
    String title,
    String description,
    String imagePath,
    List<String> features,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with gradient overlay
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 16),
                ...features.map((feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.teal, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            feature,
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}