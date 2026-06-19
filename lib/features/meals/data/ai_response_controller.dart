import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:ileum/core/api/api_controller.dart';
import 'package:ileum/core/api/api_provider.dart';

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
  // ℹ️ INFO HANDLER
  // ==============================
  void _showInfo(String message) {
    Get.snackbar(
      "Information",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blueAccent,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.info_outline, color: Colors.white),
    );
  }

  // ==============================
  // 🧠 GENERATE AI MEAL PLAN
  // ==============================
  Future<Map<String, dynamic>?> generateMealPlan(
    Map<String, dynamic> body,
  ) async {
    state = true;
    debugPrint("generateMealPlan a dukhe gechi");
    try {
      final response = await api.sendRequest(
        path: "/chat/generate-meal-plan",
        method: "POST",
        data: body,
      );
      // 🔍 DEBUG: Log the full response so we can see what the server returns on error
      debugPrint("===== generateMealPlan RAW RESPONSE =====");
      debugPrint("status: ${response['status']}");
      debugPrint("message: ${response['message']}");
      debugPrint("data: ${response['data']}");
      debugPrint("error: ${response['error']}");
      debugPrint("statusCode: ${response['statusCode']}");
      debugPrint("=========================================");
      if (response["status"] == true) {
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
        final isProfileSetup =
            response["error"]?["isProfileSetup"] ??
            response["data"]?["isProfileSetup"];
        final isConfigSetup =
            response["error"]?["isConfigSetup"] ??
            response["data"]?["isConfigSetup"];
        final msg = (response["message"]?.toString() ?? "").toLowerCase();

        if (isProfileSetup == false ||
            isProfileSetup == "false" ||
            msg.contains("profile not found")) {
          _showInfo(response["message"] ?? "Please complete your profile.");
          // Return a redirect signal — navigation is handled by the widget layer
          // to avoid Get.key not being mounted on cold start.
          return {'__redirect': '/profile-setup'};
        } else if (isConfigSetup == false ||
            isConfigSetup == "false" ||
            msg.contains("config not found")) {
          _showInfo(
            response["message"] ?? "Please complete your configuration.",
          );
          return {'__redirect': '/user-goal'};
        } else {
          debugPrint("Something else else Error : " + response.toString());
          _showError(response["message"] ?? "Failed to generate plan");
        }
        debugPrint("Returning null");
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
      if (response["status"] == true) {
        // Handling potential double wrapping here as well for consistency
        final innerResponse = response["data"];

        if (innerResponse is Map && innerResponse["status"] == true) {
          return Map<String, dynamic>.from(innerResponse["data"]);
        }

        return Map<String, dynamic>.from(innerResponse);
      } else {
        state = false;
        final isProfileSetup =
            response["error"]?["isProfileSetup"] ??
            response["data"]?["isProfileSetup"];
        final isConfigSetup =
            response["error"]?["isConfigSetup"] ??
            response["data"]?["isConfigSetup"];
        final msg = (response["message"]?.toString() ?? "").toLowerCase();

        if (isProfileSetup == false ||
            isProfileSetup == "false" ||
            msg.contains("profile not found")) {
          _showInfo(response["message"] ?? "Please complete your profile.");
          return {'__redirect': '/profile-setup'};
        } else if (isConfigSetup == false ||
            isConfigSetup == "false" ||
            msg.contains("config not found")) {
          _showInfo(
            response["message"] ?? "Please complete your configuration.",
          );
          return {'__redirect': '/user-goal'};
        } else {
          _showError("No saved plan found.");
        }
        return null;
      }
    } catch (e) {
      state = false;
      _showError("Failed to fetch saved plan.");
      return null;
    }
  }
}
