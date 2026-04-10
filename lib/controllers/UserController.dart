import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:planit_prep_pro/controllers/ApiController.dart';
import 'package:planit_prep_pro/providers/api_provider.dart';

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

  // STORE USER PROFILE DETAILS
  Future<bool> storeUserProfileDetails(Map<String, dynamic> body) async {
    state = true; // Set isLoading to true
    try {
      final response = await api.sendRequest(
        path: "/user-profile-store",
        method: "POST",
        data: body,
      );

      print("API Response: $response");

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
}
