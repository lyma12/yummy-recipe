import 'package:base_code_template_flutter/data/repositories/shared_preference/first_time_reposity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firstTimeReposityProvider =
    Provider<FirstTimeReposity>((ref) => FirstTimeReposityTmpl());
