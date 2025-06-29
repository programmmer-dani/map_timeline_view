import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_timeline_view/providers/marker_provider.dart';
import 'package:map_timeline_view/providers/time_provider.dart';
import 'package:map_timeline_view/providers/selected_event_provider.dart';
import 'package:provider/provider.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  MapViewState createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  Timer? _debounceTimer;
  MapMarkerProvider? markerProvider;
  TimelineRangeProvider? timeProvider;
  SelectedEventProvider? selectedEventProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (markerProvider == null) {
      markerProvider = Provider.of<MapMarkerProvider>(context, listen: false);
      markerProvider!.addListener(_onMarkerProviderChanged);
    }
    if (timeProvider == null) {
      timeProvider = Provider.of<TimelineRangeProvider>(context, listen: false);
      timeProvider!.addListener(_onTimeProviderChanged);
    }
    if (selectedEventProvider == null) {
      selectedEventProvider = Provider.of<SelectedEventProvider>(context, listen: false);
      selectedEventProvider!.addListener(_onSelectedEventChanged);
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    markerProvider?.removeListener(_onMarkerProviderChanged);
    timeProvider?.removeListener(_onTimeProviderChanged);
    selectedEventProvider?.removeListener(_onSelectedEventChanged);
    super.dispose();
  }

  void _onMarkerProviderChanged() {
    if (mounted) setState(() {});
  }

  void _onTimeProviderChanged() {
    // Recalculate markers when time changes to update highlighting
    if (mounted && markerProvider != null) {
      markerProvider!.recalculateMarkers(context);
    }
  }

  void _onSelectedEventChanged() {
    // Recalculate markers when selected event changes to update highlighting
    if (mounted && markerProvider != null) {
      markerProvider!.recalculateMarkers(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final markerProvider = context.watch<MapMarkerProvider>();
    // Listen to time changes to trigger rebuilds for highlighting
    context.watch<TimelineRangeProvider>();
    // Listen to selected event changes to trigger rebuilds for highlighting
    context.watch<SelectedEventProvider>();

    return FlutterMap(
      mapController: markerProvider.mapController,
      options: MapOptions(
        initialCenter: LatLng(52.370216, 4.895168),
        initialZoom: 13.0,
        interactiveFlags: InteractiveFlag.all,
        onMapReady: () {
          markerProvider.recalculateMarkers(context);
        },
        onMapEvent: (_) {
          _debounceTimer?.cancel();
          _debounceTimer = Timer(
            const Duration(milliseconds: 200),
            () => markerProvider.recalculateMarkers(context),
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
