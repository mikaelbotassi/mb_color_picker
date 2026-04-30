import 'package:flutter/material.dart';
import 'package:tabler_icons_plus/tabler_icons_plus.dart';

enum GradientDirectionOption {
  back(TablerIcons.arrowLeft, AlignmentGeometry.centerRight,
    AlignmentGeometry.centerLeft),
  forward(TablerIcons.arrowRight, AlignmentGeometry.centerLeft,
    AlignmentGeometry.centerRight),
  upward(TablerIcons.arrowUp, AlignmentGeometry.bottomCenter,
    AlignmentGeometry.topCenter),
  downward(TablerIcons.arrowDown, AlignmentGeometry.topCenter,
    AlignmentGeometry.bottomCenter),
  northEast(TablerIcons.arrowUpRight, AlignmentGeometry.bottomLeft,
    AlignmentGeometry.topRight),
  northWest(TablerIcons.arrowUpLeft, AlignmentGeometry.bottomRight,
    AlignmentGeometry.topLeft),
  southEast(TablerIcons.arrowDownRight,AlignmentGeometry.topLeft,
    AlignmentGeometry.bottomRight),
  southWest(TablerIcons.arrowDownLeft,AlignmentGeometry.topRight,
    AlignmentGeometry.bottomLeft);

  const GradientDirectionOption(this.icon, this.begin, this.end);

  final IconData icon;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

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
