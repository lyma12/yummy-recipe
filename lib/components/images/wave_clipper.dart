import 'package:flutter/cupertino.dart';

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height * 0.8500000);
    path.cubicTo(
        size.width * 0.1325000,
        size.height * 0.7533333,
        size.width * 0.3305000,
        size.height * 0.7000000,
        size.width * 0.5000000,
        size.height * 0.8400000);
    path.cubicTo(
        size.width * 0.6770000,
        size.height * 0.9833333,
        size.width * 0.8510000,
        size.height * 0.9933333,
        size.width,
        size.height * 0.9366667);
    path.quadraticBezierTo(size.width * 1.0005000, size.height * 0.6858333,
        size.width * 1.0020000, size.height * -0.0033333);
    path.lineTo(size.width * 0.0020000, size.height * -0.0033333);
    path.quadraticBezierTo(size.width * 0.0030000, size.height * 0.4775000, 0,
        size.height * 0.8500000);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
