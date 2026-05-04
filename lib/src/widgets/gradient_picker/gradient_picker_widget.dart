import 'package:flutter/material.dart';
import 'package:mb_color_picker/src/models/color_picker_value.dart';
import 'package:mb_color_picker/src/utils/extensions/gradient_extension.dart';
import 'package:mb_color_picker/src/viewmodels/gradient_picker_controller.dart';
import 'package:mb_color_picker/src/widgets/gradient_picker/widgets/direction_buttons.dart';
import 'package:mb_color_picker/src/widgets/gradient_picker/widgets/gradient_stop_range.dart';
import 'package:mb_color_picker/src/widgets/gradient_picker/widgets/palette/stop_palette.dart';

/// Displays the full gradient editor UI.
class GradientPickerWidget extends StatefulWidget {
  /// Creates a gradient picker widget.
  const GradientPickerWidget({
    required this.initialValue,
    this.onChanged,
    this.maxStops = 8,
    super.key,
  });

  /// Initial gradient displayed in the editor.
  final Gradient initialValue;

  /// Called whenever the edited gradient value changes.
  final ValueChanged<GradientValue>? onChanged;

  /// Maximum number of gradient stops allowed in the editor.
  final int maxStops;

  @override
  State<GradientPickerWidget> createState() => _GradientPickerWidgetState();
}

class _GradientPickerWidgetState extends State<GradientPickerWidget> {

  late final GradientPickerController controller;

  @override
  void initState() {
    controller = GradientPickerController(widget.initialValue
      .gradientPickerValue, widget.maxStops);
    controller.addListener(notifyChanged);
    super.initState();
  }

  @override
  void dispose() {
    controller..removeListener(notifyChanged)
    ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            GradientStopRange(
              stops: controller.sortedStops,
              selectedStop: controller.selectedStop,
              gradient: controller.gradient,
              onSelected: (stop) {
                controller.selectedStop = stop;
              },
              onDragged: controller.moveStop,
            ),
            StopPalette(controller: controller),
            DirectionButtonsWidget(
              initialValue: controller.direction,
              onChanged: (value) {
                controller.setDirection(value);
              },
            ),
          ],
        );
      },
    );
  }

  /// Notifies listeners with the current gradient picker value.
  void notifyChanged() {
    final stops = controller.sortedStops;

    widget.onChanged?.call(
      GradientValue(
        stops: stops,
        begin: controller.direction.begin,
        end: controller.direction.end,
      ),
    );
  }
}
