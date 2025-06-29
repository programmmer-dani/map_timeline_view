import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:map_timeline_view/entities/event.dart';
import 'package:map_timeline_view/providers/researchgroup_provider.dart';
import 'package:map_timeline_view/providers/time_provider.dart';

/// Centralized service for calculating which events should be visible
class VisibleEventsService {
  static final VisibleEventsService _instance = VisibleEventsService._internal();
  factory VisibleEventsService() => _instance;
  VisibleEventsService._internal();

  /// Calculate visible events for both map and timeline
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
      final groupEvents = group.events.where((event) {
        // Time range filter
        final isInTimeRange = event.start.isBefore(visibleEnd) && event.end.isAfter(visibleStart);
        
        // Map bounds filter
        bool isInMapBounds = true;
        if (includeMapBoundsFilter && mapBounds != null) {
          isInMapBounds = event.latitude >= mapBounds.southWest.latitude &&
              event.latitude <= mapBounds.northEast.latitude &&
              event.longitude >= mapBounds.southWest.longitude &&
              event.longitude <= mapBounds.northEast.longitude;
        }
        
        return isInTimeRange && isInMapBounds;
      }).toList();

      if (groupEvents.isNotEmpty) {
        visibleEventsByGroup[group.id] = groupEvents;
      }
    }

    return visibleEventsByGroup;
  }

  /// Check if an event should be highlighted based on current selected time
  bool isEventHighlighted({
    required BuildContext context,
    required Event event,
  }) {
    final timeProvider = Provider.of<TimelineRangeProvider>(context, listen: false);
    final selectedTime = timeProvider.selectedTime;
    
    return event.start.isBefore(selectedTime) && event.end.isAfter(selectedTime);
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

  /// Get a singleton instance of the visible events service
  static VisibleEventsService get instance => _instance;
} 