import 'package:base_code_template_flutter/data/providers/api_spoonacular_provider.dart';
import 'package:base_code_template_flutter/data/repositories/api/spoonacular/spoonacular_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final spoonacularRepositoryProvider = Provider<SpoonacularRepository>(
  (ref) => SpoonacularRepositoryImpl(
    ref.watch(apiSpoonacularProvider),
  ),
);
