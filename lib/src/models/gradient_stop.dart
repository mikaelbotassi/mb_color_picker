import 'dart:ui';

/// Represents a single color stop within a gradient.
class GradientStop {
  /// Creates a gradient stop with a [color] and normalized [position].
  GradientStop({
    required this.color,
    required this.position,
  });

  /// Color displayed at this stop.
  Color color;

  /// Stop location in the gradient, typically between `0.0` and `1.0`.
  double position;

  /// Returns a copy with any provided fields replaced.
  GradientStop copyWith({
    Color? color,
    double? position,
  }) {
    return GradientStop(
      color: color ?? this.color,
      position: position ?? this.position,
    );
  }

  /// Human-readable percentage label for the current [position].
  String get positionLabel {
    return '${(position * 100).round()}%';
  }

}
