import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_spoonacular_response.freezed.dart';
part 'user_spoonacular_response.g.dart';

@freezed
class UserSpoonacularResponse with _$UserSpoonacularResponse {
  const factory UserSpoonacularResponse({
    String? username,
    String? spoonacularPassword,
    String? hash,
  }) = _UserSpoonacularResponse;

  factory UserSpoonacularResponse.fromJson(Map<String, dynamic> json) =>
      _$UserSpoonacularResponseFromJson(json);
}
