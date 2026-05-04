import 'package:flutter/material.dart';
import 'package:mb_color_picker/src/models/direction_option.dart';
import 'package:mb_color_picker/src/widgets/core/toggle_button/toggle_button_group.dart';

/// Displays selectable buttons for choosing a gradient direction.
class DirectionButtonsWidget extends StatelessWidget {
  /// Creates a direction button group.
  const DirectionButtonsWidget({
    required this.initialValue,
    required this.onChanged,
    super.key,
  });

  /// Called when the selected direction changes.
  final ValueChanged<GradientDirectionOption> onChanged;

  /// Initially selected direction.
  final GradientDirectionOption initialValue;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          'Direction',
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

  /// Toggle button options for all preset gradient directions.
  List<ToggleButtonOption<GradientDirectionOption>> get options =>
      GradientDirectionOption.values
          .map((o) => ToggleButtonOption(
                value: o,
                icon: o.icon,
              ))
          .toList();
}
