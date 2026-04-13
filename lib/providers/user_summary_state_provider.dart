import 'package:flutter_riverpod/flutter_riverpod.dart';

// This provider holds the global state of the user summary based on your API structure
final userSummaryProvider = StateProvider<Map<String, dynamic>>((ref) {
  return {
    "status": true,
    "data": {
      "date": "Monday, 13 Apr",
      "greeting": "Hello!",
      "caloriesDone": 0,
      "caloriesTotal": 2000,
      "water": "0.0 L",
      "steps": "0",
      "protein": "0g",
      "mealsDone": "0 / 4",
      "progress": 0.0,
      "name": "User",
      "age": 0,
      "gender": "",
      "height": 0,
      "weight": 0,
      "target_weight": 0,
      "dietType": "vegetarian",
      "avatar": null,
      "config": {
        "answers": {
          "allergies": "None",
          "food_pref": "",
          "meals_per_day": "3 meals",
          "prep_style": "Batch cooking",
          "appliances": "Stove & Oven",
          "cooking_time": "Morning",
          "reminders": "Daily",
          "target_calorie": "1500 kcal",
          "cooking_day": []
        }
      }
    }
  };
});