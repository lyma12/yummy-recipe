import 'package:base_code_template_flutter/resources/theme_data.dart';
import 'package:flutter/material.dart';

import 'gen/colors.gen.dart';
import 'gen/fonts.gen.dart';

class AppTextStyles {
  AppTextStyles._();

  static const defaultStyle = TextStyle(
    fontFamily: FontFamily.notoSans,
    color: ColorName.black,
  );

  static final bottomBarItemOn = defaultStyle.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w400,
  );

  static final bottomBarItem = defaultStyle.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w400,
  );

  static final s30w600 = defaultStyle.copyWith(
    fontSize: 30,
    fontWeight: FontWeight.w600,
  );

  static final s16w400 = defaultStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static final s16w700 = defaultStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static final s14w400 = defaultStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static final s20w400 = defaultStyle.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w400,
  );

  static final titleLargeBold = titleLarge.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  static final titleLarge = defaultStyle.copyWith(
    fontSize: 28,
  );

  static final bodyMedium = defaultStyle.copyWith(
    fontSize: 14,
  );
  static final bodyMediumBold = bodyMedium.copyWith(
    fontWeight: FontWeight.bold,
  );
  static final bodySmall = defaultStyle.copyWith(
    fontSize: 11,
  );
  static final titleMedium = defaultStyle.copyWith(
    fontSize: 16,
  );
  static final titleMediumBold = titleMedium.copyWith(
    fontWeight: FontWeight.bold,
  );
  static final hintBodySmall = bodySmall.copyWith(
    color: GobalThemeData.lightColorScheme.outlineVariant,
  );
  static final titleSmall = defaultStyle.copyWith(
    fontSize: 14,
  );
  static final titleSmallBold = titleSmall.copyWith(
    fontWeight: FontWeight.bold,
  );
  static final bodyMediumItalic = bodyMedium.copyWith(
    fontStyle: FontStyle.italic,
  );
  static final bodyLarge = defaultStyle.copyWith(
    fontSize: 24,
  );
  static final bodyLargeWhite = bodyLarge.copyWith(
    color: Colors.white,
  );
  static final s10 = defaultStyle.copyWith(
    fontSize: 10,
    color: Colors.black,
  );
}
