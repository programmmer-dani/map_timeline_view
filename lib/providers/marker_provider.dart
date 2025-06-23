import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../entities/event_type.dart';
import '../providers/time_provider.dart';
import '../providers/researchgroup_provider.dart';

import 'package:flutter_map/flutter_map.dart';

class MapMarkerProvider extends ChangeNotifier {
  final MapController mapController;

  List<Marker> _markers = [];
  List<Marker> get markers => _markers;

  final ResearchGroupsProvider groupProvider;
  final TimelineRangeProvider timeProvider;

  MapMarkerProvider({
    required this.mapController,
    required this.groupProvider,
    required this.timeProvider,
  });

  void recalculateMarkers() {
    final bounds = mapController.camera.visibleBounds;
    final selectedTime = timeProvider.selectedTime;

    final newMarkers = <Marker>[];
    for (final group in groupProvider.groups) {
      if (!group.isSelected) continue;
      for (final event in group.events) {
        final isInTime =
            !selectedTime.isBefore(event.start) &&
            !selectedTime.isAfter(event.end);
        final isInBounds = bounds.contains(
          LatLng(event.latitude, event.longitude),
        );
        if (isInTime && isInBounds) {
          newMarkers.add(
            Marker(
              width: 30,
              height: 30,
              point: LatLng(event.latitude, event.longitude),
              child: _getEventIcon(event.type),
            ),
          );
        }
      }
    }

    _markers = newMarkers;
    notifyListeners();
  }

  Widget _getEventIcon(EventType type) {
    switch (type) {
      case EventType.flood:
        return const Icon(Icons.water, color: Colors.blue, size: 28);
      case EventType.storm:
        return const Icon(Icons.bolt, color: Colors.orange, size: 28);
      case EventType.earthquake:
        return const Icon(Icons.waves, color: Colors.redAccent, size: 28);
      case EventType.fire:
        return const Icon(
          Icons.local_fire_department,
          color: Colors.deepOrange,
          size: 28,
        );
      default:
        return const Icon(Icons.location_on, color: Colors.black, size: 28);
    }
  }
}
