import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ileum/features/meals/data/ai_response_controller.dart';

final aiResponseControllerProvider =
    StateNotifierProvider<AiResponseController, bool>((ref) {
      return AiResponseController(ref);
    });
