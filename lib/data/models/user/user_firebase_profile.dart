import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'user_firebase_profile.freezed.dart';
part 'user_firebase_profile.g.dart';

@freezed
@HiveType(typeId: 6, adapterName: "UserFirebaseProfileAdapter")
class UserFirebaseProfile with _$UserFirebaseProfile {
  const factory UserFirebaseProfile({
    @HiveField(0) required String id,
    @HiveField(1) String? name,
    @HiveField(2) String? imageUrl,
    @HiveField(3) String? address,
    @HiveField(4) String? introduce,
  }) = _UserFirebaseProfile;

  factory UserFirebaseProfile.fromJson(Map<String, dynamic> json) =>
      _$UserFirebaseProfileFromJson(json);
}
