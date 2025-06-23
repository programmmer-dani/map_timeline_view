import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_timeline_view/entities/event_type.dart';
import 'package:map_timeline_view/providers/researchgroup_provider.dart';
import 'package:map_timeline_view/providers/time_provider.dart';
import 'package:map_timeline_view/widgets/control_panel.dart';
import 'package:map_timeline_view/widgets/start_and_end_selectors.dart';
import 'package:map_timeline_view/widgets/timeline.dart';
import 'package:provider/provider.dart';

class MapWithSplitView extends StatefulWidget {
  const MapWithSplitView({super.key});

  @override
  State<MapWithSplitView> createState() => MapWithSplitViewState();
}

class MapWithSplitViewState extends State<MapWithSplitView> {
  final double controlPanelHeight = 78.0;
  double _splitRatio = 1.0;
  final double _minSplit = 0.47;
  final double _maxSplit = 0.7;

  final MapController _mapController = MapController();
  List<Marker> _markers = [];

  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => recalculateMarkers());
  }

  void recalculateMarkers() {
    final camera = _mapController.camera;
    final bounds = camera.visibleBounds;
    final groupProvider = context.read<ResearchGroupsProvider>();
    final timeProvider = context.read<TimelineRangeProvider>();
    final selectedTime = timeProvider.selectedTime;

    final newMarkers = <Marker>[];

    for (final group in groupProvider.groups) {
      if (!group.isSelected) continue;

      for (final event in group.events) {
        final isWithinTime =
            !selectedTime.isBefore(event.start) &&
            !selectedTime.isAfter(event.end);
        final isWithinBounds = bounds.contains(
          LatLng(event.latitude, event.longitude),
        );

        if (isWithinTime && isWithinBounds) {
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

  void _onMapInteraction(MapEvent event) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(
      const Duration(milliseconds: 200),
      recalculateMarkers,
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double draggerHeight = 40;
    final double halfDraggerHeight = draggerHeight / 2;

    final isMobile = ControlPanel().isMobile;

    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final mapHeight = _splitRatio * height;
        final topHeight = height - mapHeight - draggerHeight;

        return Stack(
          children: [
            if (_splitRatio < 1.0)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: topHeight,
                child: TimelineView(
                  researchGroups: ['Group A', 'Group B'], // Update accordingly
                  visibleStart: DateTime.now().subtract(
                    const Duration(hours: 1),
                  ),
                  visibleEnd: DateTime.now().add(const Duration(hours: 1)),
                ),
              ),

            Positioned(
              top: topHeight + draggerHeight,
              left: 0,
              right: 0,
              height: mapHeight,
              child: _buildMap(),
            ),


            // DRAGGER
            Positioned(
              top: topHeight,
              left: 0,
              right: 0,
              height: draggerHeight,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  setState(() {
                    _splitRatio -= details.delta.dy / height;
                    _splitRatio = _splitRatio.clamp(_minSplit, 1.0);
                  });
                },
                onVerticalDragEnd: (details) {
                  setState(() {
                    if (_splitRatio < _minSplit) {
                      _splitRatio = isMobile ? 0.20 : 0.11;
                    } else if (_splitRatio > _maxSplit) {
                      _splitRatio = 1.0;
                    }
                  });
                },
                child: Center(
                  child: Container(
                    width: 30,
                    height: draggerHeight * 3.5,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(40),
                        bottom: Radius.circular(40),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: Icon(
                          Icons.drag_handle,
                          size: 24,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 16,
              left: 16,
              child: const TimelineStartDisplay(),
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: const TimelineEndDisplay(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: LatLng(52.370216, 4.895168),
        initialZoom: 13.0,
        interactiveFlags: InteractiveFlag.all,
        onMapEvent: _onMapInteraction,
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
