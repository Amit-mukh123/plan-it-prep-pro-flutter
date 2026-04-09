import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planit_prep_pro/controllers/ApiController.dart';

final apiControllerProvider = Provider<ApiController>((ref) {
  return ApiController(ref);
});