import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_timeline_view/entities/event_type.dart';
import 'package:map_timeline_view/providers/researchgroup_provider.dart';
import 'package:map_timeline_view/providers/selected_event_provider.dart';
import 'package:map_timeline_view/providers/time_provider.dart';
import 'package:map_timeline_view/widgets/event_pop_up.dart';
import 'package:map_timeline_view/widgets/timeline_indicator.dart';
import 'package:provider/provider.dart';

// Helper class to represent a cluster of nearby markers
class MarkerCluster {
  final LatLng center;
  final List<Marker> markers;
  final int count;

  MarkerCluster(this.center, this.markers) : count = markers.length;
}

class MapMarkerProvider extends ChangeNotifier {
  final MapController mapController;
  List<Marker> _markers = [];
  static const double _clusterRadius = 50.0; // pixels
  static const double _clusterThreshold = 2; // minimum markers to form a cluster

  // Color scheme for research groups
  static const List<Color> selectedColors = [
    Color(0xFF2196F3), // Blue
    Color(0xFF4CAF50), // Green
    Color(0xFFFF9800), // Orange
    Color(0xFF9C27B0), // Purple
    Color(0xFFF44336), // Red
    Color(0xFF00BCD4), // Cyan
    Color(0xFF795548), // Brown
    Color(0xFF607D8B), // Blue Grey
  ];

  MapMarkerProvider({required this.mapController});

  List<Marker> get markers => _markers;

  Color _getGroupColor(int groupIndex) {
    return selectedColors[groupIndex % selectedColors.length];
  }

  void recalculateMarkers(BuildContext context) {
    print('=== Recalculating Markers ===');
    try {
      final bounds = mapController.bounds;
      if (bounds == null) {
        print('Map bounds are null, skipping marker calculation');
        return;
      }
      print('Map bounds: ${bounds.southWest} to ${bounds.northEast}');

      final timeProvider = Provider.of<TimelineRangeProvider>(
        context,
        listen: false,
      );
      final selectedTime = timeProvider.selectedTime;
      print('Selected time: $selectedTime');

      final researchGroupsProvider = Provider.of<ResearchGroupsProvider>(
        context,
        listen: false,
      );
      final selectedGroups = researchGroupsProvider.groups.where(
        (g) => g.isSelected,
      );
      print('Selected groups: ${selectedGroups.length}');

      final individualMarkers = <Marker>[];

      for (final group in selectedGroups) {
        print('Processing group: ${group.name} with ${group.events.length} events');
        final groupIndex = selectedGroups.toList().indexOf(group);
        final groupColor = _getGroupColor(groupIndex);
        
        for (final event in group.events) {
          // Normalize the selected time to remove seconds and milliseconds for comparison
          final normalizedSelectedTime = DateTime(
            selectedTime.year,
            selectedTime.month,
            selectedTime.day,
            selectedTime.hour,
            selectedTime.minute,
          );
          
          final isInTime =
              !normalizedSelectedTime.isBefore(event.start) &&
              !normalizedSelectedTime.isAfter(event.end);
          final isInBounds = bounds.contains(
            LatLng(event.latitude, event.longitude),
          );

          print('Event: ${event.title} - Start: ${event.start}, End: ${event.end}');
          print('Normalized selected time: $normalizedSelectedTime');
          print('Event: ${event.title} - In time: $isInTime, In bounds: $isInBounds');

          if (isInTime && isInBounds) {
            individualMarkers.add(
              Marker(
                width: 100, // Increased width to accommodate timeline indicator
                height: 40,
                point: LatLng(event.latitude, event.longitude),
                child: GestureDetector(
                  onTap: () {
                    final selectedEventProvider =
                        Provider.of<SelectedEventProvider>(
                          context,
                          listen: false,
                        );
                    selectedEventProvider.select(event);

                    if (_isMobile()) {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        builder: (_) => const EventPopUpWidget(),
                      );
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _getEventIcon(event.type),
                      const SizedBox(width: 4),
                      TimelineIndicator(
                        event: event,
                        selectedTime: selectedTime,
                        groupColor: groupColor,
                      ),
                    ],
                  ),
                ),
              ),
            );
            print('Added marker for event: ${event.title}');
          }
        }
      }

      // Apply clustering to the markers
      _markers = _applyClustering(individualMarkers, context);
      print('Total markers after clustering: ${_markers.length}');
      notifyListeners();
    } catch (e) {
      debugPrint('MapController not ready yet: $e');
    }
  }

  List<Marker> _applyClustering(List<Marker> individualMarkers, BuildContext context) {
    if (individualMarkers.length < _clusterThreshold) {
      return individualMarkers; // No clustering needed
    }

    final clusters = <MarkerCluster>[];
    final processedMarkers = <Marker>{};

    for (final marker in individualMarkers) {
      if (processedMarkers.contains(marker)) continue;

      final nearbyMarkers = <Marker>[marker];
      processedMarkers.add(marker);

      // Find all markers within the cluster radius
      for (final otherMarker in individualMarkers) {
        if (processedMarkers.contains(otherMarker)) continue;

        final distance = _calculatePixelDistance(marker.point, otherMarker.point);
        if (distance <= _clusterRadius) {
          nearbyMarkers.add(otherMarker);
          processedMarkers.add(otherMarker);
        }
      }

      // Create cluster if we have enough markers
      if (nearbyMarkers.length >= _clusterThreshold) {
        final center = _calculateClusterCenter(nearbyMarkers);
        clusters.add(MarkerCluster(center, nearbyMarkers));
      } else {
        // Add individual markers back
        for (final m in nearbyMarkers) {
          if (!processedMarkers.contains(m)) {
            clusters.add(MarkerCluster(m.point, [m]));
          }
        }
      }
    }

    // Convert clusters to markers
    final clusteredMarkers = <Marker>[];
    for (final cluster in clusters) {
      if (cluster.count == 1) {
        // Single marker, use original
        clusteredMarkers.add(cluster.markers.first);
      } else {
        // Multiple markers, create cluster marker
        clusteredMarkers.add(
          Marker(
            width: 40,
            height: 40,
            point: cluster.center,
            child: GestureDetector(
              onTap: () => _showClusterDetails(context, cluster),
              child: _buildClusterIcon(cluster.count),
            ),
          ),
        );
      }
    }

    return clusteredMarkers;
  }

  double _calculatePixelDistance(LatLng point1, LatLng point2) {
    // Convert lat/lng to approximate pixel distance
    // This is a simplified calculation - in a real app you'd use proper projection
    final latDiff = (point1.latitude - point2.latitude).abs();
    final lngDiff = (point1.longitude - point2.longitude).abs();
    
    // Rough approximation: 1 degree ≈ 111km, and we assume ~100 pixels per degree at zoom level
    return (latDiff + lngDiff) * 100;
  }

  LatLng _calculateClusterCenter(List<Marker> markers) {
    double totalLat = 0;
    double totalLng = 0;
    
    for (final marker in markers) {
      totalLat += marker.point.latitude;
      totalLng += marker.point.longitude;
    }
    
    return LatLng(
      totalLat / markers.length,
      totalLng / markers.length,
    );
  }

  Widget _buildClusterIcon(int count) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          count.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  void _showClusterDetails(BuildContext context, MarkerCluster cluster) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cluster: ${cluster.count} Events'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final marker in cluster.markers)
                ListTile(
                  leading: _getEventIcon(_getEventTypeFromMarker(marker)),
                  title: Text('Event at ${marker.point.latitude.toStringAsFixed(4)}, ${marker.point.longitude.toStringAsFixed(4)}'),
                  subtitle: Text('Tap to view details'),
                  onTap: () {
                    Navigator.of(context).pop();
                    // Trigger the marker tap event
                    final markerChild = marker.child as GestureDetector;
                    markerChild.onTap?.call();
                  },
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  EventType _getEventTypeFromMarker(Marker marker) {
    // Extract event type from marker's icon
    final icon = marker.child as GestureDetector;
    final rowWidget = icon.child as Row;
    final iconWidget = rowWidget.children[0] as Icon;
    
    if (iconWidget.icon == Icons.water) return EventType.flood;
    if (iconWidget.icon == Icons.bolt) return EventType.storm;
    if (iconWidget.icon == Icons.waves) return EventType.earthquake;
    if (iconWidget.icon == Icons.local_fire_department) return EventType.fire;
    return EventType.storm; // default
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

  bool _isMobile() {
    return defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android;
  }
}
