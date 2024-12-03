import 'package:base_code_template_flutter/common/my_flutter_app_icons.dart';
import 'package:base_code_template_flutter/components/base_view/base_view.dart';
import 'package:base_code_template_flutter/data/providers/auth_repository_provider.dart';
import 'package:base_code_template_flutter/data/providers/secure_storage_provider.dart';
import 'package:base_code_template_flutter/data/providers/session_repository_provider.dart';
import 'package:base_code_template_flutter/resources/app_text_styles.dart';
import 'package:base_code_template_flutter/screens/login/components/input_icon.dart';
import 'package:base_code_template_flutter/screens/login/signup_state.dart';
import 'package:base_code_template_flutter/screens/login/signup_view_model.dart';
import 'package:base_code_template_flutter/utilities/exceptions/email_exception.dart';
import 'package:base_code_template_flutter/utilities/exceptions/password_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _provider =
    StateNotifierProvider.autoDispose<SignupViewModel, SignupState>(
        (ref) => SignupViewModel(
              authRepository: ref.watch(firebaseAuthRepositoryProvider),
              ref: ref,
              secureStorageManager: ref.watch(secureStorageProvider),
              sessionRepository: ref.watch(sessionRepositoryProvider),
            ));

class SignupScreen extends BaseView {
  const SignupScreen({super.key});

  @override
  BaseViewState<SignupScreen, SignupViewModel> createState() =>
      SignupViewState();
}

class SignupViewState extends BaseViewState<SignupScreen, SignupViewModel> {
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return null;
  }

  @override
  void dispose() {
    //viewModel.resetData();
    super.dispose();
  }

  @override
  Widget buildBody(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Icon(
              MyFlutterApp.applogo,
              color: Theme.of(context).colorScheme.primary,
              size: 120,
            ),
          ),
          Text(AppLocalizations.of(context)?.sign_up_title ?? "Sign up",
              textAlign: TextAlign.center, style: AppTextStyles.titleLargeBold),
          Column(
            children: [
              InputIcon(
                errorText: state.emailException,
                icon: const Icon(Icons.email_outlined),
                hint: AppLocalizations.of(context)?.hint_email_signup ??
                    "simit.donuts@gmail.com",
                onChange: (text) {
                  viewModel.setEmail(text);
                },
              ),
              InputIcon(
                errorText: state.passwordException,
                onChange: (text) {
                  viewModel.setPassword(text);
                },
                icon: const Icon(MyFlutterApp.password),
                hint: AppLocalizations.of(context)?.hint_password_signup ??
                    "password",
                stuffIcon: const Icon(Icons.remove_red_eye_sharp),
                isPassword: true,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 80,
                  vertical: 16,
                ),
                child: Divider(
                  height: 5,
                  color: Color.fromRGBO(75, 72, 72, 0.298),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      viewModel
                          .signupGmailPassword(state.email, state.password)
                          .then((onValue) {
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      }, onError: (error) {
                        if (error is FirebaseAuthException) {
                          if (error.code == 'weak-password') {
                            viewModel.setPasswordException(
                                error.message ?? "weak password");
                          } else if (error.code == 'email-already-in-use') {
                            viewModel.setEmailException(
                                error.message ?? "email already in use");
                          } else {
                            viewModel.setEmailException(
                                error.message ?? "error sign in");
                          }
                        } else if (error is EmailException) {
                          viewModel.setEmailException(error.message);
                        } else if (error is PasswordException) {
                          viewModel.setPasswordException(error.message);
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 24,
                      ),
                      child: Text(
                          AppLocalizations.of(context)?.create_account ??
                              "Create account"),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  String get screenName => "";

  SignupState get state => ref.watch(_provider);

  @override
  SignupViewModel get viewModel => ref.read(_provider.notifier);
}
