import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:ileum/core/theme/app_theme.dart';
import 'package:ileum/features/auth/data/auth_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final bool isRegister = Get.arguments?['isRegister'] ?? false;
  bool _loginWithOtp = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    if (_loginWithOtp) {
      final Map<String, dynamic> body = {
        "email": _emailController.text.trim(),
      };

      final bool isSuccess = await ref.read(authProvider.notifier).login(body);

      if (isSuccess) {
        Get.offNamed(
          '/verify-otp',
          arguments: {
            'email': _emailController.text.trim(),
            'isRegister': isRegister,
          },
        );
      } else {
        Get.snackbar(
          "Account not found",
          "Please register to continue",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orangeAccent,
          colorText: Colors.white,
        );
        Get.toNamed('/register');
      }
    } else {
      final Map<String, dynamic> body = {
        "email": _emailController.text.trim(),
        "password": _passwordController.text,
      };

      final bool isSuccess = await ref.read(authProvider.notifier).loginWithPassword(body);

      if (isSuccess) {
        if (isRegister) {
          Get.offAllNamed('/profile-setup');
        } else {
          Get.offAllNamed('/main-shell');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),
                      _buildHeader(),
                      const SizedBox(height: 32),
                      const _Label('Email Address'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        enabled: !isLoading,
                        keyboardType: TextInputType.emailAddress,
                        style: GoogleFonts.dmSans(
                          fontSize: 15,
                          color: AppColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter your email address',
                          filled: true,
                          fillColor: AppColors.surface,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.outlineStrong,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Enter your email address";
                          }
                          if (!GetUtils.isEmail(val)) {
                            return "Enter a valid email address";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      if (!_loginWithOtp) ...[
                        const _Label('Password'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController,
                          enabled: !isLoading,
                          obscureText: true,
                          style: GoogleFonts.dmSans(
                            fontSize: 15,
                            color: AppColors.textPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter your password',
                            filled: true,
                            fillColor: AppColors.surface,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.outlineStrong,
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                          ),
                          validator: (val) {
                            if (!_loginWithOtp) {
                              if (val == null || val.isEmpty) {
                                return "Enter your password";
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                      Row(
                        children: [
                          Checkbox(
                            value: _loginWithOtp,
                            activeColor: AppColors.primary,
                            onChanged: isLoading
                                ? null
                                : (val) {
                                    setState(() {
                                      _loginWithOtp = val ?? false;
                                    });
                                  },
                          ),
                          Text(
                            "Login with OTP",
                            style: GoogleFonts.dmSans(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.login_rounded, size: 20),
                                    const SizedBox(width: 10),
                                    Text(
                                      _loginWithOtp ? 'Send OTP' : 'Login',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: GestureDetector(
                          onTap: () => Get.toNamed('/register'),
                          child: RichText(
                            text: TextSpan(
                              text: "Don't have an account? ",
                              style: GoogleFonts.dmSans(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Sign up',
                                  style: GoogleFonts.dmSans(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            final Uri url = Uri.parse('https://planit-prep-web.vercel.app/privacy-policy');
                            if (!await launchUrl(url)) {
                              debugPrint('Could not launch $url');
                            }
                          },
                          child: Text(
                            "Privacy Policy",
                            style: GoogleFonts.dmSans(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.eco_rounded, color: AppColors.primary, size: 28),
            const SizedBox(width: 8),
            Text(
              'FitPumpkin',
              style: GoogleFonts.dmSerifDisplay(
                fontSize: 22,
                color: AppColors.primaryDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text('Welcome back', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 4),
        Text(
          'Enter your email address to continue',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: GoogleFonts.dmSans(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: AppColors.textSecondary,
    ),
  );
}

