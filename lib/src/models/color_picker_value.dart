import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mb_color_picker/src/models/direction_option.dart';
import 'package:mb_color_picker/src/models/gradient_stop.dart';

/// Base type for values handled by the color picker.
///
/// A picker value can represent either a single [Color] or a [Gradient],
/// while exposing shared operations such as opacity updates and conversions
/// between solid and gradient representations.
sealed class ColorPickerValue<T extends Object> {
  /// Creates a color picker value.
  const ColorPickerValue();

  /// Returns the underlying value represented by this picker state.
  T get value;

  /// Returns the effective opacity applied to this value.
  double get opacity;

  /// Returns a copy of this value with the provided [opacity].
  ColorPickerValue<T> copyWithOpacity(double opacity);

  /// Converts this value into a [Gradient] representation.
  ///
  /// Solid colors are converted to a simple linear gradient that starts
  /// with the selected color.
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

  /// Converts this value into a single [Color] representation.
  ///
  /// Gradient values return their first gradient color.
  Color toSolidColor(){
    return switch (this) {
      GradientValue(:final gradient) => gradient.colors.first,
      SolidColorValue(:final value) => value,
    };
  }

}

/// Represents a gradient selection in the color picker.
class GradientValue extends ColorPickerValue<Gradient> {
  /// Creates a gradient picker value.
  const GradientValue({
    required this.stops,
    required this.begin,
    required this.end,
    this.alpha = 1,
  });

  /// Gradient color stops used to build the gradient.
  final List<GradientStop> stops;

  /// Starting alignment of the gradient.
  final AlignmentGeometry begin;

  /// Ending alignment of the gradient.
  final AlignmentGeometry end;

  /// Opacity multiplier applied to all gradient colors.
  final double alpha;

  /// First color in the sorted gradient stop list.
  Color get startColor => colors.first;

  /// Colors extracted from [sortedStops].
  List<Color> get colors => sortedStops.map((stop) => stop.color)
    .toList(growable: false);

  /// Stop positions extracted from [sortedStops].
  List<double> get positions => sortedStops.map((stop) => stop.position)
    .toList(growable:false);

  /// Gradient stops sorted by position in ascending order.
  List<GradientStop> get sortedStops => stops.sorted((a,b){
    return a.position.compareTo(b.position);
  });

  /// Last color in the sorted gradient stop list.
  Color get endColor => colors.last;

  /// Builds the [LinearGradient] represented by this value.
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

  /// Direction option derived from [begin] and [end].
  GradientDirectionOption get direction => GradientDirectionOption
    .fromBeginAndEnd(begin, end);

  @override
  double get opacity => alpha;

  /// Returns a copy with any provided fields replaced.
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

/// Represents a solid color selection in the color picker.
class SolidColorValue extends ColorPickerValue<Color>{

  /// Creates a solid color picker value.
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
