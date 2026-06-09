import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ileum/features/user_profile/data/user_summary_state_provider.dart';
import 'package:ileum/core/theme/app_theme.dart';

class HealthGoalsScreen extends ConsumerStatefulWidget {
  const HealthGoalsScreen({super.key});

  @override
  ConsumerState<HealthGoalsScreen> createState() => _HealthGoalsScreenState();
}

class _HealthGoalsScreenState extends ConsumerState<HealthGoalsScreen> {
  int _selectedGoal = 0;
  double _calories = 1800;

  static const _goals = [
    _GoalOption(emoji: '⚖️', label: 'Lose Weight'),
    _GoalOption(emoji: '💪', label: 'Gain Muscle'),
    _GoalOption(emoji: '🧘', label: 'Maintain Weight'),
    _GoalOption(emoji: '🏃', label: 'Improve Fitness'),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bool isEdited = Get.arguments?['isEdited'] ?? false;
      if (isEdited) {
        final userData = ref.read(userSummaryProvider)['data'];
        final String savedGoal =
            userData['config']?['answers']?['health_goal'] ?? "";
        final int savedCals = userData['caloriesTotal'] ?? 1800;

        setState(() {
          _calories = savedCals.toDouble().clamp(1200.0, 3000.0);
          if (savedGoal.isNotEmpty) {
            _selectedGoal = _goals.indexWhere((g) => g.label == savedGoal);
            if (_selectedGoal == -1) _selectedGoal = 0;
          }
        });
      }
    });
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
                "What's your goal?",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                "We'll build your plan around it",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),

              // Goal grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.6,
                ),
                itemCount: _goals.length,
                itemBuilder: (_, i) {
                  final isSelected = _selectedGoal == i;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedGoal = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryContainer
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.outline,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            _goals[i].emoji,
                            style: const TextStyle(fontSize: 28),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _goals[i].label,
                              style: GoogleFonts.dmSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Calorie slider
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.07),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Calorie Target',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: SliderTheme(
                            data: SliderThemeData(
                              activeTrackColor: AppColors.primary,
                              inactiveTrackColor: AppColors.outline,
                              thumbColor: AppColors.primary,
                              overlayColor: AppColors.primary.withValues(
                                alpha: 0.1,
                              ),
                            ),
                            child: Slider(
                              min: 1200,
                              max: 3000,
                              value: _calories,
                              onChanged: (v) => setState(() => _calories = v),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            '${_calories.round()} kcal',
                            style: GoogleFonts.dmSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Access arguments to determine if we should pass isEdited true
                    final bool isEdited = Get.arguments?['isEdited'] ?? false;
                    Get.toNamed(
                      '/qs_and_ans',
                      arguments: {
                        'goal': _goals[_selectedGoal].label,
                        'isEdited': isEdited,
                      },
                    );
                  },
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Save Goals'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoalOption {
  final String emoji;
  final String label;
  const _GoalOption({required this.emoji, required this.label});
}
