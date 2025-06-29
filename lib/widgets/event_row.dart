import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:provider/provider.dart';
import 'package:map_timeline_view/entities/event.dart';
import 'package:map_timeline_view/entities/research_group.dart';
import 'package:map_timeline_view/services/visible_events_service.dart';
import 'package:map_timeline_view/widgets/event_pop_up.dart';
import 'package:map_timeline_view/providers/selected_event_provider.dart';
import 'package:map_timeline_view/providers/time_provider.dart';
import 'package:map_timeline_view/widgets/event_highlight_indicator.dart';

class GroupEventCluster {
  final List<Event> events;
  final DateTime start;
  final DateTime end;
  final int count;
  final String dominantType;

  GroupEventCluster(this.events)
      : start = events.map((e) => e.start).reduce((a, b) => a.isBefore(b) ? a : b),
        end = events.map((e) => e.end).reduce((a, b) => a.isAfter(b) ? a : b),
        count = events.length,
        dominantType = _getDominantEventType(events);

  String get title => '$count Events ($dominantType)';

  static String _getDominantEventType(List<Event> events) {
    final typeCounts = <String, int>{};
    for (final event in events) {
      final typeName = event.type.name;
      typeCounts[typeName] = (typeCounts[typeName] ?? 0) + 1;
    }
    
    String dominantType = 'Mixed';
    int maxCount = 0;
    for (final entry in typeCounts.entries) {
      if (entry.value > maxCount) {
        maxCount = entry.value;
        dominantType = entry.key;
      }
    }
    
    return dominantType;
  }
}

class EventRow extends StatelessWidget {
  final ResearchGroup group;
  final void Function(Event)? onEventTap; 
  final int maxLanes; 
  final Color groupColor; 

  const EventRow({
    super.key,
    required this.group,
    this.onEventTap,
    this.maxLanes = 3, 
    required this.groupColor,
  });

  @override
  Widget build(BuildContext context) {
    // Use centralized service to get visible events for this group
    final visibleEventsService = VisibleEventsService.instance;
    final visibleEvents = visibleEventsService.getVisibleEventsForGroup(
      context: context,
      groupId: group.id,
      includeMapBoundsFilter: false, // Timeline doesn't use map bounds filtering
    );

    final lanes = _assignEventsToLanes(visibleEvents);
    const laneHeight = 34.0;
    
    final needsClustering = lanes.length > maxLanes; 
    
    List<GroupEventCluster> clusters = [];
    List<Event> individualEvents = visibleEvents;
    
    if (needsClustering) {
      clusters = _detectGroupClusters(visibleEvents);
      
      final clusteredEventIds = clusters.expand((cluster) => cluster.events.map((e) => e.id)).toSet();
      individualEvents = visibleEvents.where((event) => !clusteredEventIds.contains(event.id)).toList();
      
      lanes.clear();
      lanes.addAll(_assignEventsToLanes(individualEvents));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final rowWidth = constraints.maxWidth;
        final totalHeight = (lanes.length * laneHeight) + (clusters.isNotEmpty ? 50.0 : 0.0);

        return SizedBox(
          height: totalHeight,
          child: Column(
            children: [
              if (lanes.isNotEmpty)
                SizedBox(
                  height: lanes.length * laneHeight,
                  child: Stack(
                    children: [
                      for (int laneIndex = 0; laneIndex < lanes.length; laneIndex++)
                        ...lanes[laneIndex].map((event) {
                          final left = _calculateOffset(
                            event.start,
                            rowWidth,
                            context,
                          );
                          final width = _calculateWidth(
                            event,
                            rowWidth,
                            context,
                          );

                          return Positioned(
                            top: laneIndex * laneHeight,
                            left: left,
                            child: EventHighlightIndicator(
                              event: event,
                              groupColor: groupColor,
                              opacity: 0.6, // De-highlight non-overlapping events
                              child: GestureDetector(
                                onTap: () => _handleEventTap(context, event),
                                child: Container(
                                  width: width,
                                  height: laneHeight - 4,
                                  margin: const EdgeInsets.symmetric(horizontal: 2),
                                  decoration: BoxDecoration(
                                    color: groupColor,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: groupColor.withOpacity(0.3),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      event.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              
              if (clusters.isNotEmpty && needsClustering)
                SizedBox(
                  height: 50,
                  child: Stack(
                    children: [
                      for (final cluster in clusters)
                        Positioned(
                          left: _calculateOffset(
                            cluster.start,
                            rowWidth,
                            context,
                          ),
                          child: EventHighlightIndicator(
                            event: cluster.events.first, // Use first event for highlighting
                            groupColor: groupColor,
                            opacity: 0.6, // De-highlight non-overlapping events
                            child: GestureDetector(
                              onTap: () => _showClusterDetails(context, cluster),
                              child: Container(
                                width: _calculateClusterWidth(
                                  cluster,
                                  rowWidth,
                                  context,
                                ),
                                height: 44,
                                margin: const EdgeInsets.symmetric(horizontal: 2),
                                decoration: BoxDecoration(
                                  color: groupColor.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: groupColor.withOpacity(0.4),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: groupColor,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${cluster.count}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        cluster.dominantType,
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _handleEventTap(BuildContext context, Event event) {
    final selectedEventProvider = Provider.of<SelectedEventProvider>(
      context,
      listen: false,
    );

    if (_isDesktop()) {
      selectedEventProvider.select(event);
    } else {
      selectedEventProvider.select(event);
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (_) => const EventPopUpWidget(),
      );
    }
  }

  bool _isDesktop() {
    return ![
      TargetPlatform.iOS,
      TargetPlatform.android,
      TargetPlatform.fuchsia,
    ].contains(defaultTargetPlatform);
  }

  double _calculateOffset(
    DateTime eventStart,
    double rowWidth,
    BuildContext context,
  ) {
    final timeProvider = Provider.of<TimelineRangeProvider>(context, listen: false);
    final visibleStart = timeProvider.startingPoint;
    final visibleEnd = timeProvider.endingPoint;
    
    final totalMs = visibleEnd.millisecondsSinceEpoch - visibleStart.millisecondsSinceEpoch;
    final offsetMs = eventStart.millisecondsSinceEpoch - visibleStart.millisecondsSinceEpoch;
    return (offsetMs / totalMs) * rowWidth;
  }

  double _calculateWidth(
    Event event,
    double rowWidth,
    BuildContext context,
  ) {
    final timeProvider = Provider.of<TimelineRangeProvider>(context, listen: false);
    final visibleStart = timeProvider.startingPoint;
    final visibleEnd = timeProvider.endingPoint;
    
    final totalMs = visibleEnd.millisecondsSinceEpoch - visibleStart.millisecondsSinceEpoch;
    final durationMs = event.end.millisecondsSinceEpoch - event.start.millisecondsSinceEpoch;
    return (durationMs / totalMs) * rowWidth;
  }

  List<List<Event>> _assignEventsToLanes(List<Event> events) {
    final sorted = List<Event>.from(events)
      ..sort((a, b) => a.start.compareTo(b.start));

    final lanes = <List<Event>>[];

    for (final event in sorted) {
      bool placed = false;

      for (final lane in lanes) {
        if (lane.isEmpty || !event.start.isBefore(lane.last.end)) {
          lane.add(event);
          placed = true;
          break;
        }
      }

      if (!placed) {
        lanes.add([event]);
      }
    }

    return lanes;
  }

  List<GroupEventCluster> _detectGroupClusters(List<Event> events) {
    if (events.length < 3) return []; 

    final sorted = List<Event>.from(events)..sort((a, b) => a.start.compareTo(b.start));
    final clusters = <GroupEventCluster>[];
    final processedEvents = <Event>{};

    for (int i = 0; i < sorted.length; i++) {
      if (processedEvents.contains(sorted[i])) continue;

      final overlappingEvents = <Event>[sorted[i]];
      processedEvents.add(sorted[i]);

      for (int j = i + 1; j < sorted.length; j++) {
        final otherEvent = sorted[j];
        if (processedEvents.contains(otherEvent)) continue;

        if (_eventsOverlap(sorted[i], otherEvent)) {
          overlappingEvents.add(otherEvent);
          processedEvents.add(otherEvent);
        }
      }

      if (overlappingEvents.length >= 3) {
        clusters.add(GroupEventCluster(overlappingEvents));
      }
    }

    clusters.sort((a, b) {
      if (a.count != b.count) {
        return b.count.compareTo(a.count); 
      }
      return a.start.compareTo(b.start); 
    });

    return clusters;
  }

  bool _eventsOverlap(Event event1, Event event2) {
    return event1.start.isBefore(event2.end) && event2.start.isBefore(event1.end);
  }

  double _calculateClusterWidth(
    GroupEventCluster cluster,
    double rowWidth,
    BuildContext context,
  ) {
    final timeProvider = Provider.of<TimelineRangeProvider>(context, listen: false);
    final visibleStart = timeProvider.startingPoint;
    final visibleEnd = timeProvider.endingPoint;
    
    final totalMs = visibleEnd.millisecondsSinceEpoch - visibleStart.millisecondsSinceEpoch;
    if (totalMs <= 0) return 0.0;
    final durationMs = cluster.end.millisecondsSinceEpoch - cluster.start.millisecondsSinceEpoch;
    return (durationMs / totalMs * rowWidth).clamp(0.0, rowWidth);
  }

  void _showClusterDetails(BuildContext context, GroupEventCluster cluster) {
    final eventsByType = <String, List<Event>>{};
    for (final event in cluster.events) {
      final typeName = event.type.name;
      eventsByType.putIfAbsent(typeName, () => []).add(event);
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: groupColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '${group.name} Cluster: ${cluster.title}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.schedule, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      '${_formatDateTime(cluster.start)} - ${_formatDateTime(cluster.end)}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              const Text(
                'Events by Type:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              
              ...eventsByType.entries.map((entry) {
                final typeName = entry.key;
                final events = entry.value;
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: groupColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border(
                      left: BorderSide(color: groupColor, width: 3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: groupColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$typeName (${events.length})',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ...events.map((event) => Padding(
                        padding: const EdgeInsets.only(left: 20, top: 2),
                        child: Text(
                          '• ${event.title} (${_formatDateTime(event.start)} - ${_formatDateTime(event.end)})',
                          style: const TextStyle(fontSize: 12),
                        ),
                      )),
                    ],
                  ),
                );
              }),
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

  String _formatDateTime(DateTime dt) {
    return '${dt.year.toString().padLeft(4, '0')}-'
        '${dt.month.toString().padLeft(2, '0')}-'
        '${dt.day.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
