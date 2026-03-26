import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/app_data.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class GroceryScreen extends StatefulWidget {
  const GroceryScreen({super.key});

  @override
  State<GroceryScreen> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends State<GroceryScreen> {
  final List<GroceryItem> _items = List.from(AppData.groceryItems);

  int get _checkedCount => _items.where((i) => i.isPurchased).length;

  @override
  Widget build(BuildContext context) {
    final produce = _items.sublist(0, 4);
    final protein = _items.sublist(4, 6);
    final pantry = _items.sublist(6);

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
                    child: Text('Grocery List',
                        style: Theme.of(context).textTheme.titleLarge),
                  ),
                  const AppIconButton(icon: Icons.share_rounded),
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
                    Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const Icon(Icons.search_rounded,
                              size: 20, color: AppColors.textTertiary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search items…',
                                hintStyle: GoogleFonts.dmSans(
                                    fontSize: 14,
                                    color: AppColors.textTertiary),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                filled: false,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Count row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_items.length} items · $_checkedCount checked',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        GestureDetector(
                          onTap: () => setState(() {
                            for (final item in _items) {
                              if (item.isPurchased) item.isPurchased = false;
                            }
                          }),
                          child: Text(
                            'Clear done',
                            style: GoogleFonts.dmSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryDark),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Items card
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _CategoryLabel('Produce'),
                          ...produce.map((i) => _GroceryRow(
                              item: i,
                              onToggle: () => setState(() {
                                    i.isPurchased = !i.isPurchased;
                                  }))),
                          _CategoryLabel('Protein'),
                          ...protein.map((i) => _GroceryRow(
                              item: i,
                              onToggle: () => setState(() {
                                    i.isPurchased = !i.isPurchased;
                                  }))),
                          _CategoryLabel('Pantry'),
                          ...pantry.asMap().entries.map((e) => _GroceryRow(
                              item: e.value,
                              isLast: e.key == pantry.length - 1,
                              onToggle: () => setState(() {
                                    e.value.isPurchased =
                                        !e.value.isPurchased;
                                  }))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Add Item button
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add_rounded),
                        label: Text(
                          'Add Item',
                          style: GoogleFonts.dmSans(fontSize: 13),
                        ),
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
  final GroceryItem item;
  final VoidCallback onToggle;
  final bool isLast;

  const _GroceryRow({
    required this.item,
    required this.onToggle,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(color: AppColors.outline, width: 1)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: item.isPurchased
                    ? AppColors.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: item.isPurchased
                      ? AppColors.primary
                      : AppColors.outlineStrong,
                  width: 2,
                ),
              ),
              child: item.isPurchased
                  ? const Icon(Icons.check_rounded,
                      size: 14, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: GoogleFonts.dmSans(
                    fontSize: 15,
                    color: item.isPurchased
                        ? AppColors.textTertiary
                        : AppColors.textPrimary,
                    decoration: item.isPurchased
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                Text(item.quantity,
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Text(item.price,
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
