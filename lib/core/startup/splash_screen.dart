import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ileum/core/theme/app_theme.dart';
import 'package:ileum/features/auth/data/auth_provider.dart'; // Assuming your authControllerProvider is defined here

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    // Wait for the minimum splash duration (2 seconds)
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Call checkAuth to refresh state from storage
    await ref.read(authProvider.notifier).checkAuth();

    // Read the updated auth state
    final authState = ref.read(authProvider);

    if (mounted) {
      if (authState.isLoggedIn) {
        Navigator.of(context).pushReplacementNamed('/main-shell');
      } else {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.eco_rounded,
                size: 44,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'PlanitPrep',
              style: GoogleFonts.dmSerifDisplay(
                fontSize: 36,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Smart Nutrition. Smarter Living.',
              style: GoogleFonts.dmSans(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.75),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
