import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HexadecimalColorTextField extends StatefulWidget {
  const HexadecimalColorTextField({
    required this.textStyle,
    required this.hexadecimalController,
    this.enabled = true,
    this.onHexadecimalSubmitted,
    super.key,
  });

  final TextEditingController hexadecimalController;
  final bool enabled;
  final ValueChanged<String>? onHexadecimalSubmitted;
  final TextStyle? textStyle;

  @override
  State<HexadecimalColorTextField> createState() =>
    _HexadecimalColorTextFieldState();
}

class _HexadecimalColorTextFieldState extends State<HexadecimalColorTextField> {
  @override
  void initState() {
    super.initState();
    if (widget.enabled) {
      _normalizeValue();
    }
  }

  @override
  void didUpdateWidget(covariant HexadecimalColorTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled &&
        oldWidget.hexadecimalController != widget.hexadecimalController) {
      _normalizeValue();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return SizedBox(
      width: widget.enabled ? 72 : 92,
      child: TextFormField(
        enabled: widget.enabled,
        style: widget.textStyle,
        controller: widget.hexadecimalController,
        maxLength: widget.enabled ? 6 : null,
        readOnly: !widget.enabled,
        textInputAction: TextInputAction.done,
        textAlignVertical: TextAlignVertical.center,
        onFieldSubmitted: widget.onHexadecimalSubmitted,
        decoration: InputDecoration(
          isDense: true,
          counterText: '',
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          prefixText: widget.enabled ? '# ' : null,
          prefixStyle: widget.textStyle?.
            apply(color: colors.onSurface.withAlpha(100)),
        ),
        inputFormatters: widget.enabled ? [
          FilteringTextInputFormatter.allow(
            RegExp('[0-9a-fA-F]'),
          ),
          UpperCaseTextFormatter(),
        ] : const [],
      ),
    );
  }

  void _normalizeValue() {
    final normalizedValue = widget.hexadecimalController.text
        .replaceAll('#', '')
        .toUpperCase();
    if (widget.hexadecimalController.text == normalizedValue) {
      return;
    }

    widget.hexadecimalController.value =
        widget.hexadecimalController.value.copyWith(
      text: normalizedValue,
      selection: TextSelection.collapsed(offset: normalizedValue.length),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
