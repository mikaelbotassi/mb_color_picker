import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:mb_color_picker/src/models/color_picker_type.dart';
import 'package:mb_color_picker/src/models/color_picker_value.dart';
import 'package:mb_color_picker/src/utils/extensions/gradient_extension.dart';
import 'package:mb_color_picker/src/widgets/core/primary_button.dart';
import 'package:mb_color_picker/src/widgets/core/text_button_widget.dart';
import 'package:mb_color_picker/src/widgets/gradient_picker/gradient_picker_widget.dart';
import 'package:mb_color_picker/src/widgets/gradient_picker/widgets/color_picker_dialog_header.dart';
import 'package:tabler_icons_plus/tabler_icons_plus.dart';

/// Dialog used to edit either a solid color or a gradient value.
class ColorPickerDialog extends StatefulWidget {

  /// Creates a color picker dialog.
  const ColorPickerDialog({
    required this.allowedTypes,
    required this.initialValue,
    this.maxStops = 8,
    super.key
  });

  /// Initial value displayed when the dialog opens.
  final ColorPickerValue initialValue;

  /// Selection modes available in the dialog.
  final Set<ColorPickerType> allowedTypes;

  /// Maximum number of gradient stops allowed when editing gradients.
  final int maxStops;

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {

  late ColorPickerType type;
  late SolidColorValue solidValue;
  late GradientValue gradientValue;

  @override
  void initState() {
    final initialValue = widget.initialValue;
    solidValue = SolidColorValue(initialValue.toSolidColor());
    gradientValue = initialValue.toGradient().gradientPickerValue;
    type = initialValue is GradientValue
        ? ColorPickerType.gradient
        : ColorPickerType.solid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (colors, textTheme) = (theme.colorScheme, theme.textTheme);
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(8),
        side: BorderSide(
          color: colors.inverseSurface.withAlpha(100),
          width: 2
        )
      ),
      title: ColorPickerDialogHeader(
        allowedTypes: widget.allowedTypes,
        onChanged: (newType){
          setState(() {
            type = newType;
          });
        },
        type: type,
      ),
      content: SizedBox(
        child: SingleChildScrollView(
          child: type == ColorPickerType.solid
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ColorPicker(
                    pickerColor: solidValue.value,
                    onColorChanged: (color) {
                      solidValue = SolidColorValue(color);
                    },
                    displayThumbColor: true,
                    pickerAreaHeightPercent: 0.8,
                  ),
                )
              : SizedBox(
                  width: 360,
                  child: GradientPickerWidget(
                    onChanged: (newValue){
                      gradientValue = newValue;
                    },
                    initialValue: gradientValue.toGradient(),
                    maxStops: widget.maxStops,
                  ),
                ),
        ),
      ),
      actions: [
        TextButtonWidget(
          onPressed: () => Navigator.pop(context),
          icon: TablerIcons.x,
          text: 'Cancel',
        ),
        PrimaryButton(
          onPressed: () {
            Navigator.pop(
              context,
              type == ColorPickerType.gradient ? gradientValue : solidValue,
            );
          },
          icon: TablerIcons.check,
          text: 'Apply',
        )
      ],
    );
  }
}
