import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class ChangeMealSheet extends StatelessWidget {
  final String mealType;

  const ChangeMealSheet({super.key, required this.mealType});

  static void show(BuildContext context, String mealType) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => ChangeMealSheet(mealType: mealType),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outlineStrong,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Changing meal for',
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            mealType,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 20),

          // Generate with AI
          _SheetOption(
            iconBg: AppColors.primary,
            iconColor: Colors.white,
            icon: Icons.auto_awesome_rounded,
            containerBg: AppColors.primaryContainer,
            borderColor: AppColors.primary,
            title: 'Generate with AI',
            subtitle: 'AI picks the best meal for your goals',
            titleColor: AppColors.primaryDark,
            onTap: () => Navigator.pop(context),
          ),
          const SizedBox(height: 10),

          // From available ingredients
          _SheetOption(
            iconBg: const Color(0xFFFEF3C7),
            iconColor: const Color(0xFF92400E),
            icon: Icons.kitchen_rounded,
            containerBg: AppColors.surface,
            borderColor: AppColors.outlineStrong,
            title: 'From available ingredients',
            subtitle: "Use what's already in your kitchen",
            titleColor: AppColors.textPrimary,
            onTap: () => Navigator.pop(context),
          ),
          const SizedBox(height: 14),

          // Cancel
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
              ),
              child: Text(
                'Cancel',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetOption extends StatelessWidget {
  final Color iconBg;
  final Color iconColor;
  final IconData icon;
  final Color containerBg;
  final Color borderColor;
  final String title;
  final String subtitle;
  final Color titleColor;
  final VoidCallback onTap;

  const _SheetOption({
    required this.iconBg,
    required this.iconColor,
    required this.icon,
    required this.containerBg,
    required this.borderColor,
    required this.title,
    required this.subtitle,
    required this.titleColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: containerBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 22, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: AppColors.textSecondary,
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
