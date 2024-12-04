import 'package:base_code_template_flutter/data/repositories/shared_preference/shared_preference_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firstTimeRepositoryProvider =
    Provider<SharedPreferenceRepository>((ref) => FirstTimeRepositoryTmpl());
