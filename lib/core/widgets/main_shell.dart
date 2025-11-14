import 'package:flutter/material.dart';
import '../../features/booking/presentation/pages/flight_search_page.dart';
import '../../features/auth/presentation/pages/profile_page.dart';
import '../../features/home/presentation/pages/tourist_news_page.dart';
import 'app_bottom_navigation.dart';

class MainShell extends StatefulWidget {
  final int initialIndex;
  
  const MainShell({super.key, this.initialIndex = 0});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _currentIndex;
  
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _pages = const [
    FlightSearchPage(),
    ProfilePage(),
    TouristNewsPage(),
  ];

  void _onTap(int idx) {
    if (idx == _currentIndex) return;
    setState(() {
      _currentIndex = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
