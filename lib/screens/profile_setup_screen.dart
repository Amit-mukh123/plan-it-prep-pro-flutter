import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planit_prep_pro/providers/user_summary_state_provider.dart';
import 'package:planit_prep_pro/screens/home_screen.dart';
import '../theme/app_theme.dart';
import '../providers/user_provider.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  // --- TextEditingControllers ---
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _targetWeightController = TextEditingController();

  // --- Selection State ---
  int _dietIndex = 0;
  String? _selectedGender;

  final _diets = ['Vegetarian', 'Non-Veg', 'Vegan'];
  final _dietIcons = [Icons.spa_rounded, Icons.egg_rounded, Icons.eco_rounded];
  final _genders = ['Male', 'Female', 'Other', 'Prefer not to say'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bool isEdited = Get.arguments?['isEdited'] ?? false;
      if (isEdited) {
        print("call kiya re munna");
        final userData = ref.read(userSummaryProvider)['data'];
        if (userData != null) {
          _fullNameController.text = (userData['name'] ?? "").toString();
          _ageController.text = safeInt(userData['age'] ?? "").toString();
          _heightController.text = safeInt(
            userData['height'] ?? "",
          ).toString();
          _weightController.text = safeInt(
            userData['weight'] ?? "",
          ).toString();
          _targetWeightController.text = safeInt(
            userData['target_weight'] ?? "",
          ).toString();

          final String gender = userData['gender'] ?? "";
          if (_genders.contains(gender)) {
            setState(() => _selectedGender = gender);
          }

          final String diet = userData['dietType'] ?? "";
          final index = _diets.indexWhere(
            (d) => d.toLowerCase() == diet.toLowerCase(),
          );
          if (index != -1) {
            setState(() => _dietIndex = index);
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  /// Logic to capture inputs and call the storeUserProfileDetails function
  Future<void> _handleSaveProfile() async {
    // Basic validation
    if (_fullNameController.text.trim().isEmpty || _selectedGender == null) {
      Get.snackbar(
        "Required Fields",
        "Please fill in your name and gender",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orangeAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    // Body formatted with "data" -> "answers" nesting
    final Map<String, dynamic> body = {
      "data": {
        "full_name": _fullNameController.text.trim(),
        "gender": _selectedGender,
        "age": _ageController.text.trim(),
        "height": _heightController.text.trim(),
        "weight": _weightController.text.trim(),
        "target_weight": _targetWeightController.text.trim(),
        "diet": _diets[_dietIndex],
      },
    };

    // Call the store function from UserController via Riverpod
    final bool isSuccess = await ref
        .read(userControllerProvider.notifier)
        .storeUserProfileDetails(body);

    if (isSuccess) {
      final bool isEdited = Get.arguments?['isEdited'] ?? false;
      if (isEdited) {
        Get.offAllNamed('/main-shell');
      } else {
        Get.offNamed('/user-goal');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the loading state (the boolean state of UserController)
    final isLoading = ref.watch(userControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Set up your profile',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                'Tell us about yourself to personalize your plan',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),

              // Avatar upload (Static UI)
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text('👤', style: TextStyle(fontSize: 36)),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.surface,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const _Label('Full Name'),
              const SizedBox(height: 6),
              TextField(
                controller: _fullNameController,
                enabled: !isLoading,
                decoration: const InputDecoration(hintText: 'Enter Name'),
              ),
              const SizedBox(height: 12),

              const _Label('Gender'),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                items: _genders.map((String gender) {
                  return DropdownMenuItem(value: gender, child: Text(gender));
                }).toList(),
                onChanged: isLoading
                    ? null
                    : (value) => setState(() => _selectedGender = value),
                decoration: const InputDecoration(hintText: 'Select Gender'),
                dropdownColor: AppColors.surface,
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _Label('Age'),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _ageController,
                          enabled: !isLoading,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(hintText: '00'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _Label('Height (cm)'),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _heightController,
                          enabled: !isLoading,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(hintText: '00'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              const _Label('Weight (kg)'),
              const SizedBox(height: 6),
              TextField(
                controller: _weightController,
                enabled: !isLoading,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: '00'),
              ),
              const SizedBox(height: 12),

              const _Label('Target Weight (kg)'),
              const SizedBox(height: 6),
              TextField(
                controller: _targetWeightController,
                enabled: !isLoading,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: '00'),
              ),
              const SizedBox(height: 16),

              Text(
                'Diet Preference',
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: List.generate(_diets.length, (i) {
                  final active = _dietIndex == i;
                  return GestureDetector(
                    onTap: isLoading
                        ? null
                        : () => setState(() => _dietIndex = i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: active
                            ? AppColors.primaryContainer
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: active
                              ? AppColors.primary
                              : AppColors.outlineStrong,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _dietIcons[i],
                            size: 16,
                            color: active
                                ? AppColors.primaryDark
                                : AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _diets[i],
                            style: GoogleFonts.dmSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: active
                                  ? AppColors.primaryDark
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _handleSaveProfile,
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
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
