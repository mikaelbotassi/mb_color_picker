import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:mb_color_picker/src/widgets/color_picker_dialog.dart';
import 'package:mb_color_picker/src/models/color_picker_type.dart';
import 'package:mb_color_picker/src/models/color_picker_value.dart';
import 'package:mb_color_picker/src/widgets/gradient_picker/widgets/text_fields/color_opacity_text_field.dart';
import 'package:mb_color_picker/src/widgets/gradient_picker/widgets/text_fields/hexadecimal_color_text_field.dart';

class MbColorPickerWidget extends StatefulWidget {
  const MbColorPickerWidget({
    required this.onChanged,
    this.decoration,
    this.initialValue,
    this.allowedTypes = const {ColorPickerType.solid, ColorPickerType.gradient},
    this.textStyle,
    this.maxStops = 8,
    super.key,
  });

  final ColorPickerValue? initialValue;
  final ValueChanged<ColorPickerValue> onChanged;
  final Set<ColorPickerType> allowedTypes;
  final int maxStops;
  final TextStyle? textStyle;
  final BoxDecoration? decoration;

  @override
  State<MbColorPickerWidget> createState() => _MbColorPickerWidgetState();
}

class _MbColorPickerWidgetState extends State<MbColorPickerWidget> {
  late ColorPickerValue selectedValue;

  late final TextEditingController hexadecimalController;
  late final TextEditingController opacityController;

  @override
  void initState() {
    selectedValue = widget.initialValue ?? const SolidColorValue(Colors.white);
    hexadecimalController = TextEditingController(
      text: hexadecimalLabel,
    );
    opacityController = TextEditingController(
      text: opacityPercentage.toString(),
    );
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MbColorPickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final initialValue = widget.initialValue;
    if (initialValue != null && !_isSameValue(selectedValue, initialValue)) {
      selectedValue = widget.initialValue!;
      _syncControllers();
    }
  }

  @override
  void dispose() {
    hexadecimalController.dispose();
    opacityController.dispose();
    super.dispose();
  }

  Future<void> openColorPicker() async {
    final newValue = await showDialog<ColorPickerValue>(
      context: context,
      builder: (context) {
        return ColorPickerDialog(
          allowedTypes: widget.allowedTypes,
          initialValue: selectedValue,
          maxStops: widget.maxStops,
        );
      },
    );
    if (newValue != null) {
      setState(() {
        selectedValue = newValue;
        _syncControllers();
      });
      widget.onChanged(newValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (textStyle, colors) = (widget.textStyle ?? theme.textTheme.bodyMedium,
      theme.colorScheme);
    final colorPickerHeight = (textStyle?.fontSize ?? 24) * 2;
    return Container(
      decoration: widget.decoration ?? BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: colors.onSurface.withAlpha(100))
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 4,
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                spacing: 8,
                children: [
                  GestureDetector(
                    onTap: openColorPicker,
                    child: Container(
                      width: colorPickerHeight,
                      height: colorPickerHeight,
                      decoration: BoxDecoration(
                        color: isGradient ? null : selectedValue.toSolidColor(),
                        gradient: isGradient ? selectedValue.toGradient():null,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: colors.onSurface
                          .withAlpha(100))
                      ),
                    ),
                  ),
                  HexadecimalColorTextField(
                    hexadecimalController: hexadecimalController,
                    textStyle: textStyle,
                    enabled: !isGradient,
                    onHexadecimalSubmitted: isGradient ? null :
                      _handleHexadecimalSubmitted,
                  )
                ],
              ),
            ),
            VerticalDivider(
              color: colors.onSurface.withAlpha(100),
              width: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: ColorOpacityTextField(
                textStyle: textStyle,
                controller: opacityController,
                onOpacitySubmitted: _handleOpacitySubmitted,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _handleHexadecimalSubmitted(String value) {
    try{
      if (isGradient) {
        _syncControllers();
        return;
      }

      final normalizedValue = value.trim().replaceAll('#', '');

      if (normalizedValue.isEmpty) {
        _syncControllers();
        return;
      }

      if(normalizedValue.toLowerCase().contains('trans')){
        setState(() {
          selectedValue = const SolidColorValue(Colors.transparent);
          _syncControllers();
        });
        return;
      }

      final hexValue = normalizedValue.length >= 6
          ? normalizedValue.substring(0, 6)
          : normalizedValue.padRight(6,
          normalizedValue[normalizedValue.length - 1]);

      final parsedColor = Color(
        int.parse(
          '${alphaChannel.toRadixString(16).padLeft(2, '0')}$hexValue',
          radix: 16,
        ),
      );

      setState(() {
        selectedValue = SolidColorValue(parsedColor);
        _syncControllers();
      });

      widget.onChanged(selectedValue);
    } on Exception catch(_){
      _syncControllers();
      return;
    }
  }

  void _handleOpacitySubmitted(int value) {
    final clampedValue = value.clamp(0, 100);
    final opacity = clampedValue / 100;

    setState(() {
      selectedValue = selectedValue.copyWithOpacity(opacity);
      _syncControllers();
    });

    widget.onChanged(selectedValue);
  }

  void _syncControllers() {
    hexadecimalController.text = hexadecimalLabel;
    opacityController.text = opacityPercentage.toString();
  }

  bool get isGradient => selectedValue is GradientValue;

  int get alphaChannel => (selectedValue.opacity * 255).round().clamp(0, 255);

  int get opacityPercentage => (alphaChannel / 255 * 100).round();

  String get hexadecimalLabel {
    if (isGradient) {
      return 'Gradient';
    }

    if (alphaChannel == 0) {
      return 'Transparent';
    }
    return selectedValue.toSolidColor().toHexString().replaceRange(0, 2, '');
  }

  bool _isSameValue(ColorPickerValue a, ColorPickerValue b) {
    if (a.runtimeType != b.runtimeType) return false;
    if (a is SolidColorValue && b is SolidColorValue) {
      return a.value == b.value;
    }
    if (a is GradientValue && b is GradientValue) {
      return _isSameGradientValue(a, b);
    }
    return false;
  }

  bool _isSameGradientValue(GradientValue a, GradientValue b) {
    if (a.begin != b.begin || a.end != b.end || a.alpha != b.alpha) {
      return false;
    }

    if (a.stops.length != b.stops.length) {
      return false;
    }

    for (var index = 0; index < a.stops.length; index++) {
      final stopA = a.stops[index];
      final stopB = b.stops[index];
      if (stopA.color != stopB.color || stopA.position != stopB.position) {
        return false;
      }
    }

    return true;
  }

}
