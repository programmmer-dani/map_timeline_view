import 'package:flutter/material.dart';
import 'package:map_timeline_view/entities/event.dart';

class SelectedEventProvider with ChangeNotifier {
  Event? _event;

  Event? get event => _event;

  void select(Event event) {
    _event = event;
    notifyListeners();
  }

  void clear() {
    _event = null;
    notifyListeners();
  }
}
