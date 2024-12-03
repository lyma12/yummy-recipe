import 'package:flutter/widgets.dart';

import '../../../resources/gen/colors.gen.dart';

class CircleButton extends StatelessWidget {
  const CircleButton({
    this.width = 40,
    this.height = 40,
    required this.child,
    required this.onTap,
    this.backgroundColor = ColorName.grayF2F6FA,
    super.key,
  });

  final Widget child;

  final VoidCallback? onTap;

  final double height;

  final double width;

  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
        ),
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
