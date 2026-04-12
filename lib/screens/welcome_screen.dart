import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const _emojis = ['🥗', '🍎', '🥦', '🍳', null, '🍇', '🥑', '🫐', '🍋'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Hero section
            Expanded(
              child: Container(
                color: AppColors.primaryContainer,
                child: Center(
                  child: SizedBox(
                    width: 200,
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                          ),
                      itemCount: _emojis.length,
                      itemBuilder: (_, i) {
                        final e = _emojis[i];
                        return Container(
                          decoration: BoxDecoration(
                            color: e == null
                                ? AppColors.primary
                                : Colors.white.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: e == null
                                ? const Icon(
                                    Icons.eco_rounded,
                                    color: Colors.white,
                                    size: 28,
                                  )
                                : Text(e, style: const TextStyle(fontSize: 28)),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            // Content section
            Container(
              color: AppColors.bg,
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your AI Nutrition\nCompanion',
                    style: GoogleFonts.dmSerifDisplay(
                      fontSize: 32,
                      height: 1.2,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Plan meals, track nutrition, and stay healthy — all in one place.',
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () => Get.toNamed('/register'),
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: const Text('Get Started'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      ),
                      child: const Text('Log In'),
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
