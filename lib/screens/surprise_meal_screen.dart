import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

// ─── Ingredient model ─────────────────────────────────
class _Ingredient {
  final String emoji;
  final String name;
  const _Ingredient(this.emoji, this.name);
}

// ─── Meal Model ──────────────────────────────────────
class SurpriseMeal {
  final String name;
  final String description;
  final int calories;
  final String protein;
  final String carbs;
  final String fat;
  final String matchPercentage;
  final String prepTime;
  final String emoji;
  final String bgColor;
  final List<String> ingredients;
  final List<String> steps;

  SurpriseMeal({
    required this.name,
    required this.description,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.matchPercentage,
    required this.prepTime,
    required this.emoji,
    required this.bgColor,
    required this.ingredients,
    required this.steps,
  });

  factory SurpriseMeal.fromJson(Map<String, dynamic> json) {
    return SurpriseMeal(
      name: json['name'],
      description: json['description'],
      calories: json['calories'],
      protein: json['protein'],
      carbs: json['carbs'],
      fat: json['fat'],
      matchPercentage: json['matchPercentage'],
      prepTime: json['prepTime'],
      emoji: json['emoji'],
      bgColor: json['bgColor'],
      ingredients: List<String>.from(json['ingredients']),
      steps: List<String>.from(json['steps']),
    );
  }
}

class SurpriseMealScreen extends StatefulWidget {
  const SurpriseMealScreen({super.key});

  @override
  State<SurpriseMealScreen> createState() => _SurpriseMealScreenState();
}

class _SurpriseMealScreenState extends State<SurpriseMealScreen> {
  final _inputController = TextEditingController();
  bool _isLoading = false;
  SurpriseMeal? _generatedMeal;

  final List<_Ingredient> _ingredients = [
    const _Ingredient('🍗', 'Chicken'),
    const _Ingredient('🍚', 'Rice'),
    const _Ingredient('🥚', 'Eggs'),
    const _Ingredient('🍅', 'Tomato'),
  ];

  // ================= API INTEGRATION SECTION =================
  final String _dummyJson = '''
  {
    "name": "Spicy Egg Fried Rice",
    "description": "A quick high-protein stir-fry using your kitchen staples.",
    "calories": 460,
    "protein": "22g",
    "carbs": "54g",
    "fat": "12g",
    "matchPercentage": "93%",
    "prepTime": "15 min",
    "emoji": "🍳",
    "bgColor": "0xFFFEF3C7",
    "ingredients": ["2 cups cooked rice", "3 large eggs", "1 tomato chopped", "Chili flakes", "Soy sauce"],
    "steps": [
      "Heat oil in a pan and sauté tomatoes with chili flakes.",
      "Push tomatoes aside and scramble the eggs in the center.",
      "Add the cooked rice and soy sauce, tossing on high heat.",
      "Serve hot with a garnish of your choice."
    ]
  }
  ''';

  Future<void> _handleGeneration() async {
    setState(() {
      _isLoading = true;
      _generatedMeal = null;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _generatedMeal = SurpriseMeal.fromJson(jsonDecode(_dummyJson));
        _isLoading = false;
      });
    }
  }

  void _removeIngredient(int index) {
    setState(() => _ingredients.removeAt(index));
  }

  void _addIngredient() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _ingredients.add(_Ingredient('🥬', text));
      _inputController.clear();
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroBanner(context),
                    const SizedBox(height: 20),
                    _buildIngredientSection(context),
                    const SizedBox(height: 20),
                    _buildActionButtons(),
                    const SizedBox(height: 12),
                    const Divider(color: AppColors.outline),
                    const SizedBox(height: 12),
                    if (_isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (_generatedMeal != null)
                      _SurpriseResultCard(meal: _generatedMeal!),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        children: [
          if (Navigator.canPop(context))
            AppIconButton(
              icon: Icons.arrow_back_rounded,
              onTap: () => Navigator.pop(context),
            ),
          const SizedBox(width: 8),
          Text('Surprise Meal', style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }

  Widget _buildHeroBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Text('🎲', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 8),
          Text(
            "What's in your kitchen?",
            style: GoogleFonts.dmSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Add your ingredients and let AI suggest a meal.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your ingredients',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ..._ingredients.asMap().entries.map(
              (e) => _IngredientChip(
                emoji: e.value.emoji,
                name: e.value.name,
                onRemove: () => _removeIngredient(e.key),
              ),
            ),
            _AddMoreButton(onTap: () => _showAddDialog(context)),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(
                48,
              ), // Fixed: Use minimumSize instead of height
            ),
            onPressed: _isLoading ? null : _handleGeneration,
            icon: const Icon(Icons.inventory_2_outlined, size: 18),
            label: const Text('Use These'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(
                48,
              ), // Fixed: Use minimumSize instead of height
            ),
            onPressed: _isLoading ? null : _handleGeneration,
            icon: const Icon(Icons.auto_awesome_rounded, size: 18),
            label: const Text('AI Surprise'),
          ),
        ),
      ],
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add ingredient'),
        content: TextField(
          controller: _inputController,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'e.g. Spinach'),
          onSubmitted: (_) {
            _addIngredient();
            Navigator.pop(ctx);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _addIngredient();
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class _SurpriseResultCard extends StatefulWidget {
  final SurpriseMeal meal;
  const _SurpriseResultCard({required this.meal});

  @override
  State<_SurpriseResultCard> createState() => _SurpriseResultCardState();
}

class _SurpriseResultCardState extends State<_SurpriseResultCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          Container(
            height: 100,
            width: double.infinity,
            color: Color(int.parse(widget.meal.bgColor)),
            child: Center(
              child: Text(
                widget.meal.emoji,
                style: const TextStyle(fontSize: 50),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.meal.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            widget.meal.description,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    NutriBadge.cal('${widget.meal.calories} kcal'),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _Badge(
                      text: '🎯 ${widget.meal.matchPercentage} match',
                      isPrimary: true,
                    ),
                    const SizedBox(width: 8),
                    _Badge(text: '⏱ ${widget.meal.prepTime}', isPrimary: false),
                  ],
                ),
                const SizedBox(height: 16),

                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: _buildRecipeDetails(),
                  crossFadeState: _isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                ),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => setState(() => _isExpanded = !_isExpanded),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryContainer,
                      foregroundColor: AppColors.primaryDark,
                      elevation: 0,
                    ),
                    child: Text(
                      _isExpanded ? 'Close Recipe' : 'View Recipe Details',
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

  Widget _buildRecipeDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _MacroInfo(
              label: 'Protein',
              value: widget.meal.protein,
              color: AppColors.proText,
            ),
            _MacroInfo(
              label: 'Carbs',
              value: widget.meal.carbs,
              color: AppColors.carbText,
            ),
            _MacroInfo(
              label: 'Fat',
              value: widget.meal.fat,
              color: AppColors.fatText,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Ingredients Needed:',
          style: GoogleFonts.dmSans(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        ...widget.meal.ingredients.map(
          (item) => Text('• $item', style: const TextStyle(fontSize: 13)),
        ),
        const SizedBox(height: 16),
        Text(
          'Cooking Steps:',
          style: GoogleFonts.dmSans(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        ...widget.meal.steps.asMap().entries.map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              '${e.key + 1}. ${e.value}',
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

// ─── Helper UI Components ─────────────────────────────

class _MacroInfo extends StatelessWidget {
  final String label, value;
  final Color color;
  const _MacroInfo({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, color: color),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final bool isPrimary;
  const _Badge({required this.text, required this.isPrimary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isPrimary ? AppColors.primaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: isPrimary ? AppColors.primary : AppColors.outlineStrong,
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.dmSans(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isPrimary ? AppColors.primaryDark : AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _IngredientChip extends StatelessWidget {
  final String emoji, name;
  final VoidCallback onRemove;
  const _IngredientChip({
    required this.emoji,
    required this.name,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text('$emoji $name', style: const TextStyle(fontSize: 12)),
      onDeleted: onRemove,
      deleteIconColor: AppColors.textTertiary,
      backgroundColor: AppColors.surfaceVariant,
      side: BorderSide.none,
      shape: const StadiumBorder(),
    );
  }
}

class _AddMoreButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddMoreButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      onPressed: onTap,
      label: const Text(
        'Add more',
        style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
      ),
      avatar: const Icon(Icons.add, size: 14, color: AppColors.textSecondary),
      backgroundColor: AppColors.surface,
      side: const BorderSide(color: AppColors.outlineStrong),
      shape: const StadiumBorder(),
    );
  }
}
