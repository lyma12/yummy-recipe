import 'package:flutter/material.dart';

class BNBCustomPaint extends CustomPainter {
  int index = 1;
  final Color paintColor;
  final Color paintIconColor;

  BNBCustomPaint(this.index,
      {this.paintColor = Colors.white, this.paintIconColor = Colors.white});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = paintColor
      ..style = PaintingStyle.fill;
    Paint paintIcon = Paint()
      ..color = paintIconColor
      ..style = PaintingStyle.fill;
    final paintFunctions = [paint0, paint1, paint2, paint3, paint4];
    if (index >= 0 && index < paintFunctions.length) {
      paintFunctions[index](canvas, size, paint, paintIcon);
    }
  }

  void paint2(Canvas canvas, Size size, Paint paint, Paint paintIcon) {
    Path path = Path()
      ..moveTo(0, size.height * 0.50)
      ..quadraticBezierTo(
          0, size.height * 0.25, size.width * (1 / 24), size.height * 0.25)
      ..lineTo(size.width * (7 / 24), size.height * 0.25)
      ..cubicTo(size.width * (1 / 3), size.height * 0.25, size.width * (1 / 3),
          size.height * 0.75, size.width * (3 / 8), size.height * 0.75)
      ..lineTo(size.width * (5 / 8), size.height * 0.75)
      ..cubicTo(size.width * (2 / 3), size.height * 0.75, size.width * (2 / 3),
          size.height * 0.25, size.width * (17 / 24), size.height * 0.25)
      ..lineTo(size.width * (23 / 24), size.height * 0.25)
      ..quadraticBezierTo(
          size.width, size.height * 0.25, size.width, size.height * 0.5)
      ..lineTo(size.width, size.height * 0.75)
      ..quadraticBezierTo(
          size.width, size.height * 0.95, size.width * 0.95, size.height * 0.95)
      ..lineTo(size.width * 0.05, size.height * 0.95)
      ..quadraticBezierTo(0, size.height * 0.95, 0, size.height * 0.75)
      ..close();

    Path circle = Path()
      ..moveTo(size.width * (3 / 8), size.height * 0.25)
      ..quadraticBezierTo(size.width * (3 / 8), 0, size.width * (5 / 12), 0)
      ..lineTo(size.width * (7 / 12), 0)
      ..quadraticBezierTo(
          size.width * (5 / 8), 0, size.width * (5 / 8), size.height * 0.25)
      ..lineTo(size.width * (5 / 8), size.height * 0.50)
      ..quadraticBezierTo(size.width * (5 / 8), size.height * 0.70,
          size.width * (7 / 12), size.height * 0.70)
      ..lineTo(size.width * (5 / 12), size.height * 0.70)
      ..quadraticBezierTo(size.width * (3 / 8), size.height * 0.70,
          size.width * (3 / 8), size.height * 0.5)
      ..close();
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawShadow(circle, Colors.black, 5, true);
    canvas.drawPath(path, paint);
    canvas.drawPath(circle, paintIcon);
  }

  void paint0(Canvas canvas, Size size, Paint paint, Paint paintIcon) {
    Path path = Path()
      ..moveTo(0, size.height * 0.5)
      ..quadraticBezierTo(
          0, size.height * 0.25, size.width * (1 / 48), size.height * 0.25)
      ..cubicTo(size.width * (1 / 24), size.height * 0.25, 0,
          size.height * 0.75, size.width * (1 / 24), size.height * 0.75)
      ..quadraticBezierTo(size.width * (1 / 24), size.height * 0.75,
          size.width * (7 / 24), size.height * 0.75)
      ..cubicTo(size.width * (1 / 3), size.height * 0.75, size.width * (1 / 3),
          size.height * 0.25, size.width * (3 / 8), size.height * 0.25)
      ..lineTo(size.width * (23 / 24), size.height * 0.25)
      ..quadraticBezierTo(
          size.width, size.height * 0.25, size.width, size.height * 0.50)
      ..lineTo(size.width, size.height * 0.75)
      ..quadraticBezierTo(
          size.width, size.height, size.width * 0.95, size.height)
      ..lineTo(size.width * 0.05, size.height)
      ..quadraticBezierTo(0, size.height, 0, size.height * 0.75)
      ..lineTo(0, size.height * 0.5)
      ..close();

    Path circle = Path()
      ..moveTo(size.width * (1 / 24), size.height * 0.25)
      ..quadraticBezierTo(size.width * (1 / 24), 0, size.width * (1 / 12), 0)
      ..lineTo(size.width * (1 / 4), 0)
      ..quadraticBezierTo(
          size.width * (7 / 24), 0, size.width * (7 / 24), size.height * 0.25)
      ..lineTo(size.width * (7 / 24), size.height * 0.50)
      ..quadraticBezierTo(size.width * (7 / 24), size.height * 0.70,
          size.width * (1 / 4), size.height * 0.70)
      ..lineTo(size.width * (1 / 12), size.height * 0.70)
      ..quadraticBezierTo(size.width * (1 / 24), size.height * 0.70,
          size.width * (1 / 24), size.height * 0.50)
      ..close();

    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawShadow(circle, Colors.black, 5, true);
    canvas.drawPath(path, paint);
    canvas.drawPath(circle, paintIcon);
  }

  void paint1(Canvas canvas, Size size, Paint paint, Paint paintIcon) {
    Path path = Path()
      ..moveTo(0, size.height * 0.5)
      ..quadraticBezierTo(
          0, size.height * 0.25, size.width * (1 / 24), size.height * 0.25)
      ..lineTo(size.width * (1 / 8), size.height * 0.25)
      ..cubicTo(size.width * (1 / 6), size.height * 0.25, size.width * (1 / 6),
          size.height * 0.75, size.width * (1 / 4), size.height * 0.75)
      ..lineTo(size.width * (5 / 12), size.height * 0.75)
      ..cubicTo(size.width * (1 / 2), size.height * 0.75, size.width * 0.50,
          size.height * 0.25, size.width * (13 / 24), size.height * 0.25)
      ..lineTo(size.width * (23 / 24), size.height * 0.25)
      ..quadraticBezierTo(
          size.width, size.height * 0.25, size.width, size.height * 0.5)
      ..lineTo(size.width, size.height * 0.75)
      ..quadraticBezierTo(size.width, size.height * 0.95,
          size.width * (23 / 24), size.height * 0.95)
      ..lineTo(size.width * (1 / 24), size.height * 0.95)
      ..quadraticBezierTo(0, size.height * 0.95, 0, size.height * 0.75)
      ..lineTo(0, size.height * 0.5)
      ..close();

    Path circle = Path()
      ..moveTo(size.width * (5 / 24), size.height * 0.25)
      ..quadraticBezierTo(size.width * (5 / 24), 0, size.width * (1 / 4), 0)
      ..lineTo(size.width * (5 / 12), 0)
      ..quadraticBezierTo(
          size.width * (11 / 24), 0, size.width * (11 / 24), size.height * 0.25)
      ..lineTo(size.width * (11 / 24), size.height * 0.50)
      ..quadraticBezierTo(size.width * (11 / 24), size.height * 0.70,
          size.width * (5 / 12), size.height * 0.70)
      ..lineTo(size.width * (1 / 4), size.height * 0.70)
      ..quadraticBezierTo(size.width * (5 / 24), size.height * 0.70,
          size.width * (5 / 24), size.height * 0.5)
      ..close();
    canvas.drawShadow(circle, Colors.black, 5, true);
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
    canvas.drawPath(circle, paintIcon);
  }

  void paint3(Canvas canvas, Size size, Paint paint, Paint paintIcon) {
    Path path = Path()
      ..moveTo(0, size.height * 0.50)
      ..quadraticBezierTo(
          0, size.height * 0.25, size.width * (1 / 24), size.height * 0.25)
      ..lineTo(size.width * (11 / 24), size.height * 0.25)
      ..cubicTo(size.width * (1 / 2), size.height * 0.25, size.width * (1 / 2),
          size.height * 0.75, size.width * (13 / 24), size.height * 0.75)
      ..lineTo(size.width * (19 / 24), size.height * 0.75)
      ..cubicTo(size.width * (5 / 6), size.height * 0.75, size.width * (5 / 6),
          size.height * 0.25, size.width * (7 / 8), size.height * 0.25)
      ..lineTo(size.width * (23 / 24), size.height * 0.25)
      ..quadraticBezierTo(
          size.width, size.height * 0.25, size.width, size.height * 0.5)
      ..lineTo(size.width, size.height * 0.75)
      ..quadraticBezierTo(
          size.width, size.height * 0.95, size.width * 0.95, size.height * 0.95)
      ..lineTo(size.width * 0.05, size.height * 0.95)
      ..quadraticBezierTo(0, size.height * 0.95, 0, size.height * 0.75)
      ..close();

    Path circle = Path()
      ..moveTo(size.width * (13 / 24), size.height * 0.25)
      ..quadraticBezierTo(size.width * (13 / 24), 0, size.width * (7 / 12), 0)
      ..lineTo(size.width * (3 / 4), 0)
      ..quadraticBezierTo(
          size.width * (19 / 24), 0, size.width * (19 / 24), size.height * 0.25)
      ..lineTo(size.width * (19 / 24), size.height * 0.50)
      ..quadraticBezierTo(size.width * (19 / 24), size.height * 0.70,
          size.width * (3 / 4), size.height * 0.70)
      ..lineTo(size.width * (7 / 12), size.height * 0.70)
      ..quadraticBezierTo(size.width * (13 / 24), size.height * 0.70,
          size.width * (13 / 24), size.height * 0.5)
      ..close();
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawShadow(circle, Colors.black, 5, true);
    canvas.drawPath(path, paint);
    canvas.drawPath(circle, paintIcon);
  }

  void paint4(Canvas canvas, Size size, Paint paint, Paint paintIcon) {
    Path path = Path()
      ..moveTo(0, size.height * 0.50)
      ..quadraticBezierTo(
          0, size.height * 0.25, size.width * (1 / 24), size.height * 0.25)
      ..lineTo(size.width * (5 / 8), size.height * 0.25)
      ..cubicTo(size.width * (2 / 3), size.height * 0.25, size.width * (2 / 3),
          size.height * 0.75, size.width * (17 / 24), size.height * 0.75)
      ..lineTo(size.width * (23 / 24), size.height * 0.75)
      ..cubicTo(
          size.width * (47 / 48),
          size.height * 0.75,
          size.width * (47 / 48),
          size.height * 0.25,
          size.width * (47 / 48),
          size.height * 0.25)
      ..lineTo(size.width * (47 / 48), size.height * 0.25)
      ..quadraticBezierTo(
          size.width, size.height * 0.25, size.width, size.height * 0.5)
      ..lineTo(size.width, size.height * 0.75)
      ..quadraticBezierTo(
          size.width, size.height * 0.95, size.width * 0.95, size.height * 0.95)
      ..lineTo(size.width * 0.05, size.height * 0.95)
      ..quadraticBezierTo(0, size.height * 0.95, 0, size.height * 0.75)
      ..close();

    Path circle = Path()
      ..moveTo(size.width * (17 / 24), size.height * 0.25)
      ..quadraticBezierTo(size.width * (17 / 24), 0, size.width * (3 / 4), 0)
      ..lineTo(size.width * (11 / 12), 0)
      ..quadraticBezierTo(
          size.width * (23 / 24), 0, size.width * (23 / 24), size.height * 0.25)
      ..lineTo(size.width * (23 / 24), size.height * 0.50)
      ..quadraticBezierTo(size.width * (23 / 24), size.height * 0.70,
          size.width * (11 / 12), size.height * 0.70)
      ..lineTo(size.width * (3 / 4), size.height * 0.70)
      ..quadraticBezierTo(size.width * (17 / 24), size.height * 0.70,
          size.width * (17 / 24), size.height * 0.5)
      ..close();
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawShadow(circle, Colors.black, 5, true);
    canvas.drawPath(path, paint);
    canvas.drawPath(circle, paintIcon);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate is BNBCustomPaint) {
      return oldDelegate.index != index;
    }
    return false;
  }
}
