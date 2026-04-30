import 'package:flutter/material.dart';
import 'package:mb_color_picker/src/models/color_picker_value.dart';
import 'package:mb_color_picker/src/viewmodels/gradient_picker_controller.dart';
import 'package:mb_color_picker/src/widgets/gradient_picker/widgets/gradient_color_menu.dart';
import 'package:mb_color_picker/src/widgets/gradient_picker/widgets/palette/stop_palette_item.dart';

class StopPalette extends StatelessWidget {
  const StopPalette({
    required this.controller,
    super.key
  });

  final GradientPickerController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        GradientColorMenu(controller: controller),
        ...stopWidgets
      ],
    );
  }

  List<Widget> get stopWidgets => controller.sortedStops
    .map((stop) => StopPaletteItem(
      key: ObjectKey(stop),
      active: controller.selectedStop == stop,
      color: stop.color,
      position: stop.position,
      onRemove: () => controller.removeStop(stop),
      onChanged: (value){
        if(value is SolidColorValue){
          controller.changeStopColor(stop, value.value);
        }
      })).toList(growable: false);

}
