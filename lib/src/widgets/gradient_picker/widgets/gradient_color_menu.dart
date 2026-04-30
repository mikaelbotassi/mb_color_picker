import 'package:flutter/material.dart';
import 'package:mb_color_picker/src/viewmodels/gradient_picker_controller.dart';
import 'package:mb_color_picker/src/widgets/core/icon_button.dart';
import 'package:tabler_icons_plus/tabler_icons_plus.dart';

class GradientColorMenu extends StatelessWidget {
  const GradientColorMenu({required this.controller, super.key});

  final GradientPickerController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(child: Text('Interrupções')),
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
