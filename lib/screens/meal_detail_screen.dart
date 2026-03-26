import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class MealDetailScreen extends StatelessWidget {
  const MealDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve the JSON map passed from the MealCard
    final Map<String, dynamic> meal = Get.arguments;

    final List<String> ingredients = List<String>.from(meal['ingredients']);
    final List<String> steps = List<String>.from(meal['steps']);
    final Color bgColor = Color(int.parse(meal['bgColor']));

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          // Hero image section using JSON data
          Stack(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                color: bgColor,
                child: Center(
                  child: Text(
                    meal['emoji'],
                    style: const TextStyle(fontSize: 72),
                  ),
                ),
              ),
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.85),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_back_rounded,
                              size: 22, color: AppColors.textPrimary),
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.85),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.favorite_border_rounded,
                            size: 22, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Content section
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Badge from JSON
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              meal['name'],
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${meal['tags'].join(' · ')} · ${meal['prepTime']}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      NutriBadge.cal('${meal['calories']} kcal'),
                    ],
                  ),

                  // Nutri row from JSON
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Row(
                      children: [
                        NutriBox(
                            value: '${meal['calories']}',
                            label: 'kcal',
                            valueColor: AppColors.calText),
                        const SizedBox(width: 8),
                        NutriBox(
                            value: meal['protein'],
                            label: 'protein',
                            valueColor: AppColors.proText),
                        const SizedBox(width: 8),
                        NutriBox(
                            value: meal['carbs'],
                            label: 'carbs',
                            valueColor: AppColors.carbText),
                        const SizedBox(width: 8),
                        NutriBox(
                            value: meal['fat'],
                            label: 'fat',
                            valueColor: AppColors.fatText),
                      ],
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 10),

                  // Ingredients from JSON
                  Text('Ingredients',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: ingredients.map((ing) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(ing,
                                style: GoogleFonts.dmSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textPrimary)),
                            const SizedBox(width: 4),
                            const Icon(Icons.close_rounded,
                                size: 14, color: AppColors.textTertiary),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 10),

                  // Instructions from JSON
                  Text('Instructions',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 10),
                  ...steps.asMap().entries.map((e) => _StepItem(
                        number: e.key + 1,
                        text: e.value,
                        isLast: e.key == steps.length - 1,
                      )),
                  const SizedBox(height: 20),

                  // Action Button
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.add_rounded),
                            label: const Text('Add to Plan'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(color: AppColors.outline, width: 1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}