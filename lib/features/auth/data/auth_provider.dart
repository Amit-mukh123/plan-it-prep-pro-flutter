import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ileum/features/auth/data/auth_controller.dart';
import 'package:ileum/features/auth/data/auth_state.dart';

final authProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref);
});
