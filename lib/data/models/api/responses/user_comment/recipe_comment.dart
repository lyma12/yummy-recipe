import 'package:base_code_template_flutter/data/models/user/user_firebase_profile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'recipe_comment.freezed.dart';
part 'recipe_comment.g.dart';

@freezed
@HiveType(typeId: 7, adapterName: 'RecipeCommentApdater')
class RecipeComment with _$RecipeComment {
  const factory RecipeComment({
    @HiveField(0) required UserFirebaseProfile user,
    @HiveField(1) required String text,
    @HiveField(2) required DateTime createAt,
  }) = _RecipeComment;

  factory RecipeComment.fromJson(Map<String, dynamic> json) =>
      _$RecipeCommentFromJson(json);
}
