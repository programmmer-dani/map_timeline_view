import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:map_timeline_view/entities/event.dart';
import 'package:map_timeline_view/providers/researchgroup_provider.dart';
import 'package:map_timeline_view/providers/time_provider.dart';

/// Centralized service for calculating which events should be visible
/// on both the map and timeline widgets
class VisibleEventsService {
  static final VisibleEventsService _instance = VisibleEventsService._internal();
  factory VisibleEventsService() => _instance;
  VisibleEventsService._internal();

  /// Calculate visible events for both map and timeline
  /// Returns a map of group ID to list of visible events
  Map<String, List<Event>> calculateVisibleEvents({
    required BuildContext context,
    LatLngBounds? mapBounds,
    bool includeMapBoundsFilter = true,
  }) {
    final timeProvider = Provider.of<TimelineRangeProvider>(context, listen: false);
    final researchGroupsProvider = Provider.of<ResearchGroupsProvider>(context, listen: false);
    
    final visibleStart = timeProvider.startingPoint;
    final visibleEnd = timeProvider.endingPoint;
    
    final selectedGroups = researchGroupsProvider.groups.where((g) => g.isSelected).toList();
    final visibleEventsByGroup = <String, List<Event>>{};

    for (final group in selectedGroups) {
      final visibleEvents = <Event>[];

      for (final event in group.events) {
        // Time-based filtering (same for both map and timeline)
        final isInTimeRange = event.start.isBefore(visibleEnd) && event.end.isAfter(visibleStart);
        
        // Map bounds filtering (only for map, optional for timeline)
        bool isInMapBounds = true;
        if (includeMapBoundsFilter && mapBounds != null) {
          // Check if map bounds are very large (zoomed out)
          final latSpan = (mapBounds.northEast.latitude - mapBounds.southWest.latitude).abs();
          final lngSpan = (mapBounds.northEast.longitude - mapBounds.southWest.longitude).abs();
          final isZoomedOut = latSpan > 50 || lngSpan > 50; // Very large bounds
          
          if (isZoomedOut) {
            // When zoomed out, don't filter by map bounds to keep all events visible
            isInMapBounds = true;
          } else {
            // When zoomed in, use normal map bounds filtering
            isInMapBounds = mapBounds.contains(LatLng(event.latitude, event.longitude));
          }
        }

        if (isInTimeRange && isInMapBounds) {
          visibleEvents.add(event);
        }
      }

      if (visibleEvents.isNotEmpty) {
        visibleEventsByGroup[group.id] = visibleEvents;
      }
    }
    
    return visibleEventsByGroup;
  }

  /// Calculate which events should be highlighted based on current selected time
  /// Returns a map of group ID to list of highlighted events
  Map<String, List<Event>> calculateHighlightedEvents({
    required BuildContext context,
    LatLngBounds? mapBounds,
    bool includeMapBoundsFilter = true,
  }) {
    final timeProvider = Provider.of<TimelineRangeProvider>(context, listen: false);
    final selectedTime = timeProvider.selectedTime;
    
    // Get all visible events first
    final visibleEventsByGroup = calculateVisibleEvents(
      context: context,
      mapBounds: mapBounds,
      includeMapBoundsFilter: includeMapBoundsFilter,
    );
    
    final highlightedEventsByGroup = <String, List<Event>>{};
    
    for (final entry in visibleEventsByGroup.entries) {
      final groupId = entry.key;
      final visibleEvents = entry.value;
      
      final highlightedEvents = visibleEvents.where((event) {
        // Event is highlighted if selected time overlaps with event duration
        return event.start.isBefore(selectedTime) && event.end.isAfter(selectedTime);
      }).toList();
      
      if (highlightedEvents.isNotEmpty) {
        highlightedEventsByGroup[groupId] = highlightedEvents;
      }
    }
    
    return highlightedEventsByGroup;
  }

  /// Check if an event should be highlighted based on current selected time
  bool isEventHighlighted({
    required BuildContext context,
    required Event event,
  }) {
    final timeProvider = Provider.of<TimelineRangeProvider>(context, listen: false);
    final selectedTime = timeProvider.selectedTime;
    
    // Event is highlighted if selected time overlaps with event duration
    return event.start.isBefore(selectedTime) && event.end.isAfter(selectedTime);
  }

  /// Get highlighted events for a specific group
  List<Event> getHighlightedEventsForGroup({
    required BuildContext context,
    required String groupId,
    LatLngBounds? mapBounds,
    bool includeMapBoundsFilter = true,
  }) {
    final highlightedEventsByGroup = calculateHighlightedEvents(
      context: context,
      mapBounds: mapBounds,
      includeMapBoundsFilter: includeMapBoundsFilter,
    );

    return highlightedEventsByGroup[groupId] ?? [];
  }

  /// Calculate visible events for timeline (without map bounds filtering)
  Map<String, List<Event>> calculateTimelineVisibleEvents(BuildContext context) {
    return calculateVisibleEvents(
      context: context,
      mapBounds: null,
      includeMapBoundsFilter: false,
    );
  }

  /// Calculate highlighted events for timeline (without map bounds filtering)
  Map<String, List<Event>> calculateTimelineHighlightedEvents(BuildContext context) {
    return calculateHighlightedEvents(
      context: context,
      mapBounds: null,
      includeMapBoundsFilter: false,
    );
  }

  /// Calculate visible events for map (with map bounds filtering)
  Map<String, List<Event>> calculateMapVisibleEvents(BuildContext context, LatLngBounds mapBounds) {
    return calculateVisibleEvents(
      context: context,
      mapBounds: mapBounds,
      includeMapBoundsFilter: true,
    );
  }

  /// Calculate highlighted events for map (with map bounds filtering)
  Map<String, List<Event>> calculateMapHighlightedEvents(BuildContext context, LatLngBounds mapBounds) {
    return calculateHighlightedEvents(
      context: context,
      mapBounds: mapBounds,
      includeMapBoundsFilter: true,
    );
  }

  /// Get all visible events as a flat list
  List<Event> getAllVisibleEvents({
    required BuildContext context,
    LatLngBounds? mapBounds,
    bool includeMapBoundsFilter = true,
  }) {
    final visibleEventsByGroup = calculateVisibleEvents(
      context: context,
      mapBounds: mapBounds,
      includeMapBoundsFilter: includeMapBoundsFilter,
    );

    return visibleEventsByGroup.values.expand((events) => events).toList();
  }

  /// Get visible events for a specific group
  List<Event> getVisibleEventsForGroup({
    required BuildContext context,
    required String groupId,
    LatLngBounds? mapBounds,
    bool includeMapBoundsFilter = true,
  }) {
    final visibleEventsByGroup = calculateVisibleEvents(
      context: context,
      mapBounds: mapBounds,
      includeMapBoundsFilter: includeMapBoundsFilter,
    );

    return visibleEventsByGroup[groupId] ?? [];
  }

  /// Get a singleton instance of the visible events service
  static VisibleEventsService get instance => _instance;
} 