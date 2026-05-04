import 'package:flutter/material.dart';

/// Defines the color selection modes available in the color picker.
///
/// Each value also exposes an [icon] and a [tooltip] to simplify
/// building interface controls.
enum ColorPickerType{
  /// Selects a single solid color with no transition between shades.
  solid(Icons.square,'Solid Color'),

  /// Selects a gradient color, allowing multiple colors to be combined.
  gradient(Icons.gradient, 'Gradient');

  /// Creates a selection type with the visual metadata used by the UI.
  const ColorPickerType(this.icon,this.tooltip);

  /// Icon associated with the selection type for display in the UI.
  final IconData icon;

  /// Short text used to describe the option in tooltips and accessible actions.
  final String tooltip;

}
