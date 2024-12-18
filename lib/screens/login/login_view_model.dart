import 'package:base_code_template_flutter/components/base_view/base_view_model.dart';
import 'package:base_code_template_flutter/data/models/user/user_firebase_profile.dart';
import 'package:base_code_template_flutter/data/providers/user_provider.dart';
import 'package:base_code_template_flutter/data/repositories/firebase/user_firebase_store_repository.dart';
import 'package:base_code_template_flutter/data/repositories/signin/signin_repository.dart';
import 'package:base_code_template_flutter/screens/login/login_state.dart';
import 'package:base_code_template_flutter/utilities/utilities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginViewModel extends BaseViewModel<LoginState> {
  LoginViewModel({
    required this.ref,
    required this.facebookAuth,
    required this.firebaseAuth,
    required this.googleAuth,
    required this.userProfileRepository,
  }) : super(const LoginState());

  final Ref ref;
  final SignInRepository facebookAuth;
  final SignInRepository googleAuth;
  final AuthRepository firebaseAuth;
  final UserProfileRepository userProfileRepository;

  void initData() {
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

  Future<void> signInByFacebookAuth() async {
    await facebookAuth.signIn();
  }

  Future<void> sigInByGoogleAuth() async {
    await googleAuth.signIn();
  }

  Future<void> signInGmailPassword(String? email, String? password) async {
    if (Utilities.checkEmail(email) && Utilities.checkPassword(password)) {
      await firebaseAuth.signIn(email!, password!);
    }
  }

  Future<UserFirebaseProfile?> getProfile() async {
    final user = state.user;
    if (user == null) {
      return null;
    }
    return await userProfileRepository.loadProfile(user.uid);
  }

  Future<void> forgetPassword(String email) async {}
}
