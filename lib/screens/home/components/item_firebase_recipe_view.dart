import 'package:base_code_template_flutter/components/images/profile_avatar.dart';
import 'package:base_code_template_flutter/components/richtext/app_rich_text.dart';
import 'package:base_code_template_flutter/resources/app_text_styles.dart';
import 'package:base_code_template_flutter/utilities/utilities.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../components/buttons/option_button.dart';
import '../../../components/divider/divider_horizontal.dart';
import '../../../data/models/recipe/recipe.dart';
import '../../../resources/gen/assets.gen.dart';
import '../../../utilities/constants/text_constants.dart';

class ItemFirebaseRecipeView extends StatefulWidget {
  const ItemFirebaseRecipeView({
    super.key,
    required this.recipe,
    this.onLikeTap,
    this.onCommentTap,
    this.onShareTap,
    required this.onSeeMore,
    this.isHasLike = false,
  });

  final Recipe? recipe;
  final VoidCallback? onLikeTap;
  final VoidCallback? onCommentTap;
  final VoidCallback? onShareTap;
  final VoidCallback onSeeMore;
  final bool? isHasLike;

  @override
  State<StatefulWidget> createState() => _ItemFirebaseRecipeState();
}

class _ItemFirebaseRecipeState extends State<ItemFirebaseRecipeView> {
  late FirebaseRecipe recipe;

  @override
  Widget build(BuildContext context) {
    recipe = widget.recipe as FirebaseRecipe;
    var createAt = recipe.createAt;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: ProfileAvatar(
            imageUrl: recipe.user?.imageUrl,
          ),
          title: Text(
            recipe.title ?? '',
            style: AppTextStyles.titleMediumBold,
          ),
          subtitle: Text(
            recipe.user?.name ?? '',
            style: AppTextStyles.titleSmall,
          ),
          trailing: createAt != null
              ? Text(
                  Utilities.formatDateTime(createAt),
                  style: AppTextStyles.titleSmallBold,
                )
              : null,
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 16, top: 10, bottom: 10, right: 16),
          child: Text(
            recipe.summary ?? '',
            style: AppTextStyles.bodyMedium.copyWith(
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 2,
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 16, top: 10, bottom: 10, right: 16),
          child: TextButton(
            onPressed: widget.onSeeMore,
            child: Text(
              AppLocalizations.of(context)?.see_more ?? 'See more',
              style: AppTextStyles.bodyMediumBold,
            ),
          ),
        ),
        if (recipe.image != null)
          CachedNetworkImage(
            imageUrl: recipe.image ?? "",
          ),
        SizedBox(
          width: double.infinity,
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AppRichText.richTextIconText(
                  data: " ${recipe.like} ",
                  icon: const Icon(
                    Icons.favorite,
                    size: 15,
                  ),
                  name: 'likes'),
              AppRichText.richTextIconText(
                  data: " ${recipe.listComment.length} ",
                  icon: const Icon(
                    Icons.forum_outlined,
                    size: 15,
                  ),
                  name: 'comments'),
            ],
          ),
        ),
        const DividerHorizontal(),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              OptionButton(
                icon: widget.isHasLike ?? false
                    ? Icons.thumb_up_alt
                    : Icons.thumb_up_outlined,
                label: TextConstants.like,
                onTap: widget.onLikeTap ?? () {},
              ),
              OptionButton(
                iconPath: Assets.icons.comment.path,
                label: TextConstants.comments,
                onTap: widget.onCommentTap ?? () {},
              ),
              OptionButton(
                iconPath: Assets.icons.share.path,
                label: TextConstants.share,
                onTap: widget.onShareTap ?? () {},
              ),
            ],
          ),
        ),
        const DividerHorizontal(height: 3),
      ],
    );
  }
}
