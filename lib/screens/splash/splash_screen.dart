import 'package:auto_route/auto_route.dart';
import 'package:base_code_template_flutter/common/my_flutter_app_icons.dart';
import 'package:base_code_template_flutter/data/providers/auth_repository_provider.dart';
import 'package:base_code_template_flutter/data/providers/shared_preference_repository_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../components/base_view/base_view.dart';
import '../../components/loading/loading_view_model.dart';
import '../../router/app_router.dart';
import 'splash_view_model.dart';

final _provider = StateNotifierProvider.autoDispose(
  (ref) => SplashViewModel(
    firstTimeRepository: ref.read(firstTimeRepositoryProvider),
    firebaseAuthRepository: ref.read(firebaseAuthRepositoryProvider),
  ),
);

/// Screen code: A_01
@RoutePage()
class SplashScreen extends BaseView {
  const SplashScreen({super.key});

  @override
  BaseViewState<SplashScreen, SplashViewModel> createState() =>
      _SplashViewState();
}

class _SplashViewState extends BaseViewState<SplashScreen, SplashViewModel> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkFirstTimeAndAuth();
    });
  }

  Future<void> _checkFirstTimeAndAuth() async {
    Object? error;
    await loading.whileLoading(context, () async {
      try {
        final isNotFirstOpen = await viewModel.checkIsNotFirstTime();
        if (mounted) {
          if (!isNotFirstOpen) {
            await AutoRouter.of(context).replace(
              const FirstTimeRoute(),
            );
            return;
          }
          final isAuthentication = viewModel.checkIsLogin();
          if (!isAuthentication) {
            await AutoRouter.of(context).replace(
              const LoginRoute(),
            );
            return;
          }
          final isSettingProfile = viewModel.checkFirstSetting();
          if (isSettingProfile) {
            await AutoRouter.of(context).replace(
              const FirstTimeRoute(),
            );
            return;
          }
          await AutoRouter.of(context).replace(const HomeRoute());
        }
      } catch (e) {
        error = e;
      }
    });

    if (error != null) {
      handleError(error!);
    }
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Widget buildBody(BuildContext context) {
    return const Center(
        child: Icon(
      MyFlutterApp.applogo,
      size: 120,
    ));
  }

  @override
  SplashViewModel get viewModel => ref.read(_provider.notifier);
  LoadingStateViewModel get loading => ref.read(loadingStateProvider.notifier);
  @override
  String get screenName => SplashRoute.name;
}
