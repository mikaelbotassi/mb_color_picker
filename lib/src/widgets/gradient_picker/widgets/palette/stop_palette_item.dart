import 'package:flutter/material.dart';
import 'package:mb_color_picker/src/models/color_picker_type.dart';
import 'package:mb_color_picker/src/models/color_picker_value.dart';
import 'package:mb_color_picker/src/widgets/color_picker.dart';
import 'package:mb_color_picker/src/widgets/core/icon_button.dart';
import 'package:tabler_icons_plus/tabler_icons_plus.dart';

/// Displays a single editable gradient stop inside the palette.
class StopPaletteItem extends StatelessWidget {
  /// Creates a palette item for one gradient stop.
  const StopPaletteItem({
    required this.color,
    required this.position,
    required this.onChanged,
    required this.onRemove,
    this.active = false,
    super.key,
  });

  /// Current stop color.
  final Color color;

  /// Current stop position in the gradient.
  final double position;

  /// Called when the stop color changes.
  final ValueChanged<ColorPickerValue> onChanged;

  /// Called when the stop should be removed.
  final VoidCallback onRemove;

  /// Whether this stop is currently selected.
  final bool active;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: active ? colors.inverseSurface.withAlpha(50) :
          Colors.transparent,
        borderRadius: BorderRadius.circular(4)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MbColorPickerWidget(
            allowedTypes: const {ColorPickerType.solid},
            initialValue: SolidColorValue(color),
            onChanged: onChanged,
          ),
          IconButtonWidget(
            icon: TablerIcons.minus,
            onPressed: onRemove,
          )
        ],
      ),
    );
  }
}
