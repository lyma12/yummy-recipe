import 'package:flutter/material.dart';

class ShimmerWidget extends StatefulWidget {
  final double height;
  final double width;
  final Color baseColor;
  final Color highlightColor;

  const ShimmerWidget({
    super.key,
    required this.height,
    required this.width,
    this.baseColor = Colors.grey,
    this.highlightColor = Colors.white,
  });

  @override
  ShimmerWidgetState createState() => ShimmerWidgetState();
}

class ShimmerWidgetState extends State<ShimmerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: -1, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor
              ],
              stops: [0.0, _animation.value, 1.0],
              begin: const Alignment(-1, 0),
              end: const Alignment(1, 0),
            ).createShader(bounds);
          },
          child: Container(
            margin: const EdgeInsets.all(20),
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: const Color.fromARGB(153, 209, 208, 208),
              borderRadius: BorderRadius.circular(20), // Bo góc với bán kính 20
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
