import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../providers/researchgroup_provider.dart';
import '../providers/time_provider.dart';
import '../entities/event_type.dart';

class MapView extends StatefulWidget {
  const MapView({super.key, this.onMapEvent});

  final void Function(MapEvent)? onMapEvent;

  @override
  MapViewState createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  final MapController _mapController = MapController();
  List<Marker> _markers = [];
  Timer? _debounceTimer;

  void recalculateMarkers() {
    final bounds = _mapController.camera.visibleBounds;
    final groupProvider = context.read<ResearchGroupsProvider>();
    final timeProvider = context.read<TimelineRangeProvider>();
    final selectedTime = timeProvider.selectedTime;

    final newMarkers = <Marker>[];
    for (final group in groupProvider.groups) {
      if (!group.isSelected) continue;
      for (final event in group.events) {
        final isInTime = !selectedTime.isBefore(event.start) &&
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

    setState(() {
      _markers = newMarkers;
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: LatLng(52.370216, 4.895168),
        initialZoom: 13.0,
        interactiveFlags: InteractiveFlag.all,
        onMapEvent: (event) {
          widget.onMapEvent?.call(event);
          _debounceTimer?.cancel();
          _debounceTimer = Timer(
            const Duration(milliseconds: 200),
            recalculateMarkers,
          );
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.map_timeline_view',
        ),
        MarkerLayer(markers: _markers),
      ],
    );
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
        return const Icon(Icons.local_fire_department, color: Colors.deepOrange, size: 28);
      default:
        return const Icon(Icons.location_on, color: Colors.black, size: 28);
    }
  }
}
