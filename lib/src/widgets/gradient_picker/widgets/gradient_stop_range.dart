import 'package:flutter/material.dart';
import 'package:mb_color_picker/src/models/gradient_stop.dart';
import 'package:mb_color_picker/src/widgets/gradient_picker/widgets/stop_handle/gradient_stop_handle.dart';

class GradientStopRange extends StatelessWidget {
  const GradientStopRange({
    required this.stops,
    required this.selectedStop,
    required this.gradient,
    required this.onSelected,
    required this.onDragged,
    this.fallbackWidth = 360,
    super.key,
  });

  final List<GradientStop> stops;
  final GradientStop selectedStop;
  final LinearGradient gradient;
  final ValueChanged<GradientStop> onSelected;
  final double fallbackWidth;
  final void Function(double delta) onDragged;

  static const double handleWidth = 28;
  static const double rangeHeight = 48;

  double get handleTopPosition => handleWidth * 0.25;
  double get rangeTopPosition => handleWidth - (handleWidth * 0.25);
  double get boxHeight => rangeHeight + (handleWidth * 0.75);
  double get trackHorizontalPadding => handleWidth/2;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      height: boxHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : fallbackWidth;

          final trackWidth = width - (trackHorizontalPadding * 2);

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: trackHorizontalPadding - 4,
                right: trackHorizontalPadding,
                top: rangeTopPosition,
                height: rangeHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colors.outlineVariant),
                    gradient: gradient,
                  ),
                ),
              ),
              ...getStops(trackWidth, width)
            ],
          );
        },
      ),
    );
  }

  List<Positioned> getStops(double trackWidth, double width) => stops
  .map((stop){
    final leftPosition = (trackHorizontalPadding +
        (stop.position * trackWidth) -
        (handleWidth / 2))
        .clamp(0.0, width - handleWidth);
    return Positioned(
      left: leftPosition,
      top: 0,
      child: GradientStopHandle(
        color: stop.color,
        selected: stop == selectedStop,
        onTap: () => onSelected(stop),
        height: handleWidth,
        onDragged: (details) {
          onDragged(details.delta.dx / trackWidth);
        },
      ),
    );
  }).toList(growable: false);

}
