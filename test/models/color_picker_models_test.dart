import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mb_color_picker/src/models/color_picker_value.dart';
import 'package:mb_color_picker/src/models/direction_option.dart';
import 'package:mb_color_picker/src/models/gradient_stop.dart';
import 'package:mb_color_picker/src/utils/extensions/gradient_extension.dart';

void main() {
  group('SolidColorValue', () {
    test('converts to solid color and gradient representations', () {
      const value = SolidColorValue(Color(0xFF336699));

      expect(value.toSolidColor(), const Color(0xFF336699));

      final gradient = value.toGradient() as LinearGradient;
      expect(gradient.colors, [const Color(0xFF336699), Colors.white]);
    });

    test('copyWithOpacity updates the alpha channel', () {
      const value = SolidColorValue(Color(0xFF336699));

      final updated = value.copyWithOpacity(0.5);

      expect(updated.value.a, closeTo(0.5, 0.001));
    });
  });

  group('GradientValue', () {
    test('sorts stops and exposes derived collections', () {
      final value = GradientValue(
        stops: [
          GradientStop(color: Colors.red, position: 1),
          GradientStop(color: Colors.blue, position: 0),
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );

      expect(value.sortedStops.map((stop) => stop.position), [0, 1]);
      expect(value.colors, [Colors.blue, Colors.red]);
      expect(value.positions, [0, 1]);
      expect(value.startColor, Colors.blue);
      expect(value.endColor, Colors.red);
      expect(value.direction, GradientDirectionOption.forward);
    });

    test('builds a linear gradient with stop alpha applied', () {
      final value = GradientValue(
        stops: [
          GradientStop(color: const Color(0xFF0000FF), position: 0),
          GradientStop(color: const Color(0xFFFF0000), position: 1),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        alpha: 0.5,
      );

      final gradient = value.gradient;

      expect(gradient.begin, Alignment.topCenter);
      expect(gradient.end, Alignment.bottomCenter);
      expect(gradient.stops, [0, 1]);
      expect(gradient.colors.first.a, closeTo(0.5, 0.001));
      expect(gradient.colors.last.a, closeTo(0.5, 0.001));
    });

    test('copyWith clamps opacity and preserves values by default', () {
      final value = GradientValue(
        stops: [
          GradientStop(color: Colors.blue, position: 0),
          GradientStop(color: Colors.red, position: 1),
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );

      final updated = value.copyWith(alpha: 2);

      expect(updated.alpha, 1);
      expect(updated.stops, value.stops);
      expect(updated.begin, value.begin);
      expect(updated.end, value.end);
    });
  });

  group('GradientExtension', () {
    test('returns explicit stops when present', () {
      const gradient = LinearGradient(
        colors: [Colors.red, Colors.blue],
        stops: [0.2, 0.8],
      );

      expect(gradient.resolvedStops, [0.2, 0.8]);
    });

    test('generates evenly distributed stops when missing', () {
      const gradient = LinearGradient(
        colors: [Colors.red, Colors.green, Colors.blue],
      );

      expect(gradient.resolvedStops, [0, 0.5, 1]);
    });

    test('returns forward for non-linear gradients', () {
      const gradient = RadialGradient(colors: [Colors.red, Colors.blue]);

      expect(gradient.direction, GradientDirectionOption.forward);
    });

    test('converts a gradient into picker models', () {
      const gradient = LinearGradient(
        colors: [Colors.red, Colors.blue],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      );

      final value = gradient.gradientPickerValue;

      expect(value.direction, GradientDirectionOption.northEast);
      expect(value.stops.length, 2);
      expect(value.stops.first.position, 0);
      expect(value.stops.last.position, 1);
      expect(value.stops.first.color, Colors.red);
      expect(value.stops.last.color, Colors.blue);
    });
  });
}
