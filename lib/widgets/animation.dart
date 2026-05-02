import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class NutriPulseAnimation extends StatefulWidget {
  final double size;
  final Color color;

  const NutriPulseAnimation({
    super.key,
    this.size = 50.0,
    this.color = AppColors.primary,
  });

  @override
  State<NutriPulseAnimation> createState() => _NutriPulseAnimationState();
}

class _NutriPulseAnimationState extends State<NutriPulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: widget.color.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            Icons.eco_rounded, // Using your app's leaf theme icon
            size: widget.size * 0.6,
            color: widget.color,
          ),
        ),
      ),
    );
  }
}