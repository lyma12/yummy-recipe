import 'package:base_code_template_flutter/components/base_view/base_view_model.dart';
import 'package:base_code_template_flutter/data/repositories/api/session/session_repository.dart';
import 'package:base_code_template_flutter/data/repositories/signin/signin_repository.dart';
import 'package:base_code_template_flutter/data/services/secure_storage/secure_storage_manager.dart';
import 'package:base_code_template_flutter/screens/login/signup_state.dart';
import 'package:base_code_template_flutter/utilities/utilities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupViewModel extends BaseViewModel<SignupState> {
  SignupViewModel({
    required this.authRepository,
    required this.ref,
    required this.secureStorageManager,
    required this.sessionRepository,
  }) : super(const SignupState());
  final Ref ref;
  final SessionRepository sessionRepository;
  final SecureStorageManager secureStorageManager;
  final AuthRepository authRepository;

  void setEmail(String email) {
    state = state.copyWith(email: email, emailException: null);
  }

  void setPassword(String password) {
    state = state.copyWith(password: password, passwordException: null);
  }

  void setEmailException(String exception) {
    state = state.copyWith(emailException: exception);
  }

  void setPasswordException(String exception) {
    state = state.copyWith(passwordException: exception);
  }

  void resetData() {
    state = state.copyWith(
      email: null,
      password: null,
      emailException: null,
      passwordException: null,
    );
  }

  Future<void> signupGmailPassword(String? email, String? password) async {
    if (Utilities.checkEmail(email) && Utilities.checkPassword(password)) {
      await authRepository.signup(email!, password!);
    }
  }
}
