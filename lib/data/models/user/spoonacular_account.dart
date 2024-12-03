import 'package:freezed_annotation/freezed_annotation.dart';

part 'spoonacular_account.freezed.dart';
part 'spoonacular_account.g.dart';

@freezed
class SpoonacularAccount with _$SpoonacularAccount {
  const factory SpoonacularAccount({
    String? userNameSpoonacular,
    String? spoonacularPassword,
    String? hash,
  }) = _SpoonacularAccount;

  factory SpoonacularAccount.fromJson(Map<String, dynamic> json) =>
      _$SpoonacularAccountFromJson(json);
}
