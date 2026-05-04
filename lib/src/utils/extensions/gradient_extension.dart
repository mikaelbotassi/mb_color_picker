import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mb_color_picker/src/models/color_picker_value.dart';
import 'package:mb_color_picker/src/models/direction_option.dart';
import 'package:mb_color_picker/src/models/gradient_stop.dart';

/// Adds helper APIs for converting gradients into picker-friendly models.
extension GradientExtension on Gradient{

  /// Returns the preset direction that best matches this gradient.
  ///
  /// Non-linear gradients fall back to [GradientDirectionOption.forward].
  GradientDirectionOption get direction{
    final lGradient = this is LinearGradient ? this as LinearGradient : null;
    if(lGradient == null) return GradientDirectionOption.forward;
    return GradientDirectionOption.fromBeginAndEnd(lGradient.begin,
    lGradient.end);
  }

  /// Returns the gradient stop positions for this gradient.
  ///
  /// When the gradient does not define explicit stops, evenly spaced
  /// positions are generated across all colors.
  List<double> get resolvedStops {
    final stops = this.stops;

    if (stops != null) return stops;

    final colorCount = colors.length;

    return List.generate(colorCount, (index) {
      if (index == 0) return 0.0;
      if (index == colorCount - 1) return 1.0;

      final value = index / (colorCount - 1);
      return double.parse(value.toStringAsFixed(6));
    });
  }

  /// Returns this gradient as a list of [GradientStop] values.
  List<GradientStop> get gradientStops => resolvedStops.mapIndexed((i,stop) =>
    GradientStop(color: colors[i], position: stop)).toList(growable: false);

  /// Converts this gradient into a [GradientValue] used by the color picker.
  GradientValue get gradientPickerValue => GradientValue(stops: gradientStops,
    begin: direction.begin,end: direction.end);

}
