## 0.0.2

* Update `ColorPickerDialog` to calculate a dynamic `availableWidth` with `MediaQuery` and `clampDouble` for more adaptive dialog sizing.
* Remove fixed content width assumptions and redundant horizontal scrolling around the solid color picker to avoid unbounded width layout errors.
* Simplify the `ColorPickerDialog` build method by removing unused theme references and consolidating width handling for solid and gradient modes.
* Bump package version to `0.0.2` in `pubspec.yaml`.

## 0.0.1

* Add the initial `mb_color_picker` package release with support for solid colors and gradients through `MbColorPickerWidget`.
* Implement gradient editing controls, including stop management, direction selection, palette editing, opacity handling, and dialog-based editing flows.
* Add comprehensive unit and widget tests covering picker values, gradient extensions, controller behavior, dialog interactions, and widget state changes.
* Replace the default README template with full package documentation, usage examples, API notes, and customization guidance.
* Update the project license to MIT.
