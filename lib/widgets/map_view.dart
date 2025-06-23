import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_timeline_view/providers/marker_provider.dart';
import 'package:provider/provider.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  MapViewState createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();

    // Listen to map marker provider changes to trigger rebuild (for markers)
    final markerProvider = context.read<MapMarkerProvider>();
    markerProvider.addListener(_onMarkerProviderChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    final markerProvider = context.read<MapMarkerProvider>();
    markerProvider.removeListener(_onMarkerProviderChanged);
    super.dispose();
  }

  void _onMarkerProviderChanged() {
    // Called when markers update — just rebuild to refresh marker layer
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final markerProvider = context.watch<MapMarkerProvider>();

    return FlutterMap(
      mapController: markerProvider.mapController,
      options: MapOptions(
        initialCenter: LatLng(52.370216, 4.895168),
        initialZoom: 13.0,
        interactiveFlags: InteractiveFlag.all,
        onMapEvent: (_) {
          _debounceTimer?.cancel();
          _debounceTimer = Timer(
            const Duration(milliseconds: 200),
            () => markerProvider.recalculateMarkers(),
          );
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.map_timeline_view',
        ),
        MarkerLayer(markers: markerProvider.markers),
      ],
    );
  }
}
