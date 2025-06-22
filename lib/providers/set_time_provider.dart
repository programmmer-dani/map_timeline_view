import 'package:flutter/foundation.dart';

/*
 * USAGE:
 * final timeline = Provider.of<TimelineRangeProvider>(context, listen: false);
 * timeline.setSelectedTime(DateTime.now());
 */



class TimelineRangeProvider extends ChangeNotifier {
  DateTime _selectedTime;
  DateTime _startingPoint;
  DateTime _endingPoint;

  TimelineRangeProvider({
    required DateTime selectedTime,
    required DateTime visibleStart,
    required DateTime visibleEnd,
  })  : _selectedTime = selectedTime,
        _startingPoint = visibleStart,
        _endingPoint = visibleEnd;

  // Getters
  DateTime get selectedTime => _selectedTime;
  DateTime get visibleStart => _startingPoint;
  DateTime get visibleEnd => _endingPoint;

  // Set selected time
  void setSelectedTime(DateTime newTime) {
    _selectedTime = newTime;
    notifyListeners();
  }

  // Set visible start and end
  void setRange(DateTime start, DateTime end) {
    _startingPoint = start;
    _endingPoint = end;
    notifyListeners();
  }

  // Set all three at once
  void updateAll({
    required DateTime selectedTime,
    required DateTime visibleStart,
    required DateTime visibleEnd,
  }) {
    _selectedTime = selectedTime;
    _startingPoint = visibleStart;
    _endingPoint = visibleEnd;
    notifyListeners();
  }
}
