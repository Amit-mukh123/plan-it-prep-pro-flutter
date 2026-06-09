import 'package:flutter/material.dart';
import 'package:ileum/routes.dart';
import 'package:ileum/core/theme/app_theme.dart';
// ─── Models (Updated with API conversion helpers) ───────────────────────────────

class MealModel {
  final String mealType;
  final String time;
  final String name;
  final String emoji;
  final Color bgColor;
  final int calories;
  final String? protein;
  final double opacity;

  const MealModel({
    required this.mealType,
    required this.time,
    required this.name,
    required this.emoji,
    required this.bgColor,
    required this.calories,
    this.protein,
    this.opacity = 1.0,
  });

  // Future-proofing: Convert JSON from API to Model
  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      mealType: json['mealType'] ?? '',
      time: json['time'] ?? '',
      name: json['name'] ?? '',
      emoji: json['emoji'] ?? '🍽️',
      bgColor: Color(int.parse(json['bgColor'])),
      calories: json['calories'] ?? 0,
      protein: json['protein'],
    );
  }
}

class DietMealModel {
  final String emoji;
  final String type;
  final String name;
  final int calories;
  final String protein;
  final String carbs;
  final String fat;

  const DietMealModel({
    required this.emoji,
    required this.type,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });
}

class GroceryItem {
  final String name;
  final String quantity;
  final String price;
  bool isPurchased;

  GroceryItem({
    required this.name,
    required this.quantity,
    required this.price,
    this.isPurchased = false,
  });
}

class AlarmModel {
  final String emoji;
  final String time;
  final String ampm;
  final String label;
  final String schedule;
  bool isActive;

  AlarmModel({
    required this.emoji,
    required this.time,
    required this.ampm,
    required this.label,
    required this.schedule,
    this.isActive = true,
  });
}

class NotifModel {
  final Color iconBg;
  final Color iconColor;
  final IconData icon;
  final String title;
  final String body;
  final String time;
  final bool hasUnread;

  const NotifModel({
    required this.iconBg,
    required this.iconColor,
    required this.icon,
    required this.title,
    required this.body,
    required this.time,
    this.hasUnread = false,
  });
}

class QuickAction {
  final Color iconBg;
  final Color iconColor;
  final IconData icon;
  final String label;
  final String route; // Added for navigation

  const QuickAction({
    required this.iconBg,
    required this.iconColor,
    required this.icon,
    required this.label,
    required this.route,
  });
}

// ─── API Service (Handles future network calls) ───────────────────────────────

class ApiService {
  // Simulate an API call with a 1-second delay
  static Future<List<MealModel>> fetchTodayMeals() async {
    await Future.delayed(const Duration(seconds: 1));
    return AppData.todayMeals;
  }

  // Example for fetching notifications via API later
  static Future<List<NotifModel>> fetchNotifications() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return AppData.notifications;
  }
}

// ─── Sample Data ─────────────────────────────────────

class AppData {
  static final List<MealModel> todayMeals = [
    const MealModel(
      mealType: 'Breakfast',
      time: '7:30 AM',
      name: 'Oats Porridge',
      emoji: '🥣',
      bgColor: Color(0xFFFEF9C3),
      calories: 320,
      protein: '12g pro',
    ),
    const MealModel(
      mealType: 'Lunch',
      time: '1:00 PM',
      name: 'Quinoa Salad',
      emoji: '🥗',
      bgColor: Color(0xFFD1FAE5),
      calories: 420,
      protein: '18g pro',
    ),
    const MealModel(
      mealType: 'Dinner',
      time: '7:30 PM',
      name: 'Dal & Rice',
      emoji: '🍛',
      bgColor: Color(0xFFEDE9FE),
      calories: 580,
      opacity: 0.85,
    ),
  ];

  static final List<DietMealModel> dietPlanMeals = [
    const DietMealModel(
      emoji: '🌅',
      type: 'Breakfast',
      name: 'Oats with Banana & Almonds',
      calories: 320,
      protein: '12g',
      carbs: '54g',
      fat: '6g',
    ),
    const DietMealModel(
      emoji: '☀️',
      type: 'Lunch',
      name: 'Paneer Tikka with Brown Rice',
      calories: 520,
      protein: '28g',
      carbs: '68g',
      fat: '12g',
    ),
    const DietMealModel(
      emoji: '🌙',
      type: 'Dinner',
      name: 'Moong Dal Soup with Roti',
      calories: 480,
      protein: '22g',
      carbs: '72g',
      fat: '8g',
    ),
    const DietMealModel(
      emoji: '🍎',
      type: 'Snack',
      name: 'Greek Yogurt + Mixed Berries',
      calories: 180,
      protein: '14g',
      carbs: '20g',
      fat: '2g',
    ),
  ];

  static List<GroceryItem> groceryItems = [
    GroceryItem(
      name: 'Spinach',
      quantity: '250g',
      price: '₹30',
      isPurchased: true,
    ),
    GroceryItem(
      name: 'Tomatoes',
      quantity: '500g',
      price: '₹25',
      isPurchased: true,
    ),
    GroceryItem(name: 'Broccoli', quantity: '1 head', price: '₹45'),
    GroceryItem(name: 'Carrots', quantity: '4 pcs', price: '₹20'),
    GroceryItem(
      name: 'Eggs',
      quantity: '12 pack',
      price: '₹80',
      isPurchased: true,
    ),
    GroceryItem(name: 'Chicken Breast', quantity: '500g', price: '₹220'),
    GroceryItem(name: 'Quinoa', quantity: '1 kg', price: '₹180'),
    GroceryItem(name: 'Brown Rice', quantity: '2 kg', price: '₹120'),
  ];

  static List<AlarmModel> alarms = [
    AlarmModel(
      emoji: '🌅',
      time: '8:00',
      ampm: 'AM',
      label: 'Breakfast · Oats with Banana',
      schedule: 'Mon–Fri',
      isActive: true,
    ),
    AlarmModel(
      emoji: '☀️',
      time: '1:00',
      ampm: 'PM',
      label: "Lunch · Today's plan",
      schedule: 'Every day',
      isActive: true,
    ),
    AlarmModel(
      emoji: '🍎',
      time: '4:30',
      ampm: 'PM',
      label: 'Snack Time',
      schedule: 'Weekdays',
      isActive: false,
    ),
    AlarmModel(
      emoji: '🌙',
      time: '8:00',
      ampm: 'PM',
      label: "Dinner · Today's plan",
      schedule: 'Every day',
      isActive: true,
    ),
  ];

  static const List<NotifModel> notifications = [
    NotifModel(
      iconBg: AppColors.primaryContainer,
      iconColor: AppColors.primaryDark,
      icon: Icons.auto_awesome_rounded,
      title: 'New diet plan generated!',
      body: 'Your weekly plan for Jan 14–20 is ready. 7 days, 21 meals.',
      time: '2 hours ago',
      hasUnread: true,
    ),
    NotifModel(
      iconBg: Color(0xFFEDE9FE),
      iconColor: Color(0xFF6D28D9),
      icon: Icons.alarm_rounded,
      title: 'Lunch time! 🍛',
      body: 'Your Paneer Tikka + Brown Rice is scheduled for 1:00 PM.',
      time: '1 hour ago',
      hasUnread: true,
    ),
    NotifModel(
      iconBg: Color(0xFFE0F2FE),
      iconColor: Color(0xFF0369A1),
      icon: Icons.people_rounded,
      title: 'Priya shared a meal',
      body: 'Priya shared her Smoothie Bowl recipe with you.',
      time: '3 hours ago',
    ),
    NotifModel(
      iconBg: Color(0xFFFEF3C7),
      iconColor: Color(0xFF92400E),
      icon: Icons.shopping_cart_rounded,
      title: 'Grocery reminder',
      body: 'You have 5 items left on your grocery list.',
      time: 'Yesterday, 6:00 PM',
    ),
    NotifModel(
      iconBg: AppColors.primaryContainer,
      iconColor: AppColors.primaryDark,
      icon: Icons.emoji_events_rounded,
      title: '7-day streak! 🎉',
      body: "You've completed your meal plan 7 days in a row. Keep it up!",
      time: 'Yesterday, 9:00 PM',
    ),
  ];

  static const List<QuickAction> quickActions = [
    QuickAction(
      iconBg: Color(0xFFEDE9FE),
      iconColor: Color(0xFF4C1D95),
      icon: Icons.restaurant_rounded,
      label: 'Batch Meal\nGen',
      route: Routes.batchMeal,
    ),
    QuickAction(
      iconBg: Color(0xFFFEF3C7),
      iconColor: Color(0xFF92400E),
      icon: Icons.casino_rounded,
      label: 'Surprise\nMeal',
      route: Routes.surpriseMeal,
    ),

    QuickAction(
      iconBg: Color(0xFFF0FDF4),
      iconColor: Color(0xFF14532D),
      icon: Icons.alarm_rounded,
      label: 'Meal\nAlarm',
      route: Routes.mealAlarm, // This will now correctly match '/meal-alarm'
    ),
  ];
}
