import "package:bookingapp/features/auth/presentation/pages/login_page.dart";
import 'package:flutter/material.dart';
import '../../../auth/presentation/pages/register_page.dart';
import 'package:bookingapp/core/widgets/app_drawer.dart';
 
 

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          // Page background
          Positioned.fill(
            child: Image.asset('assets/images/home_bg.jpg', fit: BoxFit.cover),
          ),

          // Light gradient for text clarity
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.2),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // (Icon row removed)
                  const SizedBox(height: 10),

                  // Menu button (top-left) to open Drawer
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Builder(
                      builder: (context) {
                        return IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 4),

                  // App wordmark logo (left-aligned, small and simple)
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'SkyBooker',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  const Spacer(),

                  // Welcome text
                  const Text(
                    "Discover Your Next Flight",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    "Find the best deals and explore destinations easily.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Search Flights button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 8,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Create Account button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterPage(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        "Create Account",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
