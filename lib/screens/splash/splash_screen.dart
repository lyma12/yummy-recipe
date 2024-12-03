import 'package:auto_route/auto_route.dart';
import 'package:base_code_template_flutter/common/my_flutter_app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../components/base_view/base_view.dart';
import '../../router/app_router.dart';
import 'splash_view_model.dart';

final _provider = StateNotifierProvider.autoDispose(
  (ref) => SplashViewModel(),
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
    Future.delayed(const Duration(seconds: 2), () async {
      if (mounted) {
        await AutoRouter.of(context).replace(
          const FirstTimeRoute(),
        );
      }
    });
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

  @override
  String get screenName => SplashRoute.name;
}
