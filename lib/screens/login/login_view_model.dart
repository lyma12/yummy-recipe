import 'package:base_code_template_flutter/components/base_view/base_view_model.dart';
import 'package:base_code_template_flutter/data/providers/user_provider.dart';
import 'package:base_code_template_flutter/data/repositories/signin/signin_repository.dart';
import 'package:base_code_template_flutter/screens/login/login_state.dart';
import 'package:base_code_template_flutter/utilities/utilities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginViewModel extends BaseViewModel<LoginState> {
  LoginViewModel(
      {required this.ref,
      required this.facebookAuth,
      required this.firebaseAuth,
      required this.googleAuth})
      : super(const LoginState()) {
    _initData();
  }

  final Ref ref;
  final SigninRepository facebookAuth;
  final SigninRepository googleAuth;
  final AuthRepository firebaseAuth;

  void _initData() {
    ref.listen(userProvider, (previous, next) {
      state = state.copyWith(user: next.value);
    });
  }

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

  Future<void> signinByFacebookAuth() async {
    await facebookAuth.signin();
  }

  Future<void> siginByGoogleAuth() async {
    await googleAuth.signin();
  }

  Future<void> signinGmailPassword(String? email, String? password) async {
    if (Utilities.checkEmail(email) && Utilities.checkPassword(password)) {
      await firebaseAuth.signin(email!, password!);
    }
  }

  Future<void> forgetPassword(String email) async {}
}
