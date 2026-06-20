import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:ileum/core/api/api_controller.dart';
import 'package:ileum/core/api/api_provider.dart';

class UserController extends StateNotifier<bool> {
  UserController(this.ref) : super(false);

  final Ref ref;

  ApiController get api => ref.read(apiControllerProvider);

  // Helper for consistent error reporting
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
    );
  }

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

  // STORE USER PROFILE DETAILS
  Future<bool> storeUserProfileDetails(Map<String, dynamic> body) async {
    state = true; // Set isLoading to true
    try {
      final response = await api.sendRequest(
        path: "/user-profile-store",
        method: "POST",
        data: body,
      );

      //debugPrint("API Response: $response");

      if (response["status"] == true) {
        state = false;
        return true;
      } else {
        _showError(response["message"] ?? "Failed to save profile details.");
        state = false;
        return false;
      }
    } catch (e) {
      _showError("Connection error. Could not save profile.");
      state = false;
      return false;
    }
  }

  // STORE USER CONFIG DETAILS
  Future<bool> storeUserConfigDetails(Map<String, dynamic> body) async {
    state = true; // Set isLoading to true
    try {
      final response = await api.sendRequest(
        path: "/user-config-store",
        method: "POST",
        data: body,
      );

      if (response["status"] == true) {
        state = false;
        return true;
      } else {
        _showError(response["message"] ?? "Failed to save configuration.");
        state = false;
        return false;
      }
    } catch (e) {
      _showError("Server error. Please try again later.");
      state = false;
      return false;
    }
  }

  Future<Map<String, dynamic>?> getUserSummary() async {
    state = true; // loading start

    try {
      final response = await api.sendRequest(
        path: "/get-user-summary",
        method: "GET",
      );

      //debugPrint("User Summary Raw Response: $response");

      // 1. Check top-level status
      if (response["status"] == true) {
        state = false;

        final level1 = response["data"];

        // 2. Handle Triple Wrap Logic: response['data']['data']
        // This checks if the inner data also contains a 'status' and 'data' key
        if (level1 is Map && level1["status"] == true) {
          final actualSummary = level1["data"];
          //debugPrint(" Extracted Summary Data: $actualSummary");
          return Map<String, dynamic>.from(actualSummary);
        }

        // 3. Fallback for Double Wrap: response['data']
        return Map<String, dynamic>.from(level1);
      } else {
        state = false;
        final isProfileSetup = response["error"]?["isProfileSetup"] ?? response["data"]?["isProfileSetup"];
        final isConfigSetup = response["error"]?["isConfigSetup"] ?? response["data"]?["isConfigSetup"];
        final msg = (response["message"]?.toString() ?? "").toLowerCase();

        if (isProfileSetup == false || isProfileSetup == "false" || msg.contains("profile not found")) {
          _showInfo(response["message"] ?? "Please complete your profile.");
          // Return redirect signal — navigation handled by widget layer to avoid
          // Get.offAllNamed failing silently on cold start (Flutter vs GetX navigator mismatch)
          return {'__redirect': '/profile-setup'};
        } else if (isConfigSetup == false || isConfigSetup == "false" || msg.contains("config not found")) {
          _showInfo(response["message"] ?? "Please complete your configuration.");
          return {'__redirect': '/user-goal'};
        } else {
          _showError(response["message"] ?? "Failed to fetch user summary.");
        }
        return null;
      }
    } catch (e) {
      state = false;
      //debugPrint(" Summary Fetch Error: $e");
      _showError("Connection error. Could not fetch summary.");
      return null;
    }
  }
}
