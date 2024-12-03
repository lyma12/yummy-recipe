import 'dart:math';

import 'package:flutter/material.dart';

import 'loading_paint.dart';

class ErrorPainter extends IconPainter {
  ErrorPainter(super.time);

  final int count = 100;
  final int waveCount = 2;

  @override
  void paint(Canvas canvas, Size size) {
    Paint canvasRed = Paint()
      ..color = Colors.redAccent
      ..style = PaintingStyle.fill;
    Path canvasPath = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.5)
      ..cubicTo(size.width, 0, 0, size.height, 0, size.height * 0.5)
      ..close();
    canvas.drawPath(canvasPath, canvasRed);

    Paint facePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    Paint facePaintFull = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    Paint eyePaint = Paint()..color = Colors.black;
    Paint mouthPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final points = drawWavy(time)
        .map((e) => Offset(e.dx * size.width,
            (e.dy * size.height * 0.05) + size.height * 0.90))
        .toList();

    Path facePath = Path()
      ..addPolygon(points, false)
      ..quadraticBezierTo(size.width * 0.85, size.height * 0.90,
          size.width * 0.85, size.height * 0.80)
      ..quadraticBezierTo(size.width * 0.85, 0, size.width * 0.50, 0)
      ..quadraticBezierTo(
          size.width * 0.15, 0, size.width * 0.15, size.height * 0.80)
      ..quadraticBezierTo(
          size.width * 0.15, size.height * 0.95, points[0].dx, points[0].dy)
      ..close();
    canvas.drawPath(facePath, facePaintFull);
    canvas.drawPath(facePath, facePaint);

    double eyeX =
        size.width / 2 + size.width * (1 / 10) * sin(time * pi + pi / 2);
    double eyeY = size.width / 2 +
        size.width * (1 / 10) * cos(time * pi + pi / 2) -
        size.height * 0.15;
    double eyeWidth = size.width / 10;
    double eyeRadius = 4 * size.width / 100;
    canvas.drawCircle(
      Offset(eyeX - eyeWidth, eyeY),
      eyeRadius,
      eyePaint,
    );
    canvas.drawCircle(
      Offset(eyeX + eyeWidth, eyeY),
      eyeRadius,
      eyePaint,
    );
    Paint shadow = Paint()
      ..color = Colors.black12
      ..style = PaintingStyle.fill;
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width / 2, size.height),
            width: size.width / 2,
            height: size.height / 10),
        shadow);
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(eyeX, eyeY - size.height * 0.2),
        width: size.width * 0.1,
        height: size.height * 0.1,
      ),
      pi,
      pi / 4,
      false,
      mouthPaint,
    );
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(eyeX, eyeY + size.height * 0.1),
        width: size.width * 0.1,
        height: size.height * 0.1,
      ),
      1.25 * pi,
      pi * 0.5,
      false,
      mouthPaint,
    );
  }

  List<Offset> drawWavy(double t) {
    return List<Offset>.generate(count, (index) {
      final ratio = 0.3 + (index / (count - 1)) * 0.4;
      return Offset(ratio, sin(waveCount * (ratio + t) * pi * 2));
    }, growable: false);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
