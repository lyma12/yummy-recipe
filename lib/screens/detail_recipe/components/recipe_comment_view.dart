import 'package:base_code_template_flutter/components/images/profile_avatar.dart';
import 'package:base_code_template_flutter/data/models/api/responses/user_comment/recipe_comment.dart';
import 'package:base_code_template_flutter/resources/app_text_styles.dart';
import 'package:base_code_template_flutter/utilities/utilities.dart';
import 'package:flutter/material.dart';

class RecipeCommentView extends StatelessWidget {
  const RecipeCommentView({super.key, required this.comment});

  final RecipeComment comment;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ProfileAvatar(imageUrl: comment.user.imageUrl),
      title: Text(
        comment.user.name ?? "User_${comment.user.id}",
        style: AppTextStyles.bodyMediumBold,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(comment.text),
          const SizedBox(height: 5),
          Text(
            Utilities.formatDateTime(comment.createAt),
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }
}
