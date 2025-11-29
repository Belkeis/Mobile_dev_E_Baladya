import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../logic/cubit/auth_cubit.dart';
import 'home_page.dart';

class Entering extends StatefulWidget {
  const Entering({super.key});

  @override
  State<Entering> createState() => _EnteringState();
}

class _EnteringState extends State<Entering> {
  bool _isPressed = false;
  bool _isLoading = false;

  Future<void> _autoLogin() async {
    setState(() => _isLoading = true);
    
    // Auto-login with default user (seeded in database)
    // Email: ahmed@example.com, Password: password123
    final authCubit = context.read<AuthCubit>();
    await authCubit.login('ahmed@example.com', 'password123');
    
    if (mounted) {
      setState(() => _isLoading = false);
      
      // Check if login was successful
      final state = authCubit.state;
      if (state is AuthAuthenticated) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        // If login fails, still navigate to home (guest mode)
        // In a real app, you might want to show an error
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 60),

            // Centered SVG logo
            Expanded(
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/logo.svg',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Bottom button
            Padding(
              padding: const EdgeInsets.only(bottom: 60.0),
              child: GestureDetector(
                onTapDown: (_) {
                  if (!_isLoading) {
                    setState(() => _isPressed = true);
                  }
                },
                onTapUp: (_) => setState(() => _isPressed = false),
                onTapCancel: () => setState(() => _isPressed = false),
                onTap: _isLoading ? null : _autoLogin,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 160,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _isPressed
                        ? const Color(0xFF1D4ED8)
                        : const Color(0xFF2563EB),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: _isLoading
                      ? const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        )
                      : const Center(
                          child: Text(
                            'ابدأ الآن',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
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