import 'package:base_code_template_flutter/components/permission/permission_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

class ContainerWithPermissions extends ConsumerWidget {
  const ContainerWithPermissions({
    super.key,
    required this.child,
    required this.permissions,
  });

  final Widget child;
  final List<Permission> permissions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(permissionStateProvider);
    final allGranted = permissions.every((permission) =>
        state.permissions[permission] == PermissionStatus.granted);
    return allGranted ? child : _buildPermission(context, ref);
  }

  Widget _buildPermission(BuildContext context, WidgetRef ref) {
    return Center(
      child: Card(
        elevation: 2,
        child: SizedBox(
          height: 200,
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  AppLocalizations.of(context)?.permission_request ??
                      "Please grant permission to use this feature.",
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await openAppSettings();
                },
                child: Text(AppLocalizations.of(context)?.open_setting ??
                    "Open Setting"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
