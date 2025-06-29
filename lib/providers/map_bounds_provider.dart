import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:map_timeline_view/entities/event.dart';

/// Provider to manage the current map bounds
/// This allows both the map and timeline to access the same bounds information
class MapBoundsProvider extends ChangeNotifier {
  LatLngBounds? _currentBounds;
  bool _isValidBounds = false;
  bool _isInitialized = false;

  LatLngBounds? get currentBounds => _currentBounds;
  bool get isValidBounds => _isValidBounds;
  bool get isInitialized => _isInitialized;

  /// Update the current map bounds
  void updateBounds(LatLngBounds? bounds) {
    if (bounds == null) {
      debugPrint('MapBoundsProvider: Clearing bounds');
      _currentBounds = null;
      _isValidBounds = false;
    } else {
      _currentBounds = bounds;
      // Check if bounds are reasonable (not too small or too large)
      final latSpan = (bounds.northEast.latitude - bounds.southWest.latitude).abs();
      final lngSpan = (bounds.northEast.longitude - bounds.southWest.longitude).abs();
      
      // More reasonable validation for map bounds
      // Too small: less than 0.0001 degrees (about 10m) - this is very zoomed in
      // Too large: more than 50 degrees (covers most of the world)
      // Also check for obviously wrong bounds (like negative longitude when it should be positive)
      final isReasonableSize = latSpan >= 0.0001 && lngSpan >= 0.0001 && latSpan <= 50 && lngSpan <= 50;
      final isReasonableLocation = bounds.southWest.latitude >= -90 && bounds.southWest.latitude <= 90 &&
                                  bounds.northEast.latitude >= -90 && bounds.northEast.latitude <= 90 &&
                                  bounds.southWest.longitude >= -180 && bounds.southWest.longitude <= 180 &&
                                  bounds.northEast.longitude >= -180 && bounds.northEast.longitude <= 180;
      
      // Additional check for obviously wrong bounds (like the ones we're seeing in logs)
      // This should catch the startup bounds that are clearly wrong
      final isNotObviouslyWrong = !(bounds.southWest.longitude < -10 || bounds.northEast.longitude > 20 ||
                                   bounds.southWest.latitude < 45 || bounds.northEast.latitude > 60);
      
      _isValidBounds = isReasonableSize && isReasonableLocation && isNotObviouslyWrong;
      _isInitialized = true;
      
      debugPrint('MapBoundsProvider: Updated bounds - SW: ${bounds.southWest.latitude}, ${bounds.southWest.longitude} NE: ${bounds.northEast.latitude}, ${bounds.northEast.longitude}');
      debugPrint('MapBoundsProvider: Bounds valid: $_isValidBounds (latSpan: $latSpan, lngSpan: $lngSpan, reasonableSize: $isReasonableSize, reasonableLocation: $isReasonableLocation, notObviouslyWrong: $isNotObviouslyWrong)');
    }
    notifyListeners();
  }

  /// Force refresh bounds from a map controller
  void refreshBoundsFromController(MapController mapController) {
    final bounds = mapController.bounds;
    debugPrint('MapBoundsProvider: Force refreshing bounds from controller: $bounds');
    updateBounds(bounds);
  }

  /// Check if an event is within the current map bounds
  bool isEventInBounds(Event event) {
    // If not initialized yet or bounds are invalid, show events in a reasonable default area (around Amsterdam)
    if (!_isInitialized || !_isValidBounds) {
      return event.latitude >= 50.0 && event.latitude <= 55.0 && 
             event.longitude >= 0.0 && event.longitude <= 15.0;
    }
    
    if (_currentBounds == null) {
      return true; // If no bounds, show all events
    }

    final isInBounds = event.latitude >= _currentBounds!.southWest.latitude &&
           event.latitude <= _currentBounds!.northEast.latitude &&
           event.longitude >= _currentBounds!.southWest.longitude &&
           event.longitude <= _currentBounds!.northEast.longitude;
           
    return isInBounds;
  }

  /// Clear the current bounds
  void clearBounds() {
    debugPrint('MapBoundsProvider: Clearing bounds');
    _currentBounds = null;
    _isValidBounds = false;
    _isInitialized = false;
    notifyListeners();
  }
} 