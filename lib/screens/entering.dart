import 'package:flutter/material.dart';
import 'home_page.dart'; // updated import

class Entering extends StatefulWidget {
  const Entering({super.key});

  @override
  State<Entering> createState() => _EnteringState();
}

class _EnteringState extends State<Entering> {
  bool _isHovered = false; // for hover effect

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, 
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 80), // small top padding

            // Centered logo
            Center(
              child: Image.asset(
                'assets/images/logo.png',
                width: 220,
                height: 220,
                fit: BoxFit.contain,
              ),
            ),

            // Bottom button
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: MouseRegion(
                onEnter: (_) => setState(() => _isHovered = true),
                onExit: (_) => setState(() => _isHovered = false),
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 160,
                    height: 50,
                    decoration: BoxDecoration(
                      color: _isHovered
                          ? const Color(0xFF2563EB)
                          : Colors.transparent,
                      border: Border.all(color: const Color(0xFF2563EB), width: 3),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Center(
                      child: Text(
                        'ابدأ الآن',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color:
                              _isHovered ? Colors.white : const Color(0xFF2563EB),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
