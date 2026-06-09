import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ileum/core/api/api_controller.dart';

final apiControllerProvider = Provider<ApiController>((ref) {
  return ApiController(ref);
});
