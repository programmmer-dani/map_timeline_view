import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:map_timeline_view/entities/event.dart';

/// Provider to manage the current map bounds
/// This allows both the map and timeline to access the same bounds information
class MapBoundsProvider extends ChangeNotifier {
  LatLngBounds? _currentBounds;
  bool _isInitialized = false;

  LatLngBounds? get currentBounds => _currentBounds;
  bool get isInitialized => _isInitialized;

  /// Update the current map bounds
  void updateBounds(LatLngBounds? bounds) {
    _currentBounds = bounds;
    _isInitialized = bounds != null;
    notifyListeners();
  }

  /// Check if an event is within the current map bounds
  bool isEventInBounds(Event event) {
    if (_currentBounds == null) {
      return true; // If no bounds, show all events
    }

    return event.latitude >= _currentBounds!.southWest.latitude &&
           event.latitude <= _currentBounds!.northEast.latitude &&
           event.longitude >= _currentBounds!.southWest.longitude &&
           event.longitude <= _currentBounds!.northEast.longitude;
  }

  /// Clear the current bounds
  void clearBounds() {
    _currentBounds = null;
    _isInitialized = false;
    notifyListeners();
  }
} 