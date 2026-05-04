# mb_color_picker

A flexible Flutter color picker with first-class support for both solid colors and editable multi-stop gradients.

`mb_color_picker` provides a compact input widget that opens a dialog for color selection, opacity editing, gradient direction control, and stop management. It is designed for apps that need more than a basic color field without forcing users into a large custom editor flow.

## Features

- Solid color selection
- Multi-stop gradient editing
- Gradient direction selection
- Stop creation, selection, removal, and drag repositioning
- Hex color input
- Opacity input
- Compact inline field with preview
- Support for restricting allowed picker types
- Public value models for solid colors and gradients

## Why Use This Package

Most color pickers handle only a single color. When gradients are needed, the editing experience usually becomes custom work inside the app.

This package gives you:

- a single widget for both solid and gradient values
- a value model that is easy to store in state
- a UI that works well for forms, settings screens, design tools, and theme editors

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  mb_color_picker: ^0.0.1
```

Then run:

```bash
flutter pub get
```

## Quick Start

Import the package:

```dart
import 'package:mb_color_picker/mb_color_picker.dart';
```

Use `MbColorPickerWidget` with a `ColorPickerValue`:

```dart
import 'package:flutter/material.dart';
import 'package:mb_color_picker/mb_color_picker.dart';

class ColorPickerExample extends StatefulWidget {
  const ColorPickerExample({super.key});

  @override
  State<ColorPickerExample> createState() => _ColorPickerExampleState();
}

class _ColorPickerExampleState extends State<ColorPickerExample> {
  ColorPickerValue _value = const SolidColorValue(Colors.blue);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MbColorPickerWidget(
          initialValue: _value,
          onChanged: (value) {
            setState(() {
              _value = value;
            });
          },
        ),
        const SizedBox(height: 16),
        Container(
          width: 140,
          height: 80,
          decoration: BoxDecoration(
            color: _value is SolidColorValue
                ? (_value as SolidColorValue).value
                : null,
            gradient: _value is GradientValue
                ? (_value as GradientValue).gradient
                : null,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ],
    );
  }
}
```

## Public API

The package currently exports:

- `MbColorPickerWidget`
- `ColorPickerValue`
- `SolidColorValue`
- `GradientValue`
- `GradientStop`
- `GradientDirection`
- `GradientDirectionOption`
- `ColorPickerType`

## Working With Values

### Solid Colors

Use `SolidColorValue` when you want a single color:

```dart
const value = SolidColorValue(Colors.red);
```

### Gradients

Use `GradientValue` when you want an editable gradient:

```dart
final value = GradientValue(
  stops: [
    GradientStop(color: Colors.purple, position: 0),
    GradientStop(color: Colors.orange, position: 1),
  ],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);
```

### Convert Values

`ColorPickerValue` provides convenience conversions:

```dart
final color = value.toSolidColor();
final gradient = value.toGradient();
```

## Restrict Picker Modes

If your UI should allow only solid colors or only gradients, pass `allowedTypes`.

Solid only:

```dart
Widget build(BuildContext context) {
  return MbColorPickerWidget(
    initialValue: const SolidColorValue(Colors.green),
    allowedTypes: const {ColorPickerType.solid},
    onChanged: (value) {},
  );
}
```

Gradient only:

```dart
Widget build(BuildContext context) {
  return MbColorPickerWidget(
    initialValue: GradientValue(
      stops: [
        GradientStop(color: Colors.blue, position: 0),
        GradientStop(color: Colors.cyan, position: 1),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    allowedTypes: const {ColorPickerType.gradient},
    onChanged: (value) {},
  );
}
```

## Customize The Editor

You can configure the widget with:

- `initialValue` to define the starting solid color or gradient
- `allowedTypes` to restrict the picker mode
- `maxStops` to limit the number of editable gradient stops
- `textStyle` to style the inline text fields
- `decoration` to override the outer container appearance

Example:

```dart
Widget build(BuildContext context) {
  return MbColorPickerWidget(
    initialValue: const SolidColorValue(Colors.black),
    maxStops: 6,
    textStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.black12),
    ),
    onChanged: (value) {},
  );
}
```

## Gradient Editing Capabilities

When gradient mode is enabled, users can:

- add new stops
- remove stops
- drag stops along the track
- select a stop and change its color
- change the gradient direction
- control opacity from the same compact field

## Example Output Model

You can branch your rendering logic using the returned value type:

```dart
Widget buildPreview(ColorPickerValue value) {
  if (value is SolidColorValue) {
    return ColoredBox(color: value.value);
  }

  if (value is GradientValue) {
    return DecoratedBox(
      decoration: BoxDecoration(gradient: value.gradient),
    );
  }

  return const SizedBox.shrink();
}
```

## Testing

The package includes unit and widget tests covering:

- value conversion logic
- gradient stop handling
- gradient controller behavior
- dialog interactions
- widget update flows

Run the test suite with:

```bash
flutter test
```

## Use Cases

`mb_color_picker` is a good fit for:

- theme editors
- branding tools
- template builders
- visual design systems
- background editors
- card, banner, and button customization flows

## Limitations

- The public package API currently exports the main picker widget and value models. Lower-level widgets live under `src/` and are not intended as the primary integration surface.
- If you need screenshots, animated previews, or a hosted demo for `pub.dev`, you should add assets to the repository and reference them here.

## Contributing

If you plan to evolve the package, useful next improvements would be:

- screenshots or GIFs in the `README`
- serialization helpers for `ColorPickerValue`
- localization support for visible labels
- more theming hooks for dialog internals

## License

This package is distributed under the license included in [LICENSE](LICENSE).
