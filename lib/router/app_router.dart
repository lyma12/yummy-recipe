import 'package:auto_route/auto_route.dart';
import 'package:base_code_template_flutter/data/models/recipe/recipe.dart';
import 'package:base_code_template_flutter/screens/create/create_screen.dart';
import 'package:base_code_template_flutter/screens/first_time/first_time_screen.dart';
import 'package:base_code_template_flutter/screens/login/login_screen.dart';
import 'package:flutter/cupertino.dart';

import '../screens/detail_recipe/firebase/detail_firebase_recipe_screen.dart';
import '../screens/detail_recipe/spoonacular/detail_spoonacular_recipe_screen.dart';
import '../screens/favourite_recipe/favourite_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/main/main_screen.dart';
import '../screens/menu/menu_screen.dart';
import '../screens/notification/notification_screen.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/video/calendar_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: SplashRoute.page,
          path: '/',
        ),
        AutoRoute(
          page: FirstTimeRoute.page,
          path: '/broad',
        ),
        AutoRoute(
          page: LoginRoute.page,
          path: '/login',
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
              page: CalendarTabRoute.page,
              path: 'videoTab',
              children: [
                AutoRoute(
                  page: CalendarRoute.page,
                  path: '',
                ),
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
              page: NotificationTabRoute.page,
              path: 'notificationTab',
              children: [
                AutoRoute(
                  page: NotificationRoute.page,
                  path: '',
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

@RoutePage(name: 'CalendarTabRoute')
class CalendarTabPage extends AutoRouter {
  const CalendarTabPage({super.key});
}

@RoutePage(name: 'CreateTabRoute')
class CreateTabPage extends AutoRouter {
  const CreateTabPage({super.key});
}

@RoutePage(name: 'FavouriteTabRoute')
class FavouriteTabPage extends AutoRouter {
  const FavouriteTabPage({super.key});
}

@RoutePage(name: 'NotificationTabRoute')
class NotificationTabPage extends AutoRouter {
  const NotificationTabPage({super.key});
}

@RoutePage(name: 'MenuTabRoute')
class MenuTabPage extends AutoRouter {
  const MenuTabPage({super.key});
}
