import 'package:base_code_template_flutter/components/paint/loading_paint.dart';
import 'package:flutter/material.dart';

class IconAnimationView extends StatefulWidget {
  const IconAnimationView(
      {super.key,
      required this.iconPainterBuilder,
      this.height = 200,
      this.width = 200});

  final double height;
  final double width;

  final IconPainter Function(double time) iconPainterBuilder;

  @override
  _IconAnimationViewState createState() => _IconAnimationViewState();
}

class _IconAnimationViewState extends State<IconAnimationView>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5))
          ..repeat(reverse: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = widget.width;
    final height = widget.height;
    return Center(
      child: AnimatedBuilder(
        animation: controller,
        builder: ((context, child) {
          return CustomPaint(
            painter: widget.iconPainterBuilder(controller.value),
            size: Size(
              width,
              height,
            ),
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
