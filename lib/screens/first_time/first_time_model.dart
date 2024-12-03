import 'package:base_code_template_flutter/components/base_view/base_view_model.dart';
import 'package:base_code_template_flutter/data/repositories/shared_preference/shared_preference_repository.dart';
import 'package:base_code_template_flutter/data/repositories/shared_preference/first_time_reposity.dart';
import 'package:base_code_template_flutter/screens/first_time/first_time_state.dart';
import 'package:base_code_template_flutter/utilities/constants/app_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirstTimeModel extends BaseViewModel<FirstTimeState> {
  FirstTimeModel({
    required this.ref,
    required this.firstTimeRepository,
  }) : super(const FirstTimeState()) {
    _initData();
  }

  final Ref ref;
  final SharedPreferenceRepository firstTimeRepository;

  void _initData() async {
    await _getFinishFirstTime();
  }

  void changePage(int page) {
    if (page < 0) page = 0;
    if (page >= 2) page = 2;
    state = state.copyWith(currentPage: page);
  }

  Future<void> _getFinishFirstTime() async {
    await firstTimeRepository.getValue(AppConstants.firstTimeKey).then((value) {
      state = state.copyWith(isFirstTime: value);
    });
  }

  Future<void> setFinishFirstTime() async {
    await firstTimeRepository.setValue(AppConstants.firstTimeKey, true);
    _getFinishFirstTime();
  }
}
