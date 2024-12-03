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
    CalendarRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CalendarScreen(),
      );
    },
    CalendarTabRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CalendarTabPage(),
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
    NotificationTabRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const NotificationTabPage(),
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
/// [CalendarScreen]
class CalendarRoute extends PageRouteInfo<void> {
  const CalendarRoute({List<PageRouteInfo>? children})
      : super(
          CalendarRoute.name,
          initialChildren: children,
        );

  static const String name = 'CalendarRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [CalendarTabPage]
class CalendarTabRoute extends PageRouteInfo<void> {
  const CalendarTabRoute({List<PageRouteInfo>? children})
      : super(
          CalendarTabRoute.name,
          initialChildren: children,
        );

  static const String name = 'CalendarTabRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
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
/// [NotificationTabPage]
class NotificationTabRoute extends PageRouteInfo<void> {
  const NotificationTabRoute({List<PageRouteInfo>? children})
      : super(
          NotificationTabRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationTabRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
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
