import 'package:flutter/widgets.dart';

@immutable
class GradientDirection {
  const GradientDirection(this.begin, this.end);

  final Alignment begin;
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