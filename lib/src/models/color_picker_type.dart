import 'package:flutter/material.dart';

enum ColorPickerType{
  solid(Icons.square,'Solid Color'),
  gradient(Icons.gradient, 'Gradient');

  const ColorPickerType(this.icon,this.tooltip);

  final IconData icon;
  final String tooltip;

}