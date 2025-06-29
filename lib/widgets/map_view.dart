import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_timeline_view/providers/marker_provider.dart';
import 'package:map_timeline_view/providers/map_bounds_provider.dart';
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
  Timer? _initTimer;
  MapMarkerProvider? markerProvider;
  MapBoundsProvider? mapBoundsProvider;
  TimelineRangeProvider? timeProvider;
  SelectedEventProvider? selectedEventProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (markerProvider == null) {
      markerProvider = Provider.of<MapMarkerProvider>(context, listen: false);
      markerProvider!.addListener(_onMarkerProviderChanged);
    }
    if (mapBoundsProvider == null) {
      mapBoundsProvider = Provider.of<MapBoundsProvider>(context, listen: false);
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
    _initTimer?.cancel();
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

  void _initializeMapBounds() {
    if (mapBoundsProvider != null && markerProvider != null) {
      final bounds = markerProvider!.mapController.bounds;
      debugPrint('MapView: Initializing bounds after delay: $bounds');
      
      // Check if bounds are reasonable before setting them
      if (bounds != null) {
        final latSpan = (bounds.northEast.latitude - bounds.southWest.latitude).abs();
        final lngSpan = (bounds.northEast.longitude - bounds.southWest.longitude).abs();
        
        // More reasonable validation for initial bounds - match MapBoundsProvider
        final isReasonableSize = latSpan >= 0.0001 && lngSpan >= 0.0001 && latSpan <= 50 && lngSpan <= 50;
        final isReasonableLocation = bounds.southWest.latitude >= -90 && bounds.southWest.latitude <= 90 &&
                                    bounds.northEast.latitude >= -90 && bounds.northEast.latitude <= 90 &&
                                    bounds.southWest.longitude >= -180 && bounds.southWest.longitude <= 180 &&
                                    bounds.northEast.longitude >= -180 && bounds.northEast.longitude <= 180;
        final isNotObviouslyWrong = !(bounds.southWest.longitude < -10 || bounds.northEast.longitude > 20 ||
                                     bounds.southWest.latitude < 45 || bounds.northEast.latitude > 60);
        
        if (isReasonableSize && isReasonableLocation && isNotObviouslyWrong) {
          mapBoundsProvider!.updateBounds(bounds);
          markerProvider!.recalculateMarkers(context);
        } else {
          debugPrint('MapView: Initial bounds are invalid, waiting for user interaction');
          // Don't set invalid bounds, let the user interaction trigger proper bounds
        }
      }
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
          // Add a delay before initializing bounds to ensure the map is properly loaded
          _initTimer?.cancel();
          _initTimer = Timer(const Duration(milliseconds: 500), _initializeMapBounds);
          
          // Recalculate markers immediately without bounds filtering
          markerProvider.recalculateMarkers(context);
        },
        onMapEvent: (MapEvent event) {
          // Update map bounds provider with current bounds
          if (mapBoundsProvider != null) {
            final bounds = markerProvider.mapController.bounds;
            debugPrint('MapView: Map event triggered, bounds: $bounds');
            mapBoundsProvider!.updateBounds(bounds);
          }
          
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
