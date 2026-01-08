import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/cubit/auth_cubit.dart';
import 'home_page.dart';
import 'entering.dart';

class AuthChecker extends StatefulWidget {
  const AuthChecker({super.key});

  @override
  State<AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  @override
  void initState() {
    super.initState();
    // Check auth status when this widget is created
    context.read<AuthCubit>().checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          // Show loading while checking auth
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF2563EB),
              ),
            ),
          );
        } else if (state is AuthAuthenticated) {
          // User is logged in, go directly to home
          return const HomePage();
        } else {
          // User is not logged in, show entering page
          return const Entering();
        }
      },
    );
  }
}