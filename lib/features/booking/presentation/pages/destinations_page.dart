import 'package:flutter/material.dart';

class DestinationPage extends StatelessWidget {
  const DestinationPage({super.key});

  final List<Map<String, dynamic>> destinations = const [
    {
      "name": "The Nautilus Maldives",
      "image_url":
          "https://images.unsplash.com/photo-1505761671935-60b3a7427bad",
      "rate": 4.6,
      "description": "A luxury escape surrounded by crystal clear water.",
    },
    {
      "name": "Erin-Ijesha Falls - Nigeria",
      "image_url":
          "https://images.unsplash.com/photo-1508873535684-277a3cbcc4e4",
      "rate": 4.4,
      "description": "A layered waterfall located in serene Nigerian forest.",
    },
    {
      "name": "Sydney Opera House",
      "image_url":
          "https://images.unsplash.com/photo-1506976785307-8732e854ad77",
      "rate": 4.8,
      "description":
          "One of the most famous architectural landmarks in the world.",
    },
    {
      "name": "London Eye",
      "image_url":
          "https://images.unsplash.com/photo-1505761696007-177fa1a42e59",
      "rate": 4.5,
      "description": "An iconic ferris wheel offering breathtaking views.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Destinations"), centerTitle: true),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: destinations.length,
        itemBuilder: (context, index) {
          final place = destinations[index];

          return GestureDetector(
            onTap: () {},
            child: destinationCard(
              place["name"],
              place["image_url"],
              place["rate"].toString(),
            ),
          );
        },
      ),
    );
  }

  Widget destinationCard(String name, String imgUrl, String rate) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 200,
        margin: const EdgeInsets.only(bottom: 16),
        child: Stack(
          children: [
            Image.network(
              imgUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),

            Positioned(
              bottom: 16,
              left: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.yellow, size: 20),
                      Text(rate, style: const TextStyle(color: Colors.white)),
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
