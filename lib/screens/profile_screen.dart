import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:planit_prep_pro/providers/auth_provider.dart';
// Import the provider file where you defined userSummaryProvider

import 'package:planit_prep_pro/providers/user_summary_state_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    // Watch the global user summary state
    final userData = ref.watch(userSummaryProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        bottom: false,
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
                    onTap: () => Get.toNamed('/profile-setup'),
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
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text('👩', style: TextStyle(fontSize: 36)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userData['name'] ?? 'User',
                              style: textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Age: ${userData['age'] ?? '--'} · ${userData['height'] ?? '--'} cm · ${userData['weight'] ?? '--'} kg',
                              style: textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 6),
                            AppChip(
                              label: userData['dietType'] ?? 'Not Set',
                              isActive: true,
                              icon: Icons.spa_rounded,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Stats row using global provider data
                    Row(
                      children: [
                        _StatCard(
                          value: "${userData['mealsDone'] ?? '0'}",
                          label: 'Meals logged',
                        ),
                        const SizedBox(width: 8),
                        _StatCard(
                          value: "${userData['steps'] ?? '0'}",
                          label: 'Daily Steps',
                        ),
                        const SizedBox(width: 8),
                        _StatCard(
                          value:
                              "${userData['progress']?.toStringAsFixed(0) ?? '0'}%",
                          label: 'Plan adherence',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // My Goals
                    AppCard(
                      marginBottom: 12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('My Goals', style: textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: [
                              const AppChip(
                                label: '⚖️ Lose Weight',
                                isActive: true,
                              ),
                              AppChip(
                                label:
                                    '🎯 ${userData['caloriesTotal'] ?? '2000'} kcal/day',
                                isActive: true,
                              ),
                              AppChip(
                                label:
                                    '💪 ${userData['protein'] ?? '0'}g protein',
                                isActive: true,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Settings List
                    AppCard(
                      child: Column(
                        children: [
                          _ClickableSettingsRow(
                            iconBg: AppColors.primaryContainer,
                            iconColor: AppColors.primaryDark,
                            icon: Icons.restaurant_rounded,
                            label: 'Diet Preferences',
                            route: '/diet-preferences',
                          ),
                          _ClickableSettingsRow(
                            iconBg: const Color(0xFFE0F2FE),
                            iconColor: const Color(0xFF0369A1),
                            icon: Icons.notifications_rounded,
                            label: 'Notifications',
                            route: '/notifications',
                          ),
                          _ClickableSettingsRow(
                            iconBg: const Color(0xFFEDE9FE),
                            iconColor: const Color(0xFF6D28D9),
                            icon: Icons.lock_rounded,
                            label: 'Privacy',
                            route: '/privacy',
                          ),
                          _ClickableSettingsRow(
                            iconBg: const Color(0xFFFEF3C7),
                            iconColor: const Color(0xFF92400E),
                            icon: Icons.help_outline_rounded,
                            label: 'Help & Support',
                            route: '/help-support',
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
  final String route;

  const _ClickableSettingsRow({
    required this.iconBg,
    required this.iconColor,
    required this.icon,
    required this.label,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(route),
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

  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
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
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.dmSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
