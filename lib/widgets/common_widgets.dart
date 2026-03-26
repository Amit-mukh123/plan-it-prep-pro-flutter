import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

// ─── Nutrition Badge ─────────────────────────────────
class NutriBadge extends StatelessWidget {
  final String label;
  final Color bg;
  final Color textColor;

  const NutriBadge({
    super.key,
    required this.label,
    required this.bg,
    required this.textColor,
  });

  factory NutriBadge.cal(String label) => NutriBadge(
        label: label,
        bg: AppColors.calBg,
        textColor: AppColors.calText,
      );

  factory NutriBadge.protein(String label) => NutriBadge(
        label: label,
        bg: AppColors.proBg,
        textColor: AppColors.proText,
      );

  factory NutriBadge.carb(String label) => NutriBadge(
        label: label,
        bg: AppColors.carbBg,
        textColor: AppColors.carbText,
      );

  factory NutriBadge.fat(String label) => NutriBadge(
        label: label,
        bg: AppColors.fatBg,
        textColor: AppColors.fatText,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: GoogleFonts.dmSans(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}

// ─── Nutrition Box ───────────────────────────────────
class NutriBox extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;

  const NutriBox({
    super.key,
    required this.value,
    required this.label,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.dmSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: valueColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 10,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Section Header (title + optional action) ────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  final EdgeInsets padding;

  const SectionHeader({
    super.key,
    required this.title,
    this.action,
    this.onAction,
    this.padding = const EdgeInsets.only(top: 24, bottom: 12),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          if (action != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                action!,
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── App Card ────────────────────────────────────────
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? marginBottom;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.marginBottom,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: marginBottom != null
          ? EdgeInsets.only(bottom: marginBottom!)
          : null,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: padding != null
          ? Padding(padding: padding!, child: child)
          : child,
    );
  }
}

// ─── Icon Button (circular) ──────────────────────────
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color? bg;
  final double size;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.bg,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bg ?? Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 22, color: AppColors.textPrimary),
      ),
    );
  }
}

// ─── Chip Widget ─────────────────────────────────────
class AppChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final IconData? icon;

  const AppChip({
    super.key,
    required this.label,
    this.isActive = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryContainer : AppColors.surface,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color:
              isActive ? AppColors.primary : AppColors.outlineStrong,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
              color: isActive
                  ? AppColors.primaryDark
                  : AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isActive
                  ? AppColors.primaryDark
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Progress Row ────────────────────────────────────
class NutriProgressRow extends StatelessWidget {
  final String label;
  final String value;
  final double progress;
  final Color color;

  const NutriProgressRow({
    super.key,
    required this.label,
    required this.value,
    required this.progress,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodyMedium),
              Text(value, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppColors.outline,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Settings Row ────────────────────────────────────
class SettingsRow extends StatelessWidget {
  final Color iconBg;
  final Color iconColor;
  final IconData icon;
  final String label;
  final bool isDestructive;

  const SettingsRow({
    super.key,
    required this.iconBg,
    required this.iconColor,
    required this.icon,
    required this.label,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.outline, width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 15,
                color: isDestructive
                    ? AppColors.error
                    : AppColors.textPrimary,
              ),
            ),
          ),
          if (!isDestructive)
            const Icon(Icons.chevron_right_rounded,
                size: 20, color: AppColors.textTertiary),
        ],
      ),
    );
  }
}
