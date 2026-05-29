import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:ileum/core/api/api_controller.dart';
import 'package:ileum/core/api/api_provider.dart';
import 'package:ileum/features/auth/data/auth_service.dart';
import 'package:ileum/features/auth/data/auth_state.dart';

class AuthController extends StateNotifier<AuthState> {
  AuthController(this.ref) : super(AuthState.initial());

  final Ref ref;
  final storage = AuthStorage();

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
    );
  }

  // LOGIN -> navigate to verify otp
  Future<bool> login(Map<String, dynamic> body) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await api.sendRequest(
        path: "/send-email-otp",
        method: "POST",
        data: body,
      );

      if (response["status"] == true) {
        state = state.copyWith(isLoading: false);
        return true;
      } else {
        //_showError(response["msg"] ?? "Failed to send OTP. Please try again.");
        state = state.copyWith(isLoading: false);
        return false;
      }
    } catch (e) {
      _showError("Connection error. Please check your internet.");
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  // VERIFY OTP -> save tokens and navigate to profile setup
  Future<bool> verifyOtp(Map<String, dynamic> body) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await api.sendRequest(
        path: "/verify-email-otp",
        method: "POST",
        data: body,
      );

      if (response["status"] == true) {
        final data = response["data"];

        await storage.saveTokens(data["access_token"], data["refresh_token"]);

        state = state.copyWith(
          isLoggedIn: true,
          accessToken: data["access_token"],
          refreshToken: data["refresh_token"],
          isLoading: false,
        );

        return true;
      } else {
        _showError(response["msg"] ?? "Invalid OTP code.");
        state = state.copyWith(isLoading: false);
        return false;
      }
    } catch (e) {
      _showError("Verification failed. Please try again.");
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  // REGISTER -> navigate to login
  Future<bool> register(Map<String, dynamic> body) async {
    state = state.copyWith(isLoading: true);
    try {
      var response = await api.sendRequest(
        path: "/register",
        method: "POST",
        data: body,
      );
      //debugPrint("API Response: $response");

      if (response["status"] == true) {
        state = state.copyWith(isLoading: false);
        return true;
      } else {
        _showError(response["message"] ?? "Registration failed.");
        state = state.copyWith(isLoading: false);
        return false;
      }
    } catch (e) {
      _showError("Could not connect to server.");
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  // LOGOUT
  Future<void> logout() async {
    try {
      state = state.copyWith(isLoading: true);
      await storage.clear();
      state = AuthState.initial();
    } catch (e) {
      _showError("Logout failed.");
      state = state.copyWith(isLoading: false);
    }
  }

  // CHECK AUTH
  Future<void> checkAuth() async {
    try {
      state = state.copyWith(isLoading: true);
      final token = await storage.getAccessToken();

      if (token != null) {
        state = state.copyWith(
          isLoggedIn: true,
          accessToken: token,
          isLoading: false,
        );
      } else {
        state = AuthState.initial();
      }
    } catch (e) {
      state = AuthState.initial();
    }
  }
}
