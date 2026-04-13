import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = const [
      _NavItem(icon: Icons.home_rounded, label: 'Home'),
      _NavItem(icon: Icons.restaurant_menu_rounded, label: 'Meals'),
      _NavItem(icon: Icons.shopping_cart_rounded, label: 'Grocery'),
      _NavItem(icon: Icons.person_rounded, label: 'Profile'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.outline, width: 1)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Row(
            children: List.generate(items.length, (i) {
              final isActive = i == currentIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isActive)
                        Container(
                          width: 56,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Icon(
                            items[i].icon,
                            size: 22,
                            color: AppColors.primaryDark,
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2, top: 5),
                          child: Icon(
                            items[i].icon,
                            size: 22,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      const SizedBox(height: 2),
                      Text(
                        items[i].label,
                        style: GoogleFonts.dmSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: isActive
                              ? AppColors.primaryDark
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
