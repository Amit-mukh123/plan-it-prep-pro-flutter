import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planit_prep_pro/providers/user_summary_state_provider.dart';
import 'package:planit_prep_pro/providers/meal_plan_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class MealScreen extends ConsumerStatefulWidget {
  const MealScreen({super.key});

  @override
  ConsumerState<MealScreen> createState() => _MealScreenState();
}

class _MealScreenState extends ConsumerState<MealScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void initState() {
    super.initState();
    int initialIndex = DateTime.now().weekday - 1;
    _tabController = TabController(
      length: 7,
      vsync: this,
      initialIndex: initialIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // <-- REMOVED WidgetRef ref here
    // In ConsumerStatefulWidget, 'ref' is available globally within the State class
    final mealPlan = ref.watch(mealPlanStateProvider);

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
                  Expanded(
                    child: Text(
                      'Weekly Diet Plan',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const AppIconButton(icon: Icons.more_vert_rounded),
                ],
              ),
            ),

            // Tab bar
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.outline, width: 1),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: AppColors.primaryDark,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primary,
                indicatorWeight: 2,
                labelStyle: GoogleFonts.dmSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: GoogleFonts.dmSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                tabs: _days.map((d) => Tab(text: d)).toList(),
              ),
            ),

            // Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: List.generate(
                  7,
                  (index) => _DayPlanView(meals: mealPlan?['meals'] as List?),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class _DayPlanView extends StatelessWidget {
  final List? meals;

  const _DayPlanView({this.meals});

  @override
  Widget build(BuildContext context) {
    if (meals == null || meals!.isEmpty) {
      return const Center(child: Text("No meal plan generated for this day."));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        children: [
          ...meals!.map((m) => _DietMealCard(meal: m)),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                // Handle regeneration logic here if needed
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryContainer,
                foregroundColor: AppColors.primaryDark,
                elevation: 0,
                shape: const StadiumBorder(),
              ),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Regenerate Plan'),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _DietMealCard extends StatelessWidget {
  final dynamic meal;

  const _DietMealCard({required this.meal});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      marginBottom: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('🍴', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 6),
                  Text(
                    meal['mealType'] ?? 'Meal',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              NutriBadge.cal('${meal['calories']} kcal'),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            meal['name'] ?? 'Unknown Meal',
            style: GoogleFonts.dmSans(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              NutriBox(
                value: '${meal['calories']}',
                label: 'kcal',
                valueColor: AppColors.calText,
              ),
              const SizedBox(width: 8),
              NutriBox(
                value: '${meal['protein']}g',
                label: 'protein',
                valueColor: AppColors.proText,
              ),
              const SizedBox(width: 8),
              NutriBox(
                value: '${meal['carbs']}g',
                label: 'carbs',
                valueColor: AppColors.carbText,
              ),
              const SizedBox(width: 8),
              NutriBox(
                value: '${meal['fat']}g',
                label: 'fat',
                valueColor: AppColors.fatText,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
