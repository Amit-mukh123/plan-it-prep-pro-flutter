import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'common_widgets.dart';

class MealCard extends StatelessWidget {
  final Map<String, dynamic> mealData;
  final VoidCallback onTap;
  final VoidCallback onChangeTap;

  const MealCard({
    super.key,
    required this.mealData,
    required this.onTap,
    required this.onChangeTap,
  });

  @override
  Widget build(BuildContext context) {
    // Parse color from hex string in JSON
    final Color bgColor = Color(int.parse(mealData['bgColor']));

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Entire card is wrapped in a GestureDetector for navigation
          // We use InkWell or a nested GestureDetector inside the Row to ensure
          // specific elements (like the swap button) can have their own logic.
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: onTap,
              child: Row(
                children: [
                  // Emoji thumbnail from JSON
                  Container(
                    width: 82,
                    height: 88,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        mealData['emoji'],
                        style: const TextStyle(fontSize: 36),
                      ),
                    ),
                  ),
                  // Content from JSON
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 11,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${mealData['mealType']} · ${mealData['time']}'
                                .toUpperCase(),
                            style: GoogleFonts.dmSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.4,
                              color: AppColors.textTertiary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            mealData['name'],
                            style: GoogleFonts.dmSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              NutriBadge.cal('${mealData['calories']} kcal'),
                              if (mealData['protein'] != null) ...[
                                const SizedBox(width: 4),
                                NutriBadge.protein(mealData['protein']),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Spacer to make room for the absolute positioned swap button if necessary
                  const SizedBox(width: 50),
                ],
              ),
            ),
          ),

          // Change button - Positioned to ensure it can be clicked independently
          Positioned(
            right: 10,
            top: 0,
            bottom: 0,
            child: Center(
              child: GestureDetector(
                onTap: onChangeTap,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.outlineStrong,
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.swap_horiz_rounded,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Add Meal Button ─────────────────────────────────
class AddMealButton extends StatelessWidget {
  final VoidCallback onTap;

  const AddMealButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.outlineStrong,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_circle_outline_rounded,
              size: 20,
              color: AppColors.primaryDark,
            ),
            const SizedBox(width: 8),
            Text(
              'Add Meal',
              style: GoogleFonts.dmSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
