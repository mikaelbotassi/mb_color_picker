import 'package:flutter/material.dart';
import 'package:tabler_icons_plus/tabler_icons_plus.dart';

/// Defines the preset directions available for gradient selection.
///
/// Each option includes the icon shown in the UI and the corresponding
/// gradient [begin] and [end] alignments.
enum GradientDirectionOption {
  /// Horizontal gradient from right to left.
  back(TablerIcons.arrowLeft, AlignmentGeometry.centerRight,
    AlignmentGeometry.centerLeft),

  /// Horizontal gradient from left to right.
  forward(TablerIcons.arrowRight, AlignmentGeometry.centerLeft,
    AlignmentGeometry.centerRight),

  /// Vertical gradient from bottom to top.
  upward(TablerIcons.arrowUp, AlignmentGeometry.bottomCenter,
    AlignmentGeometry.topCenter),

  /// Vertical gradient from top to bottom.
  downward(TablerIcons.arrowDown, AlignmentGeometry.topCenter,
    AlignmentGeometry.bottomCenter),

  /// Diagonal gradient from bottom-left to top-right.
  northEast(TablerIcons.arrowUpRight, AlignmentGeometry.bottomLeft,
    AlignmentGeometry.topRight),

  /// Diagonal gradient from bottom-right to top-left.
  northWest(TablerIcons.arrowUpLeft, AlignmentGeometry.bottomRight,
    AlignmentGeometry.topLeft),

  /// Diagonal gradient from top-left to bottom-right.
  southEast(TablerIcons.arrowDownRight,AlignmentGeometry.topLeft,
    AlignmentGeometry.bottomRight),

  /// Diagonal gradient from top-right to bottom-left.
  southWest(TablerIcons.arrowDownLeft,AlignmentGeometry.topRight,
    AlignmentGeometry.bottomLeft);

  /// Creates a gradient direction option with its UI metadata.
  const GradientDirectionOption(this.icon, this.begin, this.end);

  /// Icon used to represent this direction in the UI.
  final IconData icon;

  /// Starting alignment of the gradient.
  final AlignmentGeometry begin;

  /// Ending alignment of the gradient.
  final AlignmentGeometry end;

  /// Returns the preset option that matches the provided [begin] and [end].
  ///
  /// If no exact match is found, [forward] is returned as the default.
  static GradientDirectionOption fromBeginAndEnd(
    AlignmentGeometry begin,
    AlignmentGeometry end,
  ) {
    return switch ((begin, end)) {
      (AlignmentGeometry.centerRight, AlignmentGeometry.centerLeft) => back,
      (AlignmentGeometry.bottomCenter, AlignmentGeometry.topCenter) => upward,
      (AlignmentGeometry.topCenter, AlignmentGeometry.bottomCenter) => downward,
      (AlignmentGeometry.bottomLeft, AlignmentGeometry.topRight) => northEast,
      (AlignmentGeometry.bottomRight, AlignmentGeometry.topLeft) => northWest,
      (AlignmentGeometry.topLeft, AlignmentGeometry.bottomRight) => southEast,
      (AlignmentGeometry.topRight, AlignmentGeometry.bottomLeft) => southWest,
      _ => forward,
    };
  }

}
