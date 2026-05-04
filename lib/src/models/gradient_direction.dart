import 'package:flutter/widgets.dart';

/// Stores the begin and end alignments of a gradient direction.
@immutable
class GradientDirection {
  /// Creates a gradient direction from [begin] to [end].
  const GradientDirection(this.begin, this.end);

  /// Starting alignment of the gradient.
  final Alignment begin;

  /// Ending alignment of the gradient.
  final Alignment end;

  @override
  bool operator ==(Object other) {
    return other is GradientDirection &&
        other.begin == begin &&
        other.end == end;
  }

  @override
  int get hashCode => Object.hash(begin, end);

  @override
  String toString() {
    return 'GradientDirection{begin: $begin, end: $end}';
  }
}
