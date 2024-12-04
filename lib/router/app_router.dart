import 'package:auto_route/auto_route.dart';
import 'package:base_code_template_flutter/data/models/recipe/recipe.dart';
import 'package:base_code_template_flutter/screens/create/create_screen.dart';
import 'package:base_code_template_flutter/screens/first_time/first_time_screen.dart';
import 'package:base_code_template_flutter/screens/login/login_screen.dart';
import 'package:flutter/cupertino.dart';
import '../data/models/user/spoonacular_account.dart';
import '../screens/account/account_screen.dart';
import '../screens/detail_recipe/firebase/detail_firebase_recipe_screen.dart';
import '../screens/detail_recipe/spoonacular/detail_spoonacular_recipe_screen.dart';
import '../screens/favourite_recipe/favourite_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/main/main_screen.dart';
import '../screens/menu/menu_screen.dart';
import '../screens/meal_plan/calendar/calendar_screen.dart';
import '../screens/meal_plan/meal_plan_screen.dart';
import '../screens/meal_plan/shopping_list/shopping_list_screen.dart';
import '../screens/notification/notification_screen.dart';
import '../screens/scraping_data/scraping_data_screen.dart';
import '../screens/setting/profile/profile_setting_screen.dart';
import '../screens/setting/queries/queries_setting_screen.dart';
import '../screens/splash/splash_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: SplashRoute.page,
          path: '/',
        ),
        AutoRoute(page: FirstTimeRoute.page, path: '/broad'),
        AutoRoute(
          page: LoginRoute.page,
          path: '/login',
        ),
        AutoRoute(
          page: SettingRoute.page,
          path: '/setting',
          children: [
            AutoRoute(
              page: ProfileSettingRoute.page,
              path: 'profile',
            ),
            AutoRoute(
              page: QueriesSettingRoute.page,
              path: 'queries',
            ),
          ],
        ),
        AutoRoute(
          page: MainRoute.page,
          path: '/main',
          children: [
            AutoRoute(
              page: HomeTabRoute.page,
              path: 'homeTab',
              children: [
                AutoRoute(
                  page: HomeRoute.page,
                  path: '',
                ),
                AutoRoute(
                  page: DetailFirebaseRecipeRoute.page,
                  path: 'detail',
                ),
                AutoRoute(
                  page: DetailSpoonacularRecipeRoute.page,
                  path: 'detail',
                )
                // inspection child page define here
              ],
            ),
            AutoRoute(
              page: MealPlanTabRoute.page,
              path: 'mealPlanTab',
              children: [
                AutoRoute(
                  page: MealPlanRoute.page,
                  path: '',
                ),
                AutoRoute(
                  page: ScrapingDataRoute.page,
                  path: 'scraping',
                ),
                AutoRoute(
                  page: DetailFirebaseRecipeRoute.page,
                  path: 'detail',
                ),
                AutoRoute(
                  page: DetailSpoonacularRecipeRoute.page,
                  path: 'detail',
                )
                // inspection child page define here
              ],
            ),
            AutoRoute(
              page: CreateTabRoute.page,
              path: 'createTab',
              children: [
                AutoRoute(
                  page: CreateRoute.page,
                  path: '',
                ),
                AutoRoute(
                  page: ScrapingDataRoute.page,
                  path: 'scraping',
                ),
              ],
            ),
            AutoRoute(
              page: FavouriteTabRoute.page,
              path: 'favouriteTab',
              children: [
                AutoRoute(
                  page: FavouriteRoute.page,
                  path: '',
                ),
                AutoRoute(
                  page: DetailFirebaseRecipeRoute.page,
                  path: 'detail',
                ),
                AutoRoute(
                  page: DetailSpoonacularRecipeRoute.page,
                  path: 'detail',
                )
                // inspection child page define here
              ],
            ),
            AutoRoute(
              page: AccountTabRoute.page,
              path: 'notificationTab',
              children: [
                AutoRoute(
                  page: AccountRoute.page,
                  path: '',
                ),
                AutoRoute(
                  page: ProfileSettingRoute.page,
                  path: 'editProfile',
                ),
                AutoRoute(
                  page: QueriesSettingRoute.page,
                  path: 'editQueries',
                ),
                // inspection child page define here
              ],
            ),
            AutoRoute(
              page: MenuTabRoute.page,
              path: 'menuTab',
              children: [
                AutoRoute(
                  page: MenuRoute.page,
                  path: '',
                ),
                // inspection child page define here
              ],
            ),
          ],
        ),
      ];
}

@RoutePage(name: 'HomeTabRoute')
class HomeTabPage extends AutoRouter {
  const HomeTabPage({super.key});
}


@RoutePage(name: 'MealPlanTabRoute')
class MealPlanTabPage extends AutoRouter {
  const MealPlanTabPage({super.key});
}

@RoutePage(name: 'CreateTabRoute')
class CreateTabPage extends AutoRouter {
  const CreateTabPage({super.key});
}

@RoutePage(name: 'FavouriteTabRoute')
class FavouriteTabPage extends AutoRouter {
  const FavouriteTabPage({super.key});
}

@RoutePage(name: 'AccountTabRoute')
class AccountTabPage extends AutoRouter {
  const AccountTabPage({super.key});
}

@RoutePage(name: 'MenuTabRoute')
class MenuTabPage extends AutoRouter {
  const MenuTabPage({super.key});
}

@RoutePage(name: 'SettingRoute')
class SettingPage extends AutoRouter {
  const SettingPage({super.key});
}
