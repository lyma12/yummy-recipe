import 'dart:math';

import 'package:flutter/material.dart';

abstract class IconPainter extends CustomPainter {
  IconPainter(this.time);

  double time;
}

class LoadingPaint extends IconPainter {
  LoadingPaint(super.time);

  final int count = 100;
  final int waveCount = 3;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    Path path = Path()
      ..moveTo(size.width * 0.25, 0)
      ..lineTo(size.width * 0.75, 0)
      ..lineTo(size.width * 0.75, size.height * 0.35)
      ..quadraticBezierTo(size.width * 0.75, size.height * 0.50,
          size.width * 0.6, size.height * 0.50)
      ..lineTo(size.width * 0.40, size.height * 0.50)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.50,
          size.width * 0.25, size.height * 0.35)
      ..lineTo(size.width * 0.25, 0)
      ..moveTo(size.width * 0.75, size.height * 0.10)
      ..lineTo(size.width * 0.85, size.height * 0.10)
      ..quadraticBezierTo(size.width * 0.90, size.height * 0.10,
          size.width * 0.90, size.height * 0.15)
      ..lineTo(size.width * 0.90, size.height * 0.20)
      ..quadraticBezierTo(size.width * 0.90, size.height * 0.30,
          size.width * 0.75, size.height * 0.30)
      ..moveTo(size.width * 0.25, size.height * 0.50)
      ..lineTo(size.width * 0.75, size.height * 0.50)
      ..moveTo(size.width * 0.82, size.height * 0.50)
      ..lineTo(size.width * 0.90, size.height * 0.50)
      ..close();

    var w = size.width;
    var h = size.height;
    final points = drawWavy(time)
        .map((e) => Offset(e.dx * w, (e.dy * h * 0.05) + h * 0.30))
        .toList();
    final shadowPoints = drawWavy(time)
        .map((e) => Offset(e.dx * w, (-e.dy * h * 0.05) + h * 0.30))
        .toList();
    Path wavy = Path()
      ..addPolygon(points, false)
      ..lineTo(size.width * 0.75, size.height * 0.35)
      ..quadraticBezierTo(size.width * 0.75, size.height * 0.50,
          size.width * 0.6, size.height * 0.50)
      ..lineTo(size.width * 0.40, size.height * 0.50)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.50,
          size.width * 0.25, size.height * 0.35)
      ..close();
    Path wavyShadow = Path()
      ..addPolygon(shadowPoints, false)
      ..lineTo(size.width * 0.75, size.height * 0.35)
      ..quadraticBezierTo(size.width * 0.75, size.height * 0.50,
          size.width * 0.6, size.height * 0.50)
      ..lineTo(size.width * 0.40, size.height * 0.50)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.50,
          size.width * 0.25, size.height * 0.35)
      ..close();

    Paint fillPaint = Paint()
      ..color = Colors.deepOrangeAccent
      ..style = PaintingStyle.fill;

    Paint fillPaintShadow = Paint()
      ..color = Colors.deepOrangeAccent.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    canvas.drawPath(wavyShadow, fillPaintShadow);
    canvas.drawPath(wavy, fillPaint);
    canvas.drawPath(path, paint);
  }

  List<Offset> drawWavy(double t) {
    return List<Offset>.generate(count, (index) {
      final ratio = 0.25 + (index / (count - 1)) * 0.5;
      return Offset(ratio, sin(waveCount * (ratio + t) * pi * 2));
    }, growable: false);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
