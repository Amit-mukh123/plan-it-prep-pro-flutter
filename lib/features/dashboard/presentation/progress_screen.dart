import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:ileum/core/theme/app_theme.dart';
import 'package:ileum/core/common/common_widgets.dart';

// ─── Progress Models for API Integration ────────────────────────────
class ProgressSummary {
  final double weightLoss;
  final int adherenceRate;
  final List<BarData> weeklyCalories;
  final List<double> weightTrend;

  const ProgressSummary({
    required this.weightLoss,
    required this.adherenceRate,
    required this.weeklyCalories,
    required this.weightTrend,
  });
}

// ─── API Service ──────────────────────────────────────────────────
class ProgressApiService {
  static Future<ProgressSummary> fetchUserProgress() async {
    // Simulate Network Delay
    await Future.delayed(const Duration(milliseconds: 800));

    return const ProgressSummary(
      weightLoss: -2.1,
      adherenceRate: 87,
      weeklyCalories: [
        BarData('M', 55, false),
        BarData('T', 72, true),
        BarData('W', 48, false),
        BarData('T', 62, false),
        BarData('F', 38, false),
        BarData('S', 70, false, color: Color(0xFFEDE9FE)),
        BarData('S', 50, false, color: Color(0xFFEDE9FE)),
      ],
      weightTrend: [48.0, 52.0, 56.0, 52.0, 46.0, 40.0],
    );
  }
}

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Safely accessing theme to avoid null check errors
    final theme = Theme.of(context);

    // Create local safe styles to prevent null crashes
    final TextStyle titleStyle =
        theme.textTheme.titleLarge ??
        const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
    final TextStyle subTitleStyle =
        theme.textTheme.titleMedium ??
        const TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
    final TextStyle bodySmallStyle =
        theme.textTheme.bodySmall ??
        const TextStyle(fontSize: 12, color: Colors.grey);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        bottom: false,
        child: FutureBuilder<ProgressSummary>(
          future: ProgressApiService.fetchUserProgress(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return const Center(child: Text("Error loading progress data"));
            }

            final data = snapshot.data!;

            return Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 20,
                        ),
                        onPressed: () => Get.back(),
                      ),
                      Expanded(child: Text('Progress', style: titleStyle)),
                      const AppIconButton(icon: Icons.calendar_today_rounded),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Column(
                      children: [
                        // Summary cards row
                        Row(
                          children: [
                            Expanded(
                              child: AppCard(
                                child: Column(
                                  children: [
                                    Text(
                                      data.weightLoss.toString(),
                                      style: GoogleFonts.dmSans(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primaryDark,
                                      ),
                                    ),
                                    Text(
                                      'kg this month',
                                      style: bodySmallStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: AppCard(
                                child: Column(
                                  children: [
                                    Text(
                                      '${data.adherenceRate}%',
                                      style: GoogleFonts.dmSans(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.secondary,
                                      ),
                                    ),
                                    Text(
                                      'meal plan adherence',
                                      style: bodySmallStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Weekly Calories chart
                        AppCard(
                          marginBottom: 12,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Weekly Calories', style: subTitleStyle),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 96,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: data.weeklyCalories
                                      .map((d) => _WeekBar(data: d))
                                      .toList(),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Avg: 1720 kcal/day',
                                    style: bodySmallStyle,
                                  ),
                                  Text(
                                    'Goal: 1800 kcal',
                                    style: bodySmallStyle,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Today's Nutrients
                        AppCard(
                          marginBottom: 12,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Today's Nutrients", style: subTitleStyle),
                              const SizedBox(height: 12),
                              const NutriProgressRow(
                                label: 'Protein',
                                value: '54g / 80g',
                                progress: 0.67,
                                color: AppColors.primary,
                              ),
                              const NutriProgressRow(
                                label: 'Carbohydrates',
                                value: '142g / 200g',
                                progress: 0.71,
                                color: AppColors.secondary,
                              ),
                              const NutriProgressRow(
                                label: 'Fat',
                                value: '28g / 50g',
                                progress: 0.56,
                                color: AppColors.warning,
                              ),
                              const NutriProgressRow(
                                label: 'Fiber',
                                value: '18g / 30g',
                                progress: 0.60,
                                color: AppColors.secondary,
                              ),
                            ],
                          ),
                        ),

                        // Weight Progress
                        AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Weight Progress', style: subTitleStyle),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 64,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: data.weightTrend
                                      .asMap()
                                      .entries
                                      .map(
                                        (e) => _WeightBar(
                                          height: e.value,
                                          isLast:
                                              e.key ==
                                              data.weightTrend.length - 1,
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Jan 1: 64.2 kg', style: bodySmallStyle),
                                  Text(
                                    'Now: 62.1 kg',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryDark,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class BarData {
  final String label;
  final double height;
  final bool isActive;
  final Color? color;

  const BarData(this.label, this.height, this.isActive, {this.color});
}

class _WeekBar extends StatelessWidget {
  final BarData data;
  const _WeekBar({required this.data});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              height: data.height,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color:
                    data.color ??
                    (data.isActive
                        ? AppColors.primary
                        : AppColors.primaryContainer),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            data.label,
            style: GoogleFonts.dmSans(
              fontSize: 10,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

class _WeightBar extends StatelessWidget {
  final double height;
  final bool isLast;
  const _WeightBar({required this.height, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: height,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: isLast ? AppColors.primary : AppColors.outline,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }
}
