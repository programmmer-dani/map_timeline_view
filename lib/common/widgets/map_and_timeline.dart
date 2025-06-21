import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:map_timeline_view/common/widgets/control_panel.dart';
import 'package:map_timeline_view/common/widgets/timeline.dart';

class MapWithSplitView extends StatefulWidget {
  const MapWithSplitView({super.key});

  @override
  State<MapWithSplitView> createState() => _MapWithSplitViewState();
}

class _MapWithSplitViewState extends State<MapWithSplitView> {
  final double controlPanelHeight =
      78.0; // Adjust based on your ControlPanel height
  double _splitRatio = 1.0; // 1.0 = full map, 0.0 = only top panel
  final double _minSplit = 0.47; // threshold for snapping closed
  final double _maxSplit = 0.7; // threshold for snapping open

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
            // Top content placeholder (shown when split)
            if (_splitRatio < 1.0)
              TimelineView(
                researchGroups: ['Group A', 'Group B'],
                visibleStart: DateTime.now().subtract(Duration(hours: 1)),
                visibleEnd: DateTime.now().add(Duration(hours: 1)),
              ),

            /*Positioned(
                top: controlPanelHeight,
                left: 0,
                right: 0,
                height: topHeight + halfDraggerHeight,
                child: Container(
                  color: Colors.white,
                  child: const Center(
                    child: Text(
                      'Split view placeholder',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ), */

            // Map view
            Positioned(
              top: topHeight + controlPanelHeight + halfDraggerHeight,
              left: 0,
              right: 0,
              height: mapHeight,
              child: _buildMap(),
            ),

            // Drag handle (always visible)
            Positioned(
              top: topHeight + controlPanelHeight,
              left: 0,
              right: 0,
              height: 40,
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
                      _splitRatio =
                          ControlPanel().isMobile ? 0.20 : 0.11; // snap closed
                    } else if (_splitRatio > _maxSplit) {
                      _splitRatio = 1.0; // snap fully open
                    }
                    // else keep where released
                  });
                },
                child: Center(
                  child: Container(
                    width: 30, // narrow width
                    height: 150, // tall height (adjust as needed)
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(40),
                        bottom: Radius.circular(40),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
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
          ],
        );
      },
    );
  }

  Widget _buildMap() {
    return SizedBox.expand(
      child: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(52.370216, 4.895168), // Amsterdam
          initialZoom: 13.0,
          interactionOptions: InteractionOptions(flags: InteractiveFlag.all),
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
