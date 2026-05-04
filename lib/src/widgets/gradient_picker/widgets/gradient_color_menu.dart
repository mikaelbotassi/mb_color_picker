import 'package:flutter/material.dart';
import 'package:mb_color_picker/src/viewmodels/gradient_picker_controller.dart';
import 'package:mb_color_picker/src/widgets/core/icon_button.dart';
import 'package:tabler_icons_plus/tabler_icons_plus.dart';

/// Displays actions related to editing gradient color stops.
class GradientColorMenu extends StatelessWidget {
  /// Creates a gradient color menu bound to a [GradientPickerController].
  const GradientColorMenu({required this.controller, super.key});

  /// Controller used to create and manage gradient stops.
  final GradientPickerController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(child: Text('Stops')),
        Row(
          spacing: 8,
          children: [
            IconButtonWidget(
              icon: TablerIcons.plus,
              onPressed: controller.createStop,
            ),
          ],
        )
      ],
    );
  }
}
