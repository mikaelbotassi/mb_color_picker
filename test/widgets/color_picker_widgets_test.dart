import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mb_color_picker/src/models/color_picker_type.dart';
import 'package:mb_color_picker/src/models/color_picker_value.dart';
import 'package:mb_color_picker/src/models/direction_option.dart';
import 'package:mb_color_picker/src/models/gradient_stop.dart';
import 'package:mb_color_picker/src/widgets/color_picker.dart';
import 'package:mb_color_picker/src/widgets/color_picker_dialog.dart';
import 'package:mb_color_picker/src/widgets/gradient_picker/gradient_picker_widget.dart';

void main() {
  Widget wrapWithMaterial(Widget child) {
    return MaterialApp(
      home: Scaffold(body: Center(child: child)),
    );
  }

  group('MbColorPickerWidget', () {
    testWidgets('shows gradient label and disables hex editing for gradients',
        (tester) async {
      final initialValue = GradientValue(
        stops: [
          GradientStop(color: Colors.red, position: 0),
          GradientStop(color: Colors.blue, position: 1),
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );

      await tester.pumpWidget(
        wrapWithMaterial(
          MbColorPickerWidget(
            initialValue: initialValue,
            onChanged: (_) {},
          ),
        ),
      );

      final hexField = tester.widget<TextFormField>(
        find.byType(TextFormField).first,
      );

      expect(hexField.controller?.text, 'Gradient');
      expect(hexField.enabled, isFalse);
    });

    testWidgets('submits hexadecimal values as solid colors', (tester) async {
      ColorPickerValue? changedValue;

      await tester.pumpWidget(
        wrapWithMaterial(
          MbColorPickerWidget(
            initialValue: const SolidColorValue(Color(0xFF000000)),
            onChanged: (value) => changedValue = value,
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField).first, 'FF0000');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(changedValue, isA<SolidColorValue>());
      expect((changedValue! as SolidColorValue).value, const Color(0xFFFF0000));
    });

    testWidgets('submits opacity values as percentages', (tester) async {
      ColorPickerValue? changedValue;

      await tester.pumpWidget(
        wrapWithMaterial(
          MbColorPickerWidget(
            initialValue: const SolidColorValue(Color(0xFF336699)),
            onChanged: (value) => changedValue = value,
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField).last, '25');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(changedValue, isA<SolidColorValue>());
      expect((changedValue! as SolidColorValue).opacity, closeTo(0.25, 0.01));
    });

    testWidgets('opens the dialog and does not notify on cancel',
        (tester) async {
      ColorPickerValue? changedValue;

      await tester.pumpWidget(
        wrapWithMaterial(
          MbColorPickerWidget(
            initialValue: const SolidColorValue(Color(0xFF336699)),
            onChanged: (value) => changedValue = value,
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();

      expect(find.byType(ColorPickerDialog), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Apply'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(changedValue, isNull);
    });
  });

  group('ColorPickerDialog', () {
    testWidgets('switches from solid picker to gradient picker',
        (tester) async {
      await tester.pumpWidget(
        wrapWithMaterial(
          ColorPickerDialog(
            initialValue: const SolidColorValue(Color(0xFF336699)),
            allowedTypes: const {
              ColorPickerType.solid,
              ColorPickerType.gradient,
            },
          ),
        ),
      );

      expect(find.byType(GradientPickerWidget), findsNothing);

      await tester.tap(find.byKey(const Key('ColorPickerType.gradient - null')));
      await tester.pumpAndSettle();

      expect(find.byType(GradientPickerWidget), findsOneWidget);
    });
  });

  group('GradientPickerWidget', () {
    testWidgets('notifies when the direction changes', (tester) async {
      GradientValue? changedValue;

      await tester.pumpWidget(
        wrapWithMaterial(
          GradientPickerWidget(
            initialValue: const LinearGradient(
              colors: [Colors.red, Colors.blue],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            onChanged: (value) => changedValue = value,
          ),
        ),
      );

      await tester.tap(
        find.byKey(const Key('GradientDirectionOption.upward - null')),
      );
      await tester.pumpAndSettle();

      expect(changedValue, isNotNull);
      expect(changedValue?.direction, GradientDirectionOption.upward);
      expect(changedValue?.begin, Alignment.bottomCenter);
      expect(changedValue?.end, Alignment.topCenter);
    });
  });
}
