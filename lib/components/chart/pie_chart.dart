import 'dart:math';

import 'package:base_code_template_flutter/components/richtext/app_rich_text.dart';
import 'package:base_code_template_flutter/resources/gen/colors.gen.dart';
import 'package:flutter/material.dart';

class PieChart extends StatefulWidget {
  const PieChart({super.key, required this.segments});

  final List<ChartSegment> segments;

  @override
  State<StatefulWidget> createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {
  int? _selectedSegmentIndex;
  Offset? _tooltipPosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          height: 250,
          width: 250,
          child: Center(
            child: GestureDetector(
              onTapDown: (details) {
                setState(() {
                  _selectedSegmentIndex = _getSegmentIndexSelected(details);
                  _tooltipPosition = _setTooltipPosition(details.localPosition);
                });
              },
              onTapUp: (details) {
                setState(() {
                  _selectedSegmentIndex = null;
                  _tooltipPosition = null;
                });
              },
              child: Stack(
                children: [
                  CustomPaint(
                    size: const Size(200, 200),
                    painter: PieChartPainter(
                        segments: widget.segments,
                        selectedIndex: _selectedSegmentIndex),
                  ),
                  if (_selectedSegmentIndex != null)
                    Positioned(
                        left: _tooltipPosition?.dx,
                        top: _tooltipPosition?.dy,
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: ColorName.black700,
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: Colors.white,
                                width: 2.0,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                widget.segments[_selectedSegmentIndex!]
                                    .showInfo(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 11),
                                textDirection: TextDirection.ltr,
                              ),
                            ),
                          ),
                        ))
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 200,
          width: 100,
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: widget.segments.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: AppRichText.richTextInSequents(
                      color: widget.segments[index].color.withOpacity(1),
                      name: widget.segments[index].showInfo()),
                );
              }),
        ),
      ],
    );
  }

  Offset _setTooltipPosition(Offset position) {
    Offset adjustedPosition = position;
    if (position.dx > 150) {
      adjustedPosition = Offset(145, position.dy);
    }
    if (position.dy > 150) {
      adjustedPosition = Offset(adjustedPosition.dx, 145);
    }
    return adjustedPosition;
  }

  int? _getSegmentIndexSelected(TapDownDetails details) {
    double dx = details.localPosition.dx - 100;
    double dy = details.localPosition.dy - 100;
    double angle = atan2(dy, dx);
    if (angle < 0) {
      angle += 2 * pi;
    }
    double totalAmount =
        widget.segments.fold(0, (sum, segment) => sum + segment.amount);
    double startAngle = -pi / 2;

    for (int i = 0; i < widget.segments.length; i++) {
      double sweepAngle = 2 * pi * (widget.segments[i].amount / totalAmount);
      double endAngle = startAngle + sweepAngle;

      if (angle >= startAngle && angle < endAngle) {
        return i;
      }

      startAngle = endAngle;
    }

    return null;
  }
}

class PieChartPainter extends CustomPainter {
  const PieChartPainter({required this.segments, required this.selectedIndex});

  final List<ChartSegment> segments;
  final int? selectedIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;
    double totalAmount =
        segments.fold(0, (sum, segment) => sum + segment.amount);
    double startAngle = -pi / 2;

    for (int i = 0; i < segments.length; i++) {
      double sweepAngle = 2 * pi * (segments[i].amount / totalAmount);
      paint.color = selectedIndex != null && i == selectedIndex
          ? segments[i].color.withOpacity(0.2)
          : segments[i].color.withOpacity(1);
      canvas.drawArc(
        Rect.fromLTWH(0, 0, size.width, size.height),
        startAngle,
        sweepAngle,
        true,
        paint,
      );
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ChartSegment {
  const ChartSegment({
    required this.amount,
    required this.label,
    required this.color,
  });

  final double amount;
  final String label;
  final Color color;

  String showInfo() {
    return "$label has $amount";
  }
}
