import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../resources/app_text_styles.dart';

class OptionButton extends StatelessWidget {
  const OptionButton({
    required this.label,
    required this.onTap,
    this.icon,
    this.iconColor,
    this.iconPath,
    super.key,
  });

  final IconData? icon;

  final Color? iconColor;

  final String? iconPath;

  final String label;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Row(
        children: [
          if (iconPath?.isNotEmpty ?? false)
            SvgPicture.asset(
              iconPath ?? '',
              width: 20,
              height: 20,
            )
          else
            Icon(
              icon,
              color: iconColor,
            ),
          const SizedBox(width: 5),
          Text(
            label,
            style: AppTextStyles.s14w400,
          ),
        ],
      ),
    );
  }
}
