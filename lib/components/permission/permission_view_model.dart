import 'package:base_code_template_flutter/components/permission/permission_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

final permissionStateProvider =
    StateNotifierProvider<PermissionViewModel, PermissionState>(
        (ref) => PermissionViewModel(ref));

class PermissionViewModel extends StateNotifier<PermissionState> {
  PermissionViewModel(this.ref) : super(PermissionState());
  final Ref ref;

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();
    state = state.copyWith(
      permissions: {...state.permissions, permission: status},
    );
  }

  Future<void> checkAndRequestPermissions(List<Permission> permissions) async {
    for (var permission in permissions) {
      final status = await permission.status;
      if (status.isGranted) {
        state = state.copyWith(
          permissions: {...state.permissions, permission: status},
        );
      } else {
        await requestPermission(permission);
      }
    }
  }
}
