import 'package:flutter/material.dart';
import 'package:mb_color_picker/src/models/direction_option.dart';
import 'package:mb_color_picker/src/widgets/core/toggle_button/toggle_button_group.dart';

class DirectionButtonsWidget extends StatelessWidget {
  const DirectionButtonsWidget({
    required this.initialValue,
    required this.onChanged,
    super.key
  });

  final ValueChanged<GradientDirectionOption> onChanged;
  final GradientDirectionOption initialValue;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          'Direção',
          style: textTheme.labelLarge,
        ),
        ToggleButtonGroup(
          onChanged: onChanged,
          options: options,
          initialValue: initialValue,
        ),
      ],
    );
  }

  List<ToggleButtonOption<GradientDirectionOption>> get options =>
    GradientDirectionOption.values.map((o) => ToggleButtonOption(
    value: o,
    icon: o.icon,
  )).toList();
}
