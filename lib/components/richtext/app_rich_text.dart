import 'package:base_code_template_flutter/resources/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppRichText {
  static Widget richTextTitleValueIcon({
    required String? title,
    required double? value,
    Icon? icon,
    String? iconString,
  }) {
    return RichText(
      text: TextSpan(
        text: title,
        style: AppTextStyles.bodyMediumBold,
        children: <InlineSpan>[
          TextSpan(
            text: (value ?? 0).toString(),
            style: AppTextStyles.bodyMedium,
          ),
          if (iconString != null)
            TextSpan(
              text: iconString,
              style: AppTextStyles.titleLargeBold,
            ),
          if (icon != null)
            WidgetSpan(
              child: icon,
            )
        ],
      ),
    );
  }

  static Widget richTextInSequents(
      {required Color color, required String name}) {
    return RichText(
      text: TextSpan(children: [
        WidgetSpan(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: SizedBox(
              height: 15,
              width: 15,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color,
                ),
              ),
            ),
          ),
        ),
        TextSpan(
          text: name,
          style: const TextStyle(fontSize: 9, color: Colors.black),
        ),
      ]),
    );
  }

  static Widget richTextTextIconTextIcon(
      {required String? mainText,
      required Widget firstIcon,
      required String? textBetween,
      required Widget secondIcon}) {
    return RichText(
      text: TextSpan(
        text: mainText,
        style: AppTextStyles.titleMedium,
        children: <InlineSpan>[
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: firstIcon,
          ),
          TextSpan(text: textBetween, style: AppTextStyles.titleMedium),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: secondIcon,
          ),
        ],
      ),
    );
  }

  static Widget richTextIconText(
      {Icon? icon, required String data, required String? name}) {
    return RichText(
      text: TextSpan(children: [
        if (icon != null)
          WidgetSpan(
            child: icon,
          ),
        TextSpan(
          text: name,
          style: AppTextStyles.s10,
        ),
        TextSpan(
          text: data,
          style: AppTextStyles.s10,
        )
      ]),
    );
  }
}
