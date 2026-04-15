import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class MealDetailScreen extends StatelessWidget {
  const MealDetailScreen({super.key});

  // Helper to safely parse the background color string
  Color _parseColor(dynamic colorData) {
    try {
      if (colorData == null) return AppColors.primaryContainer;
      String colorStr = colorData.toString();
      if (colorStr.startsWith('#')) {
        colorStr = colorStr.replaceFirst('#', '0xFF');
      } else if (!colorStr.startsWith('0x')) {
        colorStr = '0xFF$colorStr';
      }
      return Color(int.parse(colorStr));
    } catch (e) {
      return AppColors.primaryContainer; // Fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> meal = Get.arguments ?? {};

    // Defensive parsing for lists and basic types
    final List<String> ingredients = List<String>.from(
      meal['ingredients'] ?? [],
    );
    final List<String> steps = List<String>.from(meal['steps'] ?? []);
    final List<String> tags = List<String>.from(meal['tags'] ?? []);
    final Color bgColor = _parseColor(meal['bgColor']);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Hero Image Section
            Stack(
              children: [
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: bgColor.withOpacity(
                      0.2,
                    ), // Use opacity for better contrast
                  ),
                  child: Center(
                    child: Text(
                      meal['emoji'] ?? '🍲',
                      style: const TextStyle(fontSize: 80),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _CircleButton(
                        icon: Icons.arrow_back_rounded,
                        onTap: () => Get.back(),
                      ),
                      _CircleButton(
                        icon: Icons.favorite_border_rounded,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Content Section
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Header info
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                meal['name'] ?? 'Unknown Meal',
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${tags.isNotEmpty ? tags.join(' · ') : 'Healthy'} · ${meal['prepTime'] ?? 0} mins',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        NutriBadge.cal('${meal['calories'] ?? 0} kcal'),
                      ],
                    ),

                    const SizedBox(height: 20),
                    // Nutrition Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _NutriStat(
                          value: '${meal['protein'] ?? 0}g',
                          label: 'Protein',
                          color: AppColors.proText,
                        ),
                        _NutriStat(
                          value: '${meal['carbs'] ?? 0}g',
                          label: 'Carbs',
                          color: AppColors.carbText,
                        ),
                        _NutriStat(
                          value: '${meal['fat'] ?? 0}g',
                          label: 'Fat',
                          color: AppColors.fatText,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),

                    // Ingredients Section
                    Text(
                      'Ingredients',
                      style: GoogleFonts.dmSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ingredients
                          .map((ing) => _IngredientChip(label: ing))
                          .toList(),
                    ),

                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),

                    // Instructions (Steps) Section
                    Text(
                      'Instructions',
                      style: GoogleFonts.dmSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (steps.isEmpty)
                      const Text("No instructions provided.")
                    else
                      ...steps.asMap().entries.map(
                        (e) => _StepItem(
                          number: e.key + 1,
                          text: e.value,
                          isLast: e.key == steps.length - 1,
                        ),
                      ),

                    const SizedBox(height: 32),

                    // Bottom Action Button
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.add_task_rounded),
                        label: const Text(
                          'Add to Log',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── REUSABLE INTERNAL WIDGETS ────────────────────────────────────

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: Icon(icon, size: 22, color: AppColors.textPrimary),
      ),
    );
  }
}

class _NutriStat extends StatelessWidget {
  final String value, label;
  final Color color;
  const _NutriStat({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.28,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.dmSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _IngredientChip extends StatelessWidget {
  final String label;
  const _IngredientChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final int number;
  final String text;
  final bool isLast;

  const _StepItem({
    required this.number,
    required this.text,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: AppColors.primaryContainer,
            child: Text(
              '$number',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.dmSans(
                fontSize: 14,
                height: 1.5,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
