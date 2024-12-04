import 'package:flutter/material.dart';

class AccountScreenAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const AccountScreenAppBar({
    super.key,
    required this.onTapNotification,
    required this.onTapSetting,
  });

  final VoidCallback onTapSetting;
  final VoidCallback onTapNotification;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
            onPressed: onTapNotification,
            icon: const Icon(Icons.notifications)),
        IconButton(onPressed: onTapSetting, icon: const Icon(Icons.settings)),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(40);
}
