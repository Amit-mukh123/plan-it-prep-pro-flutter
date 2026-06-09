import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ileum/core/theme/app_theme.dart';
import 'package:ileum/core/common/common_widgets.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

// ─── MODELS ──────────────────────────────────────────

class Meal {
  final String mealType;
  final String name;
  final int calories;
  final int protein;
  final String prepTime;
  final int servings;
  final List<String> steps;
  final String emoji;

  Meal({
    required this.mealType,
    required this.name,
    required this.calories,
    required this.protein,
    required this.prepTime,
    required this.servings,
    required this.steps,
    required this.emoji,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      mealType: json['mealType'] ?? 'Meal',
      name: json['name'] ?? 'Unknown Meal',
      calories: json['calories'] ?? 0,
      protein: json['protein'] ?? 0,
      prepTime: json['prepTime'] ?? '0 min',
      servings: json['servings'] ?? 1,
      steps: List<String>.from(json['steps'] ?? []),
      emoji: _getEmojiForType(json['mealType']),
    );
  }

  static String _getEmojiForType(String? type) {
    switch (type?.toLowerCase()) {
      case 'breakfast':
        return '🥣';
      case 'lunch':
        return '🍗';
      case 'dinner':
        return '🥗';
      case 'snack':
        return '🍎';
      default:
        return '🍱';
    }
  }
}

class BatchMeal {
  final String id;
  final List<Meal> meals;
  final DateTime generatedAt;
  final String dietType;
  final int targetProtein;
  final Map<String, bool> consumedItems;

  BatchMeal({
    required this.id,
    required this.meals,
    required this.generatedAt,
    required this.dietType,
    required this.targetProtein,
    Map<String, bool>? consumedItems,
  }) : consumedItems = consumedItems ?? {};
}

// ─── MAIN SCREEN ─────────────────────────────────────

class BatchMealScreen extends StatefulWidget {
  const BatchMealScreen({super.key});

  @override
  State<BatchMealScreen> createState() => _BatchMealScreenState();
}

class _BatchMealScreenState extends State<BatchMealScreen> {
  final _proteinController = TextEditingController(text: '80');
  int _activeDietIndex = 0;
  final _dietTypes = ['High Protein', 'Keto', 'Vegan', 'Low Carb'];

  final List<BatchMeal> _allBatches = [];
  bool _isLoading = false;
  bool _showInputSection = true;

  int eatingDays(BatchMeal batch) {
    if (batch.meals.isEmpty) return 0;
    return batch.meals.map((m) => m.servings).reduce((a, b) => a > b ? a : b);
  }

  Future<void> _generateBatch() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));

    const String dummyJsonResponse = '''
    {
      "status": "success",
      "batches": [
        {
          "batch_id": "batch_ALPHA",
          "diet": "High Protein",
          "meals": [
            { "mealType": "Breakfast", "name": "Overnight Chia Oats", "calories": 340, "protein": 14, "prepTime": "5 min", "servings": 2, "steps": ["Mix chia seeds with almond milk", "Refrigerate overnight", "Top with fresh berries before eating"] },
            { "mealType": "Lunch", "name": "Grilled Chicken Rice Bowl", "calories": 520, "protein": 42, "prepTime": "20 min", "servings": 3, "steps": ["Season chicken with herbs", "Grill until golden brown", "Steam brown rice and portion out"] },
            { "mealType": "Dinner", "name": "Chickpea Spinach Salad", "calories": 380, "protein": 18, "prepTime": "10 min", "servings": 2, "steps": ["Wash spinach thoroughly", "Toss with lemon dressing", "Add chickpeas and feta"] }
          ]
        },
        {
          "batch_id": "batch_BETA",
          "diet": "Keto Style",
          "meals": [
            { "mealType": "Breakfast", "name": "Avocado Egg Bake", "calories": 410, "protein": 18, "prepTime": "12 min", "servings": 2, "steps": ["Halve avocado and remove pit", "Crack egg into the center", "Bake at 400F for 10-12 mins"] },
            { "mealType": "Lunch", "name": "Zucchini Beef Stir-fry", "calories": 480, "protein": 35, "prepTime": "15 min", "servings": 3, "steps": ["Spiralize zucchini into noodles", "Brown ground beef with garlic", "Sauté together with soy sauce"] },
            { "mealType": "Dinner", "name": "Baked Salmon Asparagus", "calories": 550, "protein": 40, "prepTime": "25 min", "servings": 2, "steps": ["Season salmon with lemon", "Place on tray with asparagus", "Roast until salmon is flaky"] }
          ]
        }
      ]
    }
    ''';

    final Map<String, dynamic> decoded = jsonDecode(dummyJsonResponse);
    final List<dynamic> batchData = decoded['batches'];

    setState(() {
      for (var b in batchData) {
        _allBatches.insert(
          0,
          BatchMeal(
            id: "${b['batch_id']}_${DateTime.now().millisecondsSinceEpoch}",
            meals: (b['meals'] as List).map((m) => Meal.fromJson(m)).toList(),
            generatedAt: DateTime.now(),
            dietType: b['diet'],
            targetProtein: int.tryParse(_proteinController.text) ?? 80,
          ),
        );
      }
      _isLoading = false;
      _showInputSection = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: _ScreenHeader(onBack: () => Navigator.pop(context)),
            ),
            if (_showInputSection)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _InputCard(
                    proteinController: _proteinController,
                    dietTypes: _dietTypes,
                    activeIndex: _activeDietIndex,
                    isLoading: _isLoading,
                    onDietSelected: (i) => setState(() => _activeDietIndex = i),
                    onGenerate: _generateBatch,
                    onClose: _allBatches.isNotEmpty
                        ? () => setState(() => _showInputSection = false)
                        : null,
                  ),
                ),
              ),
            if (!_showInputSection && _allBatches.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: _TopActions(
                    count: _allBatches.length,
                    onNewBatch: () => setState(() => _showInputSection = true),
                  ),
                ),
              ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final batch = _allBatches[index];
                  return _BatchSection(
                    batch: batch,
                    eatingDays: eatingDays(batch),
                    onDelete: () => setState(() {
                      _allBatches.removeWhere((b) => b.id == batch.id);
                      if (_allBatches.isEmpty) _showInputSection = true;
                    }),
                    onToggleUpdate: () => setState(() {}),
                  );
                }, childCount: _allBatches.length),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── COMPONENT CLASSES ─────────────────────────────

class _BatchSection extends StatelessWidget {
  final BatchMeal batch;
  final int eatingDays;
  final VoidCallback onDelete;
  final VoidCallback onToggleUpdate;

  const _BatchSection({
    required this.batch,
    required this.eatingDays,
    required this.onDelete,
    required this.onToggleUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.inventory_2_outlined,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'BATCH: ${batch.dietType.toUpperCase()}',
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                  color: AppColors.primary,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(
                  Icons.delete_sweep_outlined,
                  color: Colors.redAccent,
                  size: 22,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...batch.meals.map((meal) => _MealCard(meal: meal)),
        const SizedBox(height: 20),
        const _SectionTitle(title: 'EATING ROUTINE'),
        const SizedBox(height: 12),
        ...List.generate(
          eatingDays,
          (dayIdx) => _RoutineDay(
            dayIdx: dayIdx,
            batch: batch,
            onToggle: onToggleUpdate,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Divider(thickness: 1, color: AppColors.outline),
        ),
      ],
    );
  }
}

class _MealCard extends StatefulWidget {
  final Meal meal;
  const _MealCard({required this.meal});
  @override
  State<_MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<_MealCard> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      marginBottom: 12.0,
      child: Column(
        children: [
          ListTile(
            onTap: () => setState(() => _expanded = !_expanded),
            leading: Text(
              widget.meal.emoji,
              style: const TextStyle(fontSize: 32),
            ),
            title: Text(
              widget.meal.name,
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            subtitle: Text(
              '${widget.meal.prepTime} • ${widget.meal.servings} Servings',
              style: GoogleFonts.dmSans(fontSize: 11),
            ),
            trailing: Icon(
              _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: AppColors.primary,
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const SizedBox(height: 12),
                  Text(
                    'COOKING STEPS',
                    style: GoogleFonts.dmSans(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...widget.meal.steps.asMap().entries.map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        '${e.key + 1}. ${e.value}',
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _RoutineDay extends StatelessWidget {
  final int dayIdx;
  final BatchMeal batch;
  final VoidCallback onToggle;

  const _RoutineDay({
    required this.dayIdx,
    required this.batch,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    DateTime dayDate = batch.generatedAt.add(Duration(days: dayIdx));
    return AppCard(
      marginBottom: 12.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'DAY ${dayIdx + 1}',
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  fontSize: 14,
                ),
              ),
              Text(
                DateFormat('EEEE, MMM d').format(dayDate),
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          ...batch.meals.map((meal) {
            final bool isAvail = (dayIdx < meal.servings);
            final String key = "${dayIdx}_${meal.mealType}";
            final bool isDone = batch.consumedItems[key] ?? false;

            return Opacity(
              opacity: isAvail ? 1.0 : 0.4,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(meal.emoji, style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            meal.name,
                            style: GoogleFonts.dmSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              decoration: isDone
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: isDone
                                  ? AppColors.textTertiary
                                  : AppColors.textPrimary,
                            ),
                          ),
                          // Legendary UX: Small instructional sub-text
                          if (isAvail)
                            Text(
                              'Eat 1 portion',
                              style: GoogleFonts.dmSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: isDone
                                    ? AppColors.textTertiary
                                    : AppColors.primary.withValues(alpha: 0.8),
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (isAvail)
                      Transform.scale(
                        scale: 0.9,
                        child: Checkbox(
                          value: isDone,
                          activeColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          onChanged: (v) {
                            batch.consumedItems[key] = v ?? false;
                            onToggle();
                          },
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ─── UI HELPERS ──────────────────────────────────────

class _ScreenHeader extends StatelessWidget {
  final VoidCallback onBack;
  const _ScreenHeader({required this.onBack});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
    child: Row(
      children: [
        AppIconButton(icon: Icons.arrow_back_ios_new_rounded, onTap: onBack),
        const SizedBox(width: 8),
        Text(
          'Batch Architect',
          style: GoogleFonts.dmSans(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    ),
  );
}

class _InputCard extends StatefulWidget {
  final TextEditingController proteinController;
  final List<String> dietTypes;
  final int activeIndex;
  final bool isLoading;
  final Function(int) onDietSelected;
  final VoidCallback onGenerate;
  final VoidCallback? onClose;

  const _InputCard({
    required this.proteinController,
    required this.dietTypes,
    required this.activeIndex,
    required this.isLoading,
    required this.onDietSelected,
    required this.onGenerate,
    this.onClose,
  });

  @override
  State<_InputCard> createState() => _InputCardState();
}

class _InputCardState extends State<_InputCard> {
  bool _isDismissed = false;
  bool _isLocalLoading = false;
  int _mealCount = 3; // Legendary default: Breakfast, Lunch, Dinner

  Future<void> _handleGeneration() async {
    setState(() => _isLocalLoading = true);

    // Perceived complexity delay
    await Future.delayed(const Duration(milliseconds: 900));

    if (mounted) {
      widget.onGenerate();
      setState(() {
        _isLocalLoading = false;
        _isDismissed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        switchInCurve: Curves.easeOutBack,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(scale: animation, child: child),
          );
        },
        child: _isDismissed ? _buildEnjoyState() : _buildInputState(),
      ),
    );
  }

  Widget _buildEnjoyState() {
    return Column(
      key: const ValueKey('enjoy_state'),
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        const Icon(
          Icons.auto_awesome_rounded,
          color: AppColors.primary,
          size: 54,
        ),
        const SizedBox(height: 16),
        Text(
          'Enjoy your batch meal!',
          style: GoogleFonts.dmSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Plan optimized for $_mealCount meals.',
          textAlign: TextAlign.center,
          style: GoogleFonts.dmSans(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton.icon(
            onPressed: () => setState(() => _isDismissed = false),
            icon: const Icon(Icons.refresh_rounded, size: 20),
            label: const Text('Design New Batch'),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputState() {
    final bool effectiveLoading = widget.isLoading || _isLocalLoading;

    return Column(
      key: const ValueKey('input_state'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Configure Batch',
          style: GoogleFonts.dmSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 20),

        // --- NEW: MEAL COUNT SELECTOR ---
        const _Label('Number of Meals'),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.outline),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$_mealCount Meals',
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: effectiveLoading || _mealCount <= 1
                        ? null
                        : () => setState(() => _mealCount--),
                    icon: const Icon(Icons.remove_circle_outline, size: 22),
                    color: AppColors.primary,
                  ),
                  IconButton(
                    onPressed: effectiveLoading || _mealCount >= 6
                        ? null
                        : () => setState(() => _mealCount++),
                    icon: const Icon(Icons.add_circle_outline, size: 22),
                    color: AppColors.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        const _Label('Protein Goal (g)'),
        TextField(
          controller: widget.proteinController,
          keyboardType: TextInputType.number,
          enabled: !effectiveLoading,
          decoration: const InputDecoration(
            suffixText: 'g',
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
        const SizedBox(height: 18),

        const _Label('Dietary Style'),
        DropdownButtonFormField<int>(
          initialValue: widget.activeIndex,
          onChanged: effectiveLoading
              ? null
              : (val) => val != null ? widget.onDietSelected(val) : null,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.outline),
            ),
          ),
          items: List.generate(
            widget.dietTypes.length,
            (i) => DropdownMenuItem(
              value: i,
              child: Text(
                widget.dietTypes[i],
                style: GoogleFonts.dmSans(fontSize: 14),
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),

        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: effectiveLoading ? null : _handleGeneration,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: effectiveLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.auto_awesome_rounded),
            label: Text(
              effectiveLoading ? 'Analyzing Nutrition...' : 'Generate Batch',
              style: GoogleFonts.dmSans(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}

class _TopActions extends StatelessWidget {
  final int count;
  final VoidCallback onNewBatch;
  const _TopActions({required this.count, required this.onNewBatch});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ACTIVE BATCHES',
            style: GoogleFonts.dmSans(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: AppColors.textTertiary,
              letterSpacing: 1.2,
            ),
          ),
          Text(
            '$count Plans managed',
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
      ElevatedButton.icon(
        onPressed: onNewBatch,
        icon: const Icon(Icons.add, size: 18),
        label: const Text('New'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryContainer,
          foregroundColor: AppColors.primary,
          elevation: 0,
        ),
      ),
    ],
  );
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Icon(
        Icons.calendar_month_outlined,
        size: 18,
        color: AppColors.textTertiary,
      ),
      const SizedBox(width: 8),
      Text(
        title,
        style: GoogleFonts.dmSans(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: AppColors.textTertiary,
          letterSpacing: 1.0,
        ),
      ),
    ],
  );
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondary,
      ),
    ),
  );
}
