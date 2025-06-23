import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_timeline_view/entities/event_type.dart';
import 'package:map_timeline_view/entities/research_group.dart';
import 'package:map_timeline_view/providers/time_provider.dart';
import 'package:flutter/material.dart';

class MarkerService {
  List<Marker> buildMarkers({
    required List<ResearchGroup> groups,
    required TimelineRangeProvider timeProvider,
    required LatLngBounds bounds,
  }) {
    final selectedTime = timeProvider.selectedTime;
    final markers = <Marker>[];

    for (final group in groups) {
      if (!group.isSelected) continue;

      for (final event in group.events) {
        final isWithinTime = !selectedTime.isBefore(event.start) &&
            !selectedTime.isAfter(event.end);
        final isWithinBounds = bounds.contains(LatLng(event.latitude, event.longitude));

        if (isWithinTime && isWithinBounds) {
          markers.add(Marker(
            width: 30,
            height: 30,
            point: LatLng(event.latitude, event.longitude),
            child: _getEventIcon(event.type),
          ));
        }
      }
    }

    return markers;
  }

  Widget _getEventIcon(EventType type) {
    IconData icon;
    Color color;

    switch (type) {
      case EventType.flood:
        icon = Icons.water;
        color = Colors.blue;
        break;
      case EventType.storm:
        icon = Icons.bolt;
        color = Colors.orange;
        break;
      case EventType.earthquake:
        icon = Icons.waves;
        color = Colors.redAccent;
        break;
      case EventType.fire:
        icon = Icons.local_fire_department;
        color = Colors.deepOrange;
        break;
      default:
        icon = Icons.location_on;
        color = Colors.black;
    }

    return Icon(icon, color: color, size: 28);
  }
}
