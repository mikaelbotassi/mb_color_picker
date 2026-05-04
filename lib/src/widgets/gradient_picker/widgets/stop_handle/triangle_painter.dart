import 'package:flutter/material.dart';

/// Paints the triangular pointer displayed below a gradient stop handle.
class GradientStopTrianglePainter extends CustomPainter {
  /// Creates a triangle painter for a gradient stop handle.
  const GradientStopTrianglePainter({
    required this.color,
    required this.borderColor,
    required this.selected,
  });

  /// Fill color of the triangle.
  final Color color;

  /// Border color of the triangle.
  final Color borderColor;

  /// Whether the owning handle is selected.
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
