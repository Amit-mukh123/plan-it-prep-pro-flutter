import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ileum/features/meals/data/meal_plan_provider.dart';
import 'package:ileum/core/theme/app_theme.dart';
import 'package:ileum/core/common/common_widgets.dart';

class GroceryScreen extends ConsumerStatefulWidget {
  const GroceryScreen({super.key});

  @override
  ConsumerState<GroceryScreen> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends ConsumerState<GroceryScreen> {
  @override
  Widget build(BuildContext context) {
    final mealPlan = ref.watch(mealPlanStateProvider);
    final List<dynamic> rawItems = mealPlan?['groceryRequirements'] ?? [];

    // Grouping logic: Organizing items by category (Vegetables, Protein, Pantry, etc.)
    final Map<String, List<Map<String, dynamic>>> groupedItems = {};
    for (var item in rawItems) {
      final category = item['category'] ?? 'Other';
      if (!groupedItems.containsKey(category)) {
        groupedItems[category] = [];
      }
      groupedItems[category]!.add(item);
    }

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
                      'Grocery List',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  // const AppIconButton(icon: Icons.share_rounded),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search
                    // Container(
                    //   height: 44,
                    //   decoration: BoxDecoration(
                    //     color: AppColors.surfaceVariant,
                    //     borderRadius: BorderRadius.circular(100),
                    //   ),
                    //   padding: const EdgeInsets.symmetric(horizontal: 16),
                    //   child: Row(
                    //     children: [
                    //       const Icon(
                    //         Icons.search_rounded,
                    //         size: 20,
                    //         color: AppColors.textTertiary,
                    //       ),
                    //       const SizedBox(width: 8),
                    //       Expanded(
                    //         child: TextField(
                    //           decoration: InputDecoration(
                    //             hintText: 'Search items…',
                    //             hintStyle: GoogleFonts.dmSans(
                    //               fontSize: 14,
                    //               color: AppColors.textTertiary,
                    //             ),
                    //             border: InputBorder.none,
                    //             enabledBorder: InputBorder.none,
                    //             focusedBorder: InputBorder.none,
                    //             filled: false,
                    //             contentPadding: EdgeInsets.zero,
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // const SizedBox(height: 12),

                    // Count row
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text(
                    //       '${rawItems.length} items · $checkedCount checked',
                    //       style: Theme.of(context).textTheme.bodyMedium,
                    //     ),
                    //     // GestureDetector(
                    //     //   onTap: () => setState(() => _purchasedStatus.clear()),
                    //     //   child: Text(
                    //     //     'Clear done',
                    //     //     style: GoogleFonts.dmSans(
                    //     //       fontSize: 13,
                    //     //       fontWeight: FontWeight.w600,
                    //     //       color: AppColors.primaryDark,
                    //     //     ),
                    //     //   ),
                    //     // ),
                    //   ],
                    // ),
                    // const SizedBox(height: 12),

                    // Items card rendering from Grouped logic
                    if (rawItems.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Text(
                            "No groceries found. Generate a meal plan first!",
                          ),
                        ),
                      )
                    else
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: groupedItems.entries.map((entry) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _CategoryLabel(entry.key),
                                ...entry.value.map((item) {
                                  final itemName = item['item'] ?? 'Unknown';

                                  return _GroceryRow(
                                    name: itemName,
                                    quantity: item['quantity'] ?? '',
                                  );
                                }),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    const SizedBox(height: 16),

                    // Add Item button
                    // SizedBox(
                    //   width: double.infinity,
                    //   height: 44,
                    //   child: ElevatedButton.icon(
                    //     onPressed: () {},
                    //     icon: const Icon(Icons.add_rounded),
                    //     label: Text(
                    //       'Add Item',
                    //       style: GoogleFonts.dmSans(fontSize: 13),
                    //     ),
                    //   ),
                    // ),
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

class _CategoryLabel extends StatelessWidget {
  final String text;
  const _CategoryLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
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

class _GroceryRow extends StatelessWidget {
  final String name;
  final String quantity;

  const _GroceryRow({
    required this.name,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.outline, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.dmSans(
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
                // Text(quantity, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
