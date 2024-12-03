import 'package:auto_route/auto_route.dart';
import 'package:base_code_template_flutter/common/my_flutter_app_icons.dart';
import 'package:base_code_template_flutter/components/base_view/base_view.dart';
import 'package:base_code_template_flutter/components/loading/container_with_loading.dart';
import 'package:base_code_template_flutter/data/providers/auth_repository_provider.dart';
import 'package:base_code_template_flutter/data/providers/user_provider.dart';
import 'package:base_code_template_flutter/resources/gen/assets.gen.dart';
import 'package:base_code_template_flutter/router/app_router.dart';
import 'package:base_code_template_flutter/screens/login/components/input_icon.dart';
import 'package:base_code_template_flutter/screens/login/login_state.dart';
import 'package:base_code_template_flutter/screens/login/login_view_model.dart';
import 'package:base_code_template_flutter/screens/login/signup_screen.dart';
import 'package:base_code_template_flutter/utilities/constants/text_constants.dart';
import 'package:base_code_template_flutter/utilities/exceptions/email_exception.dart';
import 'package:base_code_template_flutter/utilities/exceptions/password_exception.dart';
import 'package:base_code_template_flutter/utilities/format_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/loading/loading_view_model.dart';

final _provider = StateNotifierProvider.autoDispose<LoginViewModel, LoginState>(
  (ref) => LoginViewModel(
    ref: ref,
    facebookAuth: ref.read(facebookSigninRepositoryProvider),
    firebaseAuth: ref.read(firebaseAuthRepositoryProvider),
    googleAuth: ref.read(googleSigninRepositoryProvider),
    userProfileRepository: ref.read(userProfileProvider),
  ),
);

@RoutePage()
class LoginScreen extends BaseView {
  const LoginScreen({super.key});

  @override
  BaseViewState<LoginScreen, LoginViewModel> createState() => _LoginViewState();
}

class _LoginViewState extends BaseViewState<LoginScreen, LoginViewModel> {
  @override
  bool get resizeToAvoidBottomInset => true;

  @override
  Widget buildBody(BuildContext context) {
    if (state.user != null) _checkFirstCreateAccount();
    return ContainerWithLoading(
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
              opacity: 0.8,
              image: Assets.images.signinBackGround.provider(),
              fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                  flex: 2,
                  child: Icon(
                    MyFlutterApp.applogo,
                    size: 120,
                  ),
                ),
                InputIcon(
                  isReset: state.email == null,
                  paddingVertical: 2,
                  errorText: state.emailException,
                  icon: const Icon(Icons.email_outlined),
                  hint: AppLocalizations.of(context)?.hint_email_signup,
                  onChange: (text) {
                    viewModel.setEmail(text);
                  },
                ),
                InputIcon(
                  isReset: state.password == null,
                  paddingVertical: 2,
                  errorText: state.passwordException,
                  onChange: (text) {
                    viewModel.setPassword(text);
                  },
                  icon: const Icon(MyFlutterApp.password),
                  hint: AppLocalizations.of(context)?.hint_password_signup,
                  stuffIcon: const Icon(Icons.remove_red_eye_sharp),
                  isPassword: true,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: ElevatedButton(
                      onPressed: () async => await signInByGmailPassword(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                        child: Text(AppLocalizations.of(context)?.sign_in ??
                            TextConstants.signIn),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async => await signInByFacebook(),
                          label: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              FormatString.formatSigninWith(
                                  AppLocalizations.of(context)?.sign_in_with ??
                                      TextConstants.signIn,
                                  "Facebook"),
                            ),
                          ),
                          icon: const Icon(Icons.facebook_sharp),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                const Color.fromARGB(255, 24, 119, 242),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async => signInByGoogle,
                          label: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              FormatString.formatSigninWith(
                                  AppLocalizations.of(context)?.sign_in_with ??
                                      TextConstants.signIn,
                                  "Google"),
                            ),
                          ),
                          icon: const Icon(
                            MyFlutterApp.applogo,
                          ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: const Color.fromARGB(137, 0, 0, 0),
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 80,
                          vertical: 28,
                        ),
                        child: Divider(
                          color: Color.fromRGBO(255, 255, 255, 0.3),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            viewModel.resetData();
                            showModalBottomSheet(
                              context: context,
                              builder: (ctx) =>
                                  const Scaffold(body: SignupScreen()),
                              isScrollControlled: true,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                            ),
                            child: Text(AppLocalizations.of(context)!
                                .sign_up_with_email),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Future<void> onInitState() async {
    super.onInitState();
    await loading.whileLoading(context, () async {
      viewModel.initData();
    });
  }

  Future<void> signInByFacebook() async {
    await loading.whileLoading(context, () async {
      await viewModel.signInByFacebookAuth().then((value) async {
        await _checkFirstCreateAccount();
      }).catchError(
        (error) {
          handleError(error);
        },
      );
    });
  }

  Future<void> signInByGoogle() async {
    await loading.whileLoading(context, () async {
      await viewModel.sigInByGoogleAuth().then((value) async {
        await _checkFirstCreateAccount();
      }).catchError((error) {
        handleError(error);
      });
    });
  }

  Future<void> signInByGmailPassword() async {
    await loading.whileLoading(context, () async {
      viewModel.signInGmailPassword(state.email, state.password).then(
          (onValue) async {
        await _checkFirstCreateAccount();
      }, onError: (error) {
        if (error is FirebaseAuthException) {
          if (error.code == 'user-not-found') {
            viewModel.setEmailException(error.message!);
          } else if (error.code == 'wrong-password') {
            viewModel.setPasswordException(error.message!);
          } else {
            viewModel.setEmailException(error.message!);
          }
        } else if (error is EmailException) {
          viewModel.setEmailException(error.message);
        } else if (error is PasswordException) {
          viewModel.setPasswordException(error.message);
        }
      });
    });
  }

  Future<void> _checkFirstCreateAccount() async {
    final profile = await viewModel.getProfile();
    if (mounted) {
      if (profile != null) {
        AutoRouter.of(context).replace(const HomeRoute());
      } else {
        AutoRouter.of(context).replace(
          ProfileSettingRoute(
            nextRoute: QueriesSettingRoute(
              nextRoute: const MainRoute(),
            ),
          ),
        );
      }
    }
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return null;
  }

  @override
  String get screenName => LoginRoute.name;

  LoginState get state => ref.watch(_provider);

  LoadingStateViewModel get loading => ref.read(loadingStateProvider.notifier);

  @override
  LoginViewModel get viewModel => ref.read(_provider.notifier);
}
