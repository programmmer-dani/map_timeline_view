import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_timeline_view/entities/event.dart';
import 'package:map_timeline_view/entities/event_type.dart';
import 'package:map_timeline_view/providers/researchgroup_provider.dart';
import 'package:map_timeline_view/providers/selected_event_provider.dart';
import 'package:map_timeline_view/providers/time_provider.dart';
import 'package:map_timeline_view/providers/map_bounds_provider.dart';
import 'package:map_timeline_view/services/visible_events_service.dart';
import 'package:map_timeline_view/widgets/event_pop_up.dart';
import 'package:map_timeline_view/widgets/timeline_indicator.dart';
import 'package:map_timeline_view/widgets/event_highlight_indicator.dart';
import 'package:provider/provider.dart';

class MarkerCluster {
  final LatLng center;
  final List<Marker> markers;
  final int count;
  final bool hasHighlightedEvents;
  final bool hasSelectedEvent;

  MarkerCluster(this.center, this.markers, this.hasHighlightedEvents, this.hasSelectedEvent) : count = markers.length;
}

class MapMarkerProvider extends ChangeNotifier {
  final MapController mapController;
  List<Marker> _markers = [];
  static const double _clusterRadius = 50.0; 
  static const double _clusterThreshold = 2; 

  static const List<Color> selectedColors = [
    Color(0xFF2196F3), 
    Color(0xFF4CAF50), 
    Color(0xFFFF9800), 
    Color(0xFF9C27B0), 
    Color(0xFFF44336), 
    Color(0xFF00BCD4), 
    Color(0xFF795548), 
    Color(0xFF607D8B), 
  ];

  MapMarkerProvider({required this.mapController});

  List<Marker> get markers => _markers;

  Color _getGroupColor(int groupIndex) {
    return selectedColors[groupIndex % selectedColors.length];
  }

  void recalculateMarkers(BuildContext context) {
    try {
      final mapBoundsProvider = Provider.of<MapBoundsProvider>(context, listen: false);
      final bounds = mapBoundsProvider.currentBounds;
      final includeMapBoundsFilter = mapBoundsProvider.isInitialized && mapBoundsProvider.isValidBounds;
      
      if (bounds == null && includeMapBoundsFilter) {
        debugPrint('Map bounds are null, skipping marker recalculation');
        return;
      }

      // Debug: Log the actual bounds being used
      if (bounds != null) {
        debugPrint('Map bounds: ${bounds.southWest.latitude}, ${bounds.southWest.longitude} to ${bounds.northEast.latitude}, ${bounds.northEast.longitude}');
      } else {
        debugPrint('Map bounds: null (showing all events)');
      }
      
      // Use centralized service to get visible events
      final visibleEventsService = VisibleEventsService.instance;
      final visibleEventsByGroup = visibleEventsService.calculateVisibleEvents(
        context: context,
        mapBounds: bounds,
        includeMapBoundsFilter: includeMapBoundsFilter,
      );

      final timeProvider = Provider.of<TimelineRangeProvider>(context, listen: false);
      final selectedTime = timeProvider.selectedTime;

      final individualMarkers = <Marker>[];

      // Process visible events by group
      for (final entry in visibleEventsByGroup.entries) {
        final groupId = entry.key;
        final visibleEvents = entry.value;
        
        // Find the group to get its color
        final researchGroupsProvider = Provider.of<ResearchGroupsProvider>(context, listen: false);
        final group = researchGroupsProvider.groups.firstWhere((g) => g.id == groupId);
        final selectedGroups = researchGroupsProvider.groups.where((g) => g.isSelected).toList();
        final groupIndex = selectedGroups.indexOf(group);
        final groupColor = _getGroupColor(groupIndex);

        for (final event in visibleEvents) {
          individualMarkers.add(
            Marker(
              width: 100, 
              height: 40,
              point: LatLng(event.latitude, event.longitude),
              child: EventHighlightIndicator(
                event: event,
                groupColor: groupColor,
                opacity: 0.6, // De-highlight non-overlapping events
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
            ),
          );
        }
      }

      _markers = _applyClustering(individualMarkers, context);
      debugPrint('Total markers after clustering: ${_markers.length}');
      notifyListeners();
    } catch (e) {
      debugPrint('MapController not ready yet: $e');
    }
  }

  List<Marker> _applyClustering(List<Marker> individualMarkers, BuildContext context) {
    if (individualMarkers.isEmpty) {
      return individualMarkers;
    }

    final clusters = <MarkerCluster>[];
    final processedMarkers = <Marker>{};

    for (final marker in individualMarkers) {
      if (processedMarkers.contains(marker)) continue;

      final nearbyMarkers = <Marker>[marker];
      processedMarkers.add(marker);

      for (final otherMarker in individualMarkers) {
        if (processedMarkers.contains(otherMarker)) continue;

        final distance = _calculatePixelDistance(marker.point, otherMarker.point);
        if (distance <= _clusterRadius) {
          nearbyMarkers.add(otherMarker);
          processedMarkers.add(otherMarker);
        }
      }

      if (nearbyMarkers.length >= _clusterThreshold) {
        final center = _calculateClusterCenter(nearbyMarkers);
        final hasHighlightedEvents = _checkClusterHighlighting(nearbyMarkers, context);
        final hasSelectedEvent = _checkClusterSelection(nearbyMarkers, context);
        clusters.add(MarkerCluster(center, nearbyMarkers, hasHighlightedEvents, hasSelectedEvent));
      } else {
        // Create individual clusters for single events
        for (final m in nearbyMarkers) {
          final hasHighlightedEvents = _checkClusterHighlighting([m], context);
          final hasSelectedEvent = _checkClusterSelection([m], context);
          clusters.add(MarkerCluster(m.point, [m], hasHighlightedEvents, hasSelectedEvent));
        }
      }
    }

    final clusteredMarkers = <Marker>[];
    for (final cluster in clusters) {
      if (cluster.count == 1) {
        clusteredMarkers.add(cluster.markers.first);
      } else {
        clusteredMarkers.add(
          Marker(
            width: 40,
            height: 40,
            point: cluster.center,
            child: GestureDetector(
              onTap: () => _showClusterDetails(context, cluster),
              child: _buildClusterIcon(cluster.count, cluster.hasHighlightedEvents, cluster.hasSelectedEvent),
            ),
          ),
        );
      }
    }

    return clusteredMarkers;
  }

  double _calculatePixelDistance(LatLng point1, LatLng point2) {
    final latDiff = (point1.latitude - point2.latitude).abs();
    final lngDiff = (point1.longitude - point2.longitude).abs();
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

  Widget _buildClusterIcon(int count, bool hasHighlightedEvents, bool hasSelectedEvent) {
    // Determine the cluster color and border based on highlighting state
    Color clusterColor;
    Color borderColor;
    double borderWidth;
    
    if (hasSelectedEvent) {
      // Selected event takes precedence - gold/yellow
      clusterColor = const Color(0xFFFFD700); // Gold
      borderColor = Colors.white;
      borderWidth = 3.0;
    } else if (hasHighlightedEvents) {
      // Time-based highlighting - red
      clusterColor = Colors.red;
      borderColor = Colors.white;
      borderWidth = 2.5;
    } else {
      // No highlighting - grey
      clusterColor = Colors.grey;
      borderColor = Colors.white;
      borderWidth = 2.0;
    }
    
    return Container(
      decoration: BoxDecoration(
        color: clusterColor,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
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
                    _triggerMarkerTap(marker);
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

  void _triggerMarkerTap(Marker marker) {
    Widget currentWidget = marker.child;
    
    // Navigate through the widget tree to find the GestureDetector
    while (currentWidget is EventHighlightIndicator) {
      currentWidget = (currentWidget as EventHighlightIndicator).child;
    }
    
    if (currentWidget is GestureDetector) {
      currentWidget.onTap?.call();
    }
  }

  EventType _getEventTypeFromMarker(Marker marker) {
    Widget currentWidget = marker.child;
    
    // Navigate through the widget tree to find the GestureDetector
    while (currentWidget is EventHighlightIndicator) {
      currentWidget = (currentWidget as EventHighlightIndicator).child;
    }
    
    if (currentWidget is! GestureDetector) {
      // Fallback if we can't find the expected structure
      return EventType.storm;
    }
    
    final rowWidget = currentWidget.child as Row;
    final iconWidget = rowWidget.children[0] as Icon;
    
    if (iconWidget.icon == Icons.water) return EventType.flood;
    if (iconWidget.icon == Icons.bolt) return EventType.storm;
    if (iconWidget.icon == Icons.waves) return EventType.earthquake;
    if (iconWidget.icon == Icons.local_fire_department) return EventType.fire;
    return EventType.storm; 
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

  /// Check if any event in the cluster should be highlighted based on time
  bool _checkClusterHighlighting(List<Marker> markers, BuildContext context) {
    final visibleEventsService = VisibleEventsService.instance;
    
    for (final marker in markers) {
      final event = _getEventFromMarker(marker);
      if (event != null) {
        final isHighlighted = visibleEventsService.isEventHighlighted(
          context: context,
          event: event,
        );
        if (isHighlighted) {
          return true;
        }
      }
    }
    return false;
  }

  /// Check if any event in the cluster is the selected event
  bool _checkClusterSelection(List<Marker> markers, BuildContext context) {
    final selectedEventProvider = Provider.of<SelectedEventProvider>(context, listen: false);
    final selectedEvent = selectedEventProvider.event;
    
    if (selectedEvent == null) return false;
    
    for (final marker in markers) {
      final event = _getEventFromMarker(marker);
      if (event != null && event.id == selectedEvent.id) {
        return true;
      }
    }
    return false;
  }

  /// Extract the Event object from a marker
  Event? _getEventFromMarker(Marker marker) {
    Widget currentWidget = marker.child;
    
    // Navigate through the widget tree to find the EventHighlightIndicator
    while (currentWidget is EventHighlightIndicator) {
      final highlightIndicator = currentWidget as EventHighlightIndicator;
      // We can access the event directly from the EventHighlightIndicator
      return highlightIndicator.event;
    }
    
    return null;
  }
}
