import 'package:base_code_template_flutter/resources/app_text_styles.dart';
import 'package:flutter/material.dart';

class DashBoardPageView extends StatelessWidget {
  const DashBoardPageView({
    super.key,
    required this.title,
    required this.image,
  });

  final String title;
  final Widget image;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        image,
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
          child: Text(
            title,
            style: AppTextStyles.titleLargeBold,
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
