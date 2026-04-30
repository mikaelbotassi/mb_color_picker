import 'package:flutter/material.dart';
import 'package:mb_color_picker/src/models/color_picker_value.dart';
import 'package:mb_color_picker/src/models/direction_option.dart';
import 'package:mb_color_picker/src/models/gradient_stop.dart';

final defaultStops = [
  GradientStop(color: Colors.black, position: 0),
  GradientStop(color: Colors.white, position: 1),
];

class GradientPickerController extends ChangeNotifier{

  GradientPickerController(GradientValue initialValue, [this.maxStops = 8]) :
    _direction = initialValue.direction{
    initStops(initialValue.stops);
  }

  late final List<GradientStop> _stops;
  final int maxStops;

  List<GradientStop> get stops => _stops;
  List<GradientStop> get sortedStops {
    return [..._stops]..sort((a, b) => a.position.compareTo(b.position));
  }
  void addStop(GradientStop stop){
    _stops.add(stop);
    _selectedStop = stop;
    notifyListeners();
  }

  GradientDirectionOption _direction;
  GradientDirectionOption get direction => _direction;
  void setDirection(GradientDirectionOption direction){
    _direction = direction;
    notifyListeners();
  }

  late GradientStop _selectedStop;

  GradientStop get selectedStop => _selectedStop;

  set selectedStop(GradientStop value) {
    _selectedStop = value;
    notifyListeners();
  }

  void initStops(List<GradientStop> initialStops) {
    assert(initialStops.isEmpty || initialStops.length > 1,
    'The number of initial stop-loss orders must be 0 or greater than 1.');
    final sourceStops = initialStops.isNotEmpty ? initialStops : defaultStops;
    _stops = sourceStops.map((stop) => stop.copyWith()).toList();
    _selectedStop = _stops.first;
  }

  void removeStop(GradientStop stop) {
    if(_stops.length <= 2) return;
    _stops.remove(stop);
    notifyListeners();
  }

  void moveStop(double delta) {
    selectedStop.position = (selectedStop.position + delta)
      .clamp(0, 1).toDouble();
    notifyListeners();
  }

  void changeSelectedColor(Color color) {
    _selectedStop.color = color;
    notifyListeners();
  }

  void changeStopColor(GradientStop stop, Color color) {
    _selectedStop = stop;
    _selectedStop.color = color;
    notifyListeners();
  }

  LinearGradient get gradient {
    final stops = sortedStops;

    return LinearGradient(
      colors: [for (final stop in stops) stop.color],
      stops: [for (final stop in stops) stop.position],
      begin: direction.begin,
      end: direction.end,
    );
  }

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
