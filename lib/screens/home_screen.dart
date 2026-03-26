import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../models/app_data.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/meal_card.dart';
import '../widgets/change_meal_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // ─── Dummy JSON Data ───────────────────────────────
  static const Map<String, dynamic> _summaryJson = {
    "date": "Tuesday, 14 Jan",
    "greeting": "Good morning, Anika! 🌿",
    "caloriesDone": 900,
    "caloriesTotal": 1800,
    "water": "2.1 L",
    "steps": "6,240",
    "protein": "54g",
    "mealsDone": "3 / 4",
    "progress": 0.5,
  };

  static const List<Map<String, dynamic>> _mealsJson = [
    {
      "id": "1",
      "mealType": "Breakfast",
      "time": "08:30 AM",
      "name": "Oatmeal with Berries",
      "emoji": "🥣",
      "bgColor": "0xFFFFF7ED",
      "calories": 320,
      "protein": "12g",
      "carbs": "45g",
      "fat": "8g",
      "prepTime": "10 min",
      "tags": ["Fiber Rich", "Vegetarian"],
      "ingredients": [
        "🌾 Rolled Oats",
        "🫐 Blueberries",
        "🥛 Almond Milk",
        "🍯 Honey",
      ],
      "steps": [
        "Boil milk in a small saucepan.",
        "Add oats and cook for 5 minutes until soft.",
        "Top with fresh berries and a drizzle of honey.",
      ],
    },
    {
      "id": "2",
      "mealType": "Lunch",
      "time": "01:00 PM",
      "name": "Quinoa Veggie Bowl",
      "emoji": "🥗",
      "bgColor": "0xFFD1FAE5",
      "calories": 420,
      "protein": "18g",
      "carbs": "58g",
      "fat": "9g",
      "prepTime": "25 min",
      "tags": ["High protein", "Vegetarian"],
      "ingredients": [
        "🌾 Quinoa",
        "🥕 Carrot",
        "🥦 Broccoli",
        "🍅 Tomato",
        "🫒 Olive oil",
      ],
      "steps": [
        "Rinse quinoa thoroughly and cook in 2 cups of water for 15 minutes until fluffy.",
        "Steam broccoli and carrots for 5 minutes until tender-crisp.",
        "Sauté garlic in olive oil, add tomatoes and cook for 3 minutes.",
        "Combine everything in a bowl and drizzle with tahini dressing.",
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: Row(
                children: [
                  Text(
                    'PlanitPrep',
                    style: GoogleFonts.dmSerifDisplay(
                      fontSize: 22,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Get.toNamed('/notifications'),
                    behavior: HitTestBehavior.opaque,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const AppIconButton(icon: Icons.notifications_rounded),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.surface,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Daily Summary Card using JSON
                    _SummaryCard(data: _summaryJson),
                    const SizedBox(height: 4),

                    // Today's Meals using JSON
                    SectionHeader(title: "Today's Meals", action: 'See plan'),

                    Column(
                      children: _mealsJson
                          .map(
                            (mealData) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: MealCard(
                                mealData: mealData, // Passing the full JSON map
                                onTap: () => Get.toNamed(
                                  '/meal-details',
                                  arguments: mealData,
                                ),
                                onChangeTap: () => ChangeMealSheet.show(
                                  context,
                                  mealData['mealType'],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),

                    AddMealButton(
                      onTap: () => ChangeMealSheet.show(context, 'Snack'),
                    ),

                    // Quick Actions
                    SectionHeader(title: 'Quick Actions'),
                    _QuickActionsGrid(),
                    const SizedBox(height: 8),
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

// ─── Daily Summary Card ───────────────────────────────
class _SummaryCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _SummaryCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['date'],
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    data['greeting'],
                    style: GoogleFonts.dmSans(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => Get.toNamed('/my-progress'),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white30),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 72,
                height: 72,
                child: Stack(
                  children: [
                    CustomPaint(
                      size: const Size(72, 72),
                      painter: _RingPainter(data['progress']),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${(data['progress'] * 100).toInt()}%',
                            style: GoogleFonts.dmSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'done',
                            style: GoogleFonts.dmSans(
                              fontSize: 9,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Calories today',
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: '${data['caloriesDone']} ',
                      style: GoogleFonts.dmSans(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(
                          text: '/ ${data['caloriesTotal']}',
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${data['caloriesTotal'] - data['caloriesDone']} kcal remaining',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatItem(value: data['water'], label: '💧 Water intake'),
              _StatItem(value: data['steps'], label: '👟 Steps today'),
              _StatItem(value: data['protein'], label: '🥩 Protein'),
              _StatItem(value: data['mealsDone'], label: '🍽 Meals done'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: GoogleFonts.dmSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.dmSans(fontSize: 10, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  _RingPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 6.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - stroke / 2;

    final bgPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
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
      2 * math.pi * progress,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

class _QuickActionsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.95,
      ),
      itemCount: AppData.quickActions.length,
      itemBuilder: (_, i) {
        final a = AppData.quickActions[i];
        return InkWell(
          onTap: () => Get.toNamed(a.route),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: a.iconBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(a.icon, size: 22, color: a.iconColor),
                ),
                const SizedBox(height: 8),
                Text(
                  a.label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                    height: 1.3,
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
