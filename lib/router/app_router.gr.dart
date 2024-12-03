// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AccountRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AccountScreen(),
      );
    },
    AccountTabRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AccountTabPage(),
      );
    },
    CalendarRoute.name: (routeData) {
      final args = routeData.argsAs<CalendarRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CalendarScreen(
          key: args.key,
          user: args.user,
        ),
      );
    },
    CreateRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CreateScreen(),
      );
    },
    CreateTabRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CreateTabPage(),
      );
    },
    DetailFirebaseRecipeRoute.name: (routeData) {
      final args = routeData.argsAs<DetailFirebaseRecipeRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: DetailFirebaseRecipeScreen(
          key: args.key,
          recipe: args.recipe,
        ),
      );
    },
    DetailSpoonacularRecipeRoute.name: (routeData) {
      final args = routeData.argsAs<DetailSpoonacularRecipeRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: DetailSpoonacularRecipeScreen(
          key: args.key,
          recipe: args.recipe,
        ),
      );
    },
    FavouriteRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const FavouriteScreen(),
      );
    },
    FavouriteTabRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const FavouriteTabPage(),
      );
    },
    FirstTimeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const FirstTimeScreen(),
      );
    },
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeScreen(),
      );
    },
    HomeTabRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeTabPage(),
      );
    },
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginScreen(),
      );
    },
    MainRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MainScreen(),
      );
    },
    MealPlanRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MealPlanScreen(),
      );
    },
    MealPlanTabRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MealPlanTabPage(),
      );
    },
    MenuRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MenuScreen(),
      );
    },
    MenuTabRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MenuTabPage(),
      );
    },
    NotificationRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const NotificationScreen(),
      );
    },
    ProfileSettingRoute.name: (routeData) {
      final args = routeData.argsAs<ProfileSettingRouteArgs>(
          orElse: () => const ProfileSettingRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ProfileSettingScreen(
          key: args.key,
          nextRoute: args.nextRoute,
        ),
      );
    },
    QueriesSettingRoute.name: (routeData) {
      final args = routeData.argsAs<QueriesSettingRouteArgs>(
          orElse: () => const QueriesSettingRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: QueriesSettingScreen(
          key: args.key,
          nextRoute: args.nextRoute,
        ),
      );
    },
    ScrapingDataRoute.name: (routeData) {
      final args = routeData.argsAs<ScrapingDataRouteArgs>(
          orElse: () => const ScrapingDataRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ScrapingDataScreen(
          key: args.key,
          onSelectRecipe: args.onSelectRecipe,
        ),
      );
    },
    SettingRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SettingPage(),
      );
    },
    ShoppingListRoute.name: (routeData) {
      final args = routeData.argsAs<ShoppingListRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ShoppingListScreen(
          key: args.key,
          user: args.user,
        ),
      );
    },
    SplashRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SplashScreen(),
      );
    },
  };
}

/// generated route for
/// [AccountScreen]
class AccountRoute extends PageRouteInfo<void> {
  const AccountRoute({List<PageRouteInfo>? children})
      : super(
          AccountRoute.name,
          initialChildren: children,
        );

  static const String name = 'AccountRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AccountTabPage]
class AccountTabRoute extends PageRouteInfo<void> {
  const AccountTabRoute({List<PageRouteInfo>? children})
      : super(
          AccountTabRoute.name,
          initialChildren: children,
        );

  static const String name = 'AccountTabRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [CalendarScreen]
class CalendarRoute extends PageRouteInfo<CalendarRouteArgs> {
  CalendarRoute({
    Key? key,
    required SpoonacularAccount user,
    List<PageRouteInfo>? children,
  }) : super(
          CalendarRoute.name,
          args: CalendarRouteArgs(
            key: key,
            user: user,
          ),
          initialChildren: children,
        );

  static const String name = 'CalendarRoute';

  static const PageInfo<CalendarRouteArgs> page =
      PageInfo<CalendarRouteArgs>(name);
}

class CalendarRouteArgs {
  const CalendarRouteArgs({
    this.key,
    required this.user,
  });

  final Key? key;

  final SpoonacularAccount user;

  @override
  String toString() {
    return 'CalendarRouteArgs{key: $key, user: $user}';
  }
}

/// generated route for
/// [CreateScreen]
class CreateRoute extends PageRouteInfo<void> {
  const CreateRoute({List<PageRouteInfo>? children})
      : super(
          CreateRoute.name,
          initialChildren: children,
        );

  static const String name = 'CreateRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [CreateTabPage]
class CreateTabRoute extends PageRouteInfo<void> {
  const CreateTabRoute({List<PageRouteInfo>? children})
      : super(
          CreateTabRoute.name,
          initialChildren: children,
        );

  static const String name = 'CreateTabRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DetailFirebaseRecipeScreen]
class DetailFirebaseRecipeRoute
    extends PageRouteInfo<DetailFirebaseRecipeRouteArgs> {
  DetailFirebaseRecipeRoute({
    Key? key,
    required Recipe recipe,
    List<PageRouteInfo>? children,
  }) : super(
          DetailFirebaseRecipeRoute.name,
          args: DetailFirebaseRecipeRouteArgs(
            key: key,
            recipe: recipe,
          ),
          initialChildren: children,
        );

  static const String name = 'DetailFirebaseRecipeRoute';

  static const PageInfo<DetailFirebaseRecipeRouteArgs> page =
      PageInfo<DetailFirebaseRecipeRouteArgs>(name);
}

class DetailFirebaseRecipeRouteArgs {
  const DetailFirebaseRecipeRouteArgs({
    this.key,
    required this.recipe,
  });

  final Key? key;

  final Recipe recipe;

  @override
  String toString() {
    return 'DetailFirebaseRecipeRouteArgs{key: $key, recipe: $recipe}';
  }
}

/// generated route for
/// [DetailSpoonacularRecipeScreen]
class DetailSpoonacularRecipeRoute
    extends PageRouteInfo<DetailSpoonacularRecipeRouteArgs> {
  DetailSpoonacularRecipeRoute({
    Key? key,
    required Recipe recipe,
    List<PageRouteInfo>? children,
  }) : super(
          DetailSpoonacularRecipeRoute.name,
          args: DetailSpoonacularRecipeRouteArgs(
            key: key,
            recipe: recipe,
          ),
          initialChildren: children,
        );

  static const String name = 'DetailSpoonacularRecipeRoute';

  static const PageInfo<DetailSpoonacularRecipeRouteArgs> page =
      PageInfo<DetailSpoonacularRecipeRouteArgs>(name);
}

class DetailSpoonacularRecipeRouteArgs {
  const DetailSpoonacularRecipeRouteArgs({
    this.key,
    required this.recipe,
  });

  final Key? key;

  final Recipe recipe;

  @override
  String toString() {
    return 'DetailSpoonacularRecipeRouteArgs{key: $key, recipe: $recipe}';
  }
}

/// generated route for
/// [FavouriteScreen]
class FavouriteRoute extends PageRouteInfo<void> {
  const FavouriteRoute({List<PageRouteInfo>? children})
      : super(
          FavouriteRoute.name,
          initialChildren: children,
        );

  static const String name = 'FavouriteRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [FavouriteTabPage]
class FavouriteTabRoute extends PageRouteInfo<void> {
  const FavouriteTabRoute({List<PageRouteInfo>? children})
      : super(
          FavouriteTabRoute.name,
          initialChildren: children,
        );

  static const String name = 'FavouriteTabRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [FirstTimeScreen]
class FirstTimeRoute extends PageRouteInfo<void> {
  const FirstTimeRoute({List<PageRouteInfo>? children})
      : super(
          FirstTimeRoute.name,
          initialChildren: children,
        );

  static const String name = 'FirstTimeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HomeTabPage]
class HomeTabRoute extends PageRouteInfo<void> {
  const HomeTabRoute({List<PageRouteInfo>? children})
      : super(
          HomeTabRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeTabRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoginScreen]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MainScreen]
class MainRoute extends PageRouteInfo<void> {
  const MainRoute({List<PageRouteInfo>? children})
      : super(
          MainRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MealPlanScreen]
class MealPlanRoute extends PageRouteInfo<void> {
  const MealPlanRoute({List<PageRouteInfo>? children})
      : super(
          MealPlanRoute.name,
          initialChildren: children,
        );

  static const String name = 'MealPlanRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MealPlanTabPage]
class MealPlanTabRoute extends PageRouteInfo<void> {
  const MealPlanTabRoute({List<PageRouteInfo>? children})
      : super(
          MealPlanTabRoute.name,
          initialChildren: children,
        );

  static const String name = 'MealPlanTabRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MenuScreen]
class MenuRoute extends PageRouteInfo<void> {
  const MenuRoute({List<PageRouteInfo>? children})
      : super(
          MenuRoute.name,
          initialChildren: children,
        );

  static const String name = 'MenuRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MenuTabPage]
class MenuTabRoute extends PageRouteInfo<void> {
  const MenuTabRoute({List<PageRouteInfo>? children})
      : super(
          MenuTabRoute.name,
          initialChildren: children,
        );

  static const String name = 'MenuTabRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [NotificationScreen]
class NotificationRoute extends PageRouteInfo<void> {
  const NotificationRoute({List<PageRouteInfo>? children})
      : super(
          NotificationRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProfileSettingScreen]
class ProfileSettingRoute extends PageRouteInfo<ProfileSettingRouteArgs> {
  ProfileSettingRoute({
    Key? key,
    PageRouteInfo<dynamic>? nextRoute,
    List<PageRouteInfo>? children,
  }) : super(
          ProfileSettingRoute.name,
          args: ProfileSettingRouteArgs(
            key: key,
            nextRoute: nextRoute,
          ),
          initialChildren: children,
        );

  static const String name = 'ProfileSettingRoute';

  static const PageInfo<ProfileSettingRouteArgs> page =
      PageInfo<ProfileSettingRouteArgs>(name);
}

class ProfileSettingRouteArgs {
  const ProfileSettingRouteArgs({
    this.key,
    this.nextRoute,
  });

  final Key? key;

  final PageRouteInfo<dynamic>? nextRoute;

  @override
  String toString() {
    return 'ProfileSettingRouteArgs{key: $key, nextRoute: $nextRoute}';
  }
}

/// generated route for
/// [QueriesSettingScreen]
class QueriesSettingRoute extends PageRouteInfo<QueriesSettingRouteArgs> {
  QueriesSettingRoute({
    Key? key,
    PageRouteInfo<dynamic>? nextRoute,
    List<PageRouteInfo>? children,
  }) : super(
          QueriesSettingRoute.name,
          args: QueriesSettingRouteArgs(
            key: key,
            nextRoute: nextRoute,
          ),
          initialChildren: children,
        );

  static const String name = 'QueriesSettingRoute';

  static const PageInfo<QueriesSettingRouteArgs> page =
      PageInfo<QueriesSettingRouteArgs>(name);
}

class QueriesSettingRouteArgs {
  const QueriesSettingRouteArgs({
    this.key,
    this.nextRoute,
  });

  final Key? key;

  final PageRouteInfo<dynamic>? nextRoute;

  @override
  String toString() {
    return 'QueriesSettingRouteArgs{key: $key, nextRoute: $nextRoute}';
  }
}

/// generated route for
/// [ScrapingDataScreen]
class ScrapingDataRoute extends PageRouteInfo<ScrapingDataRouteArgs> {
  ScrapingDataRoute({
    Key? key,
    dynamic Function(Recipe)? onSelectRecipe,
    List<PageRouteInfo>? children,
  }) : super(
          ScrapingDataRoute.name,
          args: ScrapingDataRouteArgs(
            key: key,
            onSelectRecipe: onSelectRecipe,
          ),
          initialChildren: children,
        );

  static const String name = 'ScrapingDataRoute';

  static const PageInfo<ScrapingDataRouteArgs> page =
      PageInfo<ScrapingDataRouteArgs>(name);
}

class ScrapingDataRouteArgs {
  const ScrapingDataRouteArgs({
    this.key,
    this.onSelectRecipe,
  });

  final Key? key;

  final dynamic Function(Recipe)? onSelectRecipe;

  @override
  String toString() {
    return 'ScrapingDataRouteArgs{key: $key, onSelectRecipe: $onSelectRecipe}';
  }
}

/// generated route for
/// [SettingPage]
class SettingRoute extends PageRouteInfo<void> {
  const SettingRoute({List<PageRouteInfo>? children})
      : super(
          SettingRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ShoppingListScreen]
class ShoppingListRoute extends PageRouteInfo<ShoppingListRouteArgs> {
  ShoppingListRoute({
    Key? key,
    required SpoonacularAccount user,
    List<PageRouteInfo>? children,
  }) : super(
          ShoppingListRoute.name,
          args: ShoppingListRouteArgs(
            key: key,
            user: user,
          ),
          initialChildren: children,
        );

  static const String name = 'ShoppingListRoute';

  static const PageInfo<ShoppingListRouteArgs> page =
      PageInfo<ShoppingListRouteArgs>(name);
}

class ShoppingListRouteArgs {
  const ShoppingListRouteArgs({
    this.key,
    required this.user,
  });

  final Key? key;

  final SpoonacularAccount user;

  @override
  String toString() {
    return 'ShoppingListRouteArgs{key: $key, user: $user}';
  }
}

/// generated route for
/// [SplashScreen]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
