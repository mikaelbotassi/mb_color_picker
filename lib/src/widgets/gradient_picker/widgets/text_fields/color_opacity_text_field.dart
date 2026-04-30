import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ColorOpacityTextField extends StatelessWidget {
  const ColorOpacityTextField({
    required this.controller,
    required this.onOpacitySubmitted,
    required this.textStyle,
    super.key
  });

  final TextEditingController controller;
  final ValueChanged<int> onOpacitySubmitted;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return SizedBox(
      width: 42,
      child: TextFormField(
        style: textStyle,
        controller: controller,
        maxLength: 3,
        textInputAction: TextInputAction.done,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        onFieldSubmitted: (value) => onOpacitySubmitted
          .call(int.tryParse(value) ?? 100),
        decoration: InputDecoration(
          isDense: true,
          counterText: '',
          border: InputBorder.none,
          suffixStyle: textStyle?.apply(color: colors.onSurface.withAlpha(100)),
          suffixText: ' %',
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
      ),
    );
  }
}
