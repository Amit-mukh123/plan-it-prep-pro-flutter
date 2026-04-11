import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planit_prep_pro/controllers/AiResponseController.dart';

final aiResponseControllerProvider =
    StateNotifierProvider<AiResponseController, bool>((ref) {
      return AiResponseController(ref);
    });
