import 'dart:ui';

class GradientStop {
  GradientStop({
    required this.color,
    required this.position,
  });

  Color color;
  double position;

  GradientStop copyWith({
    Color? color,
    double? position,
  }) {
    return GradientStop(
      color: color ?? this.color,
      position: position ?? this.position,
    );
  }

  String get positionLabel {
    return '${(position * 100).round()}%';
  }

}
