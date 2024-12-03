import 'package:flutter/material.dart';

import '../../resources/gen/colors.gen.dart';

class DividerHorizontal extends StatelessWidget {
  const DividerHorizontal({
    this.height = 1,
    this.color = ColorName.grayFFEDEDED,
    super.key,
  });

  final double height;

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      color: color,
    );
  }
}
