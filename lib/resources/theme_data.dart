import 'package:flutter/material.dart';

import '../../resources/gen/colors.gen.dart';

/*
primary: màu sắc được sử dụng nhiều trong app
onPrimary: màu sắc cho các phần từ nằm trên primary color
secondary: màu sắc phụ sử dụng cho các phần từ ít nổi bật
surface: màu sắc cơ bản dùng cho các thành phần như thẻ, dialogs, ...
*/
class GobalThemeData {
  static final Color _lightFocusColor = Colors.black.withOpacity(0.12);
  static final Color _darkFocusColor = Colors.white.withOpacity(0.12);
  static ThemeData lightThemeData =
      themeData(lightColorScheme, _lightFocusColor);
  static ThemeData darkThemeData = themeData(darkColorScheme, _darkFocusColor);

  static ThemeData themeData(ColorScheme colorScheme, Color focusColor) {
    return ThemeData(
      canvasColor: colorScheme.surface,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      highlightColor: Colors.transparent,
      focusColor: focusColor,
      indicatorColor: colorScheme.outline,
      hoverColor: colorScheme.outlineVariant,
    );
  }

  static const ColorScheme lightColorScheme = ColorScheme(
    primary: ColorName.lightPrimary,
    onPrimary: ColorName.black,
    secondary: ColorName.lightSecondary,
    onSecondary: ColorName.lightOnSecondary,
    error: ColorName.lightError,
    onError: ColorName.lightOnError,
    surface: ColorName.lightSurface,
    onSurface: ColorName.lightOnSurface,
    brightness: Brightness.light,
    outline: ColorName.lightOutline,
    outlineVariant: ColorName.lightOutlineVariant,
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    primary: ColorName.darkPrimary,
    onPrimary: ColorName.black,
    secondary: ColorName.darkSecondary,
    onSecondary: ColorName.darkOnSecondary,
    error: ColorName.darkError,
    onError: ColorName.darkOnError,
    surface: ColorName.darkSurface,
    onSurface: ColorName.darkOnSurface,
    brightness: Brightness.light,
    outline: ColorName.darkOutline,
    outlineVariant: ColorName.darkOutlineVariant,
  );
// static const TextTheme textStyle = TextTheme(
//   bodyLarge: TextStyle(
//     fontSize: 28,
//   ),
//   titleSmall:
//       TextStyle(fontSize: 16, color: Color.fromARGB(1, 151, 145, 151)),
//   displayLarge: TextStyle(
//     fontSize: 34,
//     fontWeight: FontWeight.bold,
//     color: Color.fromARGB(255, 238, 103, 35),
//   ),
//   headlineSmall: TextStyle(
//     fontSize: 17,
//     color: Color.fromARGB(200, 145, 137, 137),
//   ),
// );
}
