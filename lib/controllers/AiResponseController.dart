import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:planit_prep_pro/controllers/ApiController.dart';
import 'package:planit_prep_pro/providers/api_provider.dart';

class AiResponseController extends StateNotifier<bool> {
  AiResponseController(this.ref) : super(false);

  final Ref ref;

  ApiController get api => ref.read(apiControllerProvider);

  // ==============================
  // 🔴 ERROR HANDLER
  // ==============================
  void _showError(String message) {
    Get.snackbar(
      "Error",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.error_outline, color: Colors.white),
    );
  }

  // ==============================
  // 🧠 GENERATE AI MEAL PLAN
  // ==============================
  Future<Map<String, dynamic>?> generateMealPlan(
    Map<String, dynamic> body,
  ) async {
    state = true;
    try {
      final response = await api.sendRequest(
        path: "/chat/generate-meal-plan",
        method: "POST",
        data: body,
      );
      print(response);
      if (response != null && response["status"] == true) {
        state = false;

        // This peels: response['data']['data']
        final level1 = response["data"];
        if (level1 is Map && level1["status"] == true) {
          final actualData = level1["data"];
          debugPrint("Final Meal Data: ${jsonEncode(actualData)}");
          return Map<String, dynamic>.from(actualData);
        }

        return Map<String, dynamic>.from(level1);
      } else {
        state = false;
        _showError(response?["message"] ?? "Failed to generate plan");
        if (response?["message"]?.contains("User profile not found") ?? false)
          Get.toNamed('/profile-setup');
        return null;
      }
    } catch (e) {
      state = false;
      _showError("Server error. Please try again.");
      return null;
    }
  }

  // ==============================
  // 📥 GET SAVED PLAN
  // ==============================
  Future<Map<String, dynamic>?> getSavedMealPlan(
    Map<String, dynamic> body,
  ) async {
    state = true;

    try {
      final response = await api.sendRequest(
        path: "/chat/meal-plan",
        method: "POST",
        data: body,
      );

      state = false;
      if (response != null && response["status"] == true) {
        // Handling potential double wrapping here as well for consistency
        final innerResponse = response["data"];

        if (innerResponse is Map && innerResponse["status"] == true) {
          return Map<String, dynamic>.from(innerResponse["data"]);
        }

        return Map<String, dynamic>.from(innerResponse);
      } else {
        _showError(response?["message"] ?? "No saved plan found.");
        return null;
      }
    } catch (e) {
      state = false;
      _showError("Failed to fetch saved plan.");
      return null;
    }
  }
}
