import 'package:flutter/material.dart';

class TextButtonWidget extends StatelessWidget {

  const TextButtonWidget({
    this.icon,
    this.text,
    this.enabled = true,
    this.color,
    this.onPressed,
    super.key
  });

  final IconData? icon;
  final String? text;
  final VoidCallback? onPressed;
  final bool enabled;
  final Color?  color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (textTheme, colors) = (theme.textTheme, theme.colorScheme);
    final iconSize = text != null ? 16.0 : 24.0;
    final color = this.color ?? colors.onSurface;
    final validatedColor = enabled ? color : color.withAlpha(100);
    return InkWell(
      onTap: enabled ? onPressed : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          spacing: 8,
          mainAxisSize: MainAxisSize.min,
          children: [
            if(icon != null) Icon(icon, color: validatedColor, size: iconSize),
            if(text != null) Text(
              text!,
                style: textTheme.bodyMedium?.apply(color: validatedColor)
              )
          ],
        ),
      ),
    );
  }
}
