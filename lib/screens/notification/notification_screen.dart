import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../components/base_view/base_view.dart';
import '../../router/app_router.dart';
import 'notification_view_model.dart';

final _provider = StateNotifierProvider.autoDispose(
  (ref) => NotificationViewModel(),
);

/// Screen code: A_07
@RoutePage()
class NotificationScreen extends BaseView {
  const NotificationScreen({super.key});

  @override
  BaseViewState<NotificationScreen, NotificationViewModel> createState() =>
      _NotificationViewState();
}

class _NotificationViewState
    extends BaseViewState<NotificationScreen, NotificationViewModel> {
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Widget buildBody(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          FirebaseAuth.instance.signOut();
        },
        child: const Text('logout'),
      ),
    );
  }

  @override
  NotificationViewModel get viewModel => ref.read(_provider.notifier);

  @override
  String get screenName => NotificationRoute.name;
}
