import 'package:flutter/material.dart';
import 'package:mb_color_picker/src/models/color_picker_value.dart';
import 'package:mb_color_picker/src/models/direction_option.dart';
import 'package:mb_color_picker/src/models/gradient_stop.dart';

/// Default gradient stops used when no initial stops are provided.
final defaultStops = [
  GradientStop(color: Colors.black, position: 0),
  GradientStop(color: Colors.white, position: 1),
];

/// Controls the editable state of the gradient picker.
///
/// This controller manages gradient stops, the selected stop, and the
/// current gradient direction while notifying listeners about changes.
class GradientPickerController extends ChangeNotifier{

  /// Creates a controller from an initial gradient value.
  ///
  /// The optional [maxStops] limits how many gradient stops can be created.
  GradientPickerController(GradientValue initialValue, [this.maxStops = 8]) :
    _direction = initialValue.direction{
    initStops(initialValue.stops);
  }

  late final List<GradientStop> _stops;

  /// Maximum number of stops allowed in the editor.
  final int maxStops;

  /// Current editable list of gradient stops.
  List<GradientStop> get stops => _stops;

  /// Current gradient stops sorted by position.
  List<GradientStop> get sortedStops {
    return [..._stops]..sort((a, b) => a.position.compareTo(b.position));
  }

  /// Adds a new [stop] and selects it.
  void addStop(GradientStop stop){
    _stops.add(stop);
    _selectedStop = stop;
    notifyListeners();
  }

  GradientDirectionOption _direction;

  /// Currently selected gradient direction.
  GradientDirectionOption get direction => _direction;

  /// Updates the current gradient [direction].
  void setDirection(GradientDirectionOption direction){
    _direction = direction;
    notifyListeners();
  }

  late GradientStop _selectedStop;

  /// Currently selected gradient stop.
  GradientStop get selectedStop => _selectedStop;

  /// Updates the currently selected gradient stop.
  set selectedStop(GradientStop value) {
    _selectedStop = value;
    notifyListeners();
  }

  /// Initializes the editable stop list from [initialStops].
  ///
  /// When [initialStops] is empty, [defaultStops] are used instead.
  void initStops(List<GradientStop> initialStops) {
    assert(initialStops.isEmpty || initialStops.length > 1,
    'The number of initial stop-loss orders must be 0 or greater than 1.');
    final sourceStops = initialStops.isNotEmpty ? initialStops : defaultStops;
    _stops = sourceStops.map((stop) => stop.copyWith()).toList();
    _selectedStop = _stops.first;
  }

  /// Removes the provided [stop] when at least two stops remain afterwards.
  void removeStop(GradientStop stop) {
    if(_stops.length <= 2) return;
    _stops.remove(stop);
    notifyListeners();
  }

  /// Moves the selected stop by [delta] and clamps it between `0` and `1`.
  void moveStop(double delta) {
    selectedStop.position = (selectedStop.position + delta)
      .clamp(0, 1).toDouble();
    notifyListeners();
  }

  /// Updates the color of the currently selected stop.
  void changeSelectedColor(Color color) {
    _selectedStop.color = color;
    notifyListeners();
  }

  /// Selects [stop] and updates its color to [color].
  void changeStopColor(GradientStop stop, Color color) {
    _selectedStop = stop;
    _selectedStop.color = color;
    notifyListeners();
  }

  /// Builds the current [LinearGradient] from the editable stops and direction.
  LinearGradient get gradient {
    final stops = sortedStops;

    return LinearGradient(
      colors: [for (final stop in stops) stop.color],
      stops: [for (final stop in stops) stop.position],
      begin: direction.begin,
      end: direction.end,
    );
  }

  /// Creates a new stop between the selected stop and a neighboring stop.
  ///
  /// If the maximum number of stops has been reached, nothing happens.
  void createStop() {
    if(this.stops.length >= maxStops) return;
    final stops = sortedStops;
    final selectedIndex = stops.indexOf(_selectedStop);
    final nextStop = selectedIndex < stops.length - 1
        ? stops[selectedIndex + 1]
        : null;
    final previousStop = selectedIndex > 0 ? stops[selectedIndex - 1] : null;
    final position = nextStop != null
        ? (selectedStop.position + nextStop.position) / 2
        : previousStop != null
        ? (previousStop.position + selectedStop.position) / 2
        : 0.5;

    addStop(
      GradientStop(
        color: selectedStop.color,
        position: position.clamp(0, 1).toDouble(),
      ),
    );
  }

}
