import 'package:auto_route/auto_route.dart';
import 'package:base_code_template_flutter/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({
    super.key,
    required this.onTapSetting,
  });

  final VoidCallback onTapSetting;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // setting profile
          ListTile(
            title: Text(AppLocalizations.of(context)?.setting_profile ??
                "Setting profile"),
            leading: const Icon(Icons.account_circle),
            onTap: () => goToSettingProfile(context),
          ),
          // setting queries
          ListTile(
            title: Text(AppLocalizations.of(context)?.setting_queries ??
                "Setting queries recipe"),
            leading: const Icon(Icons.filter_list),
            onTap: () => goToSettingQueries(context),
          )
        ],
      ),
    );
  }

  Future<void> goToSettingProfile(BuildContext context) async {
    onTapSetting();
    await AutoRouter.of(context)
        .push(ProfileSettingRoute(nextRoute: const AccountRoute()));
  }

  Future<void> goToSettingQueries(BuildContext context) async {
    onTapSetting();
    await AutoRouter.of(context)
        .push(QueriesSettingRoute(nextRoute: const AccountRoute()));
  }
}
