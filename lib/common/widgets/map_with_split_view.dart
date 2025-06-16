import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class MapWithSplitView extends StatefulWidget {
  const MapWithSplitView({super.key});

  @override
  State<MapWithSplitView> createState() => _MapWithSplitViewState();
}

class _MapWithSplitViewState extends State<MapWithSplitView> {
  double _splitRatio = 1.0; // 1.0 = full map, < 1.0 = split view
  final double _minSplit = 0.3; // Minimum visible map area

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final mapHeight = _splitRatio * height;
        final bottomHeight = height - mapHeight;

        return Stack(
          children: [
            // Top: Placeholder content (shown when split)
            if (_splitRatio < 1.0)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: bottomHeight,
                child: _buildTopContent(), // Renamed for clarity
              ),

            // Map view pushed down
            Positioned(
              top: bottomHeight,
              left: 0,
              right: 0,
              height: mapHeight,
              child: _buildMap(),
            ),

            // Drag handle
            Positioned(
              top: bottomHeight,
              left: 0,
              right: 0,
              height: 32,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  setState(() {
                    _splitRatio -= details.delta.dy / height;
                    _splitRatio = _splitRatio.clamp(_minSplit, 1.0);
                  });
                },
                child: Center(
                  child: Container(
                    width: 120,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(4),
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
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(52.370216, 4.895168), // Amsterdam default center
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
    );
  }

  Widget _buildTopContent() {
    return Container(
      color: Colors.white,
      child: const Center(
        child: Text('Split view placeholder', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
