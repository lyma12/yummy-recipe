import 'package:auto_route/auto_route.dart';
import 'package:base_code_template_flutter/components/buttons/option_button.dart';
import 'package:base_code_template_flutter/components/divider/divider_horizontal.dart';
import 'package:base_code_template_flutter/components/loading/loading_view_model.dart';
import 'package:base_code_template_flutter/data/providers/auth_repository_provider.dart';
import 'package:base_code_template_flutter/data/providers/favourite_recipe_provider.dart';
import 'package:base_code_template_flutter/data/providers/hive_storage_provider.dart';
import 'package:base_code_template_flutter/data/providers/session_repository_provider.dart';
import 'package:base_code_template_flutter/data/providers/user_provider.dart';
import 'package:base_code_template_flutter/resources/app_text_styles.dart';
import 'package:base_code_template_flutter/resources/gen/assets.gen.dart';
import 'package:base_code_template_flutter/screens/detail_recipe/components/recipe_comment_view.dart';
import 'package:base_code_template_flutter/screens/detail_recipe/detail_recipe_screen.dart';
import 'package:base_code_template_flutter/screens/detail_recipe/detail_recipe_state.dart';
import 'package:base_code_template_flutter/screens/detail_recipe/firebase/detail_firebase_recipe_view_model.dart';
import 'package:base_code_template_flutter/utilities/constants/text_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/recipe_repository_provider.dart';
import '../../../router/app_router.dart';

final _provider = StateNotifierProvider.autoDispose<
    DetailFirebaseRecipeViewModel, DetailFirebaseRecipeState>(
  (ref) => DetailFirebaseRecipeViewModel(
    ref: ref,
    firebaseStoreRepository: ref.read(recipeFirebaseRepositoryProvider),
    sessionRepository: ref.read(sessionRepositoryProvider),
    hiveStorageManager: ref.read(hiveStorageProvider),
    favouriteRecipeProvider: ref.read(favouriteRecipeProvider.notifier),
    userProfileRepository: ref.read(userProfileProvider),
    auth: ref.read(firebaseAuthRepositoryProvider),
  ),
);

@RoutePage()
class DetailFirebaseRecipeScreen extends DetailRecipeScreen {
  const DetailFirebaseRecipeScreen({super.key, required super.recipe});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _DetailFirebaseRecipeViewState();
  }
}

class _DetailFirebaseRecipeViewState extends DetailRecipeViewState {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  @override
  DetailFirebaseRecipeViewModel get viewModel => ref.read(_provider.notifier);

  @override
  String get screenName => DetailFirebaseRecipeRoute.name;

  @override
  DetailFirebaseRecipeState get state => ref.watch(_provider);

  LoadingStateViewModel get loading => ref.watch(loadingStateProvider.notifier);

  @override
  List<Widget> otherSliverView() {
    return <Widget>[
      _divider(),
      _bottomAction(),
      _divider(),
      _listCommentation(),
      _textComment(),
    ];
  }

  Widget _divider() {
    return const SliverToBoxAdapter(
      child: DividerHorizontal(
        height: 2,
      ),
    );
  }

  Widget _bottomAction() {
    return SliverToBoxAdapter(
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            OptionButton(
              icon: viewModel.isHasLike()
                  ? Icons.thumb_up_alt
                  : Icons.thumb_up_alt_outlined,
              label: TextConstants.like,
              onTap: () async {
                await viewModel.like();
              },
            ),
            OptionButton(
                iconPath: Assets.icons.comment.path,
                label: TextConstants.comments,
                onTap: () {
                  FocusScope.of(context).requestFocus(_focusNode);
                }),
            OptionButton(
              iconPath: Assets.icons.share.path,
              label: TextConstants.share,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _listCommentation() {
    return state.listComment.isNotEmpty
        ? SliverList.builder(
            itemCount: state.listComment.length,
            itemBuilder: (context, index) {
              final comment = state.listComment[index];
              return RecipeCommentView(comment: comment);
            })
        : const SliverToBoxAdapter(
            child: Text("Have no comment"),
          );
  }

  Widget _textComment() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: TextField(
            controller: _controller,
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
            focusNode: _focusNode,
            style: AppTextStyles.bodyMedium,
            decoration: InputDecoration(
                hintText: AppLocalizations.of(context)?.write_comment ??
                    "Write a comment...",
                hintStyle: AppTextStyles.bodyMediumItalic,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 10.0),
                suffixIcon: IconButton(
                    onPressed: () async {
                      final comment = _controller.text.trim();
                      await viewModel.comment(comment);
                      _controller.clear();
                    },
                    icon: const Icon(Icons.send_rounded))),
            onSubmitted: (value) async {
              await viewModel.comment(value);
              _controller.clear();
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Future<void> onInitData() async {
    Object? error;
    await loading.whileLoading(context, () async {
      try {
        await viewModel.initData(widget.recipe);
      } catch (e) {
        error = e;
      }
    });

    if (error != null) {
      handleError(error!);
    }
  }
}
