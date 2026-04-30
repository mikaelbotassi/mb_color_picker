import 'package:flutter/material.dart';

class IconButtonWidget extends StatelessWidget {

  const IconButtonWidget({
    this.icon,
    this.color,
    this.enabled = true,
    this.onPressed,
    this.padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
    super.key
  });

  final IconData? icon;
  final VoidCallback? onPressed;
  final bool enabled;
  final EdgeInsetsGeometry padding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final (colors, textTheme) = (Theme.of(context).colorScheme,
    Theme.of(context).textTheme);
    final color = this.color ?? colors.onSurface;
    return InkWell(
      onTap: enabled ? onPressed : null,
      child: Padding(
        padding: padding,
        child: Row(
          spacing: 8,
          children: [
            if(icon != null)
              Icon(
                icon,
                color: enabled ? color : color.withAlpha(100),
              ),
          ],
        ),
      ),
    );
  }
}
