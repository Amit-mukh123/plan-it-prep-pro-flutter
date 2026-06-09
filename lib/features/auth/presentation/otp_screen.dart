import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:ileum/core/theme/app_theme.dart';
import 'package:ileum/features/auth/data/auth_provider.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _pinController = TextEditingController();
  final _focusNode = FocusNode();

  // Retrieving arguments passed from previous screen
  // Arguments are expected as a Map or similar; defaulting isRegister to false
  final String email = Get.arguments?['email'] ?? "your email";
  final bool isRegister = Get.arguments?['isRegister'] ?? false;

  @override
  void dispose() {
    _pinController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _handleVerifyOtp() async {
    String otp = _pinController.text;

    if (otp.length < 6) {
      Get.snackbar(
        "Invalid OTP",
        "Please enter the full 6-digit code",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    final Map<String, dynamic> body = {"email": email, "otp": otp};

    final bool isSuccess = await ref
        .read(authProvider.notifier)
        .verifyOtp(body);

    if (isSuccess) {
      Get.snackbar(
        "Verified",
        "OTP Verified Successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.primary,
        colorText: Colors.white,
      );

      // Conditional navigation based on isRegister flag
      if (isRegister) {
        Get.offAllNamed('/profile-setup');
      } else {
        Get.offAllNamed('/main-shell');
      }
    } else {
      Get.snackbar(
        "Verification Failed",
        "Invalid OTP code, please try again",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      // Optional: Navigate back to login if required by logic
      Get.offAllNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded),
                padding: EdgeInsets.zero,
              ),
              const SizedBox(height: 24),
              Text(
                'Verify your email',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 6),
              RichText(
                text: TextSpan(
                  text: 'We sent a 6-digit code to ',
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                  children: [
                    TextSpan(
                      text: email,
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Pinput(
                  length: 6,
                  controller: _pinController,
                  focusNode: _focusNode,
                  enabled: !isLoading,
                  defaultPinTheme: PinTheme(
                    width: 52,
                    height: 56,
                    textStyle: GoogleFonts.dmSans(
                      fontSize: 22,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.outlineStrong,
                        width: 1.5,
                      ),
                    ),
                  ),
                  focusedPinTheme: PinTheme(
                    width: 52,
                    height: 56,
                    textStyle: GoogleFonts.dmSans(
                      fontSize: 22,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                  ),
                  onCompleted: (pin) {
                    if (!isLoading) {
                      _handleVerifyOtp();
                    }
                  },
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _handleVerifyOtp,
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Verify & Continue'),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Didn't receive? ",
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                    children: [
                      TextSpan(
                        text: 'Resend OTP',
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
