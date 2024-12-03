import 'package:json_annotation/json_annotation.dart';

part 'user_spoonacular_request.g.dart';

@JsonSerializable()
class UserSpoonacularRequest {
  final String username;
  final String lastname;
  final String firstname;
  final String email;

  UserSpoonacularRequest({
    required this.username,
    required this.lastname,
    required this.firstname,
    required this.email,
  });

  factory UserSpoonacularRequest.fromJson(Map<String, dynamic> json) =>
      _$UserSpoonacularRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UserSpoonacularRequestToJson(this);
}
