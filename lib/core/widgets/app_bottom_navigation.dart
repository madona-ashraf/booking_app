import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Use CurvedNavigationBar for a curved/convex-style bottom navigation.
    final items = <Widget>[
      Icon(
        currentIndex == 0 ? Icons.flight : Icons.flight_outlined,
        size: 24,
        color: currentIndex == 0 ? Colors.teal : Colors.grey,
      ),
      Icon(
        currentIndex == 1 ? Icons.person : Icons.person_outline,
        size: 24,
        color: currentIndex == 1 ? Colors.teal : Colors.grey,
      ),
      Icon(
        currentIndex == 2 ? Icons.newspaper : Icons.newspaper_outlined,
        size: 24,
        color: currentIndex == 2 ? Colors.teal : Colors.grey,
      ),
    ];

    return CurvedNavigationBar(
      index: currentIndex,
      items: items,
      onTap: onTap,
      color: Colors.white,
      buttonBackgroundColor: Colors.teal,
      backgroundColor: Colors.transparent,
      height: 60,
      animationDuration: const Duration(milliseconds: 300),
      animationCurve: Curves.easeInOut,
    );
  }
}
