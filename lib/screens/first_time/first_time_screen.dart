import 'package:auto_route/auto_route.dart';
import 'package:base_code_template_flutter/components/base_view/base_view.dart';
import 'package:base_code_template_flutter/data/providers/shared_preference_repository_provider.dart';
import 'package:base_code_template_flutter/resources/gen/assets.gen.dart';
import 'package:base_code_template_flutter/router/app_router.dart';
import 'package:base_code_template_flutter/screens/first_time/components/dash_board_page_view.dart';
import 'package:base_code_template_flutter/screens/first_time/first_time_model.dart';
import 'package:base_code_template_flutter/screens/first_time/first_time_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _provider =
    StateNotifierProvider.autoDispose<FirstTimeModel, FirstTimeState>(
  (ref) => FirstTimeModel(
      ref: ref, firstTimeRepository: ref.watch(firstTimeRepositoryProvider)),
);

@RoutePage()
class FirstTimeScreen extends BaseView {
  const FirstTimeScreen({super.key});

  @override
  BaseViewState<FirstTimeScreen, FirstTimeModel> createState() =>
      _FirstTimeViewState();
}

class _FirstTimeViewState
    extends BaseViewState<FirstTimeScreen, FirstTimeModel> {
  @override
  Widget build(BuildContext context) {
    if (state.isFirstTime) AutoRouter.of(context).replace(const LoginRoute());
    return super.build(context);
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return null;
  }

  @override
  Widget buildBody(BuildContext context) {
    if (state.isFirstTime) {
      context.replaceRoute(
          const LoginRoute()); //AutoRouter.of(context).replace(const LoginRoute());
    }
    return !state.isFirstTime
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: PageView(
                  scrollDirection: Axis.horizontal,
                  pageSnapping: true,
                  onPageChanged: (i) => viewModel.changePage(i),
                  children: <Widget>[
                    DashBoardPageView(
                      title: AppLocalizations.of(context)?.pageViewTitle1 ??
                          "Page1",
                      image: Assets.images.firstTime.variant1
                          .image(fit: BoxFit.contain),
                    ),
                    DashBoardPageView(
                      title: AppLocalizations.of(context)?.pageViewTitle2 ??
                          "Page2",
                      image: Assets.images.firstTime.variant2
                          .image(fit: BoxFit.contain),
                    ),
                    DashBoardPageView(
                      title: AppLocalizations.of(context)?.pageViewTitle3 ??
                          "Page3",
                      image: Assets.images.firstTime.variant3
                          .image(fit: BoxFit.contain),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    3,
                    (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeIn,
                            width: index == state.currentPage ? 20 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: index == state.currentPage
                                  ? Theme.of(context).indicatorColor
                                  : Theme.of(context).hoverColor,
                            ),
                          ),
                        )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => {viewModel.setFinishFirstTime()},
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 24),
                      child: Text(
                        AppLocalizations.of(context)?.buttonDashBoard ?? "Next",
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        : const Center();
  }

  @override
  FirstTimeModel get viewModel => ref.read(_provider.notifier);

  @override
  String get screenName => FirstTimeRoute.name;

  FirstTimeState get state => ref.watch(_provider);
}
