import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:planit_prep_pro/providers/AiResponse_provider.dart';
import 'package:planit_prep_pro/providers/user_provider.dart';
import 'package:planit_prep_pro/providers/user_summary_state_provider.dart';
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

      ref
          .read(userSummaryProvider.notifier)
          .update(
            (state) => {
              ...state,
              "date": summary["date"] ?? state["date"],
              "greeting": summary["greeting"] ?? state["greeting"],
              "caloriesDone": summary["caloriesDone"] ?? state["caloriesDone"],
              "caloriesTotal":
                  summary["caloriesTotal"] ?? state["caloriesTotal"],
              "water": summary["water"] ?? state["water"],
              "steps": summary["steps"] ?? state["steps"],
              "protein": summary["protein"] ?? state["protein"],
              "mealsDone": summary["mealsDone"] ?? state["mealsDone"],
              "progress": summary["progress"] ?? state["progress"],
              "name": summary["name"] ?? state["name"],
            },
          );

      debugPrint("Updated Summary: $_summaryData");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(aiResponseControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => _fetchMealPlan(refresh: false),
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
          sanitizedMeal['ingredients'] = rawMeal['ingredients'] ?? [];
          sanitizedMeal['steps'] = rawMeal['steps'] ?? [];
          sanitizedMeal['tags'] = rawMeal['tags'] ?? [];

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
    final int done = (data['caloriesDone'] ?? 0).toInt();
    final int total = (data['caloriesTotal'] ?? 2000).toInt();
    final double progress = (data['progress'] ?? 0.0).toDouble();
    final int left = (total - done).clamp(0, total);

    // Calculate dynamic progress for macros (fixing the 0 value issue)
    // You can adjust the denominators (targets) based on your app's logic
    double waterProgress = (safeDouble(data['water']) / 3.0).clamp(
      0.0,
      1.0,
    ); // Target: 3L
    double proteinProgress = (safeDouble(data['protein']) / 150.0).clamp(
      0.0,
      1.0,
    ); // Target: 150g
    double mealsProgress = (safeDouble(data['mealsDone']) / 4.0).clamp(
      0.0,
      1.0,
    ); // Target: 4 meals

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: 0,
        vertical: 4,
      ), // Decreased vertical margin
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ), // Decreased vertical padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data['date']?.toString().toUpperCase() ?? "SUNDAY, 1 APR",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  letterSpacing: 1.1,
                  color: Colors.grey[400],
                  fontWeight: FontWeight.w800,
                ),
              ),
              GestureDetector(
                onTap: () => Get.toNamed('/my-progress'),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8), // Tighter spacing to decrease height
          Row(
            children: [
              _CompactRing(
                progress: progress,
                size: 65, // Slightly smaller ring to save vertical space
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$left",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 28, // Reduced font size slightly
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF1D1D1D),
                        height: 1,
                      ),
                    ),
                    Text(
                      "KCAL REMAINING",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9, // Reduced font size slightly
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "$done",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF6C63FF),
                    ),
                  ),
                  Text(
                    "EATEN",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(color: Color(0xFFF8F8F8), height: 1, thickness: 1.5),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _MacroMini(
                label: "Water",
                value: "${data['water'] ?? 0}L",
                color: Colors.blue,
                progress: waterProgress, // Now dynamic
              ),
              _MacroMini(
                label: "Protein",
                value: "${data['protein'] ?? 0}g",
                color: Colors.pink,
                progress: proteinProgress, // Now dynamic
              ),
              _MacroMini(
                label: "Meals",
                value: "${data['mealsDone'] ?? 0}",
                color: Colors.orange,
                progress: mealsProgress, // Now dynamic
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroMini extends StatelessWidget {
  final String label, value;
  final Color color;
  final double progress;

  const _MacroMini({
    required this.label,
    required this.value,
    required this.color,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1D1D1D),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 70,
          height: 4,
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress, // This will now be 0 if the data is 0
            child: Container(
              decoration: BoxDecoration(
                color: color.withOpacity(0.6),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: Colors.grey[400],
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _CompactRing extends StatelessWidget {
  final double progress;
  final double size;

  const _CompactRing({required this.progress, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(
              progress: progress,
              color: const Color(0xFF6C63FF),
              strokeWidth: 6, // Slightly thinner stroke to match smaller size
            ),
          ),
          Text(
            '${(progress * 100).toInt()}%',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF6C63FF),
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _RingPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - strokeWidth / 2;

    final bgPaint = Paint()
      ..color = const Color(0xFFF3F3F3)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final fgPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);
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
