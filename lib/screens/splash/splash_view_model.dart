import 'package:base_code_template_flutter/data/repositories/shared_preference/shared_preference_repository.dart';
import 'package:base_code_template_flutter/data/repositories/signin/signin_repository.dart';
import 'package:base_code_template_flutter/utilities/constants/app_constants.dart';
import '../../../components/base_view/base_view_model.dart';

class SplashViewModel extends BaseViewModel<void> {
  SplashViewModel({
    required this.firstTimeRepository,
    required this.firebaseAuthRepository,
  }) : super(null);
  final SharedPreferenceRepository firstTimeRepository;
  final AuthRepository firebaseAuthRepository;

  Future<bool> checkIsNotFirstTime() async {
    return await firstTimeRepository.getValue(AppConstants.firstTimeKey);
  }

  bool checkIsLogin() {
    try {
      firebaseAuthRepository.getUserCredential();
      return true;
    } catch (e) {
      return false;
    }
  }

  bool checkFirstSetting() {
    final name = firebaseAuthRepository.getUserCredential().displayName;
    return (name == null) || name.isEmpty;
  }
}
