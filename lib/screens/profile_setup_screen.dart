import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'health_goals_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  // --- 1. TextEditingControllers for all text inputs ---
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _targetWeightController = TextEditingController();

  // --- 2. State variables for selection inputs ---
  int _dietIndex = 0;
  String? _selectedGender;

  final _diets = ['Vegetarian', 'Non-Veg', 'Vegan'];
  final _dietIcons = [Icons.spa_rounded, Icons.egg_rounded, Icons.eco_rounded];
  final _genders = ['Male', 'Female', 'Other', 'Prefer not to say'];

  // --- 3. JSON data state ---
  Map<String, dynamic> userData = {};

  // --- 4. Logic to capture all inputs and print JSON ---
  void saveUserData() {
    setState(() {
      userData = {
        "user_id": "11122",
        "data": {
          "full_name": _fullNameController.text,
          "gender": _selectedGender ?? "",
          "age": _ageController.text,
          "height": _heightController.text,
          "weight": _weightController.text,
          "target_weight": _targetWeightController.text,
          "diet": _diets[_dietIndex], // Captures currently selected diet string
        },
      };
    });

    // Print the final JSON structure
    print("User Data Captured: $userData");

    // Existing navigation logic
    Get.toNamed('/user-goal');
  }

  @override
  void dispose() {
    // Clean up controllers when the widget is removed from the tree
    _fullNameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      decoration: BoxDecoration(
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

              // Full name input
              _Label('Full Name'),
              const SizedBox(height: 6),
              TextField(
                controller: _fullNameController,
                decoration: const InputDecoration(hintText: 'Anika Sharma'),
              ),
              const SizedBox(height: 12),

              // Gender Dropdown
              _Label('Gender'),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                items: _genders.map((String gender) {
                  return DropdownMenuItem(value: gender, child: Text(gender));
                }).toList(),
                onChanged: (value) => setState(() => _selectedGender = value),
                decoration: const InputDecoration(hintText: 'Select Gender'),
                dropdownColor: AppColors.surface,
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
              ),
              const SizedBox(height: 12),

              // Age + Height row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Label('Age'),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(hintText: '24'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Label('Height (cm)'),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _heightController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(hintText: '165'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Weight input
              _Label('Weight (kg)'),
              const SizedBox(height: 6),
              TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: '60'),
              ),
              const SizedBox(height: 12),

              // Target Weight input
              _Label('Target Weight (kg)'),
              const SizedBox(height: 6),
              TextField(
                controller: _targetWeightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: '55'),
              ),
              const SizedBox(height: 16),

              // Diet preference selection
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
                    onTap: () => setState(() => _dietIndex = i),
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

              // Continue Button triggers saveUserData
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: saveUserData,
                  child: const Text('Continue'),
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
