import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mb_color_picker/src/models/color_picker_value.dart';
import 'package:mb_color_picker/src/models/direction_option.dart';
import 'package:mb_color_picker/src/models/gradient_stop.dart';

extension GradientExtension on Gradient{

  GradientDirectionOption get direction{
    final lGradient = this is LinearGradient ? this as LinearGradient : null;
    if(lGradient == null) return GradientDirectionOption.forward;
    return GradientDirectionOption.fromBeginAndEnd(lGradient.begin,
    lGradient.end);
  }

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

  List<GradientStop> get gradientStops => resolvedStops.mapIndexed((i,stop) =>
    GradientStop(color: colors[i], position: stop)).toList(growable: false);

  GradientValue get gradientPickerValue => GradientValue(stops: gradientStops,
    begin: direction.begin,end: direction.end);

}
