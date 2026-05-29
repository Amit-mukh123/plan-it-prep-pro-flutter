import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ileum/core/theme/app_theme.dart';
import 'package:ileum/core/common/common_widgets.dart';

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
    // Robust Color Parsing
    final Color accentColor = _parseColor(mealData['bgColor']);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: accentColor.withValues(alpha: 0.1),
            highlightColor: Colors.transparent,
            child: SizedBox(
              height: 100,
              child: Row(
                children: [
                  // Leading Emoji Section
                  Container(
                    width: 90,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.6),
                    ),
                    child: Center(
                      child: Text(
                        mealData['emoji']?.toString() ?? '🍽️',
                        style: const TextStyle(fontSize: 38),
                      ),
                    ),
                  ),

                  // Middle Content Section
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${mealData['mealType'] ?? ''} • ${mealData['time'] ?? ''}'
                                .toUpperCase(),
                            style: GoogleFonts.dmSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                              color: AppColors.textTertiary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            mealData['name']?.toString() ?? 'Untitled Meal',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.dmSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              // 🔥 FIX: Explicitly convert to String to prevent TypeError
                              NutriBadge.cal(
                                '${mealData['calories']?.toString() ?? '0'} kcal',
                              ),
                              if (mealData['protein'] != null) ...[
                                const SizedBox(width: 6),
                                // 🔥 FIX: Ensure protein is passed as a string/expected type
                                NutriBadge.protein(
                                  mealData['protein'].toString(),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Action Button Section
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _SwapActionBtn(onTap: onChangeTap),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _parseColor(dynamic hex) {
    try {
      if (hex == null || hex is! String || !hex.startsWith('#')) {
        return const Color(0xFFE0E0E0);
      }
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (e) {
      return const Color(0xFFE0E0E0);
    }
  }
}

class _SwapActionBtn extends StatelessWidget {
  final VoidCallback onTap;
  const _SwapActionBtn({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.bg,
          border: Border.all(
            color: AppColors.outlineStrong.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: const Icon(
          Icons.swap_horiz_rounded,
          size: 18,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class AddMealButton extends StatelessWidget {
  final VoidCallback onTap;

  const AddMealButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primaryDark.withValues(alpha: 0.15),
              width: 1.5,
              style: BorderStyle.solid,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add_rounded,
                size: 20,
                color: AppColors.primaryDark,
              ),
              const SizedBox(width: 8),
              Text(
                'Add Extra Meal',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
