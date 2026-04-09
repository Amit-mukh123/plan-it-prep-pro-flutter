import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:planit_prep_pro/controllers/ApiController.dart';
import 'package:planit_prep_pro/providers/api_provider.dart';
import 'package:planit_prep_pro/services/AuthService.dart';
import 'package:planit_prep_pro/states/AuthState.dart';

class AuthController extends StateNotifier<AuthState> {
  AuthController(this.ref) : super(AuthState.initial());

  final Ref ref;
  final storage = AuthStorage();

  ApiController get api => ref.read(apiControllerProvider);

  // LOGIN -> navigate to verify otp
  Future<bool> login(Map<String, dynamic> body) async {
    state = state.copyWith(isLoading: true);

    final response = await api.sendRequest(
      path: "/send-otp",
      method: "POST",
      data: body,
    );

    if (response["status"] == true) {
      state = state.copyWith(isLoading: false);

      return true;
    } else {
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  // VERIFY OTP -> save tokens and navigate to profile setup
  Future<bool> verifyOtp(Map<String, dynamic> body) async {
    state = state.copyWith(isLoading: true);

    final response = await api.sendRequest(
      path: "/verify-otp",
      method: "POST",
      data: body,
    );

    if (response["status"] == true) {
      final data = response["data"];

      print(data["access_token"]);

      await storage.saveTokens(data["access_token"], data["refresh_token"]);

      state = state.copyWith(
        isLoggedIn: true,
        accessToken: data["access_token"],
        refreshToken: data["refresh_token"],
        isLoading: false,
      );

      return true;
    } else {
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  // REGISTER -> navigate to login
  Future<bool> register(Map<String, dynamic> body) async {
    state = state.copyWith(isLoading: true);

    final response = await api.sendRequest(
      path: "/register",
      method: "POST",
      data: body,
    );

    print("API Response: $response");

    if (response["status"] == true) {
      state = state.copyWith(isLoading: false);
      return true;
    } else {
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  // LOGOUT
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    await storage.clear();

    state = AuthState.initial();
  }

  // CHECK AUTH
  Future<void> checkAuth() async {
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
  }
}
