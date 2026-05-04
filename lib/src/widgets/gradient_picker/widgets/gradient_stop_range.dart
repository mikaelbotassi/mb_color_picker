import 'package:flutter/material.dart';
import 'package:mb_color_picker/src/models/gradient_stop.dart';
import 'package:mb_color_picker/src/widgets/gradient_picker/widgets/stop_handle/gradient_stop_handle.dart';

/// Displays the gradient preview track and draggable stop handles.
class GradientStopRange extends StatelessWidget {
  /// Creates a gradient stop range widget.
  const GradientStopRange({
    required this.stops,
    required this.selectedStop,
    required this.gradient,
    required this.onSelected,
    required this.onDragged,
    this.fallbackWidth = 360,
    super.key,
  });

  /// Stops displayed on the gradient track.
  final List<GradientStop> stops;

  /// Currently selected stop.
  final GradientStop selectedStop;

  /// Gradient preview shown in the track.
  final LinearGradient gradient;

  /// Called when a stop is selected.
  final ValueChanged<GradientStop> onSelected;

  /// Width used when layout constraints are unbounded.
  final double fallbackWidth;

  /// Called with the normalized drag delta for the selected stop.
  final void Function(double delta) onDragged;

  /// Visual width and height used for each stop handle.
  static const double handleWidth = 28;

  /// Height of the gradient preview track.
  static const double rangeHeight = 48;

  /// Top position of the stop handle area.
  double get handleTopPosition => handleWidth * 0.25;

  /// Top position of the gradient track.
  double get rangeTopPosition => handleWidth - (handleWidth * 0.25);

  /// Total height required by the widget.
  double get boxHeight => rangeHeight + (handleWidth * 0.75);

  /// Horizontal padding applied so handles can align with the track ends.
  double get trackHorizontalPadding => handleWidth / 2;

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

  /// Builds positioned handles for each stop along the track.
  List<Positioned> getStops(double trackWidth, double width) => stops
      .map((stop) {
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
      })
      .toList(growable: false);
}
