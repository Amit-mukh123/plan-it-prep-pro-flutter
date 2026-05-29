import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ileum/features/user_profile/data/user_controller.dart';

/// Provider for the UserController.
/// It uses [StateNotifierProvider] because UserController extends [StateNotifier].
/// The state is a [bool] representing the loading status.
final userControllerProvider = StateNotifierProvider<UserController, bool>((
  ref,
) {
  return UserController(ref);
});
