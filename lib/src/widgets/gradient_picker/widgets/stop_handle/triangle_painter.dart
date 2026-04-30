import 'package:flutter/material.dart';

class GradientStopTrianglePainter extends CustomPainter {
  const GradientStopTrianglePainter({
    required this.color,
    required this.borderColor,
    required this.selected,
  });

  final Color color;
  final Color borderColor;
  final bool selected;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, fillPaint);

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = selected ? 1.5 : 1;

    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant GradientStopTrianglePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.selected != selected;
  }
}
