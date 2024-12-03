import 'package:auto_route/auto_route.dart';
import 'package:base_code_template_flutter/components/base_view/base_view.dart';
import 'package:base_code_template_flutter/components/file_picker/circle_picker.dart';
import 'package:base_code_template_flutter/components/loading/container_with_loading.dart';
import 'package:base_code_template_flutter/components/loading/loading_view_model.dart';
import 'package:base_code_template_flutter/data/providers/auth_repository_provider.dart';
import 'package:base_code_template_flutter/data/providers/firebase_store_provider.dart';
import 'package:base_code_template_flutter/data/providers/user_provider.dart';
import 'package:base_code_template_flutter/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/http.dart';

import '../../../components/images/wave_clipper.dart';
import '../../../resources/app_text_styles.dart';
import '../../../resources/gen/assets.gen.dart';
import 'profile_setting_state.dart';
import 'profile_setting_view_model.dart';

final _provider = StateNotifierProvider.autoDispose<
        ProfileSettingViewModel, ProfileSettingState>(
    (ref) => ProfileSettingViewModel(
          ref: ref,
          firebaseAuth: ref.read(firebaseAuthRepositoryProvider),
          firebaseStorageRepository:
              ref.read(firebaseStorageRepositoryProvider),
          userProfileRepository: ref.read(userProfileProvider),
        ));

@RoutePage()
class ProfileSettingScreen extends BaseView {
  const ProfileSettingScreen({
    super.key,
    @Path('nextRoute') this.nextRoute,
  });

  final PageRouteInfo? nextRoute;

  @override
  BaseViewState<ProfileSettingScreen, ProfileSettingViewModel> createState() =>
      _FirstSettingViewState();
}

class _FirstSettingViewState
    extends BaseViewState<ProfileSettingScreen, ProfileSettingViewModel> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _introduceController;

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  bool get resizeToAvoidBottomInset => true;

  @override
  void onInitState() {
    super.onInitState();
    Object? error;
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _introduceController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loading.whileLoading(context, () async {
        try {
          await viewModel.initData();
          _updateControllers();
        } catch (e) {
          error = e;
        }
      });
      if (error != null) {
        handleError(error!);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _introduceController.dispose();
    super.dispose();
  }

  void _updateControllers() {
    _nameController.text = state.profile?.name ?? "";
    _addressController.text = state.profile?.address ?? "";
    _introduceController.text = state.profile?.introduce ?? "";
  }

  @override
  Widget buildBody(BuildContext context) {
    return ContainerWithLoading(
        child: CustomScrollView(
      slivers: [
        _topBackGroundImage(),
        _formEditProfile(),
      ],
    ));
  }

  Widget _topBackGroundImage() {
    return SliverAppBar(
      expandedHeight: 300,
      backgroundColor: Colors.white,
      flexibleSpace: ClipPath(
        clipper: WaveClipper(),
        child: Assets.images.signinBackGround.image(
          height: 300,
          fit: BoxFit.cover,
        ),
      ),
      pinned: true, // Optional: pin the app bar
    );
  }

  Widget _formEditProfile() {
    return SliverToBoxAdapter(
      // child: SizedBox(
      child: Stack(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 70, left: 16, right: 16, bottom: 16),
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 50, left: 30, right: 25, bottom: 25),
                child: SizedBox(
                  width: 420,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            AppLocalizations.of(context)?.edit_profile ??
                                "Edit profile",
                            style: AppTextStyles.titleLarge),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                              label: Text(AppLocalizations.of(context)?.name ??
                                  "Name: "),
                              hintText:
                                  AppLocalizations.of(context)?.name_hint ??
                                      'Enter your name',
                              hintStyle: AppTextStyles.hintBodySmall),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)
                                  ?.complete_text;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: _addressController,
                          decoration: InputDecoration(
                              label: Text(
                                  AppLocalizations.of(context)?.address ??
                                      "Address: "),
                              hintText:
                                  AppLocalizations.of(context)?.address_hint ??
                                      "Enter your address: ",
                              hintStyle: AppTextStyles.hintBodySmall),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)
                                  ?.complete_text;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          AppLocalizations.of(context)?.introduce ??
                              "Introduce: ",
                          style: AppTextStyles.titleMedium,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _introduceController,
                          style: AppTextStyles.bodyMedium,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText:
                                AppLocalizations.of(context)?.introduce_hint,
                            hintStyle: AppTextStyles.hintBodySmall,
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await saveProfile();
                          },
                          child: Text(
                            AppLocalizations.of(context)?.save ?? "Save",
                            style: AppTextStyles.titleMedium,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            child: CirclePicker(
              onSaved: (data) {
                viewModel.saveImageAvatar(data);
              },
              existingImageUrl: state.profile?.imageUrl,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> saveProfile() async {
    Object? error;
    final formState = _formKey.currentState;
    if (formState == null) return;
    if (formState.validate()) {
      await loading.whileLoading(context, () async {
        try {
          viewModel.saveName(_nameController.text);
          viewModel.saveAddress(_addressController.text);
          viewModel.saveIntroduce(_introduceController.text);
          await viewModel.saveProfile();
          formState.reset();
          final nextRoute = widget.nextRoute;
          if (nextRoute != null && mounted) {
            await AutoRouter.of(context).replace(nextRoute);
          }
        } catch (e) {
          error = e;
        }
      });
    }
    if (error != null) {
      handleError(error!);
    }
  }

  @override
  String get screenName => ProfileSettingRoute.name;

  ProfileSettingState get state => ref.watch(_provider);

  LoadingStateViewModel get loading => ref.read(loadingStateProvider.notifier);

  @override
  ProfileSettingViewModel get viewModel => ref.read(_provider.notifier);
}
