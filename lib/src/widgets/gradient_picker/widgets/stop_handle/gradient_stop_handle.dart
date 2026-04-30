import 'package:flutter/material.dart';
import 'package:mb_color_picker/src/widgets/gradient_picker/widgets/stop_handle/triangle_painter.dart';

class GradientStopHandle extends StatelessWidget {
  const GradientStopHandle({
    required this.color,
    required this.selected,
    required this.onTap,
    required this.onDragged,
    this.height = 24,
    super.key,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;
  final ValueChanged<DragUpdateDetails> onDragged;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final outerColor = selected
        ? colors.primary
        : colors.surfaceContainerHighest;

    final borderColor = selected
        ? colors.primary
        : colors.surfaceContainerHighest;

    final width = height*0.85;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      onHorizontalDragStart: (_) => onTap(),
      onHorizontalDragUpdate: onDragged,
      child: SizedBox(
        width: width,
        height: height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              curve: Curves.easeOut,
              width: width,
              height: width,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: outerColor,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: selected ? 8 : 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            CustomPaint(
              size: Size(width * 0.35, height*0.15),
              painter: GradientStopTrianglePainter(
                color: outerColor,
                borderColor: borderColor,
                selected: selected,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
