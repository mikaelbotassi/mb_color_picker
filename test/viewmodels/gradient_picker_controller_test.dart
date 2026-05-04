import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mb_color_picker/src/models/color_picker_value.dart';
import 'package:mb_color_picker/src/models/direction_option.dart';
import 'package:mb_color_picker/src/models/gradient_stop.dart';
import 'package:mb_color_picker/src/viewmodels/gradient_picker_controller.dart';

void main() {
  GradientValue buildGradientValue({
    List<GradientStop>? stops,
    AlignmentGeometry begin = Alignment.centerLeft,
    AlignmentGeometry end = Alignment.centerRight,
  }) {
    return GradientValue(
      stops: stops ?? [],
      begin: begin,
      end: end,
    );
  }

  group('GradientPickerController', () {
    test('uses default stops when initialized with an empty list', () {
      final controller = GradientPickerController(buildGradientValue());

      expect(controller.stops.length, 2);
      expect(controller.stops.first.color, Colors.black);
      expect(controller.stops.last.color, Colors.white);
      expect(controller.selectedStop, same(controller.stops.first));
      expect(controller.stops.first, isNot(same(defaultStops.first)));
    });

    test('sorts stops by position', () {
      final controller = GradientPickerController(
        buildGradientValue(
          stops: [
            GradientStop(color: Colors.red, position: 1),
            GradientStop(color: Colors.blue, position: 0),
          ],
        ),
      );

      expect(controller.sortedStops.map((stop) => stop.position), [0, 1]);
    });

    test('adds and selects a stop', () {
      final controller = GradientPickerController(buildGradientValue());
      final newStop = GradientStop(color: Colors.red, position: 0.5);

      controller.addStop(newStop);

      expect(controller.stops, contains(newStop));
      expect(controller.selectedStop, same(newStop));
    });

    test('removes a stop only when more than two exist', () {
      final controller = GradientPickerController(
        buildGradientValue(
          stops: [
            GradientStop(color: Colors.black, position: 0),
            GradientStop(color: Colors.red, position: 0.5),
            GradientStop(color: Colors.white, position: 1),
          ],
        ),
      );

      controller.removeStop(controller.stops[1]);
      expect(controller.stops.length, 2);

      controller.removeStop(controller.stops.first);
      expect(controller.stops.length, 2);
    });

    test('moves the selected stop and clamps the position', () {
      final controller = GradientPickerController(buildGradientValue());

      controller.moveStop(2);
      expect(controller.selectedStop.position, 1);

      controller.moveStop(-2);
      expect(controller.selectedStop.position, 0);
    });

    test('changes selected and targeted stop colors', () {
      final controller = GradientPickerController(buildGradientValue());

      controller.changeSelectedColor(Colors.green);
      expect(controller.selectedStop.color, Colors.green);

      final otherStop = controller.stops.last;
      controller.changeStopColor(otherStop, Colors.red);
      expect(controller.selectedStop, same(otherStop));
      expect(otherStop.color, Colors.red);
    });

    test('updates the direction and exposes a matching gradient', () {
      final controller = GradientPickerController(buildGradientValue());

      controller.setDirection(GradientDirectionOption.upward);

      expect(controller.direction, GradientDirectionOption.upward);
      expect(controller.gradient.begin, Alignment.bottomCenter);
      expect(controller.gradient.end, Alignment.topCenter);
      expect(controller.gradient.stops, [0, 1]);
    });

    test('creates a stop between the selected stop and its neighbor', () {
      final controller = GradientPickerController(buildGradientValue());

      controller.createStop();

      expect(controller.stops.length, 3);
      expect(controller.selectedStop.position, 0.5);
      expect(controller.selectedStop.color, Colors.black);
    });

    test('does not create a stop when maxStops is reached', () {
      final controller = GradientPickerController(buildGradientValue(), 2);

      controller.createStop();

      expect(controller.stops.length, 2);
    });
  });
}
