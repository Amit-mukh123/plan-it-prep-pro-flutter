import 'package:flutter_riverpod/flutter_riverpod.dart';

// This provider holds the global state of the user summary
final userSummaryProvider = StateProvider<Map<String, dynamic>>((ref) {
  return {
    "date": "",
    "greeting": "Hello!",
    "caloriesDone": 0,
    "caloriesTotal": 2000,
    "water": "0",
    "steps": "0",
    "protein": "0",
    "mealsDone": "0",
    "progress": 0.0,
    "name": "User", // Added name as you requested
  };
});
