import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:planit_prep_pro/providers/auth_provider.dart';
import 'package:planit_prep_pro/providers/user_summary_state_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    // Watch the global user summary state
    final rawState = ref.watch(userSummaryProvider);

    // Access the 'data' map from your JSON structure
    final userData = rawState['data'] ?? {};
    final configAnswers = userData['config']?['answers'] ?? {};
    final String currentGoal = configAnswers['health_goal'] ?? 'Not Set';

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  Expanded(child: Text('Profile', style: textTheme.titleLarge)),
                  AppIconButton(
                    icon: Icons.edit_rounded,
                    onTap: () => Get.toNamed(
                      '/profile-setup',
                      arguments: {'isEdited': true},
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile header
                    Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text('👩', style: TextStyle(fontSize: 36)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userData['name'] ?? 'User',
                                style: textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  AppChip(
                                    label: userData['dietType'] ?? 'Not Set',
                                    isActive: true,
                                    icon: Icons.spa_rounded,
                                  ),
                                  AppChip(
                                    label: currentGoal,
                                    isActive: true,
                                    icon: Icons.track_changes_rounded,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Vital Metrics Section (Age, Height, Weight)
                    Row(
                      children: [
                        _StatCard(
                          icon: Icons.cake_rounded,
                          value: "${userData['age'] ?? '--'}",
                          label: 'Age',
                        ),
                        const SizedBox(width: 8),
                        _StatCard(
                          icon: Icons.height_rounded,
                          value: "${userData['height'] ?? '--'} cm",
                          label: 'Height',
                        ),
                        const SizedBox(width: 8),
                        _StatCard(
                          icon: Icons.monitor_weight_rounded,
                          value: "${userData['weight'] ?? '--'} kg",
                          label: 'Weight',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Primary Stats
                    Row(
                      children: [
                        _StatCard(
                          icon: Icons.restaurant_menu_rounded,
                          value: "${userData['mealsDone'] ?? '0'}",
                          label: 'Meals logged',
                        ),
                        const SizedBox(width: 8),
                        _StatCard(
                          icon: Icons.track_changes_rounded,
                          value:
                              "${(userData['progress'] ?? 0).toStringAsFixed(0)}%",
                          label: 'Adherence',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Settings List
                    AppCard(
                      child: Column(
                        children: [
                          // Diet Preferences with isEdited: true
                          _ClickableSettingsRow(
                            iconBg: AppColors.primaryContainer,
                            iconColor: AppColors.primaryDark,
                            icon: Icons.restaurant_rounded,
                            label: 'Diet Preferences',
                            onTap: () => Get.toNamed(
                              '/user-goal',
                              arguments: {'isEdited': true},
                            ),
                          ),
                          _ClickableSettingsRow(
                            iconBg: const Color(0xFFEDE9FE),
                            iconColor: const Color(0xFF6D28D9),
                            icon: Icons.lock_rounded,
                            label: 'Privacy',
                            onTap: () => Get.toNamed('/privacy'),
                          ),
                          _ClickableSettingsRow(
                            iconBg: const Color(0xFFFEF3C7),
                            iconColor: const Color(0xFF92400E),
                            icon: Icons.help_outline_rounded,
                            label: 'Help & Support',
                            onTap: () => Get.toNamed('/help-support'),
                          ),
                          // Logout Button
                          GestureDetector(
                            onTap: () async {
                              await ref.read(authProvider.notifier).logout();
                              Get.offAllNamed('/login');
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: AppColors.errorContainer,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.logout_rounded,
                                      size: 18,
                                      color: AppColors.error,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Log Out',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 15,
                                      color: AppColors.error,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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

// ─── Helper Internal Widgets ──────────────────────────

class _ClickableSettingsRow extends StatelessWidget {
  final Color iconBg;
  final Color iconColor;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ClickableSettingsRow({
    required this.iconBg,
    required this.iconColor,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: SettingsRow(
          iconBg: iconBg,
          iconColor: iconColor,
          icon: icon,
          label: label,
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: AppColors.primaryDark.withOpacity(0.5)),
            const SizedBox(height: 8),
            Text(
              value,
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
