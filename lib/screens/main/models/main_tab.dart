import 'package:base_code_template_flutter/common/my_flutter_app_icons.dart';
import 'package:base_code_template_flutter/utilities/constants/text_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum MainTab {
  home,
  cart,
  daily,
  loveList,
  account,
}

extension MainTabExtension on MainTab {
  String getLabel(BuildContext context) {
    switch (this) {
      case MainTab.home:
        return AppLocalizations.of(context)?.home ?? TextConstants.home;
      case MainTab.cart:
        return AppLocalizations.of(context)?.markert ?? TextConstants.calendar;
      case MainTab.daily:
        return AppLocalizations.of(context)?.create ?? TextConstants.create;
      case MainTab.loveList:
        return AppLocalizations.of(context)?.wish_list ??
            TextConstants.whishList;
      case MainTab.account:
        return AppLocalizations.of(context)?.account ?? TextConstants.account;
    }
  }

  Widget iconPath(BuildContext context) {
    switch (this) {
      case MainTab.home:
        return Expanded(
          child: Icon(
            MyFlutterApp.home,
            color: Theme.of(context).colorScheme.outline,
            size: 15,
          ),
        );
      case MainTab.cart:
        return Expanded(
          child: Icon(
            MyFlutterApp.cart,
            color: Theme.of(context).colorScheme.outline,
            size: 15,
          ),
        );
      case MainTab.daily:
        return Expanded(
          child: Icon(
            MyFlutterApp.pencil,
            color: Theme.of(context).colorScheme.outline,
            size: 15,
          ),
        );
      case MainTab.loveList:
        return Expanded(
          child: Icon(
            MyFlutterApp.love,
            color: Theme.of(context).colorScheme.outline,
            size: 15,
          ),
        );
      case MainTab.account:
        return Expanded(
          child: Icon(
            MyFlutterApp.account,
            color: Theme.of(context).colorScheme.outline,
            size: 15,
          ),
        );
    }
  }

  Widget activeIconPath(BuildContext context) {
    switch (this) {
      case MainTab.home:
        return Expanded(
          child: Icon(
            MyFlutterApp.home,
            color: Theme.of(context).colorScheme.primary,
          ),
        );
      case MainTab.cart:
        return Expanded(
          child: Icon(
            MyFlutterApp.cart,
            color: Theme.of(context).colorScheme.primary,
          ),
        );
      case MainTab.daily:
        return Expanded(
          child: Icon(
            MyFlutterApp.pencil,
            color: Theme.of(context).colorScheme.primary,
          ),
        );
      case MainTab.loveList:
        return Expanded(
          child: Icon(
            MyFlutterApp.love,
            color: Theme.of(context).colorScheme.primary,
          ),
        );
      case MainTab.account:
        return Expanded(
          child: Icon(
            MyFlutterApp.account,
            color: Theme.of(context).colorScheme.primary,
          ),
        );
    }
  }
}
