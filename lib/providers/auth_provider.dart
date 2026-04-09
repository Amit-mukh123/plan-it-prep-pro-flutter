import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planit_prep_pro/controllers/AuthController.dart';
import 'package:planit_prep_pro/states/AuthState.dart';

final authProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref);
});