import 'package:flutter/material.dart';
import 'package:mb_color_picker/src/models/color_picker_type.dart';
import 'package:mb_color_picker/src/widgets/core/toggle_button/toggle_button_group.dart';

/// Displays the header controls used to switch color picker modes.
class ColorPickerDialogHeader extends StatelessWidget {
  /// Creates a dialog header for choosing the active picker type.
  const ColorPickerDialogHeader({
    required this.type,
    required this.onChanged,
    required this.allowedTypes,
    super.key,
  });

  /// Called when the selected picker type changes.
  final ValueChanged<ColorPickerType> onChanged;

  /// Currently selected picker type.
  final ColorPickerType type;

  /// Types that can be selected in this header.
  final Set<ColorPickerType> allowedTypes;

  @override
  Widget build(BuildContext context) {
    if (allowedTypes.length <= 1) {
      return Container();
    }
    return Row(
      children: [
        IntrinsicWidth(
          child: ToggleButtonGroup(
            initialValue: type,
            onChanged: onChanged,
            options: options,
          ),
        ),
      ],
    );
  }

  /// Toggle button options built from [allowedTypes].
  List<ToggleButtonOption<ColorPickerType>> get options => allowedTypes
      .map((type) => ToggleButtonOption(value: type, icon: type.icon))
      .toList(growable: false);
}
