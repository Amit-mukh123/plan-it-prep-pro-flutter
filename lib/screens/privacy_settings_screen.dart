import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  // ── Sharing toggles ───────────────────────────────
  bool _mealSharing = true;
  bool _communityRecipes = false;
  bool _progressVisibility = true;

  // ── Diet preference chips ─────────────────────────
  // Row 1: Vegetarian / Non-Veg / Vegan
  final List<bool> _dietRow1 = [true, false, false];
  final List<String> _dietRow1Labels = ['Vegetarian', 'Non-Veg', 'Vegan'];
  final List<IconData> _dietRow1Icons = [
    Icons.spa_rounded,
    Icons.egg_rounded,
    Icons.eco_rounded,
  ];

  // Row 2: Keto / High Protein / Low Carb
  final List<bool> _dietRow2 = [true, true, false];
  final List<String> _dietRow2Labels = ['Keto', 'High Protein', 'Low Carb'];

  // ── Help & Support items ──────────────────────────
  static const _supportItems = [
    _SupportItem(
      iconBg: AppColors.primaryContainer,
      iconColor: AppColors.primaryDark,
      icon: Icons.quiz_rounded,
      title: 'FAQ',
      subtitle: 'Common questions answered',
    ),
    _SupportItem(
      iconBg: Color(0xFFE0F2FE),
      iconColor: Color(0xFF0369A1),
      icon: Icons.chat_rounded,
      title: 'Contact Support',
      subtitle: 'Live chat · Mon–Sat',
    ),
    _SupportItem(
      iconBg: Color(0xFFFEF3C7),
      iconColor: Color(0xFF92400E),
      icon: Icons.email_rounded,
      title: 'Email Support',
      subtitle: 'hello@planitprep.app',
      isLast: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top bar with back button ──────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
              child: Row(
                children: [
                  // Back button (margin-left: -8px in HTML)
                  AppIconButton(
                    icon: Icons.arrow_back_rounded,
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Privacy Settings',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
            ),

            // ── Scrollable content ────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Card 1: Sharing ───────────────
                    // AppCard(
                    //   marginBottom: 12,
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       // Section label
                    //       _CardSectionLabel('Sharing'),

                    //       // Allow meal sharing
                    //       _ToggleListItem(
                    //         title: 'Allow meal sharing',
                    //         subtitle: 'Let others see your meals',
                    //         value: _mealSharing,
                    //         onChanged: (v) =>
                    //             setState(() => _mealSharing = v),
                    //       ),

                    //       // Community recipes
                    //       _ToggleListItem(
                    //         title: 'Community recipes',
                    //         subtitle: 'Contribute your recipes',
                    //         value: _communityRecipes,
                    //         onChanged: (v) =>
                    //             setState(() => _communityRecipes = v),
                    //       ),

                    //       // Progress visibility — no bottom border (last)
                    //       _ToggleListItem(
                    //         title: 'Progress visibility',
                    //         subtitle: 'Show progress to friends',
                    //         value: _progressVisibility,
                    //         onChanged: (v) =>
                    //             setState(() => _progressVisibility = v),
                    //         isLast: true,
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    // ── Card 2: Diet Preferences ──────
                    // AppCard(
                    //   marginBottom: 12,
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       // Section label
                    //       _CardSectionLabel('Diet Preferences'),

                    //       // Row 1 — Vegetarian / Non-Veg / Vegan (with icons)
                    //       Wrap(
                    //         spacing: 8,
                    //         runSpacing: 8,
                    //         children: List.generate(
                    //           _dietRow1Labels.length,
                    //           (i) => GestureDetector(
                    //             onTap: () => setState(
                    //                 () => _dietRow1[i] = !_dietRow1[i]),
                    //             child: _DietChip(
                    //               label: _dietRow1Labels[i],
                    //               isActive: _dietRow1[i],
                    //               icon: _dietRow1Icons[i],
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       const SizedBox(height: 8),

                    //       // Row 2 — Keto / High Protein / Low Carb (text only)
                    //       Wrap(
                    //         spacing: 8,
                    //         runSpacing: 8,
                    //         children: List.generate(
                    //           _dietRow2Labels.length,
                    //           (i) => GestureDetector(
                    //             onTap: () => setState(
                    //                 () => _dietRow2[i] = !_dietRow2[i]),
                    //             child: _DietChip(
                    //               label: _dietRow2Labels[i],
                    //               isActive: _dietRow2[i],
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    // ── Card 3: Help & Support ────────
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _CardSectionLabel('Help & Support'),
                          ..._supportItems.map(
                            (item) => _SupportListItem(item: item),
                          ),
                        ],
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

// ─── Card section label ───────────────────────────────
// Matches HTML: .section-label — uppercase, letter-spacing, text-tertiary
class _CardSectionLabel extends StatelessWidget {
  final String text;
  const _CardSectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text.toUpperCase(),
        style: GoogleFonts.dmSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.06,
          color: AppColors.textTertiary,
        ),
      ),
    );
  }
}

// ─── Toggle list item ─────────────────────────────────
// Matches HTML: .list-item with title + subtitle on left, Switch on right
class _ToggleListItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isLast;

  const _ToggleListItem({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(color: AppColors.outline, width: 1),
              ),
      ),
      child: Row(
        children: [
          // Title + subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.dmSans(
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Switch
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

// ─── Diet chip ────────────────────────────────────────
// Matches HTML: .chip + .chip.active — with optional leading icon
class _DietChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final IconData? icon;

  const _DietChip({
    required this.label,
    required this.isActive,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryContainer : AppColors.surface,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: isActive ? AppColors.primary : AppColors.outlineStrong,
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

// ─── Support item data class ─────────────────────────
class _SupportItem {
  final Color iconBg;
  final Color iconColor;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isLast;

  const _SupportItem({
    required this.iconBg,
    required this.iconColor,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isLast = false,
  });
}

// ─── Support list item ────────────────────────────────
// Matches HTML: .list-item with icon box + title/subtitle + chevron
class _SupportListItem extends StatelessWidget {
  final _SupportItem item;
  const _SupportListItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: item.isLast
              ? null
              : const Border(
                  bottom: BorderSide(color: AppColors.outline, width: 1),
                ),
        ),
        child: Row(
          children: [
            // Square icon box — matches HTML .list-icon (40×40, radius-md)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: item.iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.icon, size: 20, color: item.iconColor),
            ),
            const SizedBox(width: 12),

            // Title + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: GoogleFonts.dmSans(
                      fontSize: 15,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle,
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            // Chevron
            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
