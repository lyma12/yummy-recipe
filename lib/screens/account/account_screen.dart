import 'package:auto_route/auto_route.dart';
import 'package:base_code_template_flutter/components/app_bar/account_screen_app_bar.dart';
import 'package:base_code_template_flutter/components/divider/divider_horizontal.dart';
import 'package:base_code_template_flutter/components/images/profile_avatar.dart';
import 'package:base_code_template_flutter/components/loading/container_with_loading.dart';
import 'package:base_code_template_flutter/components/loading/loading_view_model.dart';
import 'package:base_code_template_flutter/data/providers/auth_repository_provider.dart';
import 'package:base_code_template_flutter/data/providers/hive_storage_provider.dart';
import 'package:base_code_template_flutter/data/providers/user_provider.dart';
import 'package:base_code_template_flutter/resources/app_text_styles.dart';
import 'package:base_code_template_flutter/router/app_router.dart';
import 'package:base_code_template_flutter/screens/account/account_state.dart';
import 'package:base_code_template_flutter/screens/setting/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../components/base_view/base_view.dart';
import 'account_view_model.dart';

final _provider =
    StateNotifierProvider.autoDispose<AccountViewModel, AccountState>(
  (ref) => AccountViewModel(
    firebaseAuthRepository: ref.read(firebaseAuthRepositoryProvider),
    userProfileRepository: ref.read(userProfileProvider),
    hiveStorage: ref.read(hiveStorageProvider),
  ),
);

/// Screen code: A_07
@RoutePage()
class AccountScreen extends BaseView {
  const AccountScreen({super.key});

  @override
  BaseViewState<AccountScreen, AccountViewModel> createState() =>
      _AccountViewState();
}

class _AccountViewState extends BaseViewState<AccountScreen, AccountViewModel> {
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => AccountScreenAppBar(
        onTapNotification: () {},
        onTapSetting: openSettingScreen,
      );

  @override
  Widget buildBody(BuildContext context) {
    return ContainerWithLoading(
        child: SingleChildScrollView(
      child: Column(
        children: [
          infoAccount(),
          const DividerHorizontal(),
        ],
      ),
    ));
  }

  Widget infoAccount() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ProfileAvatar(
            imageUrl: state.profile?.imageUrl ?? "",
            width: 80,
            height: 80,
          ),
          Expanded(
            child: ListTile(
              title: Text(
                state.profile?.name ?? "User",
                style: AppTextStyles.titleMediumBold,
              ),
              subtitle: Text(
                state.profile?.id ?? "user_id",
                style: AppTextStyles.bodyMediumItalic,
              ),
              trailing: ElevatedButton(
                onPressed: () async {
                  await signOut();
                },
                child: const Text("Sign out"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void openSettingScreen() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Scaffold(body: SettingScreen(
        onTapSetting: () {
          Navigator.pop(ctx);
        },
      )),
    );
  }

  @override
  Future<void> onInitState() async {
    super.onInitState();
    await _onInitData();
  }

  Future<void> _onInitData() async {
    Object? error;

    await loading.whileLoading(context, () async {
      try {
        await viewModel.initData();
      } catch (e) {
        error = e;
      }
    });
    if (error != null) {
      handleError(error!);
    }
  }

  Future<void> signOut() async {
    Object? error;
    await loading.whileLoading(context, () async {
      try {
        await viewModel.signOut();
        if (mounted) {
          await AutoRouter.of(context).replace(const LoginRoute());
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
  AccountViewModel get viewModel => ref.read(_provider.notifier);

  LoadingStateViewModel get loading => ref.read(loadingStateProvider.notifier);

  AccountState get state => ref.watch(_provider);

  @override
  String get screenName => AccountRoute.name;
}
