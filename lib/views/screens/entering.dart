import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'sign_up.dart';
import 'admin/admin_login_page.dart';
import '../../i18n/app_localizations.dart';
import '../../logic/cubit/language_cubit.dart';

class Entering extends StatefulWidget {
  const Entering({super.key});

  @override
  State<Entering> createState() => _EnteringState();
}

class _EnteringState extends State<Entering> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 24, right: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BlocBuilder<LanguageCubit, LanguageState>(
                    builder: (context, state) {
                      final isArabic = state.locale.languageCode == 'ar';
                      return GestureDetector(
                        onTap: () {
                          context.read<LanguageCubit>().toggleLanguage();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2563EB).withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFF2563EB).withOpacity(0.25),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            isArabic ? 'FR' : 'AR',
                            style: const TextStyle(
                              color: Color(0xFF2563EB),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
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

            // Buttons column
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0, left: 24, right: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // User sign up button
                  GestureDetector(
                    onTapDown: (_) {
                      setState(() => _isPressed = true);
                    },
                    onTapUp: (_) => setState(() => _isPressed = false),
                    onTapCancel: () => setState(() => _isPressed = false),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpPage()),
                      );
                    },
                    child: Stack(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: double.infinity,
                          height: 55,
                          decoration: BoxDecoration(
                            color: _isPressed
                                ? const Color(0xFF1D4ED8)
                                : const Color(0xFF2563EB),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2563EB)
                                    .withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: SizedBox.shrink(),
                          ),
                        ),
                        Positioned.fill(
                          child: Center(
                            child: Text(
                              localizations.translate('citizen_login'),
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Admin login button
                  GestureDetector(
                    onTapDown: (_) {
                      setState(() => _isPressed = true);
                    },
                    onTapUp: (_) => setState(() => _isPressed = false),
                    onTapCancel: () => setState(() => _isPressed = false),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AdminLoginPage()),
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        color: _isPressed
                            ? Colors.grey[200]
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF2563EB),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          localizations.translate('admin_login_button'),
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2563EB),
                          ),
                        ),
                      ),
                    ),
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