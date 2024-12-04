import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:permission_handler/permission_handler.dart';

part 'permission_state.freezed.dart';

@freezed
class PermissionState with _$PermissionState {
  factory PermissionState({
    @Default({}) Map<Permission, PermissionStatus> permissions,
  }) = _PermissionState;
}
