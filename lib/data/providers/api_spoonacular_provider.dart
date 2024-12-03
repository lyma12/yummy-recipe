import 'package:base_code_template_flutter/data/services/api/spoonacular/api_spoonacular_client.dart';
import 'package:base_code_template_flutter/utilities/constants/app_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiSpoonacularProvider = Provider<ApiSpoonacularClient>((ref) {
  final dio = AppOptions.dioAPI;
  return ApiSpoonacularClient(dio);
});
