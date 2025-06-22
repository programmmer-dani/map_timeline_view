import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:map_timeline_view/widgets/control_panel.dart';
import 'package:map_timeline_view/widgets/start_and_end_selectors.dart';
import 'package:map_timeline_view/widgets/timeline.dart';

class MapWithSplitView extends StatefulWidget {
  const MapWithSplitView({super.key});

  @override
  State<MapWithSplitView> createState() => _MapWithSplitViewState();
}

class _MapWithSplitViewState extends State<MapWithSplitView> {
  final double controlPanelHeight = 78.0;
  double _splitRatio = 1.0;
  final double _minSplit = 0.47;
  final double _maxSplit = 0.7;

  @override
  Widget build(BuildContext context) {
    final double draggerHeight = 40;
    final double halfDraggerHeight = draggerHeight / 2;

    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final mapHeight = _splitRatio * height;
        final topHeight = height - mapHeight - 20;

        return Stack(
          children: [
            // Top timeline view
            if (_splitRatio < 1.0)
              TimelineView(
                researchGroups: ['Group A', 'Group B'],
                visibleStart: DateTime.now().subtract(const Duration(hours: 1)),
                visibleEnd: DateTime.now().add(const Duration(hours: 1)),
              ),

            // Map view
            Positioned(
              top: topHeight + controlPanelHeight + halfDraggerHeight,
              left: 0,
              right: 0,
              height: mapHeight,
              child: _buildMap(),
            ),

            // Drag handle
            Positioned(
              top: topHeight + controlPanelHeight,
              left: 0,
              right: 0,
              height: draggerHeight,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  setState(() {
                    _splitRatio -= details.delta.dy / height;
                    _splitRatio = _splitRatio.clamp(-0.8, 1.0);
                  });
                },
                onVerticalDragEnd: (details) {
                  setState(() {
                    if (_splitRatio < _minSplit) {
                      _splitRatio = ControlPanel().isMobile ? 0.20 : 0.11;
                    } else if (_splitRatio > _maxSplit) {
                      _splitRatio = 1.0;
                    }
                  });
                },
                child: Center(
                  child: Container(
                    width: 30,
                    height: 150,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(40),
                        bottom: Radius.circular(40),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black,
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

            // Start and End time buttons (overlaid on map)
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
    return SizedBox.expand(
      child: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(52.370216, 4.895168),
          initialZoom: 13.0,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.map_timeline_view',
          ),
          const MarkerLayer(markers: []),
        ],
      ),
    );
  }
}
