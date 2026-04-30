import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mb_color_picker/src/models/direction_option.dart';
import 'package:mb_color_picker/src/models/gradient_stop.dart';

sealed class ColorPickerValue<T extends Object> {
  const ColorPickerValue();

  T get value;
  double get opacity;

  ColorPickerValue<T> copyWithOpacity(double opacity);

  Gradient toGradient() {
    return switch (this) {
      GradientValue(:final gradient) => gradient,
      SolidColorValue(:final value) => LinearGradient(
        colors: [
          value,
          Colors.white,
        ],
      ),
    };
  }

  Color toSolidColor(){
    return switch (this) {
      GradientValue(:final gradient) => gradient.colors.first,
      SolidColorValue(:final value) => value,
    };
  }

}

class GradientValue extends ColorPickerValue<Gradient> {
  const GradientValue({
    required this.stops,
    required this.begin,
    required this.end,
    this.alpha = 1,
  });

  final List<GradientStop> stops;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final double alpha;

  Color get startColor => colors.first;

  List<Color> get colors => sortedStops.map((stop) => stop.color)
    .toList(growable: false);

  List<double> get positions => sortedStops.map((stop) => stop.position)
    .toList(growable:false);

  List<GradientStop> get sortedStops => stops.sorted((a,b){
    return a.position.compareTo(b.position);
  });

  Color get endColor => colors.last;

  LinearGradient get gradient {
    return LinearGradient(
      colors: [
        for (final color in colors)
          color.withValues(alpha: color.a * alpha),
      ],
      stops: positions,
      begin: begin,
      end: end,
    );
  }

  @override
  Gradient get value => gradient;

  GradientDirectionOption get direction => GradientDirectionOption
    .fromBeginAndEnd(begin, end);

  @override
  double get opacity => alpha;

  GradientValue copyWith({
    List<GradientStop>? stops,
    Alignment? begin,
    Alignment? end,
    double? alpha,
  }) {
    return GradientValue(
      stops: stops ?? this.stops,
      begin: begin ?? this.begin,
      end: end ?? this.end,
      alpha: (alpha ?? this.alpha).clamp(0, 1),
    );
  }

  @override
  GradientValue copyWithOpacity(double opacity) {
    return copyWith(alpha: opacity);
  }

}

class SolidColorValue extends ColorPickerValue<Color>{

  const SolidColorValue(this.value);

  @override
  final Color value;

  @override
  double get opacity => value.a;

  @override
  SolidColorValue copyWithOpacity(double opacity) {
    return SolidColorValue(
      value.withValues(alpha: opacity.clamp(0, 1)),
    );
  }

}
