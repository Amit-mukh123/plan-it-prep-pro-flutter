import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:planit_prep_pro/providers/AiResponse_provider.dart';
import 'package:planit_prep_pro/providers/user_provider.dart';
import '../models/app_data.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/meal_card.dart';
import '../widgets/change_meal_sheet.dart';

// ─── SAFE PARSING HELPERS ──────────────────────────────────────────

int safeInt(dynamic value, {int defaultValue = 0}) {
  if (value == null) return defaultValue;
  if (value is int) return value;
  if (value is double) return value.toInt();
  final String stringValue = value.toString().trim();
  final match = RegExp(r'(\d+)').firstMatch(stringValue);
  if (match != null) return int.tryParse(match.group(0)!) ?? defaultValue;
  return defaultValue;
}

double safeDouble(dynamic value, {double defaultValue = 0.0}) {
  if (value == null) return defaultValue;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  final String stringValue = value.toString().trim();
  final match = RegExp(r'(\d+(\.\d+)?)').firstMatch(stringValue);
  if (match != null) return double.tryParse(match.group(0)!) ?? defaultValue;
  return defaultValue;
}

// ───────────────────────────────────────────────────────────────────

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Map<String, dynamic>? _mealPlanData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserSummary();
      _fetchMealPlan(refresh: false);
    });
  }

  Future<void> _fetchMealPlan({required bool refresh}) async {
    final String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final body = {"date": currentDate, "refresh": refresh};

    final response = await ref
        .read(aiResponseControllerProvider.notifier)
        .generateMealPlan(body);

    debugPrint("Final Data received in UI: $response");

    if (response != null) {
      setState(() {
        _mealPlanData = response;
      });

      await _loadUserSummary(); //loading user summary details

      if (response['meals'] != null) {
        debugPrint("Meals Count: ${(response['meals'] as List).length}");
      }
    } else {
      debugPrint("Response was null from controller.");
    }
  }

  Map<String, dynamic> _summaryData = {
    "date": "",
    "greeting": "Hello!",
    "caloriesDone": 0,
    "caloriesTotal": 2000,
    "water": "0",
    "steps": "0",
    "protein": "0",
    "mealsDone": "0",
    "progress": 0.0,
  };

  Future<void> _loadUserSummary() async {
    final summary = await ref
        .read(userControllerProvider.notifier)
        .getUserSummary();

    if (summary != null && mounted) {
      setState(() {
        _summaryData.clear();
        _summaryData.addAll({
          "date": summary["date"] ?? "",
          "greeting": summary["greeting"] ?? "Hello!",
          "caloriesDone": summary["caloriesDone"] ?? 0,
          "caloriesTotal": summary["caloriesTotal"] ?? 2000,
          "water": summary["water"] ?? "0",
          "steps": summary["steps"] ?? "0",
          "protein": summary["protein"] ?? "0",
          "mealsDone": summary["mealsDone"] ?? "0",
          "progress": summary["progress"] ?? 0.0,
        });
      });

      debugPrint("Updated Summary: $_summaryData"); //  DEBUG
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(aiResponseControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => _fetchMealPlan(refresh: true),
                color: AppColors.primary,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SummaryCard(data: _summaryData),
                      const SizedBox(height: 16),
                      _buildMealSectionHeader(isLoading),
                      const SizedBox(height: 8),
                      _buildMealList(isLoading),
                      const SizedBox(height: 12),
                      AddMealButton(
                        onTap: () => ChangeMealSheet.show(context, 'Snack'),
                      ),
                      const SectionHeader(title: 'Quick Actions'),
                      _QuickActionsGrid(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Row(
        children: [
          Text(
            'PlanitPrep',
            style: GoogleFonts.dmSerifDisplay(
              fontSize: 24,
              color: AppColors.primaryDark,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Get.toNamed('/notifications'),
            behavior: HitTestBehavior.opaque,
            child: const Stack(
              clipBehavior: Clip.none,
              children: [
                AppIconButton(icon: Icons.notifications_rounded),
                Positioned(top: 6, right: 6, child: _NotificationBadge()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealSectionHeader(bool isLoading) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SectionHeader(title: "Today's Meals"),
        IconButton(
          onPressed: isLoading ? null : () => _fetchMealPlan(refresh: true),
          icon: isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                )
              : const Icon(
                  Icons.refresh_rounded,
                  size: 22,
                  color: AppColors.primary,
                ),
        ),
      ],
    );
  }

  Widget _buildMealList(bool isLoading) {
    if (_mealPlanData != null && _mealPlanData!['meals'] != null) {
      final List meals = _mealPlanData!['meals'];
      return Column(
        children: meals.map((rawMeal) {
          final sanitizedMeal = Map<String, dynamic>.from(rawMeal);
          sanitizedMeal['calories'] = safeInt(rawMeal['calories']);
          sanitizedMeal['protein'] = safeInt(rawMeal['protein']);
          sanitizedMeal['carbs'] = safeInt(rawMeal['carbs']);
          sanitizedMeal['fat'] = safeInt(rawMeal['fat']);
          sanitizedMeal['prepTime'] = safeInt(rawMeal['prepTime']);

          return MealCard(
            mealData: sanitizedMeal,
            onTap: () => Get.toNamed('/meal-details', arguments: sanitizedMeal),
            onChangeTap: () =>
                ChangeMealSheet.show(context, sanitizedMeal['mealType']),
          );
        }).toList(),
      );
    }

    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Text("No meal plan generated for today."),
      ),
    );
  }
}

// ─── INTERNAL COMPONENTS ──────────────────────────────────────────

class _NotificationBadge extends StatelessWidget {
  const _NotificationBadge();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 9,
      height: 9,
      decoration: BoxDecoration(
        color: AppColors.error,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.surface, width: 1.5),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _SummaryCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final int done = safeInt(data['caloriesDone']);
    final int total = safeInt(data['caloriesTotal'], defaultValue: 2000);
    final double progress = safeDouble(data['progress']);
    final int remaining = (total - done).clamp(0, total);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['date']?.toString().toUpperCase() ?? "",
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    data['greeting']?.toString() ?? "Hello!",
                    style: GoogleFonts.dmSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              // Arrow button to Progress Screen
              GestureDetector(
                onTap: () => Get.toNamed('/my-progress'),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _ProgressRing(progress: progress),
              const SizedBox(width: 24),
              _CalorieInfo(done: done, total: total, remaining: remaining),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatItem(
                value: data['water']?.toString() ?? "0",
                label: 'Water',
              ),
              _StatItem(
                value: data['steps']?.toString() ?? "0",
                label: 'Steps',
              ),
              _StatItem(
                value: data['protein']?.toString() ?? "0",
                label: 'Protein',
              ),
              _StatItem(
                value: data['mealsDone']?.toString() ?? "0",
                label: 'Meals',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressRing extends StatelessWidget {
  final double progress;
  const _ProgressRing({required this.progress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76,
      height: 76,
      child: Stack(
        children: [
          CustomPaint(
            size: const Size(76, 76),
            painter: _RingPainter(progress),
          ),
          Center(
            child: Text(
              '${(progress * 100).toInt()}%',
              style: GoogleFonts.dmSans(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalorieInfo extends StatelessWidget {
  final int done, total, remaining;
  const _CalorieInfo({
    required this.done,
    required this.total,
    required this.remaining,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CALORIES CONSUMED',
          style: GoogleFonts.dmSans(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: Colors.white60,
          ),
        ),
        RichText(
          text: TextSpan(
            text: '$done ',
            style: GoogleFonts.dmSans(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            children: [
              TextSpan(
                text: '/ $total kcal',
                style: GoogleFonts.dmSans(fontSize: 14, color: Colors.white60),
              ),
            ],
          ),
        ),
        Text(
          '$remaining kcal left for today',
          style: GoogleFonts.dmSans(fontSize: 12, color: Colors.white70),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value, label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.dmSans(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.dmSans(fontSize: 10, color: Colors.white60),
        ),
      ],
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  _RingPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 7.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - stroke / 2;

    final bgPaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, bgPaint);

    final fgPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress.clamp(0.0, 1.0),
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(_) => true;
}

class _QuickActionsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: AppData.quickActions.length,
      itemBuilder: (_, i) {
        final a = AppData.quickActions[i];
        return InkWell(
          onTap: () => Get.toNamed(a.route),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: a.iconBg.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(a.icon, size: 24, color: a.iconColor),
                ),
                const SizedBox(height: 8),
                Text(
                  a.label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
